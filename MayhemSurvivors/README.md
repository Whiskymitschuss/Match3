# Mayhem Survivors 0.11.0 Alpha — Charakter-Meisterschaften

Android-only, Godot 4.6.3 stable / GDScript / GL Compatibility, offline.
In CHARAKTERE → MEISTERSCHAFTEN & SKINS lassen sich alle drei Helden ansehen.

Für jeden Helden separat, in beiden Arenen gemeinsam:

- Welle 5 erreichen: NEON CREW Farbvariante.
- 250 Gegner insgesamt besiegen: sichtbares Jägerabzeichen.
- Einen Run gewinnen: GOLD CHAMPION Farbvariante.
- Alle drei Ziele: eigener Meistertitel in Auswahl und Meisterschaftsseite.

Diese Skins sind Farbvarianten der vorhandenen Illustrationen und Spielkörper mit
prozeduralen Blitz-/Kronenabzeichen, keine neuen Körpermodelle. Handschuhe erhalten
dieselbe Farbabstimmung. Titel: Schrottkönig, Funkenkönigin, Nachtmeister.
Alle Belohnungen sind kosmetisch: kein Bonus auf HP, Schaden, Bewegung oder Drops.

Fortschritt wird am Rundenende bei Sieg oder Niederlage aus validierten dauerhaften
Charakterrekorden ermittelt. Abgebrochene Runs zählen wie bisher nicht. Bereits in
0.10 gespeicherte Charakterrekorde werden automatisch angerechnet; alte Gesamtsummen
ohne Charakterzuordnung werden nicht erfunden zugeteilt. Auswahl wird separat je
Held gespeichert. Gesperrte Varianten können angesehen, aber nicht ausgerüstet werden.
Freischaltungen erzwingen keinen Outfitwechsel. Neu verdiente Belohnungen erscheinen
auf dem Ergebnisbildschirm. Kein eigener Claim nötig, keine doppelt zählenden Zähler.

Speicherschema 3 wird kompatibel um optionales hero_styles ergänzt. Ungültige oder
unverdient ausgewählte IDs werden beim Laden zu Original zurückgesetzt. Bestehende
Statistik, Arenen, Ringe, Einstellungen bleiben erhalten. Als Update installieren.

## Ausführen und prüfen

project.godot mit Godot 4.6.3 öffnen und starten. Kein Assetgenerator erforderlich.
Android minSDK 24 / targetSDK 36 / ARM64 / Querformat, Code 15 / 0.11.0.
`python3 tools/run_tests.py --traces` führt 16 Suites und zwei historische Traces aus.
1.075 Assertions bestanden; zusätzlich native Galerie unter tests/mastery_*.png.
Die Galerie ist eine Engine-Vorgabeszene, kein Android-Spieltest.

Offene Geräteabnahme: Update über 0.10 mit echten Daten, drei Helden wechseln,
freigeschaltete Variante wählen, App neu starten, Touch/Notch und Kampfdarstellung.
Schwierigkeitsgrade und neue Arena-Ereignisse sind spätere Schritte, nicht Teil 0.11.

---

## Historischer Stand vor 0.11

# Mayhem Survivors 0.10.0 Alpha — Elite Encounters

Nutzerfeedback zur 0.9: „Yes alles top“. Die bestätigte Oberfläche bleibt Grundlage.
Neue Begegnungen für beide Arenen, vollständig mit Kampf, Shop und Spielende verbunden.

## Elitegegner

In Wellen 4, 6, 8 und 9 wird ab Sekunde 18 der nächste geeignete normale Spawn zur Elite.
Höchstens eine pro Welle, maximal vier pro Run. Kein zusätzliches Gegnerobjekt und
weiterhin höchstens 100 Gegner. Ohne freien Spawnplatz entsteht keine zusätzliche Elite.
Goldene Krone, eigener Körper, HP-Leiste und dezentes Ereignisfeld unten im HUD.

