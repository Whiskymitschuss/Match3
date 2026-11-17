# Mayhem Survivors0.18.0 Alpha — MAYHEM GARAGE

Die Garage ist jetzt spielbar: Hauptmenü → CASES & GARAGE. Charakterauswahl → INVENTAR
& STILE führt zum Fighter mit acht Ausrüstungskategorien. Die bisherigen Arenen,
Endlos, Schwierigkeiten, Aufgaben, der kostenlose Pass und alle sechs Kämpfer bleiben
enthalten; ihre Verfügbarkeit folgt jetzt der gewünschten Case-Regel.

## Crew, Cases und Belohnungen

Nur Bruiser und Hammer sind anfangs frei. Sparky, Shade, Twinkle, Kicksy und Steelfist
kommen aus Crew-Cases; jeder neue Fighter erhält seine Klassen-Startwaffe. Andere
Waffenbaupläne stammen aus Arsenal-Cases. Klassenbindungen bleiben erhalten.

| Case | Inhalt | Preis ohne Ticket |
| --- | --- | --- |
| Crew | Einer von fünf weiteren Fightern | 100 Studio-Coins |
| Arsenal | Acht Waffenbaupläne, drei passive Module, drei Zauber | 60 Studio-Coins |
| Style | Neun Ausrüstungsteile, drei Waffenstile, sechs Dekorationen | 40 Studio-Coins |

Einmalig ein kostenloses Ticket je Caseart. Tickets werden zuerst verbraucht. Inhalte
& Chancen zeigt die tatsächlich berechneten Einzelchancen: Crew-Gewichte30/25/20/15/10
für Sparky/Shade/Twinkle/Kicksy/Steelfist. Nach zwei Duplikaten garantiert der nächste
Crew-Case einen fehlenden Fighter, mit neu normalisierten Gewichten. Crew vollständig:
freie Resttickets können Teile liefern, weitere bezahlte Crew-Öffnung im Menü deaktiviert.
Arsenal-Gewichte insgesamt100, Style120; alle Einzelchancen im Spiel einsehbar.
Duplikate: Standard20, Selten35, Episch60 Werkstattteile. Keine Figur wird dabei verloren.

Öffnung bucht Kosten, Eigentum, Zufallszustand und Beleg vor der Animation atomar.
Schreibfehler stellen den vollständigen vorherigen Stand wieder her. Schnelltippen und
ein ausstehender Beleg blockieren weitere Öffnungen. Nach App-Neustart zeigt derselbe
Beleg denselben bereits erhaltenen Fund; erst bestätigen, dann nächsten Case öffnen.
Überspringbare Animation, Fundübersicht, letzte20 Belege. Separater Case-RNG; keine
Auswirkung auf Kampf-RNG. Alles offline/erspielbar, keine Werbung oder Echtgeldkäufe.

Nach einem beendeten echten Run gibt es dauerhaft5 Studio-Coins je überlebter Welle,
bis10 für Kills (1 je50) und20 bei Kampagnensieg, insgesamt maximal500 je Run.
Niederlage/bestätigter Abbruch behält tatsächlich verdienten Fortschritt. Training
gibt keine Belohnung. Tages-/Wochenziele und Pass bleiben zusätzliche Einnahmen.
Run-Coins bleiben die Währung des Waffenladens innerhalb des Durchlaufs.

## Inventar und Werkstatt

Individuelle Slots je Fighter: Kopf, Körper, Schuhe, Startwaffe, passives Item,
zusätzlicher Zauber und Waffenstil. Die32 Katalogeinträge sind mit Fundort, Besitz,
Klassenbindung, Werkstattrang und Verbesserungskosten sichtbar. Ausrüsten und Ablegen
wird sofort gespeichert. Waffe bleibt geschützt; unpassende/gesperrte Teile nicht ausrüstbar.
Sparky kann freigeschaltete Klassenwaffen als Startwaffe wählen. Genau zwei Hände.

Dauerhafte Werkstattränge1–5 sind vom Waffenlevel1–5 im Run getrennt. Kosten für den
nächsten Rang:20/35/55/80 Teile. Waffen geben auf Rang1 keinen Meta-Bonus, danach +2%
Schaden je Rang, maximal+8%. Körper +1Rüstung/Rang, Schuhe +1%Tempo/Rang, Kopf +2
Sammelradius/Rang. Ein passives Modul: Lebenskern +5HP/Rang, Schutzkern +1Rüstung/Rang
oder Sammlerkern +10Radius/Rang. Waffenstile und Dekoration sind rein optisch.

Beim Run-Start werden Statistiken und Optik kopiert. Menü-/Rangänderungen können den
laufenden Run nicht verändern; Wellenwechsel wenden Boni nicht erneut an. Run-Upgrades
und Sets kommen wie bisher hinzu. Originalwerte der Helden bleiben die Grundlage;
Charakterauswahl beschriftet sie als BASIS, Werkstatt/Run zeigen tatsächliche Werte.

