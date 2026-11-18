# Android-Buildbericht 0.21.0 — 2026-11-18

Godot 4.6.3 stable / JDK 21 / Android SDK 36 / Build Tools 36.0.0.
Export: `godot --headless --path . --export-debug Android builds/android/MayhemSurvivors-v0.21-debug.apk`.

- Debug-APK: 76,014,568 Bytes.
- SHA256: `bac59810199b766622b8f8fba15dc3c206d47a68ab06e3285777ecbbffcc86ab`.
- Paket com.rfworlds.mayhemsurvivors / versionCode 25 / versionName 0.21.0.
- Ausschließlich ARM64-v8a / minSDK 24 / targetSDK 36 / Landscape / GL Compatibility.
- APK v2/v3 signiert; zipalign mit 16-KiB-Prüfung. Zertifikat wie in 0.20:
  5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce.
- Nur VIBRATE, kein INTERNET. Immersiv und Edge-to-edge konfiguriert.
- Alle neuen Laufzeit-Atlanten, Daten und kompilierten Controller im Payload geprüft;
  keine Tests im APK. Details in tests/results/v0.21-payload.log.

ADB-Daemon nicht erreichbar. Das verhindert hier die Installation auf einem Gerät,
nicht den tatsächlichen Export. Keine physische Start-/Update-/Sensor-/Audio- oder
FPS-Abnahme behauptet. Über die vorhandene App installieren und Daten behalten.

Quell-ZIP enthält alle Laufzeitquellen, Szenen, Daten, Assets, Fontlizenzen, Generatoren,
Tests und Berichte. Ohne .godot, APKs, SDK/JDK oder private Signierschlüssel. Eine
aktuelle Auswahl nativer Aufnahmen liegt bei; vollständige Screenshotgalerien im Repo.
Für eigenen Export SDK/JDK/Template und denselben privaten Schlüssel für kompatible
Updates konfigurieren. Das Projekt selbst startet nach dem Import ohne Programmierung.

Quellarchiv ohne Cache frisch importiert: alle 28 Suiten / 3.764 Prüfungen und beide
historischen Traces erneut bestanden. 662 Laufzeitdateien bytegleich zum getesteten
Archiv. Protokolle: v0.21-clean-import.log, v0.21-clean-tests.log und
v0.21-source-integrity.log. Öffentliche Prüfsummen stehen im Downloads-Verzeichnis;
die vollständige Downloadprüfung wird im Repository protokolliert.
