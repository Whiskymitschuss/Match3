# Testbericht 0.4.0 — 2026-11-16

Godot 4.6.3 stable, Linux Headless und gerendert mit Mesa GL Compatibility.
Tatsächliche Ergebnisse unter `tests/results/v0.4-*.log`.

| Suite | Ergebnis |
|---|---|
| Integration | 76 / 76 |
| Kampfgrafik | 28 / 28 |
| Klassenbindung/Haltung | 42 / 42 |
| Welt/Bosswarnungen | 36 / 36 |
| Laufstatistik/Speicherung | 28 / 28 |
| Reaktor und Migration | 157 / 157 |
| Heldenfähigkeiten, Touch, Haptik und Einstellungen | 76 / 76 |
| Gesamt | 443 / 443 |

Neue Tests: Schaden und Radius, Nahkampfbonus, Rückstoß, Bossimmunität gegen
Displacement/Slow, Granatenziel/Zünder/Explosion, einmalige Treffer, Slow-Ablauf,
Dash-Distanz und durchgehende Streckenkollision bei langen Frames, Grenzen und
blockierte Aktivierung, Ende der Unverwundbarkeit, Cooldown und Pausierung in allen
Unterbrechungszuständen. Alle drei Fähigkeiten können beide Bosse besiegen und
anschließend sicher neu starten. Dafür setzen die Tests Boss-HP auf 1; dies ist keine
vollständig gespielte oder gebalancte Bossabnahme.

Touch-Tests leiten echte InputEventScreenTouch/Drag über `Viewport.push_input` durch
den Godot-Inputweg: zwei Finger, getrennte Freigabe, kein Wiederholen beim Halten,
kein Auslösen beim Überziehen des Joysticks, wechselnde UI-Transformationen und
Freigabe außerhalb des Buttons. Kein Android-Touchhardware-Beleg.
Haptikpolitik mit injiziertem Recorder geprüft: AUS, Stärken, Rate-Limit, ungültige
Ereignisse. Echte Vibration und Amplituden auf Android noch nicht geprüft.
Alte Format-3-Einstellungen, ungültige optionale Felder und echter Datei-Roundtrip getestet.
Format-1/2-Migration wird durch die bestehenden Suiten weiterhin abgedeckt.

Deterministischer Schrottplatzvergleich: alle 33 Punkte / 3.600 Schritte / drei Helden
stimmen einschließlich HP, XP, Kills, Coins, Schaden, Gegner, Projektile und RNG mit
v0.2.2 überein, wenn keine Fähigkeit ausgelöst wird. Die aktiven Fähigkeiten verändern
bewusst das Kampfergebnis. Keine Änderungen an Waffen-, Gegner-, Upgrade-, Charakter-
oder Wellengrundwerten und keine zusätzlichen Waffenfreigaben.

Fähigkeiten-Belastung: 6 × 3.600 Schritte, 360 simulierte Sekunden, 38 tatsächliche
Aktivierungen; beide Arenen und alle Helden, bis 100 Gegner. Objekt-/Loot-/Zahlen-/
Gefahrenlimits und Spielergrenzen eingehalten. Zusätzlich Standard-Stresstest mit
7.200 Schritten bestanden. Massen-Drop-Test führt 310 auf 240 Kristalle zusammen und
behält exakt 48.205 XP. Keine Android-Performance-Messung.

Acht Godot/Mesa-Aufnahmen (`tests/ability_*.png`) zeigen alle Fähigkeiten, Bereitschaft,
Granatenexplosion, Vorbereitung, Charakterwahl und Einstellungen. Vorgegebene Szenen,
keine Android-Aufnahmen. Im schnellen Audio-Test musste nach Freigabe eine reale
80-ms-Mischthread-Nachlaufzeit ergänzt werden; der finale Lauf endet ohne Ressourcenwarnung.
Dummy-Display unterstützt kein V-Sync. Kein Parser- oder Ressourcenladefehler.

Das Quell-ZIP wurde separat in ein leeres Verzeichnis entpackt und frisch importiert. Keine Parser-/Ressourcenfehler; Fähigkeitssuite daraus erneut 76 / 76 bestanden.

Offen: physisches Android-Update mit Nutzerspeicher, echte Multitouch-/Vibrationsbedienung,
volle Runs und Fähigkeitsbalancing aller Helden, Geräte-FPS, Temperatur und verschiedene Displays.

