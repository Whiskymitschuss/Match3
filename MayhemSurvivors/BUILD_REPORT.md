# Android-Buildbericht0.19.0 — 2026-11-17

Godot4.6.3 stable, JDK21, SDK36/Build Tools36.0.0, natives Debug-Template.

- builds/android/MayhemSurvivors-v0.19-debug.apk: 66,238,279 Bytes.
- SHA256 `69d14f75ccc1ad7f9cd25a0269f57ec6da4cac6a593b95de60df1eed4ce46266`.
- com.rfworlds.mayhemsurvivors / versionCode23 / versionName0.19.0.
- Nur ARM64-v8a / minSDK24 / targetSDK36 / Landscape / GL Compatibility.
- APK-Signatur v2/v3 und zipalign -c -P16 4 geprüft, bisheriges Update-Zertifikat:
  5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce.
- Nur VIBRATE-Permission, keine INTERNET-Berechtigung. Neue Boss-JSON, kompilierte
  Boss-/Todesanimationsmodule, eigene Boss-Textur und sechs Sounds im Payload geprüft.
  Keine Testskripte im APK.

Als Update über0.18 installieren. Collection/Coins/Freischaltungen/Stats bleiben
lokal erhalten. Welle4 überleben und Shop fortsetzen, dann Axels Vorstellung und
Bosskampf in5. Gesamtsieg weiter erst nach dem Arenaboss in10.

ADB-Daemon nicht erreichbar. Export und Signaturprüfung erfolgreich; keine physische
Installation, Touch-/Audio-Geräteabnahme oder FPS-/Thermikmessung behauptet.
Quell-ZIP enthält sämtliche Laufzeitdateien, Szenen, Skripte, Daten, Assets, Tests und
Berichte. Ohne Importcache, SDK, APK oder private Schlüssel. Aktuelle Axel-/Garage-
Galerien enthalten; historische reine Screenshotgalerien bleiben im Repository.
Start nach Import ohne Generatoren. Eigener Export erfordert SDK/JDK/Exporttemplate;
für ein Update über diese APK zusätzlich denselben privaten Signierschlüssel.
