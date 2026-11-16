# Android-Buildbericht — 2026-11-15

**Ergebnis: Debug-APK tatsächlich erzeugt, signiert und statisch verifiziert.**

- Datei: `builds/android/MayhemSurvivors-v0.1-debug.apk`
- Größe: 27,825,279 Bytes
- SHA-256: `31d2be7cefff622bad3fa94c3d646d44745884f613e9a0ab60f11021bbdc9a4f`
- Paket: `com.rfworlds.mayhemsurvivors`
- Version: `0.1.0`, versionCode `1`
- Native Architektur: ausschließlich `arm64-v8a`
- Minimum SDK: 24 (Android 7.0), Target/Compile SDK: 36
- Ausrichtung: Landscape, keine PC-Exportpresets
- Renderer: `gl_compatibility`, auch explizit für mobile Geräte gesetzt
- Berechtigungen: `aapt dump permissions` listet keine angeforderten Berechtigungen

## Benutzte Werkzeuge

Godot **4.6.3.stable.official.7d41c59c4**, passende offizielle Android-Debug-Exportvorlage,
OpenJDK 21, Android SDK Platform 36, Build Tools 36.0.0 und Platform Tools 37.0.3.
Die Android-Werkzeuge und Exportvorlagen fehlten zunächst und wurden nachgeladen.
`SDK manager` konnte die Paketmanifeste über den Umgebungsproxy nicht abrufen;
die offiziellen SDK-ZIP-Dateien wurden deshalb direkt von `dl.google.com` installiert.
Es wurde keine APK erfunden oder nur aus einer Vorlage umbenannt.

Godot exportierte das Projekt mit:

```sh
godot --headless --path MayhemSurvivors --export-debug Android \
  MayhemSurvivors/builds/android/MayhemSurvivors-v0.1-debug.apk
```

Das Preset benutzt den nativen Templateexport ohne Gradle. Alle fünf JSON-Datendateien
sind in der fertigen APK enthalten; Testskripte und Testscreenshots sind ausgeschlossen.
Der Debug-Schlüssel liegt ausschließlich in der Entwicklungs-Toolchain und wird nicht
als Release-Schlüssel ausgeliefert. Godot kann für weitere Debug-Builds einen eigenen
Debug-Schlüssel verwenden.

## Tatsächliche Nachprüfung

- `apksigner verify --verbose`: **Verifies**, APK-Signature-Scheme v2 und v3 gültig.
- `zipalign -c -P 16 -v 4`: **Verification successful**.
- `aapt dump badging`: Paket, Version, SDK, Landscape und ARM64 geprüft.
- APK-ZIP-Inhalt: nur `lib/arm64-v8a`; alle Spieldaten vorhanden; keine Testressourcen.
- Import/Export: keine GDScript-Parserfehler oder fehlenden Ressourcen.

Das Exportprotokoll enthält am Ende `cannot connect to daemon at tcp:5037`.
Das betrifft den nicht verfügbaren ADB-Gerätedienst, nicht die erfolgreich abgeschlossene
Signierung und APK-Verifikation. **Installation und Start auf echter Android-Hardware
wurden nicht durchgeführt.** Kein Emulatorlauf und keine Android-Frameratemessung behauptet.

Vollständiges Exportprotokoll: `tests/results/build.log`.