| Arena | Elite | Ausweichen / Konter |
|---|---|---|
| Schrottplatz | Schrottbrecher | Goldener gerader Korridor, 1,2 s Vorwarnung, dann fixierter Sturmangriff; seitlich ausweichen oder mit Bruisers Schockwelle unterbrechen |
| Reaktorzone | Impulswächter | 1,45 s Ringwarnung, dann kurzer Impuls; innen/außen bleiben oder türkise Öffnung nutzen |

Warnursprung/Ziel bleiben fixiert; Knockback bricht den Windup ab. Schockwelle unterbricht
auch an der Arenagrenze und kann den Sturm stoppen. Neue Spezialangriffe werden nicht
aus dem unsichtbaren Bereich begonnen/vollendet. Treffer nutzen Rüstung, Dashschutz und
bestehenden Kontakt-Cooldown. Gewöhnliche Gegner, Waffen- und Charaktergrundwerte erhalten.
Eliten haben 1,65-fache aktuelle Tank-HP, 1,25-faches Tanktempo und 1,10-fachen Kontaktschaden.

## Elite-Beute

Tötet eine Elite: Tankbelohnung plus 12 Coins und 12 XP (Kristall). Nach der Welle folgt
vor dem eigentlichen Shop eine kostenlose Wahl genau einer Run-Belohnung:

- Kampftraining: +5 Prozentpunkte Basis-Schadensbonus.
- Panzerreserve: +10 maximale und +10 aktuelle HP.
- Schrottdepot: 20 + 2 × besiegte Welle Coins.

Einmal pro Elite. Ein Run-/Wellenbezeichner verhindert doppelte oder alte Käufe.
Waffenentwicklung auf Stufe fünf folgt danach weiterhin verbindlich, dann der Markt.
Elite-Kills erscheinen im Ergebnis und gespeicherten Run-Verlauf. Keine Meta-Käufe,
keine neue Währung, keine Werbung. Ohne besiegte Elite keine Bonuswahl.

## Bossphasen

Bei 65 % und 30 % verbleibenden HP wechseln beide Bosse ihre Gesundheitsphase.
HP bleiben 6.000 / 7.560 und das Limit 90 s. Keine Heilung oder Unverwundbarkeitsphase.
Ein starker Treffer darf direkt Phase III erreichen. Beim Wechsel werden alte
feindliche Schüsse/Bossmarkierungen abgeräumt; eigene Schüsse bleiben erhalten.

- Overlord II: drei angekündigte Trümmer-Zielkreise einschließlich deiner letzten Position.
- Reaktorwächter II: Kreuzmarkierungen an deiner letzten Position, diagonal verlassen.
- Phase III: zusätzlich abwechselnde Impulsringe mit breiter sichtbarer Fluchtöffnung.

Neue Muster starten mit mindestens 1,5 s Warnzeit. Der Boss hält während der Warnung/
Auslösung still; kurze Erholung und begrenzte Musterzahl verhindern Überlagerung.
Die vertrauten Grundangriffe kehren zwischen den Spezialmustern zurück. Alle kritischen
Warnflächen bleiben auf LOW/MEDIUM/HIGH gleich. Drei neue eigene Audioakzente.

## Start / Tests / Build

`project.godot` in Godot 4.6.3 stable öffnen. Serielle Importkonfiguration aus 0.9 erhalten.
`python3 tools/run_tests.py --traces`: 1.030 Assertions plus beide historischen Kampftraces.
Neue Begegnungen: tests/encounters_test.gd, Lastprobe tests/encounters_soak.gd.
Native Beispielbilder tests/encounter_*.png sind gestellte Engine-Szenen, keine echten
Android-Runs. APK 0.10.0 / Code 14, gleicher Paketname/Schlüssel: als Update installieren.
Offen bleibt die Handy-Abnahme der neuen Gegner, Phasen und Belohnungsbalance.


---

## Historischer Stand vor 0.10

# Mayhem Survivors 0.9.0 Alpha — Neon Interface

