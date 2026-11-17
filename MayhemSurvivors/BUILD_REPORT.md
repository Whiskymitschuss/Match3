# Android-Buildbericht0.17.0 — 2026-11-17

Godot4.6.3 stable, JDK21, Android SDK36/Build Tools36.0.0, natives Debug-Template.

- builds/android/MayhemSurvivors-v0.17-debug.apk: 60,912,703 Bytes.
- SHA256 `f86dadf56b8b684ec8a1415f5092a0b5b92bf6f1b85879a8b8b6c7d52e07d435`.
- com.rfworlds.mayhemsurvivors / versionCode21 / versionName0.17.0.
- Ausschließlich ARM64-v8a / minSDK24 / targetSDK36 / Landscape / GL Compatibility.
- v2/v3-Signatur und zipalign -c -P16 4 geprüft, bisheriges Update-Zertifikat:
  5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce.
- Nur VIBRATE-Permission; keine INTERNET-Berechtigung. Neue Steelfist-Konfiguration,
  kompilierte Module, Grafik/SVGs/Sounds im Payload; Tests ausgeschlossen.

Als Update über0.16 vorgesehen, vorhandene Statistik/Wallet/Freischaltungen kompatibel.
Steelfist ist sofort verfügbar; sein neuer Rekord beginnt leer. Gleiches Speicherschema3.
Keine physische Installation oder Geräte-FPS/Thermik-/Balanceabnahme behauptet. Lokaler
ADB-Daemon nicht erreichbar; Export und Signaturprüfung unabhängig davon erfolgreich.
Quell-ZIP ohne .godot/SDK/Builds/private Signierschlüssel, alle Laufzeitassets/Quellen/
Tests und aktuelle Galerien. Import/Start erfordern keine Generatoren oder Programmierung.
Eigener Export erfordertSDK/JDK/Template und bisherigen privaten Schlüssel für Updates.

Quell-ZIP zusätzlich frisch ohne Importcache entpackt und importiert. Alle23 Suites
(1.747 Assertions) und beide historischen Traces erneut bestanden. Logs unter
tests/results/v0.17-clean-import.log und v0.17-clean-tests.log.
