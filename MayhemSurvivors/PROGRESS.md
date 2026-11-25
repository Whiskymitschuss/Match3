# Mayhem Survivors 0.25.0 — Kampf-Kombinationen

2026-11-18 / Branch feature/combat-synergies-v0.25.0 / Basis 0.24.0 fbef5a6.
Phase 19: Implementierung, Prüfungen, Pakete und öffentliche Übergabe abgeschlossen.

Umgesetzt: Bruchkern, Ionenrelais, Schattenspule; reale Fähigkeiten-/Waffen-
Verbindungen inklusive Entwicklungen; begrenzte Procs, garantierter Shopplatz,
Kaufprüfung, Regelansichten, Bereitschafts-HUD, Zielmarkierungen, eigene Icons und
Sounds. Sichere Touch-Wege für Kauf/Inventar/Hilfe. Profil und alte Systeme erhalten.

Frischer ZIP-Import ohne Cache: 34 Suiten / 5.434 Prüfungen und beide Traces grün.
240 neue Prüfungen zusätzlich nativ mit Touch. 16 native Ansichten / drei Formate.
27 neue Belastungsszenarien bis 100 Gegner: Grafikstufen mit identischem Schaden/
Proc-Anzahl. 110 Helden-/Arena-Szenarien und 54 stationäre Bossproben bestanden.
720 Laufzeitdateien und Projekt-/Exportkonfiguration bytegleich zur Testentpackung.
Keine offenen Script-/Parserfehler. Frühere Fixture-/UI-Korrekturen im Testbericht.

Android-APK gebaut / code31 / ARM64 / gleiche Signatur / 16-KiB-Alignment geprüft.
APK-SHA256: 60fca96d5cc2262388d9454b781d7f13f88c72408f9c2f29ab127550c5173f7d.
Finales Quell-ZIP per CRC und gegen alle 720 getesteten Laufzeitdateien geprüft.
APK und ZIP auf GitHub veröffentlicht, vollständig anonym heruntergeladen und beide
SHA256-Prüfsummen bestätigt. Nachweise: Downloads/VERIFY-v0.25.0.txt und
tests/results/v0.25.0-download.log. PR #10 offen und konfliktfrei; nicht gemergt.
Artefakte unverändert. Nächster Schritt: menschlicher Android-Praxistest der Module.
Offen: physische Android-Abnahme, menschliche Balance, Temperatur/Akku/60 FPS.
Details: SYNERGIES.md, TEST_REPORT.md, BUILD_REPORT.md.