Vollständiger Menü-Rework nach der neuen Neon-Comic-Referenz des Nutzers.
Neues Stadt-/Wirbelmotiv, kompakte Silber-/Magenta-Wortmarke, angepasstes MS-App-Icon
und RF-Worlds-Studiomarke. Hauptmenü, Charaktere, Arenen, Vorbereitung, Level-up,
Waffenentwicklung, Shop/Details/Hilfe, Werte, Einstellungen, Pause/Bestätigung,
Statistik/Verlauf, Ziele und Sieg/Niederlage verwenden die gemeinsame Gestaltung.

## Fertige UI-Grafiken und Bewegung

49 semantische Grafik-Icons ersetzen Textsymbol-/Emoji-Icons bei Navigation, Upgrades,
Kauf, Hilfe und Bedienung. Acht Gegenstands-, drei Fähigkeits- und zehn Entwicklungs-
Illustrationen wurden ebenfalls überarbeitet; neuer Joystick mit fertiger Basis und Griff.
Nicht mehr verwendete alte Icon-/Splashdateien entfernt. Die tatsächlichen Waffen-
und Charaktergrafiken bleiben erhalten. Es werden keine leeren Sprite-Nodes angezeigt.

Kurze, leicht gestaffelte Einblend-/Positionsübergänge (0,22–0,27 s), dezentes Leuchten
an Buttons, langsame Bewegung der Hintergrundillustration und begrenzte Lichtpartikel.
Beim Öffnen läuft ein kurzer Weichzeichner über die reine Hintergrundgrafik. Text und
Bedienelemente haben eigenes Rendering und behalten ihre Touchflächen. Schnelle
Navigation verwirft alte Übergänge über eine Bildschirmrevision. LOW schaltet die neue Hintergrundbewegung,
Übergangsanimation, Buttonanimation und Hintergrund-Shader ab; Texte bleiben sichtbar.
Die Hintergrundgrafik füllt weiterhin breite Displays/Tablet, HUD beachtet Safe-Areas.

## Unverändert spielbar

Die bestätigte Balance aus 0.7, Waffen-/Gegner-/Wave-/Itemdaten und Preise sind unverändert.
0.8-Audiopaket mit 31 Effekten und zwei Musiken bleibt enthalten. Statistiken/Einstellungen
weiterhin kompatibel. Android-only, ARM64, offline, kein Netzwerk/Ads/IAP.

## Start, Tests, Quellen

`project.godot` mit Godot 4.6.3 stable öffnen und starten; kein Zusammenbauen erforderlich.
`python3 tools/run_tests.py --traces` führt 926 Assertions und zwei Kampfvergleiche aus.
Neuer UI-Test prüft 101 Punkte inklusive realer Animation und vollständiger Ergebnisliste.
Native Bildschirmgalerie: tests/presentation_*.png, interface_*.png, shop_*.png.
Kurzer Engine-Mitschnitt: tests/menu_motion_preview.gif; kein Android-FPS-Benchmark.
SVG-Iconquelle: tools/generate_interface_icons.py (Python-Standardbibliothek).
Bildmotive nach Nutzerreferenzen erstellt; Fonts unter OFL, Details CREDITS.md.
Android-Debug-APK 0.9.0 / Code 13 mit bestehendem Paket und Schlüssel als Update installieren.
Neue Oberfläche/Animationen noch auf physischem Android-Gerät abnehmen.

---

## Historischer Stand vor 0.9

# Mayhem Survivors 0.8.0 Alpha — Presentation & Audio

Das Android-Spiel ist vollständig verbunden und direkt über `project.godot` startbar.
Neu: Wortmarke und App-Icon im Feuer-/Metallstil der gelieferten Nutzerreferenzen,
RF-Worlds-Studiomarke, neu gestaltetes Crew-Menü und einheitlicher Stil in Charakterwahl,
Arena-/Wellenwahl, Shop, Hilfe, Pause, Einstellungen, Statistik und Ergebnisbildschirmen.
Stahlflächen, Warnstreifen, Glutpartikel, kräftige Barlow-Überschriften und gut lesbarer
Barlow-Fließtext. LOW hält die neue Hintergrundanimation statisch. Die Dekoration
fängt keine Touch-Eingaben ab. HUD erhält dunkle Kontrastflächen, Lautstärkeregler
bekommen große Griffe und Prozentanzeigen. Vollbild/Safe-Area bleibt erhalten.

