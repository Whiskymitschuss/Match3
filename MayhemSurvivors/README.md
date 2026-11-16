# Mayhem Survivors — RF Worlds

Android Alpha 0.1.0 · Godot 4.6.3 stable · GDScript · OpenGL Compatibility

## Starten

Die signierte Test-App liegt unter `builds/android/MayhemSurvivors-v0.1-debug.apk`.
Auf ein Android-Gerät mit ARM64-Prozessor und Android 7.0 oder neuer übertragen und installieren.
Es werden weder Konto noch Internetverbindung benötigt. Diese App enthält keine Werbung,
keine Käufe und keinen Windows-Export.

Für das Quellprojekt `project.godot` mit Godot 4.6.3 öffnen und das Projekt starten.
Die Startszene ist fertig verbunden; manuelles Zusammenbauen ist nicht nötig.
Die Bedienung ist ausschließlich für Touch ausgelegt. Ein Desktop-Start dient der Entwicklung,
nicht als eigene PC-Spielversion.

## Spielen

SPIELEN → einen von drei Helden auswählen → LOS GEHT’S.
Im unteren linken Bildschirmbereich berühren und ziehen: Der dynamische Joystick steuert
Richtung und Tempo. Waffen greifen selbstständig an. Kristalle aufsammeln, eines von drei
Level-Upgrades auswählen und neun 60-Sekunden-Wellen überleben. Im Shop gibt es vier
Angebote, vier Waffenslots und einen kostenlosen Reroll je Besuch. Gleichartige Waffen
werden bis Stufe fünf verbessert. In Welle zehn muss THE OVERLORD innerhalb von 90 Sekunden
besiegt werden. Der Pausebutton liegt oben rechts. Ergebnisse, Statistik und Einstellungen
werden lokal gespeichert; laufende Runs werden nach vollständigem Beenden nicht fortgesetzt.

## Aufbau

- `scripts/core/game.gd`: Run-Koordination, Arena, KI, Wellen, Progression und mobile Menüs.
- `scripts/core/game_state_machine.gd`: explizite Zustände und zulässige Übergänge.
- `scripts/characters/player_controller.gd`: CharacterBody2D und Arenagrenzen.
- `scripts/weapons/weapon_manager.gd`: fünf automatische Waffen, Zielsuche, Waffenlevel.
- `scripts/combat/projectile_pool.gd`: begrenzter, wiederverwendeter Projektilspeicher.
- `scripts/autoload/save_manager.gd`: versionierte JSON-Daten, atomisches Schreiben, Sicherung.
- `scripts/mobile/joystick_visual.gd`: Joystick, HP-, XP- und Bossbalken.
- `scripts/ui/portrait.gd`: animierte eigene Cartoonporträts und Siegerkonfetti.
- `data/`: alle Helden, Waffenbasiswerte, Gegner, Upgrades und Wellen als JSON.
- `assets/`: eigene Wortmarke, Icon, Splashscreen und elf erzeugte WAV-Effekte.
  Die Arenagrafik und Figuren werden direkt in Godot gezeichnet, Musik wird synthetisiert.

Die Grafikstufen LOW/MEDIUM/HIGH verändern ausschließlich das Effektlimit (30/65/110),
nicht Gegnerzahl, Belohnungen oder Schwierigkeit. Maximal 100 aktive Gegner, 320
Projektilslots und 240 XP-Objekte; überschüssige Kristalle werden ohne XP-Verlust vereinigt.
Die UI wird in einer 1920×1080-Referenzfläche skaliert und berücksichtigt die Android-Safe-Area.

## Tests und Export

```sh
godot --headless --path . --editor --import --quit
godot --headless --path . --script res://tests/integration.gd
godot --headless --path . --script res://tests/soak.gd
godot --headless --path . --export-debug Android builds/android/MayhemSurvivors-v0.1-debug.apk
```

Der Export benötigt Godot-4.6.3-Android-Exportvorlagen, JDK und Android SDK in den
Godot-Editoreinstellungen. Das Preset verwendet ausschließlich ARM64 und Debug-Signierung.
Auf dem Entwicklungsrechner wurden diese Werkzeuge tatsächlich eingerichtet und benutzt.
Eine Debug-Signatur ist kein Release-Schlüssel für eine Store-Veröffentlichung.

## Speicher und Rechte

`user://save.json` enthält Schema-Version 1, die drei verfügbaren Charaktere, abgeschlossene
Spiele, Siege, höchste Welle, Kills, Spielzeit und Einstellungen. Bei ungültigem JSON entsteht
`user://save.corrupt.json`; Standardwerte erlauben den weiteren Start. Es werden keine
Netzwerk-, Standort-, Mikrofon- oder Speicherfreigaben angefordert.

Alle Spielgrafiken und Sounds wurden für dieses Projekt neu erzeugt. Godot und seine
Bibliotheken behalten ihre eigenen Lizenzen; siehe https://godotengine.org/license/.

## Abnahmestand

Die Spielsysteme und ein signierter Android-Build sind vorhanden. Physisches Android-Gerät,
Notch-/Systemleistenvarianten, Installation und Geräteleistung wurden in dieser Umgebung
nicht praktisch geprüft. Siehe `TEST_REPORT.md`, `BUILD_REPORT.md` und `PROGRESS.md`.
Die Alpha ist deshalb noch nicht als vollständig auf Android abgenommen zu verstehen.