Neun gemalte Ausrüstungsteile, Anker für alle sechs Fighter, sichtbare Schichten im
Menü und Kampf. Drei Waffenfarbstile. Ringe/Begleiter/Titel verwenden die vorhandene
globale Dekoration für alle Fighter und sind auch in der Vorschau sichtbar. Alte
Studio-Shop-Käufe und Case-Funde teilen dieselbe Eigentümerschaft.

## Zusätzliche Zauber

Die Heldenfähigkeit bleibt erhalten. Ein weiterer Touch-Button darüber aktiviert:
- Heilimpuls:11–15% Max-HP je nach Rang,45s Cooldown. Volle HP verbrauchen keinen Cast.
- Frostnova: Radius210,15–27 Schaden je nach Rang plus Schadensmodifikatoren,2s Bewegung
  auf40%,35s Cooldown.
- Phasensprung:230–270 Einheiten in Bewegungsrichtung,0,2s unverwundbar,40–32s Cooldown.
  Grenzen werden eingehalten. Ohne Bewegungsrichtung wird die Blickrichtung genutzt.

Joystick, Heldenfähigkeit und Zauber unterstützen getrennte Finger. Keine Simulation
in Pause/Levelwahl/Shop. Zauber-Cooldowns bleiben zwischen Wellen erhalten und werden
bei einem neuen Run zurückgesetzt. Das Tutorial nutzt eine eindeutig geliehene
Sparky-Trainingsfigur und schaltet dadurch keine Case-Fighter frei.

## Bestehende Profile und Start

Die neue Roster-Regel gilt auch für bisherige Profile. Alte Gratis-/Tutorial-Freigaben
ersetzen keine Crew-Cases. Coins, Statistik, Meisterschaften/Farbvarianten und gekaufte
Deko bleiben erhalten. Ein bisheriger Spielstand ohne collection wird vor der Umstellung
einmal als user://save.pre_garage.json gesichert. Save-Schema3 mit Collection-Version1.
Ein aktiver Run wird nach vollständigem Beenden weiterhin nicht wiederhergestellt.

Godot4.6.3 stable: project.godot importieren und starten. Alle Ressourcen vorhanden,
keine Generatoren/Programmierung nötig. Android ARM64, offline, Querformat, GL Compatibility.
APK0.18.0 / Code22 als Update über0.17, gleicher Paketname und Debug-Schlüssel.
25 Suites /1.898 Assertions und beide historischen Traces,86.400 Lastschritte und
15 native Ansichten geprüft. Physischer Android-Test und menschliches Balancing offen.
Lineare Weltenfreigabe/Weltkarte aus dem Ausbauplan folgt als eigener nächster Schritt.

---

## Historischer Stand vor0.18

# Mayhem Survivors 0.17.0 Alpha — STEELFIST / Der Stahlkoloss

Timo ist als sechster Held sofort verfügbar. CHARAKTERE → bis STEELFIST wischen →
AUSWÄHLEN → Arena betreten. Keine zusätzliche Freischaltbedingung oder Echtgeldkosten.
Alle fünf bisherigen Charaktere, vier Arenen, Endlos, Aufgaben, Pass und Studio-Shop
bleiben enthalten. Statistik- und Meisterschaftsreiter passen jetzt für sechs Helden.

| Startwert | Umsetzung |
| --- | --- |
| Leben | 160 Basis-HP +30 % =208 Start-/Max-HP |
| Bewegung | 165 |
| Werkzeug-Basisschaden | 25 +25 % Stahlkraft =31,25 ohne Krit |
| Angriffstempo | 0,8/s =1,25s Grundcooldown |
| Kritische Chance | 5 % |
| Schadensreduktion | 10 %, nach dem bestehenden Rüstungsabzug |
| Regeneration | Alle5 Kampfsekunden 2 % der aktuellen Max-HP |

Der30%-Lebensbonus gilt auf den Start-Grundwert. HP-Upgrades addieren danach wie bei
allen Helden ihre angegebenen Punkte. Regeneration berücksichtigt diese neuen Max-HP,
heilt nicht über das Maximum und belebt nicht wieder. Fortschritt der5s-Regeneration
bleibt zwischen Wellen erhalten; Shop, Levelwahl und Pause lassen sie nicht weiterlaufen.

