# Mayhem Survivors — RF Worlds

Android Alpha **0.2.3** · Godot 4.6.3 stable · GDScript · Compatibility Renderer

## Neu in 0.2.3

- Eigene Comic-Figuren für Grunt, Runner, Tank und THE OVERLORD statt einfacher Kreise.
- Offener Industriehof mit gezeichnetem Boden, eingelassenen Gittern und klarer Randmarkierung.
  Die ganze bisherige Spielfläche bleibt begehbar; keine neuen Kollisionen oder Hindernisse.
- Trefferaufhellung, prozedurale Laufbewegung und begrenzte, ausblendende Todeseffekte.
- Radialsalve mit Strahlenwarnung; Sturmangriff mit Korridor zum tatsächlich fixierten Ziel.
  Countdown aus der echten Angriffsuhr, unterschiedliche Warntöne auf reservierter Audiostimme.
- Größere Siegesfeier ohne zusätzliche Wartezeit oder blockierte Ergebnisbuttons.
- Persönliche Bestwerte und Bilanz je Charakter sowie die letzten 20 abgeschlossenen Runden.
- Speicherformat 2 mit Übernahme alter Gesamtwerte/Einstellungen und Sicherung des Formats 1.

Die akzeptierte Klassenbindung und Zwei-Hand-Waffenhaltung aus 0.2.2 bleiben erhalten:

| Held | Erlaubte Waffen |
|---|---|
| Bruiser | Hammer |
| Sparky | Blaster, Splitgun, Arc Cannon |
| Shade | Orbit Blade |

Sparky kann passende Schusswaffen kombinieren; sichtbar gehalten wird eine Waffe mit zwei
Händen. Orbit Blade schwebt frei. Keine klassenfremden Käufe und keine nutzlosen Projektil-
Upgrades bei reinen Nah-/Orbitklassen. Alle Kampf-/Klassendaten sind gegenüber 0.2.2 unverändert.

## Installieren und starten

Die signierte APK wird separat im GitHub-Ordner `Downloads/` bereitgestellt. Das Quellprojekt-ZIP
enthält ausschließlich Quellen, Assets, Szenen, Tests und Berichte; keine APK und keine Toolchain.
Für einen eigenen Export lautet der Zielpfad `builds/android/MayhemSurvivors-v0.2.3-debug.apk`.

Android 7.0 oder neuer, ausschließlich ARM64. Gleicher Paketname und gleicher Signaturschlüssel
wie bisher, versionCode 5; als Update vorgesehen. Die echte Geräteinstallation wurde hier nicht geprüft.

Zum Öffnen der Quellen `project.godot` mit Godot 4.6.3 importieren und starten. Keine manuelle
Programmierung oder Szenenmontage notwendig. Die Bedienung ist ausschließlich für Touch ausgelegt.

SPIELEN → Charakter wählen → Welle starten. Links unten ziehen, Waffen greifen automatisch an.
Kristalle sammeln und Upgrades wählen. Zwischen neun 60-Sekunden-Wellen liegt ein Shop mit
vier Angeboten und Rerolls. Welle zehn: Boss innerhalb von 90 Sekunden besiegen.
Pause oben rechts; Android-Unterbrechung pausiert die Simulation. Offline, ohne Werbung oder Käufe.

## Statistik und Speicherübernahme

Die bisherigen Gesamtwerte bleiben erhalten. Bei Format 1 entsteht einmalig
`user://save.v1.backup.json`; der nächste Speichervorgang schreibt Format 2 atomisch.
Ungültige JSON-Dateien werden unter `user://save.corrupt.json` gesichert und abgefangen.

Charakterbestwerte und Verlauf beginnen ab 0.2.3, weil frühere Spielstände keine Zuordnung
alter Runden zu Charakteren enthielten. Es werden keine alten Charakterergebnisse erfunden.
Gespeichert werden pro Held Spiele, Siege, Kills, Coins, aktive Kampfzeit, höchste Welle,
Kill-/Level-/Schadensbestwert, längster Run und schnellster Sieg. Der Verlauf zeigt bis zu
20 neue abgeschlossene Runden mit Ausrüstung und lässt sich nach Charakter filtern.
Ein aktiver Run wird nach vollständigem App-Ende weiterhin nicht wiederhergestellt.

## Aufbau

- `scripts/core/game.gd`: Run, Menüs, Wellen, Kampf, Shop und Ergebnisverbindung.
- `scripts/core/game_state_machine.gd`: Zustände und Übergänge.
- `scripts/characters/player_controller.gd`: Analogbewegung und Arenagrenzen.
- `scripts/weapons/weapon_manager.gd`: automatische Angriffe; gegenüber 0.2.2 unverändert.
- `scripts/combat/combat_visuals.gd`: akzeptierte Zweihandhaltung und Waffenfeedback.
- `scripts/gameplay/world_visuals.gd`: Boden, Gegnerdarstellung, Todeseffekte und Bosswarnflächen.
- `scripts/progression/run_records.gd`: Charakterbestwerte und begrenzter Verlauf.
- `scripts/autoload/save_manager.gd`: Schema-1/2-Laden, Sicherung und atomisches Schreiben.
- `assets/enemies/enemies_atlas.png`: vier vollständige Gegnerfiguren.
- `assets/environments/scrapyard.png`: flacher Arena-Hintergrund ohne Gameplay-Objekte.

Alle Spielgrafiken und Effekte wurden für das Projekt erstellt; die Bildgenerierung folgt den
vom Nutzer gelieferten Stilreferenzen. Godot und seine Bibliotheken behalten ihre eigenen
Lizenzen: https://godotengine.org/license/.

## Prüfungen und Export

```sh
godot --headless --path . --editor --import --quit
godot --headless --path . --script res://tests/integration.gd
godot --headless --path . --script res://tests/combat_visuals_test.gd
godot --headless --path . --script res://tests/character_policy_test.gd
godot --headless --path . --script res://tests/world_visuals_test.gd
godot --headless --path . --script res://tests/run_records_test.gd
godot --headless --fixed-fps 60 --path . --script res://tests/world_trace.gd
godot --headless --path . --export-debug Android builds/android/MayhemSurvivors-v0.2.3-debug.apk
```

210 Prüfungen bestanden. Die neue Regression verwendet legale Klassen-Loadouts der akzeptierten
Version 0.2.2 und vergleicht 33 Kontrollpunkte über 3600 Schritte. Der ältere `balance_trace.gd`
bleibt als historischer Test künstlicher Mehrwaffen-Loadouts erhalten.
Export benötigt Godot-Android-Vorlagen, JDK und SDK in den Editoreinstellungen; diese wurden
hier tatsächlich benutzt. APK-Signatur und 16-KiB-Alignment wurden geprüft.

## Noch offen

Echte Android-Updateinstallation und Statistikübernahme, neue Gegnerlesbarkeit im dichten Kampf,
Warntöne über Geräteaudio, lange Runs mit allen Klassen und Geräte-FPS/Temperatur.
Die Gegner sind prozedural bewegte Stand-Sprites, keine handgezeichneten Mehrbild-Laufsequenzen.
Die Renderbilder sind Godot-Testaufnahmen; Statistikbilder verwenden vorgegebene Testdaten.
Details: `TEST_REPORT.md`, `BUILD_REPORT.md`, `PROGRESS.md`.
