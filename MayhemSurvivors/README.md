# Mayhem Survivors — RF Worlds

Android Alpha **0.2.2** · Godot 4.6.3 stable · GDScript · Compatibility Renderer

## Neu: klare Waffenhaltung und Klassen

Der frühere Fehler mit zusätzlichen Händen ist durch einen getrennten Gameplay-Rig ersetzt:
Körper ohne eingemalte Arme, zwei animierte Arme und genau zwei Handschuhkomponenten.
Diese Hände liegen an den Griffpunkten einer sichtbar geführten Hauptwaffe. Die vollständigen
Auswahlporträts bleiben erhalten. Die Orbit Blade schwebt frei und bekommt keine eigenen Hände.

Vorläufige Waffenbindung für diesen Teststand:

| Held | Erlaubte Waffen |
|---|---|
| Bruiser | Hammer |
| Sparky | Blaster, Splitgun, Arc Cannon |
| Shade | Orbit Blade |

Sparky kann mehrere passende Schusswaffen ausrüsten; automatisch angegriffen wird weiterhin
mit den ausgerüsteten Waffen. In der Figur wird immer nur eine gehaltene Waffe dargestellt,
keine zusätzlichen Arme pro Waffenslot. Andere Waffen werden im Shop ausgefiltert und
auch bei der Kaufprüfung abgewiesen. Stat-Upgrades vergeben keine neuen Waffen.
Bruiser und Shade erhalten keine nutzlosen Projektil-/Multishot-Angebote.

**Die Waffenbindung verändert die möglichen Builds.** Zahlenwerte für HP, Tempo, Schaden,
Feuerrate, Reichweite, Gegner, Wellen und Belohnungen wurden nicht angepasst. Die neue
Klassenverteilung muss über volle Runs geprüft werden; keine unveränderte Gesamtbalance behauptet.

## Installieren und starten

`builds/android/MayhemSurvivors-v0.2.2-debug.apk` ist die signierte ARM64-Test-App.
Android 7.0 oder neuer. Gleicher Paketname und gleiche Debug-Signatur wie bisher,
versionCode 4; als Update vorgesehen. Speicherschema 1 und Charakter-IDs bleiben gleich.
Die tatsächliche Updateinstallation und Statistikübernahme wurden hier nicht auf einem Gerät geprüft.

Quellprojekt: `project.godot` mit Godot 4.6.3 öffnen und starten. Es sind keine manuellen
Codekorrekturen oder zusammenzubauenden Szenen nötig. Die Bedienung ist für Touch ausgelegt.

SPIELEN → Charakter auswählen → Welle starten. Links unten ziehen, Waffen greifen automatisch
an. XP-Kristalle einsammeln und ein Upgrade wählen. Zwischen neun 60-Sekunden-Wellen gibt
es einen Shop mit vier Angeboten, Heilung und Rerolls. Welle zehn: Boss innerhalb von
90 Sekunden besiegen. Pause oben rechts; Android-Unterbrechung hält die Simulation an.
Alles läuft offline, ohne Werbung, Käufe oder Konten.

## Systeme und Ressourcen

- `scripts/core/game.gd`: Run, Menüs, Wellen, Shop, XP, Schadens- und Gegnerkoordination.
- `scripts/core/game_state_machine.gd`: erlaubte Zustandsübergänge.
- `scripts/characters/player_controller.gd`: Analogbewegung und Arenagrenzen.
- `scripts/weapons/weapon_manager.gd`: automatische Waffen und unveränderte Schadensformeln.
- `scripts/combat/combat_visuals.gd`: ein gehaltener Waffen-Rig, zwei Arme/Hände, Attackenfeedback.
- `scripts/combat/projectile_pool.gd`: begrenzte, wiederverwendete Geschosse.
- `scripts/ui/character_art.gd`: getrennte Auswahlbilder, Gameplay-Körper und Handschuhregionen.
- `scripts/autoload/save_manager.gd`: versionierte, atomische lokale Speicherung mit Fehlerabfang.
- `data/characters/characters.json`: Werte, Startwaffen und `allowed_weapons` pro Klasse.
- `assets/characters/hero_rig.png`: neue Körper-/Handkomponenten; keine fertigen Arme im Körperbild.
- `assets/weapons/combat_atlas.png`: fünf Waffen, drei Geschossdesigns und Bossprojektil.

Alle Spielgrafiken und Sounds wurden für dieses Projekt erstellt. Die neuen Rigs wurden mit
Bildgenerierung aus den vom Nutzer gelieferten Charakterreferenzen abgeleitet. Godot und seine
Bibliotheken behalten ihre Lizenzen: https://godotengine.org/license/.

## Prüfen und exportieren

```sh
godot --headless --path . --editor --import --quit
godot --headless --path . --script res://tests/integration.gd
godot --headless --path . --script res://tests/combat_visuals_test.gd
godot --headless --path . --script res://tests/character_policy_test.gd
godot --headless --fixed-fps 60 --path . --script res://tests/balance_trace.gd
godot --headless --path . --export-debug Android builds/android/MayhemSurvivors-v0.2.2-debug.apk
```

146 Prüfungen bestanden (76 bestehende, 28 Effekte, 42 Klassen-/Haltungsprüfungen).
Der historische 33-Kontrollpunkt-Test injiziert alte Mehrwaffen-Loadouts künstlich, um die
unveränderten Formeln zu prüfen. Er ist kein Nachweis der neuen Klassenbalance oder eines
regulären Klassen-Runs. Das Rendering wurde mit Godot/Mesa geprüft, nicht auf Android.

Export benötigt passende Godot-Android-Vorlagen, JDK und Android SDK in den
Editoreinstellungen. Diese Werkzeuge wurden hier tatsächlich verwendet.

## Speicher und offene Abnahme

Statistik und Einstellungen liegen lokal in `user://save.json`, Schema 1. Ungültige Daten
werden gesichert und durch Standardwerte ersetzt. Ein laufender Run wird nach App-Ende
nicht wiederhergestellt. Keine Berechtigungen oder Netzwerkverbindung nötig.

Installation, neue Haltung bei Bewegung und beim Zielen in alle Richtungen, Klassenbalance
über zehn Wellen, Audio und 60-FPS-Ziel müssen auf echter Hardware geprüft werden.
Siehe `PROGRESS.md`, `TEST_REPORT.md` und `BUILD_REPORT.md`.
