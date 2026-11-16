# Android-Buildbericht 0.5.1 — 2026-11-16

Tatsächlich exportiert mit Godot 4.6.3 stable, Android-Debug-Template, JDK 21,
SDK Platform 36 / Build Tools 36.0.0. Nativer APK-Export ohne Gradle.

- Datei `builds/android/MayhemSurvivors-v0.5.1-debug.apk`
- Größe 39,928,335 Bytes
- SHA-256 `d549509425c13ed24143fea086e084b942b9c07d682953c93fe6559c8e7b4ab0`
- Paket `com.rfworlds.mayhemsurvivors`, versionCode 9 / versionName 0.5.1.
- ARM64-v8a ausschließlich, minSDK 24, targetSDK 36, Querformat, GL Compatibility.
- Einzige Berechtigung `android.permission.VIBRATE`, keine Netzwerk-/Speicherberechtigung.
- `apksigner verify --verbose --print-certs`: bestanden, v2/v3-Signatur.
- Zertifikat-SHA256 `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- Gleiches Zertifikat wie 0.5 und Vorgänger: als Update über vorhandene App vorgesehen.
- `zipalign -c -P 16 4`: bestanden.
- Neue Splatterressource enthalten, Tests nicht im APK.

Export erfolgreich. „cannot connect to daemon at tcp:5037“ betrifft das fehlende
ADB-Gerät dieser Umgebung. Keine physische Android-Installation oder FPS-Messung
behauptet. Alle zehn Waffenwege und Fähigkeiten sind in dieser APK enthalten.
Kein Windows-Export und kein zusätzlicher Berechtigungsbedarf für Effekte.

Separates Quell-ZIP mit Projekt, Szenen, Skripten, Daten, Assets, Audiogenerator,
Tests/Referenzfixtures und Berichten. `.godot`, APKs, SDK und private Signierschlüssel
sind ausgeschlossen. APK separat unter Downloads verfügbar.

Quell-ZIP separat in ein leeres Verzeichnis entpackt: frischer Godot-Import ohne Parser-/Ressourcenfehler; neue Effektsuite daraus erneut 40 / 40 bestanden.