---

# Historische Tests 0.3

# Testbericht 0.3.0 — 2026-11-16

Godot 4.6.3 stable, GDScript, Linux Headless und Mesa Compatibility. Tatsächliche Logs
unter `tests/results/v0.3-*.log`. Keine physischen Android-Tests dieser Version.

| Suite | Ergebnis |
|---|---|
| Integration | 76 / 76 |
| Kampfgrafik | 28 / 28 |
| Klassenbindung/Haltung | 42 / 42 |
| Welt/Bosswarnungen | 36 / 36 |
| Laufstatistik/Speicherung | 28 / 28 |
| Reaktor, Freischaltung, Gefahren, vollständige Zustandsabläufe, Migration | 157 / 157 |
| Gesamt | 367 / 367 |

Zusätzlich: Schrottplatz-Referenzvergleich mit v0.2.2, 33 Kontrollpunkte über 3.600
feste Simulationsschritte für alle drei Helden, vollständig identisch einschließlich
HP, XP, Coins, Kills, Schaden, Gegner, Projektile und kritischem RNG. Charakter-,
Waffen-, Gegner-, Upgrade- und klassische Wellendaten sowie Waffenmanager,
Projektilpool und Kampfgrafikmodul sind unverändert zur Referenz a4efbc4.

Belastungsläufe Schrottplatz/Reaktor: jeweils 7.200 Schritte, 120 simulierte Sekunden,
bis 100 aktive Gegner, Objekt-/Loot-/Effekt-/Gefahrenlimits eingehalten. Synthetischer
Stressaufbau mit vier Waffen; keine reguläre Klassenfreigabe und keine Android-FPS-Messung.

Kontrollierte Boss-Schadensprobe: Stufe-5-Klassenwaffen, Schadenfaktor 2,2,
Angriffsfaktor 1,6, Kritchance 25 %, Multishot +1, Abstand 100, ohne eingehenden Schaden.
Bruiser 11,38 s, Sparky 4,35 s, Shade 38,10 s bis 4.200 HP. Belegt erreichbaren Schaden
in dieser festen Versuchsanordnung, keinen vollständigen oder fair gebalancten Spieler-Run.

Reaktortest deckt Warnung ohne Schaden, Aktivierung, Invulnerabilität, lange Frames,
fixierte Ziele, Bossruhe während Warnung, vier gerichtete Dreiersalven, Pause/Level/Shop,
Victory/Timeout/Tod, Aufräumen, Neustart, alle 60 Held/Arena/Wellenkombinationen und
Migration aus Format 2 ab. Bestehender Migrationstest deckt Format 1 und Korruption ab.
Die Ablaufprüfung verkürzt Wellentimer und setzt tödlichen Boss-Testschaden; sie ist
kein autonom durchgespielter Zehn-Minuten-Run.

Sieben Bilder tatsächlich mit Godot/Mesa gerendert: Auswahl, Menü, Arena, Kreuzlaser,
Kernbomben, Stile, Statistik (`tests/reactor_*.png`). Vorgabedaten, keine Android-Aufnahmen.
Initialer Lauf meldete beim Audio-Test Ressourcen beim Prozessende; gezielter Wiederholungslauf
mit `--verbose` beendete sauber. Kein Kampf-/Parserfehler. V-Sync im Dummy-Display nicht verfügbar.

Zusätzlich Quell-ZIP in ein leeres Verzeichnis entpackt: frischer Import ohne Parser-/Ressourcenfehler, anschließend Reaktorsuite erneut 157 / 157 bestanden.

Offen: Android-Update mit echten Nutzerdaten, Bedienung und vollständiger Reaktorrun je
Held, Ton auf Gerät, Aussparungen/abweichende Displays, FPS und thermische Belastung.

---

# Historische Tests 0.2.3

# Tests 0.2.3 — 2026-11-16

## Bestätigter Nutzer-Praxistest

Nach Übergabe von 0.2.3 meldete der Nutzer einen vollständig durchgespielten Android-Run
mit Sparky und „Läuft sehr gut“. Der beigefügte Sieg-Screenshot zeigt:

- Welle 10 / 10, Sieg, Kampfzeit 09:07.
- 602 Kills, Level 20, 48.387 Schaden, 1.566 gesammelte Coins.
- Blaster Stufe 5, Arc Cannon Stufe 2, Splitgun Stufe 3.

