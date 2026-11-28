import json,pathlib
root=pathlib.Path(__file__).resolve().parents[1]
client=root/"client/world/npcs.json"
assert client.read_bytes()==(root/"server/internal/world/npcs.json").read_bytes()
npcs=json.loads(client.read_text())
placements={p["id"]:p for p in json.loads((root/"client/world/bravamar.json").read_text())["placements"] if p["kind"]=="npc"}
assert len(npcs)==len(placements)==12
assert len({n["id"] for n in npcs})==len({n["name"] for n in npcs})==12
for n in npcs:
 p=placements[n["id"]]
 assert (n["x"],n["z"],n["asset"])==(p["x"],p["z"],p["asset"])
 assert all(n[k] for k in ["bio","dialog","role","color"])
print("CW_NPC_DATA_OK")
