# Komfort-Update 0.30.0 Beta 4

## Status der sechs Punkte

| Punkt | Stand |
| --- | --- |
| Run nach App-Ende fortsetzen | Enthalten; profilbezogen, Kampf startet pausiert |
| Profil als Datei sichern/importieren | Enthalten; jetzt auch mit Touchlayout und Builds |
| Touchsteuerung anpassen | Enthalten; Vorschau mit Verschieben und Linkshändermodus |
| Boss-Training | Enthalten; echte Bosse, alle freigeschalteten Welten, keine Belohnungen |
| Ausrüstungs-Presets | Enthalten; drei Builds je freigeschaltetem Fighter |
| Optionale Google-Play-Bestenliste | Adapter/Scoring/Build-Weg implementiert und nativ kompiliert; noch nicht aktiv |

Der Nutzer hat Google Play Games gewählt und bestätigt, dass noch kein Spieleprojekt
angelegt ist. Die erforderlichen echten Projekt-/Bestenlisten-IDs fehlen. Dieser
Store-Build enthält daher weiterhin keine Google-Play-SDKs oder Internetberechtigung.
Es gibt keine öffentliche Online-Liste und keine behaupteten Google-Anmeldetests.
Die genaue Einrichtung steht in PLAY_GAMES_SETUP.md.

## Touchlayout

HAUPTMENÜ → EXTRAS → DEINE STEUERUNG oder EINSTELLUNGEN → STEUERUNG → TOUCHLAYOUT
ANPASSEN. Joystick und Fähigkeit in der Vorschau ziehen. Der Zauber bleibt über der
Fähigkeit. Linkshändermodus tauscht die Seiten. Fester Joystick aktiviert sich nur
an seiner sichtbaren Fläche, dynamischer im vorgesehenen Bewegungsbereich.

Größe 85–120 %, Sichtbarkeit 45–100 %, Deadzone 8–28 %. ANWENDEN speichert im
aktiven Profil; ABBRECHEN übernimmt nichts. STANDARD setzt zunächst nur die Vorschau
zurück. Safe Areas und Bildschirmwechsel werden berücksichtigt. Bewegung und
Fähigkeiten funktionieren mit getrennten Fingern; Release und Unterbrechung setzen
die Bewegung zurück. Einstellungen verändern keine Gegner oder Trefferberechnung.

## Boss-Training

EXTRAS → BOSS-TRAINING. Wähle einen eigenen Fighter, eine freigeschaltete Arena,
Welle 2/4/6/8/10 und Startphase 1/2/3. Du erhältst einen klar gekennzeichneten
Trainings-Build: Startwaffe Lv.5, Spielerlevel15, Schaden ×2,2 und Angriffstempo ×1,3.
Ausgerüstete permanente Gegenstände werden als Kopie verwendet.

Der Kampf nutzt die tatsächlichen Boss- und Arena-Controller, Warnungen, Phasen,
Kollisionen und Fähigkeiten. Das Ergebnis zeigt Zeit, erhaltene Treffer und Schaden.
NOCH EIN VERSUCH startet erneut. TRAINING VERLASSEN beziehungsweise SICHERN &
HAUPTMENÜ kehrt zum normalen Profil zurück. Keine Coins, Rekorde, Aufgaben- oder
Weltbelohnungen. Der vorherige gesicherte Run bleibt einschließlich Ranglisten-Ticket
erhalten. Training selbst wird nach hartem App-Ende nicht wiederhergestellt.
Bewusst veränderte Einstellungen können auch aus dem Training gespeichert werden.

## Builds

EXTRAS → AUSRÜSTUNGS-BUILDS oder in der Garage BUILDS. Pro Fighter drei Slots.
AKTUELLES SPEICHERN sichert Kopf, Körper, Schuhe, Startwaffe, Item, Zauber und
Waffenskin. Das Ersetzen eines belegten Slots wird bestätigt. ANLEGEN übernimmt
alle gespeicherten Slots gemeinsam und aktiviert den Fighter.

Nur vorhandene und kompatible Ausrüstung ist zulässig; keine Freischaltung oder
Währungsänderung durch Presets. Die aktuellen Gegenstandsränge bleiben bestehen.
Builds gelten für den nächsten neuen Run; ein schon gesicherter Durchlauf behält
seine damalige Ausrüstung. Während eines aktiven Kampfes/Trainings lassen sich
keine Builds anwenden. Schreibfehler rollen die Änderung zurück.

## Profile, Backup und Updates

Bestehendes Profilschema3 bleibt kompatibel. Ein Update von0.29 behält den aktiven
Run, die Sammlung und die fünf lokalen Profile. Neue Spieler starten unverändert
bei null mit Bruiser/Hammer/Schrottplatz. Touchlayout und Builds werden in portable
Profildateien übernommen. Eine Google-Play-Verknüpfung, offene Score-Übermittlungen
und Ranglisten-Tickets werden beim Export/Import bewusst entfernt. Das importierte
Profil bleibt offline; neue Runs können nach eigener späterer Verbindung teilnehmen.

Ranglisten zeigen derzeit tatsächliche persönliche Rekorde. Es werden keine
erfundenen Online-Einträge, Spielerzahlen oder Rangplätze angezeigt.
