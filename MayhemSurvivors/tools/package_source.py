"""Package the complete runnable 0.30.0-beta4 project, excluding generated cache and old capture galleries."""
from pathlib import Path
import argparse, zipfile
p=argparse.ArgumentParser();p.add_argument('--out',type=Path);args=p.parse_args()
root=Path(__file__).resolve().parents[1]
out=args.out or root.parent/'Downloads/MayhemSurvivors-v0.30.0-beta4-source.zip'
out.parent.mkdir(parents=True,exist_ok=True)
captures={'comfort_records_1600','comfort_extras_1600','comfort_layout_1600','comfort_presets_1600','comfort_practice_1600','comfort_practice_hud_1600','comfort_layout_2400','comfort_practice_2400','comfort_layout_1440','comfort_practice_1440'}
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as z:
 for f in sorted(root.rglob('*')):
  rel=f.relative_to(root)
  if any(v in {'.godot','.git','builds','android','__pycache__','.gradle','build'} for v in rel.parts):continue
  if rel.parts[0]=='tests' and '.png' in f.name and f.name.split('.png')[0] not in captures:continue
  if f.name=='local.properties':continue
  if f.is_file() and f.suffix not in {'.apk','.aab','.idsig','.keystore','.jks','.p12','.pem','.key','.pyc'}:z.write(f,'MayhemSurvivors/'+rel.as_posix())
 z.writestr('MayhemSurvivors/builds/android/','')
 assert z.testzip() is None
assert out.stat().st_size<100*1024*1024,'GitHub single-file size limit exceeded'
print(out, out.stat().st_size,'bytes; archive CRC passed')