## Neues Audiopaket

31 neu gestaltete Originaleffekte: mehrschichtige Waffen, Treffer/Tode, Fähigkeiten,
Entwicklungen, Pickups, Kaufen/Leveln sowie unterschiedliche Bosswarnungen und Ergebnis-
Stinger. Zwei eigene 8-Takt-Musikstücke: Menü/Werkstatt (110 BPM) und Kampf (128 BPM).
Musik startet mit kurzer Einblendung und wird während Pause/Level-up leiser.
Master/Musik/Effekte bleiben separat gespeichert; Null stoppt die jeweilige Wiedergabe.
Zwei reservierte UI-Stimmen und eine Warnungsstimme zusätzlich zu zwölf Effektstimmen;
maximal zwei feste Musikplayer. Häufige Pickup-Klänge werden zeitlich begrenzt.
Keine externen Soundaufnahmen, kein Internet nötig. Warnung/Kauf bleiben trotz
voll belegter normaler Effektstimmen verfügbar. Hörbarkeit auf Handy noch abnehmen.

## Balance und Daten

Die vom Nutzer in 0.7 bestätigten Regeln bleiben bestehen: Gegner/Wellen/Waffen/Items/
Preise und Set-Boni unverändert. Klassenbindung, zwei Hände und automatische Waffen
bleiben erhalten. Statistiken und Einstellungen werden weiter aus Format 3 geladen.
Nutzer bestätigte Vollbild, Schwierigkeit und Shop mit „Ja – Ja – Ja“; daraus werden
keine FPS-Zahlen oder Gerätemodelle abgeleitet.

## Quellen, Tests und Export

- 825 Assertions bestanden, plus historische Kampftraces; TEST_REPORT.md.
- Alle normalen Suiten: `python3 tools/run_tests.py --traces` (Godot auf PATH).
- Audio neu erzeugen optional: numpy, scipy und ffmpeg installieren, dann
  `python3 tools/generate_presentation_audio.py`. Zum Spielen/Export nicht nötig.
  Frühere Generatoren bleiben als Herkunft erhalten; nicht zum Regenerieren von 0.8 verwenden.
- Fonts Barlow/Barlow Condensed unter SIL Open Font License; Lizenzen bei den Fonts
  und in APK. Audioherkunft in assets/audio/LICENSE.txt, Gestaltung in CREDITS.md.
- ARM64 Android-Debug-APK 0.8.0 / Code 12 mit bestehendem Paket/Signierschlüssel.
  Als Update installieren. Hardwareabnahme der neuen Darstellung/Mischung noch offen.


---

## Historischer Stand vor 0.8

# Mayhem Survivors 0.7.0 Alpha — RF Worlds

Godot 4.6.3 stable, Android ARM64, offline. Das komplette Projekt lässt sich über
`project.godot` starten. Keine Programmierung oder Szenenmontage erforderlich.

## Neuer Mayhem Market

Nach Wellen 1–9 öffnet der Shop mit vier Angeboten. Beim ersten Besuch erklärt eine
überspringbare Hilfe die Bedienung; über HILFE jederzeit wieder öffnen. Der Kampf
bleibt bis NÄCHSTE WELLE angehalten. Ein Reroll je Besuch gratis, danach 8, 11, 14 … Coins.

- Angebotskarten: Preis, Seltenheit, Symbol, Wirkung und bei Gegenständen grüne Vorteile/rote Nachteile.
- WAFFEN: antippen für tatsächliche Trefferwerte, Aufrüsten und Verwerten mit Bestätigung.
  Die letzte Waffe ist geschützt. Ab Stufe fünf weiterhin kostenlose verbindliche Entwicklung.
- GEGENSTÄNDE: acht eigene Module, jedes einmal pro Run. Boni gelten bis Run-Ende.
- SETS: Waffen und Gegenstände zählen zusammen. Zwei/drei Teile aktivieren Boni.
- WERTE: aktuelle Gesamtwerte inklusive Gegenständen und Sets. Klassenbindung bleibt bestehen.

