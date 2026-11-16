# Tests 0.2.2 — 2026-11-16

- 76 bisherige Integrationsprüfungen bestanden.
- 28 Effekt-/Projektilprüfungen bestanden.
- 42 neue Klassen-/Rigprüfungen bestanden: korrekte Startwaffen, erlaubte Käufe, Abweisung
  klassenfremder Käufe ohne Coin-/Inventaränderung, 40 zufällige Shoplisten je Held,
  Filtern nutzloser Projektil-/Multishot-Upgrades, Stat-Upgrades ohne Waffenvergabe,
  zwei endliche Griffpunkte bei 16 Zielwinkeln je Held, keine Extra-Hände für Orbit, Cleanup.
- Historischer Formelnvergleich: 33 Kontrollpunkte über 3600 Schritte weiterhin bestanden.
  Er injiziert frühere Mehrwaffen-Loadouts unabhängig vom Shop und beweist nur das getestete
  Verhalten der Formeln, nicht die Balance der nun eingeschränkten Klassen-Loadouts.
- Numerische Charakterwerte geprüft; nur `allowed_weapons` in den Charakterdaten ergänzt.
  Waffen-, Gegner-, Wellen- und Upgrade-JSON sowie PlayerController und SaveManager unverändert.
- Tatsächlich gerenderte Bilder: `grip_bruiser.png`, `grip_sparky.png`, `grip_shade.png`,
  vergrößerte `grip_close_*.png`, Sparkys Dreifach-Loadout und drei Klassen-Shops.
  Die Körperregionen enthalten keine Hände; Handschuhkomponenten werden genau zweimal gezeichnet.
  Die vergrößerten Bilder sind Godot-Aufnahmen mit Kamerazoom, keine nachbearbeiteten Spielerbilder.
- Import und Android-Export ohne Parserfehler; APK-Signatur, Architektur und Alignment geprüft.

Rohprotokolle: `tests/results/v0.2.2/`. Keine physische Android-Installation oder neue
Klassenbalance über zehn Wellen geprüft. Die vorläufige Waffenbindung ist eine Spielregeländerung,
keine reine Grafikänderung; daher keine unveränderte Gesamtbalance behauptet.

---

## Archiv: Stand 0.2.1

# Waffen-/Geschosstests 0.2.1 — 2026-11-16

- 76 bestehende Integrationstests bestanden.
- 28 neue Prüfungen bestanden: tatsächliche Angriffe stempeln Charakter-/Waffenmetadaten,
  identischer Basisschaden und Flugtempo, Wiederverwendung des Projektilslots zwischen Helden,
  Mündungsfeedback, visuelle Pause, Cleanup, Hammer-/Blitz-/Orbitereignisse, Effektbudget,
  verschiedene Atlasregionen und Vorhandensein der fünf Soundressourcen.
- Reproduzierbare Balance-Regression mit `--fixed-fps 60`: alle drei Helden, fünf Waffen über
  vier Slots, 3600 Schritte, 33 Kontrollpunkte. HP, Coins, Kills, Schaden, XP, Gegnerpositionen/HP,
  Projektilpositionen/Schaden/Lebensdauer und Krit-Zufallszustand stimmen mit der 0.1-Referenz
  überein. Aufgezeichnete Positionswerte haben vier Nachkommastellen; JSON-Zahlen werden mit
  Toleranz 0.000001 verglichen. Dies ist ein getesteter Ablauf, kein formaler Beweis aller Zustände.
- Belastungstest: 7200 Schritte, 120 simulierte Sekunden, 100 Gegner als Spitze,
  ca. 0.358 ms Headless-Simulationszeit pro Schritt auf diesem Rechner. Keine Android-FPS-Angabe.
- Neun Atlaszellen auf Transparenz und sichtbaren Inhalt geprüft.
- Mit Godot Compatibility/Mesa tatsächlich gerendert: `combat_bruiser.png`, `combat_sparky.png`,
  `combat_shade.png`, `combat_shop.png` sowie drei `ammo_*.png` zum Vergleich der Geschossformen.
  Dies sind kontrollierte Testszenarien, keine Bildschirmaufnahmen eines Android-Geräts.
- Neue Audioassets importiert; keine Hardware-Hörprüfung durchgeführt.
- Android-APK exportiert, Signatur, Version, Architektur, Berechtigungen und Alignment geprüft.

Protokolle: `tests/results/v0.2.1/`. Physisches Android-Update, Audio, Effektlesbarkeit im
vollen Kampf und neue Geräte-FPS bleiben offen. Schaden, Feuerraten und Spawnregeln wurden
für das Grafikupdate nicht verändert.

---

## Archiv: Stand 0.2

# Charaktergrafik-Tests 0.2 — 2026-11-16

- Bestehende Integrationstests erneut ausgeführt: **76 bestanden, 0 fehlgeschlagen**.
- Godot 4.6.3 importiert neue PNG- und Scriptressourcen ohne Parserfehler.
- Auswahl, Arena, Hauptmenü, Shop, Upgrades, Boss und Ergebnis tatsächlich gerendert.
  Charakterauswahl und Arena visuell auf vollständig sichtbare Figuren geprüft.
- Alle sechs Atlaszellen besitzen transparente Außenbereiche und sichtbaren Figureninhalt.
- Alle Daten unter `data/` gegenüber 0.1 bytegleich. Waffenmanager, PlayerController,
  Projektilpool und SaveManager ebenfalls bytegleich. Die einzige Ergänzung im
  Simulationsschritt bestimmt eine visuelle Spiegelrichtung; sie verändert keine Bewegung.
