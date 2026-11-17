# Android-Buildbericht0.18.0 — 2026-11-17

Godot4.6.3 stable, JDK21, SDK36/Build Tools36.0.0, natives Debug-Template.

- builds/android/MayhemSurvivors-v0.18-debug.apk: 64,176,088 Bytes.
- SHA256 `0be1b611d0e0c573d5c12a1b28054a7239c2f717077a994762388490f975c0f4`.
- com.rfworlds.mayhemsurvivors / versionCode22 / versionName0.18.0.
- Nur ARM64-v8a / minSDK24 / targetSDK36 / Landscape / GL Compatibility.
- v2/v3-Signatur und zipalign -c -P16 4 geprüft, bisheriges Update-Zertifikat:
  5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce.
- Nur VIBRATE-Permission. Neue Collection-JSON, kompilierte Module, Case-/Wearable-
  Texturen, SVGs und Sounds im Payload. Keine Tests oder INTERNET-Berechtigung.

Als Update über0.17 installieren. Alte Stats/Studio-Coins/Deko erhalten, lokale
pre_garage-Sicherung, neue Roster-Regel und je1 Startticket pro Caseart. Keine physische
Installation, Geräte-FPS/Thermik oder menschliche Balanceabnahme behauptet. ADB-Daemon
nicht erreichbar; Export/Signaturprüfung erfolgreich, kein Gerätetest.
Quell-ZIP ohne .godot/SDK/Builds/private Schlüssel, alle Laufzeitdateien/Tests/Berichte
und aktuelle Garage-Galerie. Ältere reine Screenshotgalerien bleiben im Repository.
Start nach Import ohne Generatoren. Eigener Export benötigt SDK/JDK/Template und den
bisherigen privaten Signierschlüssel für ein kompatibles Update.

Quell-ZIP zusätzlich frisch ohne Importcache entpackt und importiert. Alle25 Suites
(1.898 Assertions) und beide historischen Traces erneut bestanden. Laufzeitquellen,
Szenen, Daten und Assets mit dem getesteten Archiv bytegleich. Logs unter
tests/results/v0.18-clean-import.log und v0.18-clean-tests.log.