| Set | 2 Teile | 3 Teile (zusätzlich) |
|---|---|---|
| Brecher: Hammer, Blaster, Splitgun, Wuchtgriff, Panzerplatte | +8 % Schaden | +1 Rüstung |
| Stromkreis: Arc Cannon, Überlastzelle, Ionenkühler | +8 % Angriffstempo | +15 % Projektiltempo |
| Nachtlauf: Orbit Blade, Phasenstiefel, Präzisionslinse | +8 % Bewegungstempo | +5 % Krit-Chance |

Schrottmagnet/Vitalpaket zählen zu keinem Set. Gegenstände verändern bestehende Werte;
negative Rüstung ist möglich. Maximalwerte: Krit 75 %, Rüstung 20; Max-HP-Untergrenze
bei Gegenstandskauf 30. Kein Kopieren von Vorlagenassets, keine Werbung/VIP/Käufe.
Waffen werden über ihre vorhandenen fünf Stufen aufgerüstet; kein Duplikat-Fusionssystem.

## Vollbild und Schwierigkeit

Der sichtbare Spielbereich erweitert sich auf das Display-Seitenverhältnis. Menüs
füllen den Hintergrund; HUD/Touchsteuerung beachten sichere Displayränder.
Android-Preset nutzt immersiven Modus und Edge-to-edge. Für extreme Breite passt sich
die Kamera an die Arenagrenzen an. Physische Android-Vollbildabnahme noch erforderlich.

Beide Arenen werden ab Welle vier härter: mehr Gegner in begrenzten Gruppen,
mehr HP, moderat höheres Tempo/Kontaktschaden. Wellen 1–3 unverändert. Belohnungen pro
Gegner reduziert, damit mehr Gegner nicht ungebremst mehr Upgrades finanzieren.
Maximal 100 aktive Gegner; Rollenlimits bleiben 6 Spucker/2 Drohnen.
Overlord jetzt 6.000 HP, Reaktorwächter 7.560 HP, weiterhin 90-Sekunden-Limit.
Warnzeiten bleiben erhalten. Neue Schwierigkeit braucht echte Android-Runs.

## Tests und Export

`godot --headless --path . --script res://tests/shop_test.gd` prüft den neuen Shop.
Alle ausgeführten Suiten und Grenzen der Aussagekraft: TEST_REPORT.md.
Android-Export: `godot --headless --path . --export-debug Android builds/android/MayhemSurvivors-v0.7-debug.apk`.
Voraussetzungen SDK/JDK/Exporttemplate und privater Debugschlüssel außerhalb des ZIP;
Details BUILD_REPORT.md. Paket bleibt `com.rfworlds.mayhemsurvivors`, versionCode 11.
Bestehende lokale Statistik wird geladen; aktive Runs werden weiterhin nicht wiederhergestellt.

---

## Historischer Stand (vor 0.7)

# Mayhem Survivors — RF Worlds

Android Alpha **0.6.0** · Godot **4.6.3 stable** · GDScript · GL Compatibility

## Spielen

`project.godot` in Godot importieren und starten. Ausschließlich Android-Export:
ARM64, Querformat, Android 7.0+, Paket `com.rfworlds.mayhemsurvivors`, offline.
Links unten per Touch-Joystick bewegen, Waffen greifen automatisch an. XP einsammeln,
Upgrades wählen, zwischen neun 60-Sekunden-Wellen einkaufen. Welle zehn hat ein
90-Sekunden-Limit: Boss besiegen oder verlieren. Pause oben rechts.

## Neu in 0.6: Reaktorgegner mit eigenen Rollen

Nur die Reaktorzone erhält zwei zusätzliche Gegner. Die erste Welle bleibt vertraut.

| Gegner | Einführung | Gegenmaßnahme |
|---|---|---|
| Reaktorspucker | Ab Welle 2 | Fixierte rote Ziellinie abwarten und seitlich ausweichen; auf kurze Distanz verfolgen |
| Schilddrohne | Ab Welle 4 | Cyanfarbene Verbindung verfolgen und die Drohne zuerst ausschalten |

