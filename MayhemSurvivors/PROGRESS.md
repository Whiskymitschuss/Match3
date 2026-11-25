# Mayhem Survivors 0.23.0 — Reaktorzone & Neonhafen

2026-11-18 / Branch feature/arena-mechanics-v0.23.0 / Basis 0.22.0 aee52e2.
Phase 19: Übergabe und Dokumentation. Implementierung und lokale Prüfung abgeschlossen.

Umgesetzt: Kerne sammeln und freiwillig überladen, nutzbare Container-Doppelladungen,
begrenzte Manöver-Boni, reguläre Gegnerbeute, eigene Boss-Zonenangriffe, Kicksy-Hilfe
beim ersten Auftreten und in der Pause, HUD/Ergebnisdetails/Weltkarteninfo, zwei eigene
SVGs und fünf eigene Audiocues. Kampagne und Endlos; Waffenwerte, Boss-HP, Profile und
Case-Fix erhalten. Keine Online-Systeme.

32 Suiten / 4.977 Prüfungen und beide Traces nach frischem Import bestanden.
220 neue Prüfungen zusätzlich mit nativen Touch-Ereignissen. 21 native Ansichten /
drei Seitenverhältnisse, zwölf gezielte Soak-Szenarien mit bis 100 Gegnern und 110
Helden-/Arenenkombinationen bestanden. 694 Laufzeitdateien und Konfigurationen
bytegleich zum Testprojekt. Keine offenen Script-/Parser-/Ressourcenfehler.

Android-APK gebaut / versionCode 29 / ARM64 / gleiche Signatur / Alignment geprüft.
APK-SHA256: 7a1e8343408b2b5d76e931536b402a9e16ceeda2ed08f2513586f211c0be605f.
Finales Quell-ZIP per CRC und gegen alle 694 geprüften Laufzeitdateien verifiziert.
APK und ZIP auf GitHub veröffentlicht, vollständig anonym heruntergeladen und beide
SHA256-Prüfsummen bestätigt. Nachweis: Downloads/VERIFY-v0.23.0.txt und
tests/results/v0.23.0-download.log. Pull Request #8 offen und konfliktfrei; nicht gemergt.
Nächster Schritt: menschlicher Praxistest der Arenenmechaniken auf Android.

Offen: physische Android-Abnahme, menschliche Balance, Temperatur/Akku/60-FPS-Messung.
Praxistest: beide Arenen mit Bruiser und Sparky; Manöver und Bossmuster ausprobieren.
Details: ARENA_MECHANICS.md, TEST_REPORT.md, BUILD_REPORT.md. Temporäre Entpackungen
älterer Prüfungen wurden entfernt; sämtliche Git-Versionen bleiben erhalten.