- Kampfwerte, Spawnintervalle, Kollisionsradius und Belohnungen bleiben unverändert.
- Paket, Version, Signatur und Alignment des neuen Android-Builds statisch geprüft.
- **Kein physischer Android-Test der neuen Grafiken** in dieser Umgebung. Insbesondere
  Sichtbarkeit in dichtem Kampf, Updateinstallation und Leistung müssen noch geprüft werden.
- Kein neuer Performance-Test behauptet: die Messwerte weiter unten stammen aus 0.1.

Protokolle: `tests/results/v0.2/`. Aktuelle Renderbilder: `tests/*.png`.
Die vom Nutzer gemeldeten 15 gespielten Runden betreffen die vorherige Version 0.1.

---

## Archiv: Testbericht 0.1

# Testbericht — 2026-11-15

## Tatsächlich ausgeführt

Godot 4.6.3 stable, Linux-Entwicklungsumgebung. Keine physischen Android-Geräte verbunden.

| Prüfung | Ergebnis |
|---|---|
| Headless-Import sämtlicher Ressourcen | erfolgreich; keine Parserfehler oder fehlenden Ressourcen |
| `tests/integration.gd` | **76 bestanden, 0 fehlgeschlagen** |
| `tests/soak.gd` | **7200 Schritte / 120 simulierte Sekunden bestanden** |
| OpenGL-Renderprüfung | sieben Ansichten als PNG erzeugt und visuell geprüft |
| Android-Debugexport | erfolgreich, ARM64-APK erzeugt |
| APK-Signaturprüfung | erfolgreich, v2 und v3 |
| ZIP-/16-KiB-Alignment | erfolgreich |
| APK-Paket-/Architekturprüfung | korrekt; nur arm64-v8a |
| Android-Installation / manueller kompletter Run | **nicht ausgeführt** |
| Android-FPS / Notch / echtes Multitouch / Hardwareaudio | **nicht ausgeführt** |

## Integrationsumfang

Boot und Menü; drei Charaktere und exakte Startwerte; Analogbewegung und Diagonallimit;
Arenagrenzen; sichere Spawns; Verfolgung aller drei Gegnertypen; alle fünf automatischen
Waffen; Projektiltreffer und Trefferbegrenzung; Schaden und Kritsystem im Spielpfad;
einmaliger Tod, XP-Kristalle, XP-Einsammeln und Coinbelohnung; XP-Formel und mehrere
Levelaufstiege; alle zehn Upgradeeffekte und Angebotsfilter; Shopkauf, doppelte Käufe,
Rerollkosten, keine negativen Coins und keine Max-Level-Waffenangebote;
Pause und Fortsetzen; alle neun Wellen-Shop-Übergänge; Joystick-Fingerzuordnung,
zweiter Finger, Rückstellung und Android-Unterbrechung; sichere Bereinigung beim Tod;
Boss-Spawn, Warnung, Radialsalve, Sturmziel und kein unangekündigter Startsturm;
Victory, Game Over, Bosszeitlimit, Statistik nur einmal schreiben und sauberer Neustart;
Speichern, Laden und beschädigte JSON-Datei mit Sicherung.

Die Tests setzen bewusst Zustände, Gegnerpositionen und Timer, um Grenzfälle schnell und
reproduzierbar zu erreichen. Sie sind kein Nachweis eines manuell durchgespielten Runs.
Der Testmodus unterdrückt Audiowiedergabe; WAV-Dateien werden trotzdem importiert.

## Belastungstest

Vier Level-5-Waffen, Welle-9-Regeln, kreisförmige synthetische Bewegung und anfangs
100 Gegner. Für diesen Test sind die Lebenspunkte erhöht; Leveldialoge werden automatisch
aufgelöst. Bei jedem Schritt werden Grenzen für Gegner, Projektile, Kristalle und Effekte geprüft.

Letzter gemessener Lauf: 2,435711 Sekunden Rechenzeit für 7200 Simulationsschritte,
ca. **0,338 ms pro Simulationsschritt**, Spitzenwert 100 Gegner, 208 Kills.
Das misst ausschließlich die Headless-Simulation auf dem Entwicklungsrechner.
Es ist weder eine gerenderte Framerate noch ein Leistungsversprechen für Android.

## Grafikprüfung

Godot Compatibility Renderer mit Mesa llvmpipe, 1280×720. Ansichten unter `tests/`:
`menu.png`, `characters.png`, `arena.png`, `boss.png`, `shop.png`, `upgrades.png`,
`victory.png`. Die Bilder zeigen kontrollierte Testzustände; insbesondere ist das
Victory-Bild kein Beleg für einen tatsächlich durchgespielten Run.
Die UI-Texte, Figuren, Balken und großen Buttons wurden anhand dieser Bilder geprüft.
Der virtuelle Grafiktreiber meldet nur fehlende VSync-Umschaltung.

## Verbleibende Abnahme

Auf ARM64-Android installieren, alle drei Helden durchspielen, Shop und Upgrades mit Fingern
bedienen, Gerätewechsel in Hintergrund/Vordergrund prüfen und 60-FPS-Ziel messen.
Physisches Touchgefühl, Safe Area auf realen Displayausschnitten, Audio und thermische
Stabilität sind noch offen. Deshalb keine vollständige Android-Abnahme erklärt.

Rohprotokolle: `tests/results/`.

## Entpackte Übergabe

Das ZIP wurde auf CRC-Integrität geprüft und in einen neuen Ordner entpackt.
Die entpackte Kopie wurde ohne vorhandenen `.godot`-Cache erfolgreich importiert
und headless gestartet. Ein sehr kurzer, erzwungener `--quit-after`-Start meldet
beim Beenden gelegentlich eine ObjectDB-Warnung zu noch aktiver Audiowiedergabe.
Die geordnet beendeten Integrationstests und der Belastungstest enden ohne diese Warnung.
Dies ist als offene Shutdown-Prüfung auf Android zu berücksichtigen.
