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
Nächster Schritt: finalen Quellstand verpacken, APK/ZIP auf GitHub bereitstellen,
öffentliche Downloads vollständig mit SHA256 vergleichen und PR anlegen.

Offen: physische Android-Abnahme, menschliche Balance, Temperatur/Akku/60 FPS.
Praxistest: Glutwerk mit beiden Ventilen, verschiedenen Druckwerten und Ofenkönig.
Details: FOUNDRY.md, TEST_REPORT.md, BUILD_REPORT.md. Temporäre Entpackungen alter
Prüfungen entfernt; Git-Historie und veröffentlichte Versionen erhalten.
