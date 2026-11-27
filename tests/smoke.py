"""P0.1 local integration check (requires built server and Godot)."""
import json, pathlib, subprocess, sys, time, urllib.request, tempfile
root=pathlib.Path(__file__).resolve().parents[1]
server=pathlib.Path(sys.argv[1]).resolve()
godot=sys.argv[2] if len(sys.argv)>2 else "godot"
client=root/"client"
def run_client(marker):
    with tempfile.TemporaryFile(mode="w+b") as log:
        process=subprocess.Popen([godot,"--headless","--path",str(client)],stdout=log,stderr=subprocess.STDOUT)
        try:
            for _ in range(100):
                time.sleep(.1)
                log.seek(0)
                output=log.read().decode("utf-8","replace")
                if marker in output:
                    print(output.strip())
                    if "SCRIPT ERROR" in output:raise RuntimeError(output)
                    return
                if process.poll() is not None:raise RuntimeError(output)
            raise RuntimeError(f"missing {marker}: {output}")
        finally:
            process.terminate()
            process.wait(timeout=10)
subprocess.run([godot,"--headless","--editor","--import","--path",str(client)],check=True,stdout=subprocess.DEVNULL)
# Require an unused port, so tests do not touch a prior service.
import socket
with socket.socket() as s:
    s.bind(("127.0.0.1",8090))
run_client("CW_P01_OFFLINE")
p=subprocess.Popen([str(server)],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
try:
    for _ in range(60):
        try:
            with urllib.request.urlopen("http://127.0.0.1:8090/healthz",timeout=1) as r:
                health=json.load(r)
            assert health["database"]=="not_connected" and health["service"]=="colony-world"
            break
        except OSError:
            time.sleep(.1)
    else:raise RuntimeError("server unavailable")
    with urllib.request.urlopen("http://127.0.0.1:8090/v1/hello",timeout=2) as r:
        hello=json.load(r)
    schema=json.load(open(root/"shared/protocol/v1/hello.schema.json",encoding="utf-8"))
    assert set(hello)==set(schema["required"])
    assert all(hello[k]==v["const"] for k,v in schema["properties"].items())
    run_client("CW_P01_CONNECTED")
finally:
    p.terminate()
    p.wait(timeout=10)
print("P0.1 smoke passed")
