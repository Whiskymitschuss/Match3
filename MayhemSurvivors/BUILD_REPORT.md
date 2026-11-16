# Android-Buildbericht 0.8.0 — 2026-11-16

Erfolgreicher nativer Debug-Export mit Godot 4.6.3 stable, JDK 21, SDK Platform 36,
Build Tools 36.0.0. Datei `builds/android/MayhemSurvivors-v0.8-debug.apk`.

- Größe 49,281,359 Bytes.
- SHA-256 `29fed7184728104afaf25660a35fe8a4f7f8df22a4123dae1f31e343400ef871`.
- Paket `com.rfworlds.mayhemsurvivors`, versionCode 12, versionName 0.8.0.
- ARM64-v8a ausschließlich; minSDK 24 / targetSDK 36, Landscape, GL Compatibility.
- v2/v3-Signatur mit apksigner tatsächlich geprüft.
- Zertifikat-SHA256 `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- `zipalign -c -P 16 4`: bestanden. Gleicher Signierschlüssel wie 0.7, Update vorgesehen.
- Einzige Berechtigung VIBRATE; keine Netzwerk-/Speicherberechtigung.
- Neues Launcher-Icon exportiert; Wortmarke/Fonts/beide Musikstücke vorhanden.
- OFL-Schriftlizenzen und Audioherkunft in APK enthalten, Tests ausgeschlossen.
- Immersive/Edge-to-edge-Startargumente bleiben enthalten.

ADB-Gerät nicht vorhanden; „cannot connect to daemon at tcp:5037“ betrifft diese
Umgebung und verhindert den erfolgreichen Export nicht. Keine physische Android-
Installation oder FPS-Messung der neuen Version behauptet.

Quell-ZIP enthält vollständige Dateien/Assets/Szenen/Skripte/Daten/Tests/Berichte;
keine .godot-Caches, APKs, SDKs oder privaten Schlüssel. Godot importiert die mitgelieferten
Fonts/Originalsounds selbst. Audio-Generatorabhängigkeiten nur für optionales Regenerieren.
Eigener Export benötigt SDK/JDK/Exporttemplate und eigenen Debugschlüssel; offizielles
Update benötigt denselben Schlüssel wie die bestehende App. Fertige APK separat.

Abschließende ZIP-Prüfung: in leeres Verzeichnis entpackt, Godot-Import ohne Parser-/
Ressourcenfehler. Alle 825 Assertions und beide Referenztraces mit dem mitgelieferten
Runner daraus erneut bestanden. Logs tests/results/v0.8-clean-*.log.
