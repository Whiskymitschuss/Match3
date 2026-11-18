# Prüfbericht 0.21.0 — 2026-11-18

Godot 4.6.3 stable, fester 60-Hz-Schritt. Vollständiger Lauf:
`python3 tools/run_tests.py --traces`: **28 Suiten, 3764 bestandene Prüfungen,
0 fehlgeschlagene Prüfungen**. Ergebnisdateien: tests/results/v0.21-*.log.

589 neue Produktionsprüfungen in united_test.gd: elf Helden; zehn neue Gegner;
zehn Arenen mit jeweils allen zehn Wellen; korrekte Bossbilder/-definitionen in
2/4/6/8/10; einmalige Belohnungen; Level-Up-Schlange vor Shop; Abschluss und Freigabe;
Klassenbindungen; alle fünf neuen Waffen plus zehn Entwicklungen; tatsächliche
Fähigkeiten, Cooldowns und Pause; Schild/Frost/Heilung/Lebensraub/Beschwörung;
Gefahrenvorwarnung, Ringöffnung und Limits; Projectile-Pool ohne alte Trefferlisten;
neue Ereignisse; vollständige Handbuchseiten und Menürouten; alte Profile und neue
Defaults; Niederlage, Timeout, Neustart und Endlos. Zusätzlich kompletter zehnwelliger
Durchlauf mit eingeschalteter Produktions-Zustandswache. Genau zwei Hände/Schultern
für jeden Helden und alle 14 neuen gecachten, nicht leeren Audiostreams geprüft.

27 bestehende Regressionssuiten bleiben erhalten. Historische Fixtures setzen
explizit legacy_release.apply ein, um die frühere Bossregel separat zu prüfen.
Kataloggrößen, Wischumlauf und Weltkartengröße auf den aktuellen Bestand erweitert.
world_trace: 33 unveränderte Referenzpunkte / 3.600 Schritte. effects_trace: 87
unveränderte Referenzpunkte / 8.700 Schritte; alter, zwischen Szenarien getragener
Trefferschutz wird nur in diesem historischen Harness rekonstruiert. Produktions-
Runs setzen den Trefferschutz jetzt sauber zurück. Keine Referenzdaten ersetzt.

Belastung: united_soak.gd, 110 Szenarien (11 Helden × 10 Arenen), 92.400 Schritte /
1.540 simulierte Sekunden. Gemischte Gegner, beide Entwicklungspfade alternierend,
aktive Fähigkeiten, alle vier Endboss-Angriffe, Rage, Pause und Bereinigung.
Beobachtete Spitzen: 38 Gegner, 21 Pool-Projektile, 3 neue Gefahrenflächen.
Grenzen kontrolliert: 100 Gegner, 320 Projektile, 240 XP-Pickups, 12 neue Gefahren,
6 Feuerfelder; endliche Positionen/HP/Schaden und vollständige Bereinigung.
Das ist eine Simulationsprüfung, keine Geräte-FPS-Messung und kein Nachweis einer
unter allen Extremlasten erreichten 60-FPS-Bildrate.

38 native GL-Compatibility-Aufnahmen in tests/united_*.png, 1600×900, zusätzlich
2340×1080 und 1920×1440. Auswahl, Weltkarte, neue Waffen-/Heldenbilder, Boss-Intro,
Telegraphen, HUD, Shop, Handbuch, Meisterschaft, Statistik, Garage, Einstellungen und
Kicksy-Tutorial visuell kontrolliert. Renderer: Mesa llvmpipe, kein Android-Gerät.
VSync-Warnung des Linux-Treibers; keine Parser-/Skript-/Ressourcenfehler im finalen Lauf.

Gefundene und behobene Fehler: Handbuch-Variablenkollision und Zahlenformatierung;
fehlende neue Heldenfreigaben; alte feste Menülängen; Namenskollision zwischen der
bestehenden Flammen-Deko und neuer Waffe (jetzt dauerhaft getrennte IDs flame/flamer);
Pool-Metadaten beim Wiederverwenden; unpassende Arm-/Waffengrößen; Boss-HUD-Schwellen;
Tutorial-Avatar nach Atlaswechsel. Alte Deko und gespeicherte Währungen bleiben gültig.

Offen: physische Android-Installation/Update, Mehrfinger-Eingabe, Notch/Systemleisten,
Neigung, Lautstärkewirkung, Lesbarkeit bei echter Bewegung, Langzeit-FPS/Thermik und
menschliche Balance der neuen Bossdichte sowie Case-/Weltprogression. Keine dieser
Geräteprüfungen wird durch Headless- oder Linux-Aufnahmen als bestanden ausgegeben.
