# 0.28.0 Beta 1 — lokale Spielerprofile

Stand 2026-11-23. Phase 19: Implementierung und technische Übergabe für den
geschlossenen Betatest abgeschlossen. Basis 0.27.0 / e1e59cb.
Branch feature/offline-beta-v0.28.0. Nutzerentscheidung: vollständig offline.

Implementiert: fünf Profile, bisheriger Spieler erhalten, getrennte Freischaltungen,
Coins, Ausrüstung, Einstellungen, Aufgaben und Statistiken. Spieler-/Arena-Auswahl
und aktives Profil persistent. Alle Schreibwege umgestellt. Gültige Vorgängersicherung,
atomare Ersetzung, automatische Wiederherstellung, defensive Profilindex-Reparatur
und bestätigtes manuelles Restore. Touchgerechte Verwaltung/Namen, Android-Zurück,
geschützte aktive Profile, Run-Abbruchdialoge und Beta-Hilfe mit manuellem Bericht.

Frisch entpacktes Projekt: 40 Suiten / 9973 Prüfungen / 0 Fehler plus zwei Traces.
800 Laufzeitdateien plus Konfiguration und 109 Tests bytegleich zum APK-Stand.
Neue Profil- und Speichertests (37/42) sowie native Case-Navigation (74) bestanden;
16 GL-Ansichten in drei Formaten geprüft. Analyse-Soak: 90 kontrollierte Szenarien.
Beta-APK tatsächlich gebaut: Code34, ARM64, gleicher Schlüssel/Paketname, Signatur,
Alignment und Inhalte geprüft. Übergabe mit Quell-ZIP, Testanleitung und Prüfsummen.
Öffentlicher Downloadbeleg wird nach dem Upload separat im Repo dokumentiert.

Offen bleibt die physische Android-Beta-Abnahme: Update, echte Tastatur, Touch,
Safe Area, Sensoren, Klang, Balance, Stabilität, Akku/Temperatur und 60 FPS.
Aktive Runs werden nach vollständigem App-Ende nicht fortgesetzt. Kein Cloud-Sync,
keine Anmeldung. Kein persönlicher Spielstand oder privater Schlüssel im Quellpaket.
Nächster Schritt: geschlossener Gerätetest nach BETA_TESTING.md und gezielte Befundkorrektur.

## Veröffentlichung abgeschlossen

Geschlossene Beta 1 auf GitHub: Quellstand 4a99671, Artefakte e12b430.
APK (78.383.759 Bytes) und vollständiges Quell-ZIP (79.397.772 Bytes) ohne Anmeldung
komplett heruntergeladen. Beide SHA256-Werte und öffentliche Prüfsummendatei bestätigt.
Nachweis: Downloads/VERIFY-v0.28.0-beta1.txt. PR #13 offen und konfliktfrei, nicht
automatisch gemergt: https://github.com/Whiskymitschuss/Match3/pull/13.
Jetzt folgt die physische geschlossene Android-Beta nach BETA_TESTING.md.
