# Mayhem Survivors — 0.30.0 Beta 4

RF Worlds / Godot4.6.3 stable / GDScript / Android ARM64 / Querformat / GL Compatibility.
15 Fighter, zehn Arenen, Kampagne und Endlos; fünf voneinander getrennte lokale Profile.

## Das Komfort-Update

HAUPTMENÜ → EXTRAS führt zu Boss-Training, Ausrüstungs-Builds, Touchlayout und
persönlichen Rekorden. Linkshändermodus, fester/dynamischer Joystick, Verschieben,
Größe, Transparenz und Deadzone werden pro Profil gespeichert. Drei Builds pro
Fighter legen vorhandene Ausrüstung gemeinsam an, ohne einen laufenden Run umzubauen.

Boss-Training verwendet die echten Bosse/Welt-Controller, alle fünf Bossstufen und
wählbare Startphasen. Nur eigene Fighter und freigeschaltete Welten. Keine Belohnungen
oder Statistikfortschritte; ein zuvor gesicherter normaler Run bleibt erhalten.

Run-Fortsetzen lädt Kämpfe pausiert und behält Shop/Levelwahl. Periodisches Speichern
erfolgt alle zehn Kampfsekunden im Hintergrund; Pause und wichtige Übergänge sichern
zusätzlich. EINSTELLUNGEN → PROFIL → EXPORT / IMPORT sichert Profile als Datei,
einschließlich Builds/Touchlayout. Importiert wird als zusätzlicher Spieler, kein
Überschreiben anderer Profile. Details: MOBILE_COMFORT.md und RUN_RESUME_BACKUP.md.

## Online-Status

Google Play Games wurde vom Nutzer als Dienst ausgewählt, ein Spieleprojekt ist
noch nicht angelegt. Adapter, Scoring, Konto-/Profilzuordnung, Warteschlange und
optionaler nativer Build sind implementiert. **In diesem AAB nicht aktiv:** keine
Google-SDKs/Internetberechtigung, keine Anmeldung und kein Upload. Persönliche Rekorde
bleiben verfügbar. Zur Aktivierung werden echte Projekt-/Bestenlisten-IDs benötigt;
PLAY_GAMES_SETUP.md führt den Console-Schritt und den vorbereiteten Build-Weg aus.

## Bestehende Spieler und Projektstart

Reguläre Store-Updates behalten eigene Profile, Sammlung, Guthaben und0.29-Run-Sicherungen.
Neue Spieler starten weiterhin mit Bruiser/Hammer Rang1 und Schrottplatz bei null.
Keine Gratis-Cases, Werbung, Echtgeldkäufe, Anmeldungspflicht oder eigene Server.

project.godot mit Godot4.6.3 stable öffnen/importieren und starten. Hauptszene,
Ressourcen und Daten sind verbunden. Keine manuelle Programmierung nötig.
Preset Google Play: Release-AAB, Code37, com.rfworlds.mayhemsurvivors, SDK24–36.
tools/build_store.py nutzt den getrennten bestehenden Upload-Schlüssel; keine
Schlüssel/Passwörter im Projekt. Das optionale Play-Games-Plugin ist eigener Java-Code
unter native/play_games; der Export aktiviert es nur mit realer Konfiguration.

Tests: python tools/run_tests.py --traces. tools/package_source.py erstellt das
Quellarchiv ohne generierte Caches, Android-Builds oder private Daten.

[Betatest](BETA_TESTING.md) · [Store-Übergabe](PLAY_STORE_HANDOFF.md) · [Testbericht](TEST_REPORT.md) · [Buildbericht](BUILD_REPORT.md)
