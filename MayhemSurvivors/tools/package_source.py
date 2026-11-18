"""Package the complete runnable 0.23.0 project, excluding generated cache and old capture galleries."""
from pathlib import Path
import argparse, zipfile
p=argparse.ArgumentParser();p.add_argument('--out',type=Path);args=p.parse_args()
root=Path(__file__).resolve().parents[1]
out=args.out or root.parent/'Downloads/MayhemSurvivors-v0.23.0-source.zip'
out.parent.mkdir(parents=True,exist_ok=True)
captures={'arena_mechanics_reactor_coach','arena_mechanics_reactor_warning','arena_mechanics_container_landed_1600','arena_mechanics_container_warning_2400','arena_mechanics_docks_boss_warning','arena_mechanics_reactor_boss_warning','first_arena_welcome','first_arena_build_paths','first_arena_salvage_active','first_arena_reward_details','case_navigation_reveal','case_navigation_inventory','united_home','united_map_gardens','united_hero_steelfist','united_hero_cinder','united_new_enemies_firestorm','united_guide_hero','united_tutorial'}
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
