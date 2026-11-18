# Mayhem Survivors 0.21.0 Alpha — MAYHEM UNITED

RF Worlds / Android ARM64 / Godot 4.6.3 stable / GDScript / vollständig offline.

Die neue Version verbindet elf Helden, zehn Arenen und neunzehn normale Gegnertypen
mit einer gemeinsamen Comic-Grafik. Bruiser, Steelfist, Axel, die weiteren Fighter,
Monster, Waffen und Arenaböden nutzen neu gezeichnete, aufeinander abgestimmte Atlanten.
Zwei gezeichnete Arme und Hände werden pro Held an gemeinsamen Rig-Ankern befestigt;
Waffen und sichtbare Ausrüstung bleiben austauschbar.

## Spielen und aktualisieren

MayhemSurvivors-v0.21-debug.apk über die bisherige Version installieren. Paketname
und Signierschlüssel bleiben gleich. Keine Deinstallation nötig. Coins, freigeschaltete
Helden, Ausrüstung, Statistiken und bisheriger Weltfortschritt bleiben erhalten.
project.godot lässt sich nach dem Import direkt starten; Generatoren sind optional.
Die Bedienung erfolgt per Touch-Joystick, Wischwahl und großen Schaltflächen.

## Zehn Welten

SCHROTTPLATZ → REAKTORZONE → NEONHAFEN → GLUTWERK → GIFTGÄRTEN → FROSTDEPOT → STURMDÄCHER → KRISTALLMINE → CHAOS-KIRMES → RISSKERN.

Ein Kampagnensieg in Welle 10 öffnet die nächste Arena. Endlos, Niederlagen und
Zwischenbosse öffnen keine Welt. Bruiser ist frei; die zehn weiteren Helden sind
über erspielbare Crew-Cases erhältlich. Bereits erworbene Figuren bleiben verfügbar.
Ein fehlender Fighter ist spätestens nach zwei Duplikaten beim nächsten Crew-Case
fällig. Einzelchancen werden vor dem Öffnen angezeigt. Es gibt keine Echtgeldkäufe.

Jede Arena umfasst zehn Wellen. Bosse stehen in **2 / 4 / 6 / 8 / 10**:
Säurepanzer, Schrottwalze, Breaker Axel, Sturmadmiral, eigener Arenen-Endboss.
Normale Wellen dauern 60 Sekunden, die Bosslimits 60/65/75/80/90 Sekunden.
Der Boss muss vor Ablauf besiegt werden. Nach Zwischenbossen folgen alle verdienten
Level-Up-Auswahlen und anschließend der Shop. Endlos wiederholt diese Leiter.

Die ersten vier Arenen behalten ihre Ereignisse; hinzu kommen Giftflächen, Frost,
Sturm-/Kristallbahnen, Kirmesbomben und Rissringe. Gold kündigt Gefahr an, Rot zeigt
aktive Flächen, Grün markiert sichere Ringöffnungen. Phasen bei 70/35 % Bossleben,
bei Axel 70/40 %. Feste Vorwarnungen bleiben auch in späteren Wellen vollständig.

## Fünf neue Klassen

| Held | Basis-HP / Tempo | Klassenwaffe | Aktive Fähigkeit |
| --- | --- | --- | --- |
| Cinder | 95 / 205 | Flammenwerfer | Feuersturm: fünf Sekunden Flächenschaden |
| Frosty | 110 / 190 | Kryogewehr | Nullpunkt: Schaden, normale Gegner einfrieren |
| Volt | 90 / 220 | Teslaspule | Überspannung: Kettenimpuls und Angriffstempo |
| Rook | 145 / 170 | Schildlanze | Bastion: 80 Schild, höchstens acht Sekunden |
| Nyx | 85 / 245 | Mondchakram | Phasentanz: Dash und vier Sekunden Lockvogel |

Sie ergänzen Bruiser, Sparky, Shade, Twinkle, Kicksy und Steelfist. Dreizehn Waffen
besitzen je zwei Entwicklungen auf Run-Stufe 5: insgesamt 26 echte Kampfpfade.
Werkstattränge 1–5 gelten dauerhaft und geben Waffen maximal +8 % Schaden.
Klassenbindungen, sinnvolle Upgrades und Set-Zuordnungen gelten auch für die neuen Waffen.

Zehn neue Gegner: Sichelschreck, Schattenlauerer, Panzerkäfer, Sporenmedik, Mörserwicht, Frostgeist, Stachelrad, Blutfleder, Knochenrufer, Glutstachel. Ihre Rollen umfassen
Zickzack, Teleport mit Warnfläche, gerichteten Schutz, begrenzte Heilung, Mörser,
Frost, Sturm, Lebensraub, begrenzte Beschwörung und radiale Schüsse.

## Menü, Hilfe, Währungen und Ton

Weltkarte mit zehn Karten; Wischwahl für Helden und Arenen; Garage für Kopf, Körper,
Schuhe, Waffen, Items, Zauber und sichtbare Deko. Meisterschaft und Statistik sind
für elf Helden und zehn Arenen paginiert. Gemeinsame Panels, Typografie, Icons,
Schatten und Farbakzente; leichte Übergänge, Hintergrundbewegung und Handyneigung.
Reduzierte Bewegung und Qualitätseinstellungen werden gespeichert.

Kicksy begleitet das interaktive Tutorial. Das neue HANDBUCH ist vom Hauptmenü und
während der Pause erreichbar: Regeln, tatsächliche Helden-/Waffenwerte, Bestiarium
und Technik inklusive optionaler FPS-Anzeige. Pause, Level-Up, Shop und Android-
Unterbrechungen halten die Simulation an.

Run-Coins gehören zum Wellenshop. Studio-Coins dienen Cases und dem kosmetischen
Shop. Werkstattteile verbessern permanente Ausrüstung. Tägliche/wöchentliche Aufgaben
und kostenloser Pass bleiben verbunden. Zehn einmalige Weltgeschenke bringen zusammen
1.300 Studio-Coins, 805 Teile und zusätzliche Case-Tickets; aktiv auf der Karte abholen.

14 zusätzliche eigene Waffensounds, Warnungen und Fähigkeitseffekte ergänzen die
bestehenden Menüsounds und Musik. Master/Musik/SFX sind getrennt regelbar. Eigene
Bild-/Tonquellen und Schriftlizenzen stehen in CREDITS.md und assets/audio/LICENSE.txt.

## Prüfung und Grenzen

`python3 tools/run_tests.py --traces`: 28 Suiten / 3.764 Prüfungen plus
zwei historische Vergleichsläufe. `godot --headless --path . --fixed-fps 60 --script
res://tests/united_soak.gd`: 110 Helden/Arenen-Szenarien, 92.400 Simulationsschritte.
38 native GL-Ansichten inklusive Tutorial, Bossen, neuen Helden, Breitbild und Tablet.
Historische Kampf-Fixtures schalten die alte Bossregel ausdrücklich ein; united_test
und united_soak verwenden die neue aktive Produktionsregel, inklusive echter Zustandswache.

Getestet sind Import, Simulation, Grafikdarstellung unter Linux GL Compatibility,
Android-Export, Signatur, Ausrichtung und APK-Inhalt. Physische Android-Installation,
Update mit echtem Nutzerprofil, Sensoren, Touch, wahrgenommener Ton, FPS und Thermik
sind noch auf Geräten abzunehmen. Die neue Balance braucht menschliche Testläufe.
Das Update ist eine Alpha, keine behauptete AAA- oder Store-Abnahme.

Details: TEST_REPORT.md / BUILD_REPORT.md / ACCEPTANCE.md / PROGRESS.md.
