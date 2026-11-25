# Mayhem Survivors 0.27.0 — Arena-Taktik und Fortschritt

Stand 2026-11-23. Phase 19: Implementierung, lokale Abnahme und Android-Export
abgeschlossen. Basis 0.26.0 / 35d2d7e; Branch feature/arena-tactics-v0.27.0.

## Implementiert

Sechs freiwillige Manöver für die späteren Welten: Filter, Wärme, Blitzableiter,
Runenrelais, Bombenkaskade und Ringsog. Passende Abschlussbosszonen, feste Warn-
Geometrie, sichere Räume, Countdown und Erholungsfenster. Einmalige Run-Boni,
Gegnerbeute, Pause/Tod/Wellenende/Endlos und Objektbereinigung angeschlossen.
Kicksy-Ersthilfe, gespeicherte Bestätigung, Pause-Hilfe und Weltkartenbeschreibung.
Run-Vergleich mit gleichen Rahmenbedingungen, tatsächlichen Messwerten und klarem
Leerzustand. Case-Ziele und Duplikatschutz sichtbar. Statistik für alle 15 Figuren.
Sechs Original-SVGs und drei PCM-Cues. Bestehende Preise, Chancen, Waffenwerte,
Boss-HP und Angriffskadenz beibehalten; verbrauchter Nova-Schild korrekt angezeigt.

## Prüfung und Export

Frisches Quellprojekt: 38 Suiten / 9890 Prüfungen / 0 Fehler, beide Traces grün.
790 Laufzeitdateien plus Konfiguration bytegleich zum APK-Quellstand. Drei native
Suiten (686/3443/74 Funktionsprüfungen inklusive Touch-Wege) bestanden. 30 GL-
Ansichten in drei Formaten kontrolliert. Zwei Soaks: 54 Taktik- und 90 Analyse-
Szenarien, 100 Gegner, begrenzte Effekte und identische Kampfergebnisse je Qualität.
Debug-APK tatsächlich gebaut: Code33, ARM64, Paket, Signatur, Alignment und Inhalte
geprüft. Quell-ZIP und Prüfsummen gehören zur Übergabe. Öffentlicher Downloadbeleg
wird nach dem Upload separat unter Downloads/VERIFY-v0.27.0.txt protokolliert.

## Offen und nächster Schritt

Keine offenen Funktionen im bestätigten Updateumfang. Physische Android-Abnahme
bleibt ausstehend: über bestehenden Spielstand installieren, drei Klassen-Runs
vergleichen, Manöver/Bosse, Touch, Neigung, Safe Area und Audio ausprobieren.
Menschliche Balance, Temperatur, Akku und 60 FPS am Gerät messen. Bisher keine
neuen menschlichen Android-Rundaten erhalten; Simulationen ersetzen diese
Daten nicht. Nächster fachlicher Schritt: gezielte Korrekturen nach Geräte-
abnahme. Regeln: ARENA_TACTICS.md. Nachweise: TEST_REPORT.md / BUILD_REPORT.md.

## Veröffentlichung abgeschlossen

0.27.0 auf GitHub veröffentlicht: Quellstand 824d663, Artefakte 468e3ce.
APK (78.354.194 Bytes) und Quell-ZIP (81.005.353 Bytes) vollständig ohne Anmeldung
heruntergeladen. Beide SHA256-Prüfsummen und öffentliche Prüfsummendatei bestätigt.
Nachweis: Downloads/VERIFY-v0.27.0.txt. Pull Request #12 offen und konfliktfrei,
nicht automatisch gemergt: https://github.com/Whiskymitschuss/Match3/pull/12.
Nächster fachlicher Schritt bleibt die physische Android-Abnahme.
