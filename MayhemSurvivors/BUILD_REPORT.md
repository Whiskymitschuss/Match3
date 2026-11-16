# Android-Buildbericht 0.11.0 — 2026-11-16

Tatsächlich exportiert mit Godot 4.6.3 stable, JDK 21, Android SDK 36,
Build Tools 36.0.0, nativem Debug-Template ohne Gradle.

- builds/android/MayhemSurvivors-v0.11-debug.apk: 51,529,634 Bytes.
- SHA256 `208de26438c1a5bb628cc8c3c0068e8b178e82e28bad55b97b26cefa6b9dd345`.
- com.rfworlds.mayhemsurvivors, versionCode 15, versionName 0.11.0.
- ARM64-v8a ausschließlich, minSDK 24, targetSDK 36, Landscape, GL Compatibility.
- apksigner verify erfolgreich, Zertifikat unverändert:
  5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce.
- zipalign -c -P 16 4 erfolgreich. Einzige Berechtigung VIBRATE.
- APK ohne Tests, ohne Internet-Permission; keine Werbung/IAP.

Update über 0.10 vorgesehen; Speicherung kompatibel um hero_styles ergänzt.
Kein Android-Gerät verbunden, keine Installation/FPS-Messung behauptet.
Quell-ZIP enthält alle Projektdateien, Assets, Szenen, Skripte, Tests und Berichte;
keine .godot-Caches, Builds, SDKs oder privaten Schlüssel. APK separat.
Generatoren optional, Start nach Editor-Import ohne manuelle Programmierung.
Debug-Neuexport benötigt SDK/JDK/Template und für kompatible Updates den bisherigen
privaten Signierschlüssel. Dieser gehört ausdrücklich nicht ins Quellarchiv.

Quell-ZIP frisch entpackt und ohne vorhandenen Importcache importiert.
Alle 1.075 Assertions und beide Traces erneut bestanden (v0.11-final-*.log).
