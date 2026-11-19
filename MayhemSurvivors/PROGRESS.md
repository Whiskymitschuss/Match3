# Mayhem Survivors 0.26.0 — Crew & Präsentation

Stand 2026-11-19. Phase 19: Implementierung, lokale Abnahme und Android-Export
abgeschlossen. Basis: 0.25.0 / 65694ab. Branch: feature/run-analysis-v0.26.0.
Bestätigter Umfang: insgesamt 15 Kämpfer, neues Hauptmenü, geordnete Settings,
Waffen-Skins, neue Musik/Sounds/Effekte und Run-Analyse.

## Implementiert

Viper, Echo, Nova und Rivet mit eigenen Comicgrafiken, Zwei-Hand-Rig, Klassenwerten,
Passiven, aktiven Fähigkeiten, Projektileffekten und Sounds. Cases, Meisterschaft,
Speicherung und Klassenwaffen angeschlossen. Bestehende elf Figuren erhalten.
Sechs Hauptaktionen; Audio/Grafik/Steuerung als Settings-Tabs; Tutorial und Handbuch
unter Steuerung. Sichere Menü-Rückwege und Pause/Fortsetzen.
Fünf sichtbare Waffen-Finishes mit Mustern, Schussfarben und Live-Vorschau;
Cases oder Studio-Coin-Kauf, atomare Speicherung, keine Kampfwerteboni.
Drei eigene arrangierte Musikstücke, überarbeitete SFX und Master-Peak-Limiter.
Run-Analyse mit echten Kampfwerten, Wellen/Bossfilter, lokalem Verlauf, maximal
20 Runs und 50 Wellenzeilen; Gesamtwerte auch bei längeren Endlosläufen korrekt.

## Abnahme und Export

36 Suiten / 5.761 Prüfungen / 0 Fehler am frisch entpackten Projekt; beide
historischen Traces grün. 767 Laufzeitdateien plus Konfiguration bytegleich.
218 native GL-Touchchecks und 40 Ansichten in drei Displayformaten geprüft.
Vier Belastungsläufe: 90 Analyse-, 150 Figuren/Arena-, 27 Modul- und zwölf
Crew-Szenarien bestanden. Keine finalen Parser-/Script-/Ressourcenfehler.
Debug-APK wirklich gebaut, ARM64/Paket/Code32/Signatur/Alignment/CRC und Inhalte
geprüft. Auslieferung mit Quell-ZIP und Prüfsummen; öffentliche Downloadprüfung
wird separat im Repo unter Downloads/VERIFY-v0.26.0.txt protokolliert.

## Offene Abnahme und nächster Schritt

Keine offenen Pflichtfunktionen im bestätigten Updateumfang. Physische Android-
Abnahme bleibt offen: Installation über bestehenden Spielstand, neue Klassen,
Skins, Musik, Mehrfingerbedienung, Unterbrechung, Neigung/Safe Area und lange Runs.
Menschliche Balance, Temperatur, Akku und 60 FPS müssen am Gerät gemessen werden.
Nächster Schritt: Android-Geräteabnahme und gezielte Korrekturen aus deren Befunden.

Details: PRESENTATION_UPDATE.md, RUN_ANALYSIS.md, TEST_REPORT.md, BUILD_REPORT.md.
