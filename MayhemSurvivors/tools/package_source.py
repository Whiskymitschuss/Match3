"""Package the complete runnable 0.26.0 project, excluding generated cache and old capture galleries."""
from pathlib import Path
import argparse, zipfile
p=argparse.ArgumentParser();p.add_argument('--out',type=Path);args=p.parse_args()
root=Path(__file__).resolve().parents[1]
out=args.out or root.parent/'Downloads/MayhemSurvivors-v0.26.0-source.zip'
out.parent.mkdir(parents=True,exist_ok=True)
captures={'presentation_pack_home_1600','presentation_pack_audio_1600','presentation_pack_graphics_1600','presentation_pack_controls_1600','presentation_pack_viper_select','presentation_pack_echo_select','presentation_pack_nova_select','presentation_pack_rivet_select','presentation_pack_skins_two','recap_result_1600','recap_overview_1600','recap_waves_1600','recap_endless_page','synergy_bruiser_1600','foundry_warning_1600','case_navigation_reveal','case_navigation_inventory'}
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
