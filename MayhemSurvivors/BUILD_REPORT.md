# Android-Buildbericht 0.5.0 — 2026-11-16

Tatsächlich exportiert mit Godot 4.6.3 stable, Android-Debug-Template,
OpenJDK 21, SDK Platform 36 / Build Tools 36.0.0. Nativer APK-Export ohne Gradle.

- Datei `builds/android/MayhemSurvivors-v0.5-debug.apk`
- Größe 39,907,060 Bytes
- SHA-256 `7b073fbf4cb24e6fa06e10798898d38f51a7ac5767852f5f3dca63a61743f2bf`
- Paket `com.rfworlds.mayhemsurvivors`, versionCode 8 / versionName 0.5.0.
- Nur ARM64-v8a, minSDK 24, targetSDK 36, Querformat, GL Compatibility.
- Einzige Berechtigung `android.permission.VIBRATE`; kein Internet-/Netzwerk-/Speicherzugriff.
- `apksigner verify --verbose --print-certs`: bestanden, v2/v3-Signatur.
- Zertifikat-SHA256 `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- Gleiches Zertifikat wie 0.4; Update über bestehende Installation vorgesehen.
- `zipalign -c -P 16 4`: bestanden.
- Neue Spezialisierungsdaten vorhanden, Tests nicht im APK.

Export erfolgreich. „cannot connect to daemon at tcp:5037“ betrifft das fehlende
ADB-Gerät dieser Umgebung, nicht die signierte APK-Erzeugung. Physische Installation,
Android-Start und FPS von 0.5 wurden hier nicht geprüft. Kein Windows-Export.

Separates Quell-ZIP enthält alle Projektdateien, Szenen, Skripte, Daten, Assets,
Audiogenerator, Tests und Berichte. `.godot`, APKs, SDK und private Signierschlüssel
sind ausgeschlossen; die APK ist separat verfügbar.

Quell-ZIP separat in ein leeres Verzeichnis entpackt: frischer Import ohne Parser-/Ressourcenfehler und neue Suite daraus erneut 108 / 108 bestanden.
