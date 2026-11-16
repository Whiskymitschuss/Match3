# Android-Buildbericht 0.6.0 — 2026-11-16

Tatsächlich exportiert mit Godot 4.6.3 stable, Android-Debug-Template, JDK 21,
SDK Platform 36 / Build Tools 36.0.0. Nativer APK-Export ohne Gradle.

- Datei `builds/android/MayhemSurvivors-v0.6-debug.apk`
- Größe 41,473,438 Bytes
- SHA-256 `e120b7b54291f5bc1a89db1bd6b191ce4d02a06f429b118130a332b9726d441d`
- Paket `com.rfworlds.mayhemsurvivors`, versionCode 10 / versionName 0.6.0.
- Nur ARM64-v8a, minSDK 24, targetSDK 36, Querformat, GL Compatibility.
- Einzige Berechtigung `android.permission.VIBRATE`; keine Netzwerk-/Speicherberechtigung.
- `apksigner verify --verbose --print-certs`: bestanden, v2/v3-Signatur.
- Zertifikat-SHA256 `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- Gleiches Zertifikat wie 0.5.1 und Vorgänger, daher Update über bestehende App vorgesehen.
- `zipalign -c -P 16 4`: bestanden.
- Neue Gegnerdaten und Grafik enthalten, Tests ausgeschlossen.

Export erfolgreich. „cannot connect to daemon at tcp:5037“ betrifft das fehlende
ADB-Gerät dieser Umgebung. Keine physische Android-Installation, Startprüfung oder
FPS-Messung dieser Version behauptet. Alle bisherigen Fähigkeiten/Waffenwege/Effekte
sind enthalten. Kein Windows-Export und keine neuen Berechtigungen.

Quell-ZIP separat mit sämtlichen Projektdateien, Szenen, Skripten, Daten, Assets,
Audiogenerator, Tests/Fixtures und Berichten. `.godot`, APKs, SDK und private Schlüssel
sind ausgeschlossen; APK separat im Downloadordner.

Quell-ZIP separat in ein leeres Verzeichnis entpackt: frischer Godot-Import ohne Parser-/Ressourcenfehler; Gegnersuite daraus erneut 66 / 66 bestanden.
