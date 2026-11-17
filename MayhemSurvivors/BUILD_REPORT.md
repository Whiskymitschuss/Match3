# Android-Buildbericht0.20.0 — 2026-11-17

Godot4.6.3 stable / JDK21 / Android SDK36 / Build Tools36.0.0 / natives Debug-Template.

- builds/android/MayhemSurvivors-v0.20-debug.apk: 66,276,560 Bytes.
- SHA256 `1a24181bb2b9b837439dc5bed2e0aadb67c3fd0e944209b3a9116744f7596b91`.
- com.rfworlds.mayhemsurvivors / versionCode24 / versionName0.20.0.
- ARM64-v8a ausschließlich / minSDK24 / targetSDK36 / Landscape / GL Compatibility.
- Gleicher Update-Schlüssel, APK-Signatur v2/v3 und zipalign -c -P16 4 geprüft.
- Zertifikat SHA256:5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce.
- Nur VIBRATE-Permission, kein INTERNET. Neue Progressions-JSON, kompilierte Weltkarte/
  Routengrafik/Modelle, vier Embleme und bestehender Axel-Controller im Payload geprüft.
  Keine Testskripte im APK. Keine neuen Geräteberechtigungen.

Über0.19 installieren; gleiche App und lokale Daten. Neue Map-Felder mit eigener
Version1 unter bestehendem Save-Schema3. Vor Migration pre_world_map-Backup; alte
Freigaben/besuchte Arenen und echte Siege bleiben erhalten.

ADB-Daemon nicht erreichbar; Export und Signaturprüfung erfolgreich. Keine physische
Installation, echte Sensor-/Touch-/Audioabnahme oder FPS-/Thermikmessung behauptet.
Quell-ZIP ohne .godot, Builds, SDK oder private Schlüssel, alle Runtimequellen, Szenen,
Daten/Assets, Tests und Berichte. Aktuelle Weltkarten-, Garage- und Axel-Galerien
enthalten; ältere reine Screenshotgalerien bleiben im Repository. Start nach Import
ohne Generatoren. Für eigenen Export SDK/JDK/Template und für kompatible Updates
denselben privaten Signierschlüssel verwenden.

Quell-ZIP zusätzlich frisch ohne Godot-Importcache entpackt und importiert. Alle27
Suiten /2.256 Prüfungen und beide historischen Traces erneut bestanden. Laufzeit-
skripte, Szenen, Daten und Assets mit dem getesteten Archiv bytegleich. Logs:
tests/results/v0.20-clean-import.log und v0.20-clean-tests.log.
