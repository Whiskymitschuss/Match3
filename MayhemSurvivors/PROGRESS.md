# 0.28.1 Beta 2 — neuer Store-Spieler startet bei null

Stand 2026-11-23. Branch feature/store-beta-v0.28.1. Nutzerkorrektur: neue App
in vorhandener Google Play Console, noch kein App-Eintrag. Alle neuen Spieler
starten bei null. Vollständig offline; lokale Profile bleiben getrennt.

Implementiert: keine kostenlosen Start-Cases mehr; nur Bruiser/Hammer Rang 1,
Schrottplatz, keine Guthaben, Tickets, Teile, Statistiken, Welt- oder Passfortschritte.
Kicksy-Einstieg und leeres Case-Journal entsprechend erklärt. Bestehende eigene
Spielstände bleiben bei Updates erhalten; keine globale Rücksetzung. Neue Tests
prüfen den echten Produktionsstart bis zur ersten erspielten Crew-Case und
Profiltrennung. Alte Tests erhalten benötigte Tickets jetzt ausdrücklich als Fixture.

Verifiziert: vollständiger Lauf von 41 Suiten / 10014 Prüfungen / 0 Fehler,
zusätzlich beide Regressionstraces (33 / 87 Checkpoints). Native Case-Navigation
74/0 und Profile 42/0. 15 Erstspieler-Ansichten in drei Formaten aufgenommen;
Willkommens- und Case-Ansicht visuell geprüft. Kein physisches Android-Gerät.

Google-Play-Preset: Release AAB / ARM64 / API 24–36 / VersionCode 35. Separater
privater Upload-Schlüssel außerhalb des Repositories erzeugt; keine Geheimnisse
im Export-Preset. Standard-Androidvorlagen, SDK Build-Tools 36.1 und vollständiger
OpenJDK-21-Compiler eingerichtet. Store-Build erfolgreich; Bundletool, Signatur, Manifest, CRC und native 16-KiB-
Ausrichtung verifiziert. Store-Texte, Datenschutzhinweise und Console-Übergabe vorbereitet.

Öffentliche vollständige AAB-/ZIP-Downloads und Prüfsummendatei anonym geprüft.
Offen: neuen App-Eintrag/Testerkreis in der Play Console einrichten. Keine Store-Veröffentlichung
behaupten. Store-Bilder, echte Kontakt-/Zielgruppenangaben und Android-Geräteabnahme
stehen aus. Aktive Runs nach vollständigem App-Ende nicht wiederherstellbar.

Abschließender Paketnachweis: Quell-ZIP CRC/sichere Pfade, 802 Laufzeit-/Konfigurations-
dateien bytegleich, frischer Import ohne Cache und Erstspieler-Test 37/0 bestanden.
Private Upload-Schlüssel im separaten Workspace-Backup; niemals öffentlich veröffentlichen.

Veröffentlicht auf GitHub: Source 9ff3b1d, Artefakte 06b6000; AAB 76353437 Bytes,
Quell-ZIP 79644097 Bytes, SHA256 nach vollständigem anonymem Download bestätigt.
Nachweis Downloads/VERIFY-v0.28.1-beta2.txt. Draft-PR #14 offen, nicht gemergt.
Technische Übergabe fertig; kein Store-Testlink und keine Play-Console-Veröffentlichung.
Nächster Schritt: Store-Eintrag, App-Signierung, Inhalte/Kontakt/Grafiken und Testerkreis
in der vorhandenen Console einrichten, Release-AAB hochladen, Geräteabnahme durchführen.

---

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