WERKZEUGDUO: Schraubenschlüssel und Pumpenzange bilden eine gemeinsame Klassenwaffe
in einem Slot, mit genau zwei animierten Händen. Automatische Halbkreisangriffe vor
dem Spieler wechseln die Werkzeuge ab. Jeder vierte tatsächliche Angriff trifft mit
beiden Werkzeugen für insgesamt150% Schaden und55 Rückstoß. Ein Gegner erhält dabei
einen Schadens-/Krit-Wurf und höchstens eine Todesbelohnung. Kein Ziel: kein Zähleranstieg.
Der Angriffszähler bleibt über Wellen erhalten und wird bei einem neuen Run zurückgesetzt.
Andere Klassen können das Werkzeugduo nicht kaufen; Steelfist erhält keine Fremdwaffen.
Ungeeignete Projektil-/Multishot-Upgrades werden nicht angeboten.

ROHRBRUCH-CHAOS: 35s Cooldown, einmalig300% des aktuellen normalen Werkzeugschadens
in Radius300. Bis zu150 Rückstoß und2s Betäubung, auch für Bosse. Bereits freigesetzte
Projektile/Bodengefahren bleiben aktiv; neue Angriffe und Bewegung der betäubten Gegner
warten. Kontrollierbare Spezialangriffe von Ravox/Eliten/Spuckern/Pack werden unterbrochen.
Boss-KI und deren neue Spezialangriffe pausieren mit der Betäubung und setzen danach fort.
5s lang +50% Angriffstempo; jeder tatsächliche Kill während des Buffs verlängert um0,2s,
höchstens um weitere5s. Keine Verlängerung nach Ablauf, keine dauerhafte Änderung der
gekauften Angriffswerte. HUD zeigt KRAFT-Restzeit und Fähigkeit-Cooldown. Temporäre Effekte
enden beim Wellenende/Run-Ende; keine Simulation während Pause, Shop oder Levelwahl.

Werkzeuglevel1–5: +30% Basisschaden, +10 Reichweite und +6% Angriffstempo je Level.
Auf Level5 eine kostenlose Wahl: DRUCKBRECHER (+20% Schaden/+15% Reichweite/15% längerer
Cooldown) oder RATSCHENRAUSCH (30% kürzerer Cooldown/15% weniger Schaden). Beide besitzen
eigene Icons, echte Wirkungen und bleiben Klassenwaffen. Werkstatt zeigt korrekte Werte.

Eigene Illustration nach der bereitgestellten Steelfist-Referenz, separate armlose Basis,
Handschuh und Werkzeuge. Wasser-/Dampf-Druckwelle, Stun-Sterne, Doppelschlag und Buffring;
drei eigene synthetisierte Sounds ohne Samples. Meisterschaften/Farbvarianten, Resultate,
Verlauf und bestehende Aufgaben erfassen den neuen Helden. Alte Profile werden um leere
Steelfist-Daten ergänzt; bestehende Statistiken und Studio-Coins bleiben erhalten.

Godot4.6.3 stable: project.godot importieren und starten, alle Assets vorhanden. Android
ARM64-only, offline, Querformat, GL Compatibility. APK0.17.0 / Code21 als Update über0.16.
23 Suites /1.747 Assertions und beide historischen Traces geprüft. 72 spezifische Checks,
43.200 Lastschritte und acht native GL-Ansichten. Android-Gerätetest von Bedienung,
Balance, Update mit vorhandenen Daten und FPS/Thermik bleibt offen. Kein PC-Export.

---

## Historischer Stand vor 0.17

# Mayhem Survivors 0.16.0 Alpha — Crew, Chaos & Belohnungen

Fünf Helden und vier Arenen jetzt als große Einzelkarten: links/rechts über die Karte
wischen oder die Pfeile unten nutzen. Auswahl startet erst nach AUSWÄHLEN / ARENA
BETRETEN. Gesperrte Charaktere/Arenen lassen sich ansehen, aber nicht starten.
Vertikale Ziehbewegungen und Mehrfingergesten lösen keinen Kauf oder Run-Start aus.
Die bestehende Safe-Area-Skalierung rechnet Touchpositionen in Layoutkoordinaten um.

## Gegner und Arenenereignisse

| Gegner | Ab Welle | Verhalten | Gleichzeitig |
| --- | --- | --- | --- |
| Bombling | 2 | Verfolgt dich, kündigt Explosion im Kreis 1,4s an | 4 |
| Longshot | 4 | Zielt 1,6s mit festgelegter Linie, feuert ausweichbares Projektil | 2 |
| Hexling | 6 | Markiert 1,7s ein Ziel, dann zusätzliche 0,8s Bodenwarnung | 2 |

Eigene Cartoon-Grafik, Treffer/Tod/Beute, Unterbrechung durch Seife und Rückstoß.
Bombling-Selbstexplosion gibt keine Kills oder Beute; rechtzeitiges Besiegen schon.
Maximal zwei gleichzeitige Windups dieses neuen Packs, Angriffe nur sichtbar im
Kamerabereich. Bestehendes Spawnbudget, Gegnergrenze100 und Wellen-/Stufenfaktoren.
Keine neuen Pack-Spawns während Tutorial oder Bosswellen.

