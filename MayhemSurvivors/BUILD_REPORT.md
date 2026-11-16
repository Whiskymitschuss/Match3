# Android-Buildbericht 0.13.0 — 2026-11-16

Mit Godot 4.6.3 stable, JDK 21, Android SDK 36 / Build Tools 36.0.0 und nativem
Debug-Template ohne Gradle erfolgreich exportiert.

- builds/android/MayhemSurvivors-v0.13-debug.apk: 53,744,100 Bytes.
- SHA256 `f6e9c2136d3cc8fb5e0cd79b18cbfea6022c02ba5646ca07d31cac09b837d7cc`.
- com.rfworlds.mayhemsurvivors, versionCode 17, versionName 0.13.0.
- Nur ARM64-v8a, minSDK 24, targetSDK 36, Landscape / GL Compatibility.
- apksigner v2/v3 geprüft, gleiches Update-Zertifikat:
  5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce.
- zipalign -c -P 16 4 erfolgreich. Permission ausschließlich VIBRATE.
- Payload: neues Ravox-Asset vorhanden, nur ARM64-Bibliotheken, keine Tests.

Kein verbundenes Android-Gerät, keine Installation/FPS-/Thermikmessung behauptet.
Als Update über 0.12 vorgesehen, keine neue Speichermigration nötig.
Quellarchiv enthält alle Laufzeitassets, Szenen, Skripte, Daten, Tests und Berichte;
aktuelle Galerien enthalten, ältere reine Screenshots im Repository. Kein .godot-Cache,
kein Build/SDK/privater Schlüssel. Start nach Import ohne manuelle Programmierung.
Eigener Export braucht SDK/JDK/Template und alten privaten Schlüssel für Updates.

Abschließende Quell-ZIP-Prüfung: frisch ohne Importcache entpackt und importiert;
alle 1.216 Assertions und beide Traces erneut bestanden, v0.13-final-*.log.
