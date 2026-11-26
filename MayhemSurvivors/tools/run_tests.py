"""Run the shipped Godot test suites. Python standard library only."""
import argparse, re, shutil, subprocess, tempfile, os
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--traces',action='store_true');p.add_argument('--godot',default='godot');p.add_argument('--suite',action='append',help='Run only a named shipped suite (repeatable)');args=p.parse_args()
root=Path(__file__).resolve().parents[1];logs=root/'tests/results';logs.mkdir(exist_ok=True)
suites=['integration','combat_visuals_test','character_policy_test','world_visuals_test','run_records_test','reactor_test','abilities_test','specializations_test','effects_test','reactor_roles_test','display_balance_test','shop_test','presentation_audio_test','neon_interface_test','encounters_test','mastery_test','twinkle_test','ravox_test','worlds_endless_test','kicksy_test','difficulty_test','live_rewards_test','steelfist_test','collection_model_test','garage_test','breaker_axel_test','world_map_test','united_test','case_navigation_test','boss_balance_test','first_arena_test','arena_mechanics_test','foundry_test','synergies_test','recap_test','presentation_pack_test','tactics_test','progress_comparison_test','profile_store_test','beta_profiles_test','new_player_test','run_resume_test','profile_backup_test','resume_backup_ui_test','comfort_update_test','comfort_ui_test','online_scores_test','wow_effects_test']
if args.suite:
 if any(n not in suites for n in args.suite):raise SystemExit('Unknown suite')
 suites=args.suite
if args.traces:suites+=['world_trace','effects_trace']
if not shutil.which(args.godot):raise SystemExit('Godot 4.6 stable is required on PATH; or pass --godot /path/to/godot')
for name in suites:
 with tempfile.TemporaryDirectory(prefix='mayhem-test-') as isolated:
  env=os.environ.copy();env['XDG_DATA_HOME']=isolated
  result=subprocess.run([args.godot,'--headless','--path',str(root),'--fixed-fps','60','--script','res://tests/'+name+'.gd'],capture_output=True,text=True,timeout=120,env=env)
 output=result.stdout+result.stderr;(logs/('v0.31.0-beta5-'+name+'.log')).write_text(output)
 lines=[s for s in output.splitlines() if any(x in s for x in ['RESULT','REGRESSION','ERROR','FAIL'])]
 print(name, '\n'+'\n'.join(lines),flush=True)
 if result.returncode or re.search(r'SCRIPT ERROR|\bERROR:|\bFAIL\b',output):raise SystemExit(result.returncode or 1)
print('All requested suites passed.')