Ab Welle3 ein Ereignis je normaler Welle: SCHROTTREGEN, REAKTOR-ÜBERLAST, FLUTALARM
oder SCHMELZSTURM. Zwei angekündigte Gefahrenmuster, 8s Ereignisdauer. Start frühestens
nach24s, erst wenn laufende Bodengefahren vorbei sind. Eigene Warntexte, goldene
Vorwarnungen und tatsächlicher Schaden. Bestehende Reaktor-/Hafenmuster pausieren
während des Ereignisses. Keine zusätzlichen Ereignisse im Tutorial/Bosskampf.

## Aufgaben, kostenloser Daily Pass und Studio-Shop

Hauptmenü → AUFTRÄGE & SHOP. Fortschritt wird nach beendeten Kampagnen-/Endlos-Runs
gespeichert, auch bei Niederlage oder bestätigtem Run-Abbruch. Training zählt nicht.
Vollständiges Schließen beendet wie bisher den aktiven Run ohne Wiederherstellung.
Neue Ziele zählen ab Installation0.16; alte Rekorde geben keine erfundenen Aufgaben-Kills.

| Ziele | Coins | Pass-XP |
| --- | --- | --- |
| Täglich: 100 Kills / 3 überlebte Wellen / 3 Spezialfähigkeiten | 30 / 25 / 20 | 40 / 30 / 30 |
| Wöchentlich: 1500 Kills / 1 Welle in 3 Arenen / 1 Kampagnensieg | 120 / 80 / 150 | 120 / 80 / 150 |

Belohnungen in ihrem Reiter mit ABHOLEN einsammeln. Tageswechsel00:00UTC, Wochenstart
Montag00:00UTC anhand der Geräteuhr, vollständig offline. Tages-/Wochenziele wiederholen
sich; nicht abgeholte Aufgabenbelohnungen enden beim jeweiligen Wechsel. Keine Serverzeit
oder Online-Prüfung. Wallet, Einkäufe und Pass-Fortschritt verfallen dabei nicht.

Der kostenlose Pass hat sieben Stufen à100XP mit40/50/60/75/90/110/150 Studio-Coins.
Jede Stufe einmal abholen; nach allen sieben NEUEN PASS STARTEN. Überschüssige XP
bleiben erhalten. Kein bezahlter Premiumzweig, keine Werbung oder In-App-Käufe.

Studio-Coins sind dauerhaft und getrennt von Run-Coins im Waffenladen. Sechs permanente
Artikel: Kometenring280, Stromring200, Glutring320, Mini-Bot450, Bomben-Kumpel450,
Chaos-Legende-Titel180. Kauf schaltet frei und rüstet aus. Ein Ring, ein Begleiter und
ein Titel gleichzeitig; alles im echten Kampf sichtbar, jederzeit im Studio-Shop ablegbar.
Keine Werteboni, keine zusätzlichen Waffenhände, keine negativen Guthaben/Doppelkäufe.
Kauf/Abholen wird sofort lokal geschrieben; bei Schreibfehler zurückgerollt.
Speicherschema3 kompatibel um meta/version1 ergänzt, alte Statistik bleibt erhalten.

## Start und Prüfung

Godot4.6.3 stable: project.godot importieren und starten. Keine manuellen Reparaturen,
keine Assetgeneratoren nötig. Android-only, ARM64, Querformat, offline, GL Compatibility.
APK0.16.0 / Code20, gleicher Paketname und Debug-Schlüssel wie0.15; als Update installieren.
`python3 tools/run_tests.py --traces`: 22 Suites / 1.644 Assertions und zwei historische
Traces. Neue Live-Suite80 Checks, Lastprobe21.600 Schritte, sechs native GL-Screenshots.
Physisches Android-Touchgefühl, neuer Gegnerdruck und Geräte-FPS/Thermik noch offen.
Quellarchiv enthält alle Laufzeitdateien, Tests/Logs und aktuelle Galerien ohne Cache,
SDK oder private Signierschlüssel. Ältere reine Screenshots bleiben im Repository.

---

## Historischer Stand vor 0.16

# Mayhem Survivors 0.15.0 Alpha — Normal / Veteran / Mayhem

Drei sofort auswählbare Schwierigkeitsgrade für alle vier Arenen, Kampagne und Endlos.
CHARAKTERE → ARENAWAHL → SCHWIERIGKEIT öffnet die Karten. Die Stufe wird beim Start
festgeschrieben; nachträgliche Menüauswahl beeinflusst keinen laufenden Run.
Auswahl bleibt für weitere Runs in dieser App-Sitzung erhalten; Neustart beginnt Normal.

