# Mayhem Survivors 0.22.0 — Schrottplatz & Bruiser

2026-11-18 / Branch feature/first-arena-v0.22.0 / Basis 0.21.2 deab8e1.
Phase 19: Übergabe und Dokumentation. Implementierung und lokale Prüfung abgeschlossen.

Umgesetzt: optionaler erster Einstieg, produktives Kicksy-Training mit Bruiser,
Touch-Markierungen, freiwillige Bergung mit einmaliger Run-Beute, zwei Hammer-Pfade
mit echter Wertevorschau, klare Ergebnisdetails, getrennte Boss-/Spieleranzeigen,
Touch-sichere neue Seitenwechsel und drei eigene Audiocues. Bossbalance und Case-Fix
erhalten. Keine Online-Systeme oder zusätzlichen Inhaltsmengen in diesem Update.

31 Suiten / 4.757 Checks und beide Traces nach frischem Quellimport bestanden.
167 neue Prüfungen zusätzlich mit nativem Touch; Case-Navigation 74 native Prüfungen.
18 native Ansichten / drei Seitenverhältnisse und 110 Soak-Szenarien bestanden.
674 Laufzeitdateien und Projekt-/Exportkonfigurationen bytegleich zur Testentpackung.

Android-Debug-APK gebaut, ARM64 / versionCode 28 / Signatur und Alignment geprüft.
APK-SHA256: 307330fe72bd4620c10b15c3b15747dc445ee9f6e3d84d893a37aceaad7a08f9.
Nächster Schritt: finalen Quellstand verpacken, APK/ZIP hochladen und öffentliche
Downloads vollständig mit Prüfsummen vergleichen. Danach menschliche Android-Abnahme:
Bruiser / beide Pfade / Bergung annehmen und ignorieren / Weltbelohnung abholen.

Offen: physische Geräteabnahme, menschliche Balance, Akkulaufzeit und Temperatur.
Keine Behauptung, dass das Gesamtspiel bereits perfekt oder die 60-FPS-Abnahme erfolgt ist.
Details: FIRST_ARENA.md, TEST_REPORT.md, BUILD_REPORT.md. Frühere Download-Binaries
sind nur aus der Arbeitskopie per sparse-checkout ausgeblendet; Git-Historie erhalten.