Spucker haben 55 Basis-HP, Tempo 90, Kontaktschaden 6; sie lassen 8 XP und 4 Coins fallen.
Sie halten auf mittlere Distanz an, kündigen 0,9 Sekunden lang an und schießen einen
langsamen, nicht lenkenden Glutklecks (10 Schaden, Tempo 220, Lebensdauer 3 Sekunden).
Startverzögerung 1,5 Sekunden, danach 2,8 Sekunden Cooldown zusätzlich zur Warnzeit.
Außerhalb des sichtbaren Bereichs starten oder vollenden sie keinen Schuss.
Maximal sechs Spucker und zwei gleichzeitig laufende Schusswarnungen.

Drohnen haben 75 Basis-HP, Tempo 80, Kontaktschaden 4, Belohnung 10 XP/5 Coins.
Ihre Aura im Radius 180 reduziert eingehenden Schaden normaler Verbündeter um 30 %.
Kein Stapeln, keine Heilung, keine Unverwundbarkeit. Bosse und Drohnen selbst bekommen
diesen Schutz nicht. Außerhalb der Aura oder nach dem Drohnentod ist sofort voller
Schaden möglich. Maximal zwei Drohnen. HP skalieren wie bei den alten normalen Gegnern.

Eigene Comic-Grafiken, Animation durch Bewegung/Schweben, Treffer/Tod, Signale und
Projektildarstellung. Neue Gegner ersetzen nur einen Anteil der bisherigen Grunt-Rolls;
Spawnintervalle, Wellendauern und Gesamtlimit 100 bleiben gleich. Die Reaktorzone wird
bewusst taktisch erweitert. Der Schrottplatz behält seine bisherigen Gegner und Balance.
Alle Daten unter `data/enemies/reactor_roles.json` und `data/waves/reactor.json`.

## Effektpaket aus 0.5.1

Cartoon-Splatter bei Treffern und Gegner-Tod: farbige Tropfen, kurze Todes-Puffs und
sieben Sekunden ausblendende Bodenspuren. Grün/Rotrosa/Violett kennzeichnen Monster;
der Reaktorwächter erzeugt Metallfunken. Keine Organe oder abgetrennten Körperteile.
Unter Einstellungen lässt sich CARTOON-SPLATTER getrennt abschalten; Rauch, Funken,
Explosionsspuren und andere Kampfeffekte bleiben verfügbar. Die Einstellung wird gespeichert.

Zusätzlich kräftigere Mündungsblitze, Geschossspuren, Einschlagfunken, Rauch,
Hammer-Schlagbögen/Bodenrisse, verzweigte elektrische Entladungen, Explosionswolken,
kritische Treffersterne und violette Schatten-Nachbilder. Alte Todesringe wurden durch
passende Spritzer und kleine Münz-Popups ersetzt. Zwei zusätzliche eigene Synthsounds.

Die neue Effektsebene nutzt einen getrennten visuellen Zufallsgenerator, keine
Gameplay-Zufallswerte. Wiederverwendete Partikel-Dictionaries ohne einzelne Effekt-Nodes.
LOW/MEDIUM/HIGH begrenzen die neuen Partikel auf 80/150/240, Bodenmarken auf 18/40/70
und kurze Effekt-Ereignisse auf 8/16/24. Warnmarkierungen werden über Bodenflecken gezeichnet.
Pause, Level-up und Shop halten die Effekte an; Wellenende/Run-Ende räumen sie auf.
Es ändern sich keine Kampfwerte, Belohnungen, Waffenentwicklungen oder Abklingzeiten.

## Waffenentwicklungen aus 0.5

Beim Kauf von Waffenstufe fünf wählst du kostenlos zwischen zwei Entwicklungen.
Die Wahl ist für diese Waffe in diesem Run verbindlich, kostet keine zusätzlichen Coins
und bleibt über die Wellen erhalten. Ein neuer Run beginnt wieder mit der Startwaffe
auf Stufe eins. Während der Auswahl steht die Simulation im Shop vollständig still.
Mehrere ausstehende Auswahlen erscheinen nacheinander.

