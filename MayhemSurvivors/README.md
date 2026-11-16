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
