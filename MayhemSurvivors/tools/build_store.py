"""Build the Google Play release bundle with a separately stored upload key.

No signing credentials are written into the project or export preset.
Requires the matching Godot Android export templates, JDK and Android SDK.
"""
from pathlib import Path
import argparse
import copy
import os
import re
import shutil
import subprocess
import zipfile

p=argparse.ArgumentParser()
p.add_argument('--keystore',type=Path,required=True)
p.add_argument('--password-file',type=Path,required=True)
p.add_argument('--play-games-config',type=Path,help='Real Google Play Games project and leaderboard IDs')
p.add_argument('--alias',default='rfworlds_upload')
p.add_argument('--godot',default='godot')
args=p.parse_args()
root=Path(__file__).resolve().parents[1]
key=args.keystore.resolve()
password=args.password_file.read_text().strip()
if not key.is_file() or not password:raise SystemExit('Upload key or password missing.')
if key.is_relative_to(root) or args.password_file.resolve().is_relative_to(root):
    raise SystemExit('Keep private signing files outside the source project.')
out=root/'builds/android/MayhemSurvivors-v0.31.0-beta5-store.aab'
out.parent.mkdir(parents=True,exist_ok=True)
env=os.environ.copy()
env.update(GODOT_ANDROID_KEYSTORE_RELEASE_PATH=str(key),
           GODOT_ANDROID_KEYSTORE_RELEASE_USER=args.alias,
           GODOT_ANDROID_KEYSTORE_RELEASE_PASSWORD=password)
build=root/'android/build'
if not (build/'gradlew').is_file():
    version=subprocess.check_output([args.godot,'--version'],text=True).strip().split('.')
    template_version='.'.join(version[:4])
    data=Path(env.get('XDG_DATA_HOME',Path.home()/'.local/share'))
    template=data/'godot/export_templates'/template_version/'android_source.zip'
    if not template.is_file():
        raise SystemExit('Install the matching Godot Android export templates first: '+str(template))
    build.mkdir(parents=True,exist_ok=True)
    with zipfile.ZipFile(template) as archive:
        for info in archive.infolist():
            rel=Path(info.filename)
            if rel.is_absolute() or '..' in rel.parts:raise SystemExit('Invalid template archive path.')
            if info.filename.startswith('libs/debug/'):continue
            archive.extract(info,build)
    (root/'android/.build_version').write_text(template_version+'\n')
    (build/'gradlew').chmod(0o755)
# Avoid unpacking/merging several unused native architectures in Gradle caches.
# Every retained ARM64 library is copied byte for byte from the official template.
aar=build/'libs/release/godot-lib.template_release.aar'
if not aar.is_file():raise SystemExit('Release Godot Android library missing.')
with zipfile.ZipFile(aar) as archive:
    unnecessary=[i for i in archive.infolist() if i.filename.startswith('jni/')
                 and not i.filename.startswith('jni/arm64-v8a/') and i.filename!='jni/']
    if unnecessary:
        temporary=aar.with_suffix('.arm64.aar')
        with zipfile.ZipFile(temporary,'w') as target:
            for info in archive.infolist():
                if info not in unnecessary:target.writestr(info,archive.read(info.filename))
if unnecessary:temporary.replace(aar)
# Compile the optional bridge only when real console identifiers are supplied.
import json, sys
configuration=args.play_games_config or root/'data/network/play_games.json'
if args.play_games_config or json.loads(configuration.read_text()).get('provider')=='google_play':
    subprocess.run([sys.executable,str(root/'tools/build_play_games.py'),'--config',str(configuration)],check=True,env=env)
command=[args.godot,'--headless','--path',str(root)]
command+=['--export-release','Google Play',str(out)]
result=subprocess.run(command,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True)
log=result.stdout.replace(password,'[REDACTED]')
logs=root/'tests/results';logs.mkdir(exist_ok=True)
(logs/'v0.31.0-beta5-store-build.log').write_text(log)
print(log)
if result.returncode or re.search(r'SCRIPT ERROR|\bERROR:',log) or not out.is_file():
    raise SystemExit(result.returncode or 1)
# JAR signatures protect entry bytes. Keep those unchanged, but place the JAR
# manifest first so both random-access and streaming signature readers see it.
with zipfile.ZipFile(out) as source:
    if source.namelist()[0]!='META-INF/MANIFEST.MF':
        temporary=out.with_suffix('.ordered.aab')
        order=sorted(source.infolist(),key=lambda i:(0 if i.filename=='META-INF/MANIFEST.MF'
                     else 1 if i.filename.startswith('META-INF/') else 2,i.filename))
        with zipfile.ZipFile(temporary,'w') as target:
            for info in order:
                with source.open(info) as src,target.open(copy.copy(info),'w') as dst:
                    shutil.copyfileobj(src,dst)
    else:temporary=None
if temporary:temporary.replace(out)
print('Release bundle built:',out)
print('Verify signature and bundle contents before Play Console upload.')
