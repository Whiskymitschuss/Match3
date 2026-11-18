# Android-Build 0.23.0 — 2026-11-18

Tatsächlicher erfolgreicher Debug-Export: Godot 4.6.3 stable, JDK 21, Android SDK 36,
Build Tools 36.0.0.

- MayhemSurvivors-v0.23.0-debug.apk / **76,103,712 Bytes**.
- SHA256: `7a1e8343408b2b5d76e931536b402a9e16ceeda2ed08f2513586f211c0be605f`.
- com.rfworlds.mayhemsurvivors / versionCode 29 / versionName 0.23.0.
- ARM64-v8a ausschließlich / minSDK 24 / targetSDK 36 / Querformat / GL Compatibility.
- Signatur v2/v3 und 16-KiB-zipalign erfolgreich geprüft. Gleicher Update-Schlüssel:
  Zertifikat-SHA256 `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- Nur VIBRATE-Permission; keine Internetberechtigung. APK-CRC, exakte Arenen-JSONs,
  zwei kompilierte neue Controller, zwei SVG-Texturimporte und fünf Soundimporte geprüft.
- Keine Testdateien im APK. Die Quellübergabe enthält alle Assets, Szenen, Daten,
  Skripte, Tests, Berichte und Werkzeuge, ohne Cache/SDK/APKs/private Schlüssel.

Als Update über die bestehende App vorgesehen. Profilschema 3 kompatibel; der neue
optionale Hilfestatus wird defensiv geladen. Eine physische Geräteinstallation
wurde hier nicht durchgeführt.

Frisches Quellprojekt ohne Cache importiert: alle 32 Suiten / 4.977 Prüfungen und
beide Traces bestanden, 694 Laufzeitdateien plus Konfigurationen bytegleich.
Rohprotokolle: tests/results/v0.23.0-build.log, -signature.log, -alignment.log,
-manifest.log, -payload.log, -clean-import.log, -clean-tests.log, -source-integrity.log.
Öffentliche Artefakte und Prüfsummen unter Downloads. Die vollständige anonyme
Downloadprüfung wird nach dem Upload separat protokolliert.

---

## Vorherige Builds

# Android-Build 0.22.0 — 2026-11-18

Tatsächlicher erfolgreicher Debug-Export mit Godot 4.6.3 stable / JDK 21 /
Android SDK 36 / Build Tools 36.0.0.

- Datei: MayhemSurvivors-v0.22.0-debug.apk / **76.052.611 Bytes**.
- SHA256: `307330fe72bd4620c10b15c3b15747dc445ee9f6e3d84d893a37aceaad7a08f9`.
- Paket: com.rfworlds.mayhemsurvivors / versionCode 28 / versionName 0.22.0.
- ARM64-v8a ausschließlich / minSDK 24 / targetSDK 36 / Querformat / GL Compatibility.
- Signaturen v2 und v3 sowie zipalign -c -P 16 -v 4 erfolgreich verifiziert.
- Signierschlüssel unverändert: Zertifikat-SHA256
  `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- Nur VIBRATE-Berechtigung; keine Internetberechtigung, keine Online-Abhängigkeit.
- APK-CRC, exakte Tutorial-/Arenendaten, drei neue kompilierte Controller und drei
  Soundimporte geprüft. Keine Testdateien im APK.

Die APK ist als Update über die bestehende App vorgesehen. Profil-Schema 3 bleibt
kompatibel; die neue optionale Einführungsmarkierung wird defensiv geladen.
Eine Installation auf einem physischen Gerät wurde hier nicht durchgeführt.

Das vollständige Godot-Quellprojekt enthält Szenen, GDScript, Daten, alle notwendigen
Assets, Tests, Werkzeuge, Lizenzen und Berichte. Cache, SDK, APKs und private Schlüssel
sind ausgeschlossen. Nach frischem Quellimport sind alle 31 Suiten / 4.757 Prüfungen
und beide Traces bestanden; 674 Laufzeitdateien und beide Konfigurationen bytegleich.

Rohprotokolle: tests/results/v0.22.0-build.log, -signature.log, -alignment.log,
-manifest.log, -payload.log, -clean-import.log, -clean-tests.log und -source-integrity.log.
Öffentliche Artefakte und ihre Prüfsummen liegen im Repository unter Downloads.
Die anonyme vollständige Downloadprüfung wird nach dem Upload separat protokolliert.

---

## Vorheriger Build

# Android-Build 0.21.2 — 2026-11-18

Godot4.6.3 stable / JDK21 / Android SDK36 / Build Tools36.0.0.
Tatsächlicher signierter Debug-Export erfolgreich.

- MayhemSurvivors-v0.21.2-debug.apk / 76014568 Bytes.
- SHA256 `83f428e40f8f2bb004eb58894542384524d32b60a25345c32874e3282cfadabb`.
- com.rfworlds.mayhemsurvivors / versionCode27 / versionName0.21.2.
- ARM64-v8a ausschließlich / minSDK24 / targetSDK36 / Landscape / GL Compatibility.
- v2/v3-Signatur und zipalign -c -P16 4 geprüft. Gleicher Update-Schlüssel wie0.21.1:
  5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce.
- Exakte neue Boss-/Waffen-/Entwicklungsdaten, kompilierter Controller, Archiv-CRC
  geprüft. Keine Tests im APK. Nur VIBRATE-Permission, kein INTERNET.

Über die bisherige App installieren. Case-Hotfix, Helden, Coins und Statistiken bleiben
erhalten; kein Save-Schemawechsel. Kein erreichbares Android-Gerät zur Installation.
Quell-ZIP mit kompletten Laufzeitdateien, Assets, Szenen, Daten, Tests und Berichten;
ohne Cache/SDK/APKs/private Schlüssel. Öffentliche Downloads mit separaten Prüfsummen.

Quell-ZIP zusätzlich ohne Importcache frisch entpackt und importiert. Alle30 Suiten /
4590 Prüfungen und beide Traces erneut bestanden;662 Laufzeitdateien bytegleich.
Logs:v0.21.2-clean-import.log, v0.21.2-clean-tests.log, v0.21.2-source-integrity.log.
