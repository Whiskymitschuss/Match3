"""Compile RF Worlds' optional native bridge; real console IDs enable export.

--compile-check builds the Android source without enabling the game feature.
--config reads a JSON configuration supplied by the Play Console owner.
"""
from pathlib import Path
import argparse,json,os,re,shutil,subprocess

ROOT=Path(__file__).resolve().parents[1]
ARENAS=['scrapyard','reactor','docks','foundry','gardens','frost','storm','crystal','carnival','void']
def validate(source):
 if not isinstance(source,dict) or source.get('provider')!='google_play':raise ValueError('Select google_play provider.')
 project=source.get('project_id','')
 if not isinstance(project,str) or not re.fullmatch(r'[1-9][0-9]{1,19}',project):raise ValueError('A real numeric Google Play Games project ID is required.')
 boards=source.get('boards')
 if not isinstance(boards,dict) or not 1<=len(boards)<=60:raise ValueError('Supply at least one real leaderboard ID; at most 60.')
 for key,value in boards.items():
  parts=key.split(':')
  if len(parts)!=3 or parts[0] not in ['campaign','endless'] or parts[1] not in ARENAS or parts[2] not in ['normal','veteran','mayhem']:raise ValueError('Unknown leaderboard category: '+key)
  if not isinstance(value,str) or not re.fullmatch(r'Cgk[A-Za-z0-9_-]{5,125}',value):raise ValueError('Invalid Google leaderboard ID for '+key)
 if len(set(boards.values()))!=len(boards):raise ValueError('Each mode/arena/difficulty needs its own leaderboard ID.')
 return {'provider':'google_play','project_id':project,'boards':boards}
def main():
 p=argparse.ArgumentParser();p.add_argument('--config',type=Path);p.add_argument('--compile-check',action='store_true');p.add_argument('--sdk',type=Path);args=p.parse_args()
 if bool(args.config)==args.compile_check:p.error('Use --config FILE or --compile-check.')
 config=validate(json.loads(args.config.read_text())) if args.config else None
 sdk=args.sdk or os.environ.get('ANDROID_HOME') or os.environ.get('ANDROID_SDK_ROOT')
 local=ROOT/'android/build/local.properties'
 if not sdk and local.is_file():
  found=re.search(r'^sdk\.dir=(.+)$',local.read_text(),re.M)
  if found:sdk=found[1].replace('\\:',':').replace('\\\\','\\')
 if not sdk:
  editor=Path(os.environ.get('XDG_CONFIG_HOME',Path.home()/'.config'))/'godot'
  for settings in sorted(editor.glob('editor_settings-4*.tres'),reverse=True):
   found=re.search(r'^export/android/android_sdk_path\s*=\s*("[^"\n]+")',settings.read_text(),re.M)
   if found:sdk=json.loads(found[1]);break
 if not sdk or not Path(sdk).is_dir():raise SystemExit('Configure Android SDK or pass --sdk.')
 godot=ROOT/'android/build/libs/release/godot-lib.template_release.aar'
 wrapper=ROOT/'android/build/gradlew';native=ROOT/'native/play_games'
 if not godot.is_file() or not wrapper.is_file():raise SystemExit('Install the matching Godot Android build template first (tools/build_store.py).')
 (native/'local.properties').write_text('sdk.dir='+str(Path(sdk).resolve())+'\n')
 command=[str(wrapper),'-p',str(native),'--no-daemon','--max-workers=2','assembleRelease','-PgodotAar='+str(godot)]
 if config:command+=['-PrfPlayProjectId='+config['project_id']]
 env=os.environ.copy()
 env.setdefault('ANDROID_USER_HOME',str(Path(env.get('XDG_CACHE_HOME',Path.home()/'.cache'))/'rfworlds-android'))
 Path(env['ANDROID_USER_HOME']).mkdir(parents=True,exist_ok=True)
 result=subprocess.run(command,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,env=env)
 logs=ROOT/'tests/results';logs.mkdir(exist_ok=True)
 (logs/'v0.30.0-beta4-play-games-native-build.log').write_text(result.stdout)
 if result.returncode:print(result.stdout[-12000:]);raise SystemExit(result.returncode)
 artifact=native/'build/outputs/aar/RFPlayGames-release.aar'
 if not artifact.is_file():raise SystemExit('Native bridge AAR missing.')
 if config:
  shutil.copyfile(artifact,ROOT/'addons/rf_play_games/RFPlayGames-release.aar')
  (ROOT/'data/network/play_games.json').write_text(json.dumps(config,indent=2)+'\n')
  print('Native bridge built and real Play Games configuration installed.')
 else:print('Android native bridge compiled successfully; online feature remains disabled without real console IDs.')
if __name__=='__main__':main()
