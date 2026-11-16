# Android-Buildbericht 0.12.0 — 2026-11-16

Tatsächlich mit Godot 4.6.3 stable, JDK 21, Android SDK 36 / Build Tools 36.0.0
und nativem Debug-Template ohne Gradle exportiert.

- builds/android/MayhemSurvivors-v0.12-debug.apk: 52,723,307 Bytes.
- SHA256 `9a86297ce432f2da4245bfe5ec7c5a1238835893d145b93f120a99a1e45e6620`.
- com.rfworlds.mayhemsurvivors, versionCode 16, versionName 0.12.0.
- ARM64-v8a ausschließlich; minSDK 24 / targetSDK 36; Landscape / GL Compatibility.
- apksigner v2/v3 erfolgreich; identisches Zertifikat für Update:
  5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce.
- zipalign -c -P 16 4 erfolgreich. Einzige Permission VIBRATE, keine Internet-Permission.
- APK-Payload auf ARM64, neues Twinkle-Asset und Ausschluss aller Tests geprüft.

Kein ADB-Gerät vorhanden, Installation/FPS nicht behauptet. Debug-APK als Update
vorgesehen, mit rückwärtskompatibler Ergänzung der vorhandenen Schema-3-Profile.
Quellarchiv: alle Szenen/Skripte/Daten/Laufzeitassets, Tests/Logs/Berichte und aktuelle
Galerien. Alte reine Screenshots bleiben im Repository; keine .godot-Caches, SDKs,
Builds oder privaten Schlüssel im ZIP. Import/Start ohne Ausführen von Generatoren.
Eigener Export erfordert SDK/JDK/Template und bisherigen privaten Schlüssel für Updates.

Abschließende Archivprüfung: aus ZIP ohne Importcache entpackt, in Godot importiert,
alle 1.164 Assertions und beide Traces erneut bestanden; v0.12-final-*.log.