Dies ist ein Nutzerbeleg für einen vollständigen Sparky-Run, keine durch den Agenten
aufgezeichnete Gerätemessung. Gerätemodell, Android-Version, FPS, thermisches Verhalten,
Erhalt der Statistik nach App-Neustart und vollständige Runs mit Bruiser/Shade sind damit
noch nicht bestätigt. Der Code-Stand `a4efbc4` bleibt die Referenz für weitere Erweiterungen.

## Ausgeführte Suiten

| Suite | Bestanden | Fehlgeschlagen |
|---|---:|---:|
| Integration | 76 | 0 |
| Kampfeffekte/Projektile | 28 | 0 |
| Klassen und Zweihandhaltung | 42 | 0 |
| Welt, Todeseffekte und Bosswarnungen | 36 | 0 |
| Charakterbestwerte, Verlauf und Migration | 28 | 0 |
| **Summe** | **210** | **0** |

Zusätzlich: neue deterministische Regression mit erlaubten Klassen-Loadouts gegen den
Git-Stand 0.2.2 (`d47853c`). Alle 33 Kontrollpunkte über 3600 Schritte stimmen überein:
HP, XP, Coins, Kills, Schaden, Gegner- und Projektilzustände sowie Krit-Zufallszustand.
Positionswerte werden auf vier Nachkommastellen protokolliert, JSON-Zahlen mit 0.000001
Toleranz gelesen. Dies ist ein reproduzierbarer Ablauf, kein formaler Beweis aller Spielzustände.
Spieldaten und unveränderte Kampfmodule zusätzlich bytegleich geprüft.

## Neue Grenzfälle

Todeseffekte ohne doppelte Belohnung, abgelöste Positions-Snapshots, Effektlimit und Cleanup,
Pause/Resume, echte Bossphasen und Countdown, unveränderte 18er-Salve, fixiertes Sturmziel,
keine visuelle RNG-Nutzung, kein blockierter Siegbutton, keine doppelte Siegerfassung und
Warning-Audio bei belegten normalen SFX-Stimmen.
Dateibasierte Schema-1-Migration mit Originalbackup, Erhalt aller alten Gesamtwerte und
Einstellungen, keine erfundenen Charakterresultate, echte Ergebnisverbindung, unveränderliche
Bestwerte bei schlechteren Runs, schnellster Sieg, begrenzter 20er-Verlauf, neueste Runde zuerst,
Schema-2-Roundtrip, beschädigte Unterfelder und sichere Seiten-/Charakterfilter.

## Weitere Nachweise

Headless-Lasttest: 7200 Schritte, 120 simulierte Sekunden, Spitze 100 Gegner, synthetisches
Vierwaffen-Loadout. Gemessen ca. 0.350 ms Simulationszeit pro Schritt auf dem Entwicklungsrechner.
Dies enthält keine Grafikberechnung und ist keine Android-FPS-Messung.

Gerendert und geprüft: `world_arena.png`, `world_crowd.png`, `world_boundary.png`,
`world_boss_radial.png`, `world_boss_charge.png`, `world_victory.png`, `world_stats.png`,
`world_stats_sparky.png`, `world_history.png`. Godot Compatibility/Mesa auf Linux, 1280×720.
Der Spieler bleibt wie zuvor vor der Menge sichtbar. Boden und Figuren sind Grafiken,
keine neuen Hindernisse oder veränderten Kollisionen. Statistikbilder zeigen kontrollierte
Testdatensätze, keine tatsächlichen Spielerfolge oder ausgelesenen Android-Nutzerdaten.

APK-Version, Paket, ARM64, Signatur, Berechtigungen, Assets und 16-KiB-Alignment geprüft.
Keine Parserfehler. Der virtuelle Grafiktreiber meldet nur nicht umschaltbare VSync-Einstellung.

## Offene Geräteabnahme

Ein voller Sparky-Run ist durch Nutzerfeedback bestätigt. Statistikpersistenz, spezifische
Audio-/Displayprüfungen, andere Klassen und Geräte-FPS/Temperatur bleiben noch offen.
Rohprotokolle: `tests/results/v0.2.3/`.

---

## Archiv: Stand 0.2.2

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
