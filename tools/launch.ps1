# Local development launcher; does not install dependencies or alter system settings.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$client = Join-Path $root "client"
$server = Join-Path $root "server"
$build = Join-Path $root "build"
$ownProcess = $null

function Find-Godot {
    if ($env:GODOT_EXE -and (Test-Path -LiteralPath $env:GODOT_EXE -PathType Leaf)) { return (Resolve-Path -LiteralPath $env:GODOT_EXE).Path }
    # Explicit local filenames also support renamed executables.
    foreach ($dir in @((Join-Path $root "tools\godot"), $root)) {
        foreach ($name in @("GODOT_EXE.exe", "godot.exe", "godot4.exe")) {
            $candidate = Join-Path $dir $name
            if (Test-Path -LiteralPath $candidate -PathType Leaf) { return (Resolve-Path -LiteralPath $candidate).Path }
        }
    }
    foreach ($name in @("godot.exe", "godot4.exe")) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($cmd) { return $cmd.Source }
    }
    foreach ($dir in @($root, (Join-Path $root "tools\godot"))) {
        if (Test-Path $dir) {
            $exe = Get-ChildItem -LiteralPath $dir -Filter "Godot_v4*_win64_console.exe" -File | Select-Object -First 1
            if (-not $exe) { $exe = Get-ChildItem -LiteralPath $dir -Filter "Godot_v4*_win64.exe" -File | Select-Object -First 1 }
            if ($exe) { return $exe.FullName }
        }
    }
    throw "Godot 4.7.2 nao encontrado. Baixe em https://godotengine.org/download/windows/ e coloque o executavel como tools\godot\GODOT_EXE.exe, mantenha o nome original do Godot ou defina a variavel de ambiente GODOT_EXE."
}
function Get-Health {
    try {
        $h = Invoke-RestMethod -Uri "http://127.0.0.1:3000/healthz" -TimeoutSec 1
        return ($h.service -eq "colony-world" -and $h.status -eq "ok" -and $h.phase -eq "P0.3" -and $h.protocol_version -eq 1)
    } catch { return $false }
}
try {
    $godot = Find-Godot
    Write-Host "Godot encontrado: $godot"
    $version = & $godot --version
    if ($version -and "$version" -notmatch "^4\.7\.2") {
        throw "Godot 4.7.2 esperado. Detectado: $version"
    }
    New-Item -ItemType Directory -Path $build -Force | Out-Null
    if (-not (Get-Health)) {
        $go = Get-Command go.exe -ErrorAction SilentlyContinue
        if (-not $go) { throw "Go 1.24+ nao encontrado. Instale uma vez em https://go.dev/dl/ e reabra o terminal." }
        $exe = Join-Path $build "colony-server.exe"
        Push-Location $server
        try {
            & $go.Source build -buildvcs=false -trimpath -o $exe ./cmd/colony
            if ($LASTEXITCODE -ne 0) { throw "Falha na compilacao do servidor." }
        } finally { Pop-Location }
        $env:CW_ADDR = "127.0.0.1:3000"
        if (-not $env:CW_DATA_DIR) { $env:CW_DATA_DIR = Join-Path $env:LOCALAPPDATA "ColonyWorld\dev" }
        Write-Host "Dados de conta local: $env:CW_DATA_DIR"
        $ownProcess = Start-Process -FilePath $exe -WorkingDirectory $server -PassThru -WindowStyle Hidden -RedirectStandardOutput (Join-Path $build "server.out.log") -RedirectStandardError (Join-Path $build "server.err.log")
        $ready = $false
        for ($i=0; $i -lt 30; $i++) {
            if (Get-Health) { $ready = $true; break }
            if ($ownProcess.HasExited) { break }
            Start-Sleep -Milliseconds 500
        }
        if (-not $ready) { throw "Servidor nao respondeu. Verifique build\server.err.log e a porta 3000." }
    }
    Write-Host "Servidor local conectado. Preparando cliente..."
    $import = Start-Process -FilePath $godot -ArgumentList @("--headless", "--editor", "--import", "--path", ('"{0}"' -f $client)) -Wait -PassThru -WindowStyle Hidden
    if ($import.ExitCode -ne 0) { throw "Falha ao importar o cliente Godot." }
    $game = Start-Process -FilePath $godot -ArgumentList @("--path", ('"{0}"' -f $client)) -Wait -PassThru
    if ($game.ExitCode -ne 0) { throw "Cliente finalizado com erro: $($game.ExitCode)" }
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
} finally {
    if ($null -ne $ownProcess -and -not $ownProcess.HasExited) {
        Stop-Process -Id $ownProcess.Id -ErrorAction SilentlyContinue
    }
}


