# Android-Buildbericht 0.4.0 — 2026-11-16

Tatsächlich exportiert: Godot 4.6.3 stable, Android-Debug-Template, JDK 21,
SDK Platform 36 / Build Tools 36.0.0, nativer APK-Export ohne Gradle.

- Datei: `builds/android/MayhemSurvivors-v0.4-debug.apk`
- Größe: 39,809,188 Bytes
- SHA-256: `8f396af1ad06a3e7242449f70f45b6ef20b618a36085e59154e8cf923bedb571`
- Paket `com.rfworlds.mayhemsurvivors`, versionCode 7 / versionName 0.4.0.
- Nur ARM64-v8a, Querformat, minSDK 24 / targetSDK 36, GL Compatibility.
- Einzige angeforderte Berechtigung: `android.permission.VIBRATE` für optionale Haptik.
  Keine Internet-/Netzwerk-/Speicherberechtigung.
- `apksigner verify --verbose --print-certs`: bestanden, v2/v3-Signatur.
- Zertifikat-SHA256 `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- Gleiches Signierzertifikat wie 0.3, daher Update über bestehende Installation vorgesehen.
- `zipalign -c -P 16 4`: bestanden.
- Fähigkeits-JSON vorhanden, nur ARM64-Bibliotheken, Tests nicht im APK.

Export erfolgreich. Meldung „cannot connect to daemon at tcp:5037“ betrifft das fehlende
ADB-Gerät dieser Umgebung; kein physischer Android-Start oder FPS-Test behauptet.
Vibration ist standardmäßig AUS, DEZENT/STARK benötigen die Praxisprüfung auf Gerät.

Das separate Quell-ZIP enthält Projekt, Szenen, Skripte, Daten, Assets, Generator,
Tests und Berichte. `.godot`, APKs, SDK und private Signierschlüssel sind ausgeschlossen.
Die APK ist separat im Downloadordner verfügbar. Kein Windows-Export.

Quell-ZIP in ein leeres Verzeichnis entpackt, frisch in Godot importiert: keine Parser-/Ressourcenfehler. Fähigkeitssuite im entpackten Projekt erneut 76 / 76 bestanden.
