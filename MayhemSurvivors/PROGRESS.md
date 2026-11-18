# Mayhem Survivors 0.24.0 — Glutwerk

2026-11-18 / Branch feature/foundry-valves-v0.24.0 / Basis 0.23.0 898fdd7.
Phase 19: Übergabe und Dokumentation. Implementierung und lokale Prüfung abgeschlossen.

Umgesetzt: zwei freiwillige Ventile, Druckfenster, feste Dampfrichtung, Rückstoß,
begrenzter Bonus und reguläre Gegnerbeute; Ofenkönig-Dampfbahnen, gespeicherte
Kicksy-Hilfe, HUD/Weltkarte, eigene Grafik und vier eigene Sounds. Kampfwerte,
Boss-HP, bestehende Profile und Case-Fix erhalten. Keine Online-Systeme.

33 Suiten / 5.194 Prüfungen und beide Traces nach frischem Import bestanden.
217 neue Prüfungen zusätzlich mit nativen Touch-Ereignissen. 16 native Ansichten /
drei Seitenverhältnisse, neun gezielte Belastungsszenarien bis 100 Gegner und alle
110 Helden-/Arenenkombinationen bestanden. 706 Laufzeitdateien und
Konfigurationen bytegleich zur Testentpackung. Keine offenen Script-/Parserfehler.

Android-APK gebaut / versionCode 30 / ARM64 / gleiche Signatur / Alignment geprüft.
APK-SHA256: 7beeaccb66d0ee0f9103fb4e8df8d86ec58e8f358e57b3549a942ad8d2b68b0a.
Finales Quell-ZIP per CRC und gegen alle 706 getesteten Laufzeitdateien verifiziert.
APK und ZIP auf GitHub veröffentlicht, vollständig anonym heruntergeladen und beide
SHA256-Prüfsummen bestätigt. Nachweis: Downloads/VERIFY-v0.24.0.txt und
tests/results/v0.24.0-download.log. Pull Request #9 offen und konfliktfrei; nicht gemergt.
Nächster Schritt: menschlicher Glutwerk-Praxistest auf Android.

Offen: physische Android-Abnahme, menschliche Balance, Temperatur/Akku/60 FPS.
Praxistest: Glutwerk mit beiden Ventilen, verschiedenen Druckwerten und Ofenkönig.
Details: FOUNDRY.md, TEST_REPORT.md, BUILD_REPORT.md. Temporäre Entpackungen alter
Prüfungen entfernt; Git-Historie und veröffentlichte Versionen erhalten.
