# Android-Buildbericht 0.3.0 — 2026-11-16

Tatsächlich exportiert mit Godot 4.6.3 stable, Android-Debug-Template,
OpenJDK 21, SDK Platform 36 und Build Tools 36.0.0. Nativer APK-Export ohne Gradle.

- Datei: `builds/android/MayhemSurvivors-v0.3-debug.apk`
- Größe: 39,761,813 Bytes
- SHA-256: `4291f9a91ecb01e8e867c5f83970daa9c3ffcdadd222850160487764123eb826`
- Paket: `com.rfworlds.mayhemsurvivors`
- versionCode 6 / versionName 0.3.0, minSDK 24, targetSDK 36.
- Nur `arm64-v8a`, Querformat, GL Compatibility, keine angeforderten Berechtigungen.
- `apksigner verify --verbose --print-certs`: bestanden, Signaturschemata v2/v3.
- Zertifikat-SHA256: `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- Gleiches Zertifikat wie 0.2.3, daher als Update vorgesehen.
- `zipalign -c -P 16 4`: bestanden.
- Neue Arena-/Wellen-JSON-Dateien im APK vorhanden; Tests und Berichte ausgeschlossen.

Exportcode 0. ADB meldet „cannot connect to daemon at tcp:5037“: In dieser Umgebung
ist kein Android-Gerät verbunden; die signierte APK wurde trotzdem vollständig erzeugt.
Installation, Launch und FPS auf einem echten Android-Gerät sind für 0.3 noch nicht geprüft.
Kein Windows-Export. Private Schlüssel und SDK liegen außerhalb des Quellprojekts.

Quell-ZIP: `MayhemSurvivors-v0.3-source.zip`, ohne `.godot`, APK, Signierschlüssel
und Toolchain. Separater Download der APK. Frischer Import aus entpacktem ZIP ohne Parser-/Ressourcenfehler und 157 Reaktortests bestanden. Import-/Testdetails siehe TEST_REPORT.md.
