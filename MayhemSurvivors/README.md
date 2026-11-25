# RF Worlds — Mayhem Survivors 0.28.0 Beta 1

Android / Godot 4.6.3 stable / GDScript / ARM64 / vollständig offline.
Geschlossene Beta mit 15 Kämpfern, zehn Welten, Kampagne und Endlos.

## Neu für den Betatest

- Fünf lokale Spielerprofile mit eigenen Freischaltungen, Coins, Ausrüstung,
  Einstellungen, Aufgaben, Pass und Statistiken. Auswahl je Spieler bleibt erhalten.
- Bestehender Spielstand bleibt als Spieler 1 erhalten; letzter aktiver Spieler
  wird beim Neustart geladen. Profilwechsel während eines Runs ist gesperrt.
- Atomare Speicherung mit gültiger Vorgängersicherung, automatischer Wiederherstellung,
  Profilübersicht-Reparatur und bestätigter manueller Sicherungsladung.
- Cases, Aufgaben und Weltbelohnungen speichern im richtigen Spielerprofil.
- Android-Zurück mit sicheren Menüwegen, Case-Bestätigung, Abbruchdialogen und
  Schutz vor versehentlichem App-Ende. Eingefrorene Angebote bleiben erhalten.
- Beta-Hilfe mit Testanleitung und manuell kopierbarem Bericht ohne Spielernamen.

[Installation, Daten und Testwege](BETA_TESTING.md) · [Arena-Taktik](ARENA_TACTICS.md)

## Installieren und spielen

Die signierte Debug-APK über die vorhandene Version installieren. Nicht vorher
deinstallieren: Android löscht dabei die lokalen App-Daten. Paketname bleibt
com.rfworlds.mayhemsurvivors, versionCode 34, gleicher Signierschlüssel.
MinSDK 24 / targetSDK 36 / ARM64-v8a / Querformat / GL Compatibility. Nur Vibration
als Berechtigung. Keine Anmeldung, Werbung, Echtgeldkäufe oder Internetpflicht.

Links mit dem Touch-Joystick bewegen; Waffen greifen automatisch an. Rechts die
Fähigkeit benutzen. Bosse in Welle 2/4/6/8/10, Wellenshop, XP-Upgrades, Entwicklungen,
Cases und Sammlung. Neue Manöver in späteren Welten ab normalen Wellen 3.

Dauerhafter Fortschritt wird gesichert. Aktive Runs sind nach vollständigem
App-Ende weiterhin nicht wiederaufnehmbar. Normale Android-Unterbrechung pausiert.
Daten werden nicht automatisch zwischen Handys übertragen.

## Projekt und Prüfung

project.godot in Godot 4.6.3 öffnen und starten. Alle Szenen, Assets, Musik, Sounds
und Daten sind enthalten. Python/NumPy/FFmpeg dienen nur optionalen Generatoren,
nicht zum Spielen. Ausschließlich Android-Exportpreset.

Tests: `python tools/run_tests.py --traces` mit Godot auf PATH.
[Fortschritt](PROGRESS.md) · [Tests](TEST_REPORT.md) · [Build](BUILD_REPORT.md) ·
[Änderungen](CHANGELOG.md) · [Nächste Schritte](ROADMAP.md).

Physische Android-Abnahme, Tastatur/Safe Area, Touchgefühl, subjektiver Klang,
menschliche Balance, Temperatur, Akku und gemessene 60 FPS werden im geschlossenen
Test geprüft. Automatisierte Prüfungen und Linux-GL-Bilder ersetzen diese Abnahme nicht.
