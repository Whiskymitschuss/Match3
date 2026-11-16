# Android-Buildbericht 0.14.0 — 2026-11-16

Tatsächlich exportiert: Godot 4.6.3 stable, JDK 21, SDK 36 / Build Tools 36.0.0,
natives Android-Debug-Template ohne Gradle.

- builds/android/MayhemSurvivors-v0.14-debug.apk: 58,809,870 Bytes.
- SHA256 `4426b60ab4b2b7a3cfab7c6d163f3eb89a2af4a8f38ef63d511641cdabd7c9e6`.
- com.rfworlds.mayhemsurvivors, versionCode 18 / versionName 0.14.0.
- Nur ARM64-v8a, minSDK 24, targetSDK 36, Landscape / GL Compatibility.
- Signatur v2/v3 geprüft, gleiches Zertifikat für Updates:
  5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce.
- zipalign -c -P 16 4 erfolgreich. Einzige Berechtigung VIBRATE.
- Payload auf neue Arenen/Bossatlas/Kicksy/Tutorial-JSON und Ausschluss der Tests geprüft.
- Gravity/Accelerometer aktiviert; keine neue Berechtigung und kein Internet nötig.

Schema3 kompatibel um Endlos-Rekorde und Menü-/Tutorial-Einstellungen ergänzt.
Neue leere Arena-/Heldenprofile werden ergänzt, alte Statistiken nicht erfunden zugeteilt.
Kein ADB-Gerät verbunden; Installation, Sensorfunktion auf Gerät, FPS/Thermik nicht behauptet.
Quell-ZIP enthält alle Laufzeitassets, Szenen/Skripte/Daten, Tests/Logs und aktuelle Galerien;
ältere reine Screenshots im Repository. Keine .godot-Caches, Builds, SDKs oder Schlüssel.
Generatoren optional, Start nach Import ohne manuelle Programmierung.
Eigener Export braucht SDK/JDK/Template und den bisherigen privaten Schlüssel für Updates.

Quell-ZIP frisch entpackt und ohne Importcache importiert; anschließend sämtliche
1.513 Assertions und beide historischen Traces bestanden (v0.14-final-*.log).
