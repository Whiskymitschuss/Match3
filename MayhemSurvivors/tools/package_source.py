"""Package the complete runnable 0.28.0-beta1 project, excluding generated cache and old capture galleries."""
from pathlib import Path
import argparse, zipfile
p=argparse.ArgumentParser();p.add_argument('--out',type=Path);args=p.parse_args()
root=Path(__file__).resolve().parents[1]
out=args.out or root.parent/'Downloads/MayhemSurvivors-v0.28.0-beta1-source.zip'
out.parent.mkdir(parents=True,exist_ok=True)
captures={'beta_profiles_1600', 'beta_home_1600', 'beta_profiles_2400', 'tactics_void_warning', 'case_navigation_reveal', 'beta_settings_1600', 'beta_help_1600', 'beta_rename', 'beta_restore', 'beta_profiles_1440', 'beta_run_exit', 'beta_guide', 'tactics_compare_1600'}
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
