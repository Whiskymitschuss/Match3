# Android-Buildbericht 0.16.0 — 2026-11-17

Export mit Godot4.6.3 stable, JDK21, SDK36/Build Tools36.0.0, nativem Debug-Template.

- builds/android/MayhemSurvivors-v0.16-debug.apk: 59,813,157 Bytes.
- SHA256 `09d00b47e03ff8294cb6b387730914ff3a0b910ad919cb4fbfe0350b2a8d4949`.
- com.rfworlds.mayhemsurvivors / versionCode20 / versionName0.16.0.
- ARM64-v8a ausschließlich / minSDK24 / targetSDK36 / Landscape / GL Compatibility.
- v2/v3-Signatur und zipalign -c -P16 4 geprüft; bisheriges Update-Zertifikat:
  5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce.
- Nur VIBRATE-Permission. Neue Meta-JSON/kompilierte Module/Grafiken im APK-Payload;
  Tests ausgeschlossen. Keine INTERNET-Berechtigung.

Als Update über0.15 vorgesehen. Vorhandene lokale Statistik/Meisterschaften bleiben
kompatibel; neue dauerhafte Wallet beginnt leer. Neues meta-Schema1 unter save/version3.
Keine physische Installation oder Android-FPS-/Balanceprüfung behauptet. Der lokale
ADB-Daemon war nicht erreichbar; Export/Signaturprüfung erfolgreich, kein Gerätetest.
Quell-ZIP ohne .godot/SDK/Builds/Signierschlüssel, sämtliche Laufzeitassets und Quellen,
Tests/Logs und aktuelle Galerien. Start nach Import ohne Assetgenerierung möglich.
Eigener Export benötigt SDK/JDK/Template und privaten Schlüssel für kompatible Updates.

Quellarchiv zusätzlich frisch ohne Importcache entpackt und mit Godot importiert.
Die vollständigen22 Suites (1.644 Assertions) und beide Traces erneut bestanden.
Logs: tests/results/v0.16-clean-import.log und v0.16-clean-tests.log.
