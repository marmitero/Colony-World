"""P0.3: isolated store, actual Godot UI flow, and login after restart."""
import json,os,pathlib,socket,subprocess,sys,tempfile,time,urllib.request
root=pathlib.Path(__file__).resolve().parents[1];server=pathlib.Path(sys.argv[1]).resolve();godot=sys.argv[2] if len(sys.argv)>2 else "godot"
client=root/"client"
subprocess.run([godot,"--headless","--editor","--import","--path",str(client)],check=True,stdout=subprocess.DEVNULL)
def start(env):
 p=subprocess.Popen([str(server)],env=env,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
 for _ in range(100):
  try:
   with urllib.request.urlopen("http://127.0.0.1:3000/healthz",timeout=1) as r:h=json.load(r)
   assert h["phase"]=="P0.3" and h["database"]=="local_file"
   return p
  except OSError:time.sleep(.1)
 p.terminate();p.wait();raise RuntimeError("server unavailable")
def stop(p):
 p.terminate();p.wait(timeout=10)
def post(path,body):
 req=urllib.request.Request("http://127.0.0.1:3000"+path,json.dumps(body).encode(),{"Content-Type":"application/json"})
 with urllib.request.urlopen(req,timeout=5) as r:return json.load(r)
with socket.socket() as s:s.bind(("127.0.0.1",3000))
with tempfile.TemporaryDirectory() as base:
 env=os.environ.copy();env["CW_DATA_DIR"]=base;env["CW_ADDR"]="127.0.0.1:3000"
 p=start(env)
 try:
  r=subprocess.run([godot,"--headless","--path",str(client),"--script","res://auth_smoke.gd"],capture_output=True,text=True,timeout=40)
  print(r.stdout,r.stderr)
  assert r.returncode==0 and "CW_P03_UI_CHARACTERS_OK" in r.stdout and "SCRIPT ERROR" not in r.stderr
 finally:stop(p)
 # Assert file persisted no plaintext or token, then authenticate after a new process.
 b=(pathlib.Path(base)/"accounts-v1.json").read_text()
 assert "test-only-password-123" not in b and '"token"' not in b
 p=start(env)
 try:
  a=post("/v1/auth/login",{"email":"ui-fixture@example.test","password":"test-only-password-123"})
  assert a["account"]["email"]=="ui-fixture@example.test" and a["token"]
  req=urllib.request.Request("http://127.0.0.1:3000/v1/characters",headers={"Authorization":"Bearer "+a["token"]})
  with urllib.request.urlopen(req,timeout=5) as r: roster=json.load(r)
  assert len(roster["slots"])==5 and all(roster["slots"]) and roster["selected_id"]==roster["slots"][2]["id"]
 finally:stop(p)
print("CW_P03_PERSISTENCE_OK")