| Faktor gegenüber 0.14 | Normal | Veteran | Mayhem |
| --- | --- | --- | --- |
| Normale Gegner-HP | 1,00 | 1,22 | 1,45 |
| Gegner-/Boss-Bewegungstempo | 1,00 | 1,05 | 1,10 |
| Kontaktschaden | 1,00 | 1,15 | 1,30 |
| Spawnintervall | 1,00 | 0,90 | 0,82 |
| Boss-HP | 1,00 | 1,12 | 1,25 |
| XP-/Coin-Beute | 1,00 | 1,15 | 1,30 |

Faktoren kommen auf die bestehende Wellen-/Endlosprogression. Beute wird pro Belohnung
gerundet; kleine Coin-Drops steigen deshalb nicht bei jedem Gegner. Eliten erhalten
HP-/Beutefaktor genau einmal. Gegnerlimit 100, Warnzeiten, Spezialangriffsabläufe,
Projektile und Arenagefahren unverändert. Dash-Spezialtempo bleibt wie bisher;
Tempo-Bonus betrifft die normale Bewegung. Keine Charakter-/Waffenwerte verändert.
Normal entspricht spielmechanisch 0.14. Tutorial bleibt unabhängig von Auswahl Normal.
Daten editierbar in data/difficulty/presets.json; keine Grafikeinstellung beeinflusst Werte.

## Echte getrennte Rekorde

STATISTIK → STUFEN-REKORDE zeigt getrennt nach Stufe, Modus und Arena Runs, Siege,
höchste Welle, Kills und Zeit; Kampagne zusätzlich schnellsten Sieg. Endlos zeigt keine
irreführende Sieganzeige. Bestehende Gesamtstatistik/Meisterschaften bleiben aggregiert.
HUD, Ergebnis und neue Verlaufseinträge nennen die tatsächlich gespielte Stufe.
Alte Verlaufseinträge ohne Stufe erscheinen als Normal. Alte Arena-/Endlos-Rekorde
werden aus vorhandenen Daten zu Normal migriert; Veteran/Mayhem starten leer.
Speicherschema 3 kompatibel um difficulty_records ergänzt. Ungültige Werte/IDs werden
abgefangen. Kein Transfer erfundener höherer Rekorde, keine Doppelwertung nach Spielende.
Die separate Normal-Migration erhält echte vorhandene Zeit-/Wellen-/Siegwerte.

## Prüfung / Start

Godot 4.6.3 stable: project.godot importieren, starten. Android-only / ARM64 / Querformat /
offline / minSDK24 / targetSDK36 / Code19 / 0.15.0. Als Update über 0.14 installieren.
`python3 tools/run_tests.py --traces`: 21 Suites / 1.565 Assertions und beide Traces grün.
52 neue Difficulty-Checks, 21.600 Lastschritte mit allen Stufen in allen Arenen/Welle31.
Native Galerie tests/difficulty_*.png geprüft, keine Android-Screenshots.
Physische Android-Abnahme von Bedienung, Leistung und menschlichem Tier-Balancing offen.
Quell-ZIP enthält alle Laufzeitassets/Szenen/Code/Tests und aktuelle Galerien; ältere reine
Screenshots im Repository. Keine Generatoren oder manuelle Programmierung zum Start nötig.

---

## Historischer Stand vor 0.15

# Mayhem Survivors 0.14.0 Alpha — Worlds, Endlos & Kicksy

Android-only / Godot 4.6.3 stable / GDScript / offline / ARM64 / Querformat.

## Vier Arenen, zwei Modi

SCHROTTPLATZ und REAKTORZONE bleiben erhalten. Neu, sofort wählbar:
NEONHAFEN mit eigener Hafenkarte, angekündigten Flutimpulsen und DOCK-TYRANN;
GLUTWERK mit eigener Ofenkarte, Schmelzbahnen und OFENKÖNIG. Beide Bosse besitzen
eigene Grafiken; sie verwenden die bewährten Overlord-/Wächter-Angriffsarchetypen
mit Phasen und arenaeigenen Gefahren. Keine dekorativen Hindernisse im Spielfeld.
CHARAKTERE → ARENAWAHL → WEITERE ARENEN zeigt die neuen Karten.

MODUS schaltet zwischen KAMPAGNE und ENDLOS um. Kampagne bleibt zehn Wellen mit
finalem Sieg. Endlos hat keinen Siegdeckel: normale Wellen 60 s, jede zehnte Welle
Boss mit 90-s-Limit. Boss besiegt → Shop → Welle 11/21/31 usw. Tod oder Boss-Zeitlimit
beendet den Run. Endlos-Rekorde je Arena unter STATISTIK → ENDLOS-REKORDE, getrennt
von Kampagnen-Siegen/Meisterschaften. Keine Verlängerung der begrenzten Gegnerliste.
Aktive Runs werden nach vollständigem Beenden der App weiterhin nicht wiederhergestellt.

## Jede Welle mehr Druck