| Waffe | Entwicklung A | Entwicklung B |
|---|---|---|
| Hammer | Erdbeben: größerer Rundumschlag, weniger Schaden und längerer Cooldown | Donnerfaust: schnellere, konzentrierte Einzeltreffer |
| Blaster | Durchbrecher: durchschlägt bis zu drei verschiedene Gegner | Sprengkern: geringerer Direktschaden plus Explosion gegen andere nahe Gegner |
| Splitgun | Fokusfächer: enger, stärker und weiter | Schrothagel: mehr Kugeln, breiter und schwächer je Kugel |
| Arc Cannon | Kettensturm: bis zu fünf Ziele und größere Sprungreichweite | Hochspannung: stärkerer, schnellerer Einzelzielblitz |
| Orbit Blade | Fernschneide: weiter, größer, stärker und langsamer | Wirbelklinge: enger, kleiner, schneller und schwächer je Treffer |

Alle genauen Werte stehen auf den Auswahlkarten und datenbasiert unter
`data/specializations/specializations.json`. Symbole an Waffen/HUD, Projektileffekte,
Orbitdarstellung, Rückmeldung und zusätzliche synthetisierte Töne unterscheiden die Wege.
Es erscheinen keine zusätzlichen Arme. Klassenbindung und Waffenslots bleiben erhalten.
Ergebnis und gespeicherter Verlauf enthalten die gewählte Entwicklung. Alte Einträge
bleiben ohne nachträglich erfundene Spezialisierung kompatibel; Speicherformat bleibt 3.

## Fähigkeiten aus 0.4

Rechts unten liegt ein eigener Fähigkeitenbutton mit Symbol und Abklinganzeige.
Joystick und Fähigkeit lassen sich mit zwei Fingern gleichzeitig bedienen.

| Held | Fähigkeit | Abklingzeit |
|---|---|---|
| Bruiser | Schockwelle: 48 Basisschaden, Nahkampfbonus, Radius 250; normale Gegner werden um 90 zurückgestoßen | 12 s |
| Sparky | Impulsgranate: nächstes Ziel bis 450, 0,65 s Zünder, 40 Basisschaden in Radius 180; normale Gegner zwei Sekunden auf 40 % Tempo | 10 s |
| Shade | Schattenschritt: 300 Einheiten in Bewegungsrichtung, 0,18 s unverwundbar; 26 Basisschaden pro durchquertem Gegner | 8 s |

Aktive Fähigkeiten skalieren mit Schaden/Kritchance; Bruisers Schockwelle zusätzlich
mit seinem Nahkampfbonus. Bosse sind gegen Rückstoß und Verlangsamung immun.
Ohne Ziel wirft Sparky nach vorne; ohne Bewegungsschub nutzt Shade seine Blickrichtung.
Ein Schritt direkt gegen die Arenagrenze verbraucht keine Abklingzeit. Jede Welle
beginnt mit bereiter Fähigkeit. Pause, Shop und Levelaufstieg halten alle Fähigkeitstimer an.

Eigener Schaden erscheint rot mit kurzem Randfeedback, kritische Treffer größer und
gold mit Ausrufezeichen. Schadenszahlen sind abschaltbar; LOW/MEDIUM/HIGH begrenzen
deren Anzahl auf 24/40/64. Vibration ist standardmäßig AUS, optional DEZENT oder STARK.
Vibration benötigt die normale Android-Berechtigung `VIBRATE`; kein Berechtigungsdialog.
Die tatsächliche Stärke hängt vom Gerät ab. Eigene SVG-Symbole und vier synthetisierte
WAV-Sounds; Generator unter `tools/generate_ability_audio.py`.

Diese Erweiterung fügt aktive Möglichkeiten hinzu. Grundwerte der Waffen/Gegner,
Klassenbindung und Wellen bleiben gleich; ohne Fähigkeitseinsatz besteht der
bisherige deterministische Schrottplatzvergleich weiter.

## Arenen aus 0.3

