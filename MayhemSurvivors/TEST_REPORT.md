# Testbericht 0.9.0 — 2026-11-16

Godot 4.6.3 stable, Headless plus natives Mesa-Rendering. Logs tests/results/v0.9-*.
926 Assertions bestanden: 825 bisherige + 101 neue Neon-Interface-Prüfungen.
Keine Parser-/Ressourcenfehler oder fehlgeschlagenen Assertions im finalen Lauf.

Neue Suite: alle 49 semantischen Grafikressourcen, zehn Upgrade-IDs, passende
Aktionsicons, tatsächliche Buttons/Touchgrößen und LOW/MEDIUM/HIGH; LOW ohne Motion/
Weichzeichner. Illustration wirklich integriert, Statistik mit Lesbarkeitsscrim trotz
unverändertem Main-Menu-Spielzustand, echte Angebots- und Level-up-Grafiken statt
Symbolzeichen, Kampf während Shop angehalten. Produktionsübergang beginnt transparent
und endet auf exakter Touchposition; rasche Wechsel ignorieren alte Revisionen,
keine unsichtbar bleibenden Buttons. Acht Gegenstände am Run-Ende passen mit Umbruch
in die Ergebnisfläche. Test enthält echte Prozessframes, keine bloßen Mock-Callbacks.

Referenztraces weiterhin bestanden: Welt 33 Punkte/3.600 Schritte, Effekte 87 Punkte/
8.700 Schritte unter ausdrücklich historischen eingefrorenen Wellen. Keine Aussage,
dass heutige späte Wellen mit Versionen vor 0.7 identisch wären. Datenverzeichnis
gegenüber 0.8 unverändert; Änderungen an game.gd betreffen Darstellung/Navigation.

Native Galerie: Hauptmenü, Charaktere, Arenen, Vorbereitung, Einstellungen, Pause,
Sieg; Shop/Inventar/Sets/Werte/Werkstatt/Hilfe; Statistik, Verlauf, Ziele, Level-up,
Bestätigungen, Entwicklung und vollständiger Niederlagen-Build. Neue Bildebene mit
Weichzeichner separat von Text/Bedienung. Mehrfachnavigation und Glyphen im nativen
Render kontrolliert. Teststatistiken sind Vorgaben und keine gespielten Android-Runs.

Zusätzlich Engine-Mitschnitt aus 84 gerenderten Frames bei festem 30-Hz-Zeitmaß,
als 2,8-Sekunden-GIF kodiert. Kein gemessener 30-/60-FPS-Android-Nachweis.
16:9, 1280×591 und Tablet: Hintergrundgeometrie deckt den Viewport ab. Einzelne sehr
dunkle Motivpixel in alten Kanten-Helligkeitsproben sind keine Balken; aktuelle
Darstellung anhand Geometrie und sichtbarem Motiv geprüft. Safe-Area-/Touchtests grün.

Offen: neue Oberfläche auf echter Android-Hardware einschließlich Notch/Launcher-
Maske, Schriften, Übergängen und Last/FPS/Temperatur abnehmen. Export und native
Renderprüfung ersetzen diese Abnahme nicht.

---

## Historischer Stand vor 0.9

# Testbericht 0.8.0 — 2026-11-16

Godot 4.6.3 stable. Tatsächliche Logs in `tests/results/v0.8-*`.
825 Assertions bestanden: 798 bestehende und 27 Präsentation/Audio. Final keine
Parser-, Ressourcen- oder Testfehler. Ausführung mit --headless --fixed-fps 60.

Die neue Suite prüft eingebaute Logo-/Iconressourcen, zwei Fonts, echtes Logo im
Menübaum, touchdurchlässige Dekoration, ausreichend große Menübuttons, Zustand für
Musikauswahl, beide Looplängen, Pause/Resume-Lautstärke, eingefrorenen Kampf,
separate Null-/Masterregler, reservierte UI-/Bossstimmen bei zwölf belegten Effekten,
Cacheidentität, Pickup-Begrenzung und weiterhin verbundenen Shop/Resultat/Neustart.
Mixerfreigabe am Testende wartet echte Millisekunden, unabhängig von der beschleunigten
Simulationszeit. Quellen/Datenpreise nicht geändert; Git-Diff data/ bleibt leer.

Weltvergleich 33 Punkte/3.600 Schritte bestanden. Effektvergleich 87 Punkte/8.700
Schritte mit historischen eingefrorenen Wellendaten bestanden. Letzterer prüft
weiterhin ausdrücklich alte Regeln, keine neue Balanceidentität zu Versionen vor 0.7.

Native Mesa-Renderbilder: sieben neue Bildschirmansichten (Menü, Charakterwahl,
Arenen, Vorbereitung, Einstellungen, Pause, Sieg); sechs Shopansichten; Vollbild
16:9/breit/Tablet. Vorgabeszenen mit Teststatistiken, keine echten Android-Runs.
Neue Regler/Schrift/Studio-/Wortmarke visuell kontrolliert. Alle gemessenen breiten
Renderkanten ohne schwarze Seitenpixel. Bilder tests/presentation_*.png und shop_*.png.

Audiotechnik: 31 WAVs nicht stumm, ohne digital geclippte Samples; zwei Ogg-Musiken
decodiert und auf endliche, nicht stumme Samples geprüft. Das ist keine subjektive
Hörabnahme der Mischung auf Android. Kein physisches Gerät, keine FPS-/Hitzeprüfung.
Hardwareabnahme von UI, Icon/Launcher-Maskierung, Lautsprecher/Kopfhörer noch offen.