Zusätzlich zu bisherigen Wellenwerten bekommen normale Gegner je weiterem Wellenindex
+2,5 % Basisfaktor auf HP und Tempo sowie +2 % Kontaktschaden. Tempo-Faktor maximal
1,8, Zusatz-Schadensfaktor maximal 3. HP wachsen weiter. Vorausschauende Verfolgung
steigt auf maximal 0,30 s; Runner flankieren zunehmend mit begrenzter Seitbewegung.
Telegraphierte Stürme verfolgen kein neues Ziel nach der Warnung. 100 Gegner maximal.
In Endlos steigt Boss-HP pro weiterem Zehnerzyklus um 35 %, Spawnintervall sinkt bis
höchstens 0,30 s. Ravox-/Elitekontingente wiederholen sich mit begrenztem Speicher.
Level maximal 999, XP-Anforderung numerisch abgesichert, kein festhängendes Upgrade-Menü.
Dies verändert die Schwierigkeit ausdrücklich; keine Balanceidentität zu 0.13 behauptet.

## Kicksy als Coach und Heldin

TUTORIAL MIT KICKSY startet eine sichere interaktive Übung mit 13 Etappen. Sie erklärt
Bewegung, Auto-Angriff, XP, echte Upgrade-Auswahl, Fähigkeit, Ravox-Ausweichen,
Shopkauf, Reroll, Waffenwerkstatt, Pause sowie Meisterschaft und Modi. Aufgaben werden
an tatsächlichen Aktionen geprüft, nicht nur mit Weiter weggeklickt. Keine Kampf-
rekorde, Coins oder Niederlagen durch Training. Abbruch und Wiederholung möglich.
Coach erscheint mit Pop-Animation; ruhige Menüs deaktivieren diese. Eigene angepasste
Illustration nach der vom Nutzer angehängten braunhaarigen Kicksy im roten Hoodie.
Dialoge bearbeitbar in data/tutorial/kicksy.json, keine Sprachaufnahmen behauptet.

Nach Tutorialabschluss UND 500 insgesamt besiegten Gegnern (Kampagne + beendete
Endlos-Runs, bestehende Werte zählen mit) wird KICKSY spielbar. Freischaltung wird
nach Run/Tutorial gespeichert und beim Laden aus validierten Daten rekonstruiert.
100 HP / 220 Basistempo / +10 % Passiv = tatsächlich 242 Tempo, Seltenheit EPISCH.
Nur MAYHEM-BOMBE: automatische Würfe, 20 Basisschaden, Radius 110, 0,65-s-Flug,
1,1-s-Cooldown. Projektiltempo und Multishot sind geeignet. Bomben-Stufe 1–5.
KETTENREAKTION: drei zeitversetzte Explosionen mit je 30 Basisschaden, Cooldown 28 s.
Stufe 5: STREUBOMBE (drei 30-%-Folgeexplosionen ohne Rekursion) oder FEUERBALL
(drei Sekunden Brandfeld, stärkstes überlappendes Feld). Kein Selbstschaden.
Pool 16 Bomben, maximal 15 Folgeereignisse und vier Brandfelder, auf allen Qualitätsstufen
gleiche Spielmechanik. Genau zwei animierte Arme am armlosen Kicksy-Spielkörper.
Eigene Portraits/Handschuhe/Bombe, Icons, Sounds, Statistik und Meisterschaft.

## Menü und Mobile UX

Verläufe, lesbare Karten, feste Touchziele und dezente bestehende Überblendungen.
Hintergrund-Parallaxe über Android-Gravity/Accelerometer; Bedienelemente bleiben fest.
EINSTELLUNGEN → BEWEGUNG: Neigung an/aus, ruhige Menüs und neu zentrieren.
Automatische Mittelpunktkalibrierung, geglätteter begrenzter Ausschlag, Sensor-Fallback.
LOW und ruhige Menüs reduzieren Menübewegung. Keine neue Android-Berechtigung.
Eigene Endlos-HUD ohne falsche Max-HP-Ersetzung; Tutorial-HUD ohne künstlichen Timer.
Coach-Touch wird nicht vom Joystick abgefangen. Abweichende Seitenverhältnisse werden
weiter über Safe-Area-Skalierung behandelt.

## Start / Prüfung

project.godot importieren und starten; keine Generatoren oder Programmierung erforderlich.
Android-Update Code 18 / 0.14.0, identischer Paketname und Debug-Schlüssel.
`python3 tools/run_tests.py --traces`: 20 Suites, 1.513 Assertions und beide Traces grün.
Historische Traces frieren alte Progressionswerte bewusst ein; aktuelle neue Regeln
haben eigene Tests. Lastprobe 36.000 Schritte mit fünf Helden in vier Arenen/Welle31.
Vorgabeszenen unter tests/worlds_*.png sind native Engine-Bilder, keine Android-Captures.
Offene Geräteabnahme: Tutorial-Touch, Sensor-Richtung/Komfort, Update mit bestehenden
Daten, beide neuen Arenen und menschliche Schwierigkeit/Boss-Balance/FPS/Thermik.
Quell-ZIP enthält alle Laufzeitassets, Code, Szenen, Tests, Logs und aktuelle Galerien;
ältere reine Testscreenshots bleiben im Repository. Keine SDKs/privaten Schlüssel im ZIP.

