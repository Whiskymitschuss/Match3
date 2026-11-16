# Android-Buildbericht 0.9.0 — 2026-11-16

Erfolgreicher nativer Debug-Export mit Godot 4.6.3 stable, JDK 21, SDK Platform 36,
Build Tools 36.0.0. Datei `builds/android/MayhemSurvivors-v0.9-debug.apk`.

- Größe 49,840,774 Bytes, SHA-256 `c9de3ab6b29ee90626e993db34a232a9b4bb8624e47600e2189ffac45e133fc3`.
- Paket `com.rfworlds.mayhemsurvivors`, Code 13 / Name 0.9.0.
- Nur ARM64-v8a, minSDK 24, targetSDK 36, Landscape, GL Compatibility.
- apksigner: v2/v3-Signatur geprüft, gleiches bisheriges Zertifikat
  `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- zipalign `-c -P 16 4`: bestanden. Einzige Berechtigung VIBRATE.
- APK enthält alle 49 neuen UI-Icon-Importe, neue Branding-/Weltgrafiken und Fonts,
  beide Musikstücke, ursprüngliche Waffen-/Charaktergrafiken sowie Lizenztexte.
- Keine Testdateien. Startargumente --fullscreen / --edge_to_edge tatsächlich enthalten.
- Launcher-Bild aus APK extrahiert und geprüft. Keine Android-Geräteinstallation.

Export erfolgreich; fehlender ADB-Daemon dieser Umgebung (tcp:5037) ist kein Buildfehler.
Physische Launcher-Maskierung, Übergänge, Geräte-FPS/Temperatur noch abzunehmen.
Als Update mit bestehendem Paket/Signierschlüssel vorgesehen; Statistik bleibt lokal.

Quell-ZIP enthält alle Projektdateien, Szenen, Skripte, Daten, fertige Grafiken/Audio,
Tests, Icongenerator und Berichte. .godot-Caches, APKs, SDK/JDK und private Schlüssel
sind ausgeschlossen. APK separat. Import/Spielen erfordern keine Asset-Neuerzeugung.
Für eigenen Export SDK/JDK/Godot-Template und privaten Debugschlüssel konfigurieren;
offizielles Update benötigt den bisherigen Schlüssel.

Frischer Import ohne Cache mit seriellem Editorimport und anschließend alle 926
Assertions plus beide Kampftraces erfolgreich. Erster paralleler Import in dieser
Umgebung zuvor mit SIGSEGV beendet; Projektkonfiguration bereits angepasst.

Finales ZIP erneut vollständig entpackt und Cache entfernt: Import erfolgreich,
alle 926 Assertions sowie beide Referenztraces daraus erneut bestanden.
Nachweise: tests/results/v0.9-final-zip-import.log und v0.9-final-zip-tests.log.