---

## Historischer Stand vor 0.8

# Testbericht 0.7.0 — 2026-11-16

Godot 4.6.3 stable, Linux Headless und native Mesa Compatibility. Tatsächliche Logs:
`tests/results/v0.7-*.log`. Keine physische Android-Abnahme/FPS-Messung.

| Suite | Bestanden |
|---|---:|
| Integration | 76 |
| Kampfgrafik | 28 |
| Klassenbindung/Haltung | 42 |
| Welt/Bosswarnungen | 36 |
| Statistik/Speicherung | 28 |
| Reaktor/Migration | 157 |
| Fähigkeiten/Touch/Haptik | 76 |
| Waffenspezialisierungen | 108 |
| Effekte | 40 |
| Reaktorgegner | 66 |
| Display/Balance | 100 |
| Shop/Items/Sets | 41 |
| Gesamt | 798 |

Shop prüft echte Käufe/Einmalabzug, Tradeoffs, Set-Aktivierung/-Verlust, wiederholtes
Synchronisieren, Erhalt von Levelboni, direkte Waffenupgrades bis Entwicklung,
Verwertungsrefunderstattung/letzte-Waffe-Schutz, unzureichende Coins, gültige Angebote,
Stats-/Detailansichten, eingefrorene Simulation, Wellenpersistenz und Neustartreset,
Crit-/Rüstungscap, HP-Untergrenze, Item-Historie und gespeicherten Hilfezustand.

Displayprüfung: fünf Seitenverhältnisse inkl. 32:9, drei simulierte Safe-Areas,
Kamera innerhalb Arena, echtes GUI-Pause-Klicken außerhalb der alten 1920er Breite,
Multitouch an drei Formen, Ablehnung neuer Touches in unsicheren Aussparungsbereichen.
Erste drei Wellen gegen eingefrorene 0.6-JSONs geprüft, beide späten Arenen stärker,
Belohnungen und Spawngruppen begrenzt. Fixture-Provenienz: Commit 72b145d.

Native Renderprüfung: Menü/Kampf 16:9, 1280×591 und Tablet; Ergebnis breit/Tablet.
Shop zusätzlich sechs 1280×591-Ansichten. Keine schwarzen Seitenpixel an den
geprüften Renderkanten. PNGs in tests/. Mesa warnt mangels VSync-Unterstützung;
Dummy-Audio beim visuellen Test. Das prüft keine Android-Systemleisten auf Hardware.

Regressionsvergleich Welt: 33 Kontrollpunkte/3.600 Schritte mit früherem Schrottplatz.
Effektvergleich: 87 Punkte/8.700 Schritte, alle zehn Waffenwege/Fähigkeiten/alter Boss.
Dafür werden ausdrücklich ALTE eingefrorene Wellen im Test injiziert; neue späte
Balance wird nicht als identisch behauptet. Produktion nutzt neue WaveBalance-Daten.

Lastprobe: 21.600 Schritte/360 simulierte Sekunden, beide Arenen × drei Helden,
LOW/MEDIUM/HIGH, Start mit 100 Gegnern und acht Items. Caps 100 Gegner, 6 Spucker,
2 Drohnen, 2 Warnungen, 320 Schüsse, 240 Loot und Effektlimits eingehalten.
Bot flieht auf festem Kreis; Shade teils null Kills, kein Fairness-/Run-Sieg-Beweis.

20 isolierte Boss-DPS-Proben (10 Entwicklungen × 2 Arenen) jeweils unter 90 Sekunden,
mit definiertem spätem Build ohne Itemboni. Gegnerbewegung/eingehender Schaden dabei
ausgeschaltet; beweist Erreichbarkeit des HP-Ziels, keine vollständigen Runs.
Analytische Druckprobe vergleicht Spawn-/HP-/Belohnungsfluss vor Caps/Spielerkills.
Offen: echte Android-Runs für neue Schwierigkeit und Shopökonomie, FPS/Temperatur,
Notch/immersiver Modus und alle Touch-Flows auf Hardware.

Quell-ZIP frisch in leeres Verzeichnis entpackt: Godot-Import ohne Parser-/Ressourcenfehler;
Shop 41/41 und Display/Balance 100/100 daraus erneut bestanden. Logs v0.7-clean-*.log.

Abschließende ZIP-Prüfung: in leeres Verzeichnis entpackt, Godot-Import ohne Parser-/
Ressourcenfehler. Alle 825 Assertions und beide Referenztraces mit dem mitgelieferten
Runner daraus erneut bestanden. Logs tests/results/v0.8-clean-*.log.

Erstimport-Abnahme 0.9: Ein erster paralleler Editor-Import in dieser Umgebung endete
mit SIGSEGV beim Assetimport. Nach Entfernen des generierten Caches lief der serielle
Neuimport vollständig durch; daraus alle 926 Assertions und beide Kampftraces bestanden.
`editor/import/use_multiple_threads=false` ist bereits im Projekt gesetzt, kein manueller
Eingriff erforderlich. Dies betrifft den Editor-Import und ändert keine Kampfregeln.

Finales ZIP erneut vollständig entpackt und Cache entfernt: Import erfolgreich,
alle 926 Assertions sowie beide Referenztraces daraus erneut bestanden.
Nachweise: tests/results/v0.9-final-zip-import.log und v0.9-final-zip-tests.log.