---

## Historischer Stand vor 0.14

# Mayhem Survivors 0.13.0 Alpha — RAVOX

RAVOX – DER WUTTEUFEL ist ein neuer Gegner, kein auswählbarer Held.
Eigene Grafik nach RF-Worlds-Nutzervorlage, Zermalmer als schwere Faustpanzer.
140 Basis-HP, Tempo 220, 12 Basis-Kontaktschaden. Bestehende Wellen-Skalierung gilt.

## Verhalten / Gegenmittel

In beiden Arenen ab Welle 5 bis einschließlich Welle 9. Zehn Prozent der bisherigen
Spawn-Rolls ersetzen einen normalen Spawn; keine zusätzliche Spawnquelle und kein
zusätzlicher RNG-Wurf. Höchstens zwei lebende Ravox, vier Erzeugungen pro Welle.
Ist das Kontingent voll, erscheint der ursprüngliche normale Gegner. Globales Limit
100 unverändert. Wellen 1–4 und der Bosskampf bekommen keine Ravox-Spawns.

Verfolgt den Spieler, beginnt nach zwei sichtbaren Sekunden mit dem Angriffsmuster:

1. Steht 1,25 s still und zeigt die vollständige orange Sturmbahn. Ziel und Endpunkt
   bleiben fixiert. Seitlich ausweichen; Ravox steuert nach Beginn nicht nach.
2. Stürmt mit Tempo 500 höchstens 360 Einheiten. Zermalmer: +15 % gegenüber seinem
   aktuellen Kontaktschaden, vor Rüstung/Unverwundbarkeit. Kollisionsprüfung über die
   tatsächlich zurückgelegte Strecke; keine Treffer voraus bei Verlangsamung.
3. Erholt sich 1,1 s, danach Verfolgung und 3,8 s Cooldown vor erneutem Anlauf.

Nur ein Ravox darf gleichzeitig vorwarnen/stürmen. Angriffe beginnen nur sichtbar;
unsichtbar gewordene Anläufe werden abgebrochen. Schockwelle, Twinkles Seife und Tornado
unterbrechen. Sparky verlangsamt auch den Sturm. Shades Unverwundbarkeit gilt normal.
Dauerbetäubung wird weiterhin durch Twinkles bestehende 3-s-Resistenz verhindert.

Eigene Treffer-/Todesdarstellung, Name und HP-Balken, Warn-/Sturm-Sounds und eigene
Beute (18 Basis-XP / 8 Basis-Coins, bestehende Wellenmultiplikatoren). Doppelte Tode
und Belohnungen bleiben ausgeschlossen. Pause/Level-up/Shop stoppen das Gameplay;
Aufräumen entfernt Ravox samt Warnung, neuer Run setzt die Spawnkontingente zurück.
Keine neue Speicherung nötig, alle bisherigen Charaktere/Meisterschaften kompatibel.

## Prüfen und spielen

Android 7+, ARM64, offline, Landscape. Code 17 / Version 0.13.0. Als Update installieren.
Godot 4.6.3 stable: project.godot importieren und starten, keine Generatoren nötig.
`python3 tools/run_tests.py --traces`: 18 Suites / 1.216 Assertions und beide Traces.
Ravox-Suite: 52 Checks. Lastprobe: alle vier Helden × zwei Arenen, 28.800 Schritte,
maximal 100 Gegner / zwei Ravox / vier pro Welle, keine überlappenden Ravox-Angriffe.
Künstliche HP und Pilot; keine Android-FPS- oder menschliche Balance-Abnahme.

Historische Effekt-Fixture deaktiviert neue 0.13-Spawns ausdrücklich; ihre zehn alten
Entwicklungen und Regeln bleiben vergleichbar. Neue Begegnungen separat getestet.
Quell-ZIP enthält sämtliche Laufzeitassets/Szenen/Skripte/Tests/Berichte und aktuelle
Ravox-/Twinkle-/Meisterschaft-/Encounter-Galerien. Ältere reine Screenshots im Repository.
Geräteabnahme: orange Bahn/Lesbarkeit, Ausweichen/Unterbrechen und Schwierigkeit ab Welle 5.

---

## Historischer Stand vor 0.13

# Mayhem Survivors 0.12.0 Alpha — TWINKLE