Nach der Charakterwahl folgt die Arena-Auswahl. Der Schrottplatz behält seine
bisherigen Kampfwerte. Die Reaktorzone wird durch den ersten Sieg freigeschaltet;
Siege aus älteren Versionen zählen mit. Eigener Boden, Gegnerzusammensetzung und
ab Welle drei angekündigte Strombahnen. Diese sind vor der Aktivierung ungefährlich.

Der Reaktorwächter ist eine eigene vierbeinige Maschine mit 4.200 HP: angekündigte
Kreuzlaser, drei fixierte Kernbomben und ein gerichteter Impulsfächer mit vier Salven.
Keine beweglichen Hindernisse. Alle Warnungen und Angriffe pausieren gemeinsam mit
dem Kampf und werden beim Wellenende/Neustart entfernt.

Statistik und Verlauf lassen sich nach Arena und Held filtern. Unter „Ziele & Stile“
sind drei Bodenringe erspielbar: erster Sieg, 1.000 Gesamtkills, Reaktorsieg.
Die Auswahl wird gespeichert und beeinflusst keine Kampfwerte.

| Held | Waffen |
|---|---|
| Bruiser | Hammer |
| Sparky | Blaster, Splitgun, Arc Cannon |
| Shade | Orbit Blade |

Die akzeptierte Haltung mit zwei Händen und einer sichtbar gehaltenen Waffe bleibt.
Sparkys weitere ausgerüstete Waffen greifen weiterhin automatisch an.

## Lokaler Speicher

`user://save.json`, Format 3. Format 1/2 wird automatisch geladen und vor der
Übernahme als `save.v1.backup.json` beziehungsweise `save.v2.backup.json` gesichert.
Bisherige Gesamtwerte und Einstellungen bleiben erhalten. Alte Runs gehörten zum
Schrottplatz; fehlende historische Heldenzuordnungen werden nicht erfunden.
Beschädigte Dateien erhalten ein `.corrupt.json`-Backup. Kein aktiver Run-Resume.

## Prüfen und bauen

```sh
godot --headless --path . --editor --import --quit
godot --headless --path . --fixed-fps 60 --script res://tests/integration.gd
godot --headless --path . --fixed-fps 60 --script res://tests/reactor_test.gd
godot --headless --path . --fixed-fps 60 --script res://tests/world_trace.gd
godot --headless --path . --export-debug Android builds/android/MayhemSurvivors-v0.6-debug.apk
```

Für Export Godot-Android-Template, JDK 21 und Android SDK konfigurieren. Private
Signierschlüssel/SDK sind nicht Teil des Quellprojekts. Test-APK separat verfügbar.
Weitere Tests und tatsächliche Ergebnisse: [TEST_REPORT.md](TEST_REPORT.md).
Exportdetails: [BUILD_REPORT.md](BUILD_REPORT.md).

## Assets und Grenzen

Eigene generierte Comic-Grafiken und prozedurale Effekte; eigene synthetisierte
WAV-Effekte/Musik. Keine kopierten Figuren, Sounds oder Oberflächen aus Brotato.
Keine Werbung, Käufe, Server oder bezahlten Plugins. LOW/MEDIUM/HIGH begrenzen nur
Effekte. Ziel 60 FPS auf geeigneten Geräten, keine gemessene Android-FPS-Zusage.

Version 0.4 wurde automatisiert und mit Godot/Mesa geprüft. Ihr kompletter
Android-Praxistest, echte Multitouch-/Vibrationsprüfung, Geräteleistung und das Balancing aller drei Helden stehen noch aus.
Der Nutzer hat den älteren Schrottplatz mit Sparky erfolgreich durchgespielt.

Erstimport-Abnahme 0.9: Ein erster paralleler Editor-Import in dieser Umgebung endete
mit SIGSEGV beim Assetimport. Nach Entfernen des generierten Caches lief der serielle
Neuimport vollständig durch; daraus alle 926 Assertions und beide Kampftraces bestanden.
`editor/import/use_multiple_threads=false` ist bereits im Projekt gesetzt, kein manueller
Eingriff erforderlich. Dies betrifft den Editor-Import und ändert keine Kampfregeln.
