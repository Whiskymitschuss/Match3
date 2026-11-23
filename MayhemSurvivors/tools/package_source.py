"""Package the complete runnable 0.27.0 project, excluding generated cache and old capture galleries."""
from pathlib import Path
import argparse, zipfile
p=argparse.ArgumentParser();p.add_argument('--out',type=Path);args=p.parse_args()
root=Path(__file__).resolve().parents[1]
out=args.out or root.parent/'Downloads/MayhemSurvivors-v0.27.0-source.zip'
out.parent.mkdir(parents=True,exist_ok=True)
captures={'tactics_void_warning', 'case_navigation_reveal', 'tactics_compare_empty', 'tactics_storm_warning', 'tactics_carnival_warning', 'tactics_crystal_boss', 'tactics_crystal_warning', 'tactics_cases', 'presentation_pack_home_1600', 'tactics_frost_boss', 'tactics_gardens_tool', 'tactics_frost_heat', 'tactics_compare_1600'}
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as z:
 for f in sorted(root.rglob('*')):
  rel=f.relative_to(root)
  if any(v in {'.godot','.git','builds','__pycache__'} for v in rel.parts):continue
  if rel.parts[0]=='tests' and '.png' in f.name and f.name.split('.png')[0] not in captures:continue
  if f.is_file() and f.suffix not in {'.apk','.idsig','.keystore','.pyc'}:z.write(f,'MayhemSurvivors/'+rel.as_posix())
 z.writestr('MayhemSurvivors/builds/android/','')
 assert z.testzip() is None
assert out.stat().st_size<100*1024*1024,'GitHub single-file size limit exceeded'
print(out, out.stat().st_size,'bytes; archive CRC passed')
