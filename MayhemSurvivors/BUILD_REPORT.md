# Android-Buildbericht 0.15.0 — 2026-11-17

Exportiert mit Godot 4.6.3 stable, JDK21, Android SDK36 / Build Tools36.0.0 und nativem
Debug-Template ohne Gradle.

- builds/android/MayhemSurvivors-v0.15-debug.apk: 58,827,329 Bytes.
- SHA256 `03cac377a41a24d9810a58a74997e03d4e893cc916e44ca4774e8cea501fb0bf`.
- com.rfworlds.mayhemsurvivors, versionCode19 / versionName0.15.0.
- ARM64-v8a ausschließlich / minSDK24 / targetSDK36 / Landscape / GL Compatibility.
- Signatur v2/v3 und zipalign -c -P 16 4 geprüft; gleiches Update-Zertifikat:
  5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce.
- Nur VIBRATE-Permission; Preset-JSON im Payload, keine Tests und nur ARM64-Libraries.

Als Update über 0.14 vorgesehen; lokale Statistik kompatibel ergänzt, alte Werte Normal.
Keine physische Installation, FPS-/Thermik- oder menschliche Balanceabnahme behauptet.
Quell-ZIP ohne .godot/SDK/Builds/Signierschlüssel, alle Laufzeitassets und Quelldateien
enthalten. Aktuelle Galerien enthalten, ältere reine Screenshots im Repository.
Start nach Import ohne Assetgenerierung. Eigener Export benötigt SDK/JDK/Template und
bisherigen privaten Signierschlüssel für ein kompatibles Update.

Quellarchiv frisch ohne .godot-Cache importiert und danach alle 1.565 Assertions
sowie beide historischen Traces erneut bestanden (v0.15-final-*.log).
