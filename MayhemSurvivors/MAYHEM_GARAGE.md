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

Die ursprüngliche Entwurfsphase wurde nach Wiederverfügbarkeit der Umgebung integriert.
Der aktuelle Prüfstand steht in TEST_REPORT.md, Fortsetzung in PROGRESS.md/ROADMAP.md.