Vierte spielbare Heldin: TWINKLE – DIE REINIGUNGSQUEEN.
100 HP / 210 Tempo / nur WISCHMOPP. Von Beginn an verfügbar, in beiden Arenen.
CHARAKTERE → WEITERE HELDEN öffnet ihre eigene Auswahlseite mit Beschreibung/Zitat.

## Eigene Mechanik

- Wischattacke: automatischer Halbkreis mit 150 Basisreichweite, 18 Basisschaden,
  0,95 s Basis-Cooldown. Trifft mehrere Gegner; +15 % Flächenschaden auf Mopp,
  Gift und Tornado. Bestehende globale Schadens-/Tempo-Upgrades gelten zusätzlich.
- Seifenchaos: getroffene normale Gegner eine Sekunde betäubt, keine Bewegung,
  Spezialattacke oder Kontaktschaden währenddessen. Individuelle 3-s-Resistenz ab
  Betäubungsbeginn verhindert Dauerbetäubung. Bosse sind kontrollimmun.
- Chemiekeule: Sprühflasche erzeugt am Ziel eine 3-s-Giftpfütze, 85 Basisradius,
  8 Basis-DPS. Maximal fünf Felder, überlappend gilt nur das stärkste Gift.
  Schaden in begrenzten 0,25-s-Intervallen; Lebenszeit auch bei langen Frames begrenzt.
- Putzfimmel: jeder 20. tatsächliche Kill im aktuellen Run heilt 2 HP, bis zum Maximum.
- TWINKLE TORNADO: Touch-Fähigkeit, fünf Sekunden Seifenwirbel um die bewegliche
  Heldin, 230 Radius, 24 Basis-DPS plus Flächenbonus, 110 Einheiten/s Rückstoß auf
  normale Gegner. Der Mopp dreht sich sichtbar. Keine Unverwundbarkeit. 45 s Cooldown
  ab Aktivierung. Bosse erhalten Schaden, werden aber nicht verschoben/betäubt.

Wischmopp Stufe 1–5: +30 % Basisschaden/Stufe, Reichweiten-/Tempo-Steigerung.
Pfützen-DPS skaliert gleich mit dem Waffenlevel. Auf Stufe 5 kostenlos eine Entwicklung:
SEIFENSTURM (+40 % Wischreichweite / 1,25 s Betäubung) oder CHEMIEFLUT
(+60 % Giftschaden / eine Sekunde längere Felder). Keine fremden Waffen über Shop.
Set-Zuordnung STROMKREIS; ungeeignete Multishot-/Geschosstempo-Upgrades werden nicht angeboten.

## Vollständige Integration

Eigener transparenter Grafik-Atlas: Portrait, armloser Spielkörper, separate Handschuhe
und Wischmopp. Genau zwei animierte Arme; separate prozedurale Sprühflasche.
Eigene Mopp-/Sprüh-/Seifen-/Gift-/Tornado-Effekte und drei selbst synthetisierte Sounds.
Darstellungsstufen ändern nur Blasenanzahl, keinen Schaden oder Radius.
Statistik, Historie, Ergebnis, Skins, Meisterschaft und lokale Speicherung kennen Twinkle.
Meistertitel GLANZLEGENDE, dieselben drei Ziele und Farbvarianten wie die anderen Helden.

Bestehende Schema-3-Saves bekommen leere Twinkle-Profile und Original-Skin ergänzt;
alle alten Rekorde/Einstellungen bleiben erhalten, keine erfundene Twinkle-Historie.
Transienter Schaden/Betäubung/Tornado stoppt in Pause/Level-up/Shop und wird bei
Wellenende, Neustart, Sieg/Niederlage bereinigt. Kein Run-Resume nach App-Beenden.

## Ausführen / Abnahme

Godot 4.6.3 stable, project.godot importieren und starten. Kein Generator erforderlich.
Android 7+, ARM64, offline, Querformat. Code 16 / 0.12.0, als Update installieren.
`python3 tools/run_tests.py --traces`: 17 Suites / 1.164 Assertions, beide alten Traces grün.
Neue Twinkle-Suite: 65 Checks. Lastprobe in tests/twinkle_soak.gd künstliche HP und Pilot;
3/6 Boss-Siege am Schrottplatz, drei Reaktor-Zeitlimits. Kein Beweis menschlicher Balance
oder Android-FPS. Touch/Update/Lesbarkeit und beide Bosse auf Gerät noch abnehmen.
Normale Gegner-/Waffen-/Charakterwerte der bisherigen drei Helden unverändert.

Quellarchiv enthält sämtliche Laufzeitassets und den kompletten Code/Szenen/Tests.
Historische Testscreenshots sind im GitHub-Repository; im ZIP nur die aktuelle Twinkle-
und die direkt vorherigen Meisterschaft-/Encounter-Galerien, um das Archiv klein zu halten.
Diese Screenshots sind keine Testfixtures und nicht zum Import/Spielen nötig.

---

## Historischer Stand vor 0.12

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
