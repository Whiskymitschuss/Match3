# Android-Buildbericht 0.7.0 — 2026-11-16

Erfolgreich exportiert mit Godot 4.6.3 stable, JDK 21, SDK Platform 36 und
Build Tools 36.0.0. Nativer Debug-Export ohne Gradle.

- Datei `builds/android/MayhemSurvivors-v0.7-debug.apk`, 41.529.054 Bytes.
- SHA-256 `11c3c2690540c6ce6086ae7e04990f9b73c975a7acb1a08bc38466d23de4af4f`.
- Paket `com.rfworlds.mayhemsurvivors`, versionCode 11, versionName 0.7.0.
- Ausschließlich ARM64-v8a, minSDK 24, targetSDK 36, Landscape, GL Compatibility.
- APK-Startargumente tatsächlich geprüft: `--fullscreen` und `--edge_to_edge` enthalten.
- `apksigner verify --verbose --print-certs`: erfolgreich, v2/v3-Signatur.
- Zertifikat-SHA256 `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- Gleicher Signierschlüssel wie bisher: Update über bestehende App vorgesehen.
- `zipalign -c -P 16 4`: erfolgreich.
- `aapt dump permissions`: ausschließlich `android.permission.VIBRATE`.
- Item-JSON in APK enthalten, keine Testdateien, keine Netzwerkberechtigung.

Kein Android-Gerät an ADB angeschlossen. Meldung „cannot connect to daemon at
tcp:5037“ ist in dieser Umgebung erwartet, Export/Signaturprüfung erfolgreich.
Installation, tatsächliche Systemleisten/Notch und Geräte-FPS noch nicht geprüft.

Quell-ZIP enthält komplettes Godot-Projekt inklusive Szenen, Skripten, Originalassets,
Audio, Daten, Tests und Dokumentation. `.godot`, APKs, SDK und private Schlüssel
ausgeschlossen. Debugschlüssel liegt außerhalb des Projekts. Für eigenen Export:
Godot-Android-Exporttemplate installieren, SDK/JDK im Editor konfigurieren und
lokalen Debugschlüssel verwenden; bestehende offizielle App lässt sich nur mit
passendem Schlüssel aktualisieren. Fertige APK ist separat verfügbar.

Quell-ZIP frisch in leeres Verzeichnis entpackt: Godot-Import ohne Parser-/Ressourcenfehler;
Shop 41/41 und Display/Balance 100/100 daraus erneut bestanden. Logs v0.7-clean-*.log.
