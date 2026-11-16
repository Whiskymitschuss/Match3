# Effektpaket 0.5.1 — 2026-11-16

## Aktuelle Phase

Effektpaket implementiert und final getestet; Android-APK signiert, ARM64/Paket/Version/
Berechtigungen/16-KiB-Alignment geprüft. Quell-ZIP frisch importiert, 40 neue Prüfungen
daraus erneut bestanden. GitHub-Übergabe vorbereitet.
Keine physische Android-Hardware in dieser Umgebung.

## Implementiert

Farbige Cartoon-Splattertropfen und Bodenflecken, Funken/Rauch, Mündungsblitze/Spuren,
Hammerbögen/Bodenrisse, Blitzverästelungen, Explosionen, kritische Sterne, Schatten-
Nachbilder und Münz-Popups. Alter Todesring entfernt. Eigene SVG-Textur und Synthsounds.
Neue kosmetische Ebene mit eigenem RNG, wiederverwendeten Partikel-Dictionaries und
Limits für LOW/MEDIUM/HIGH. Gespeicherter Splatter-Schalter. Bosswarnungen bleiben über
Bodenflecken sichtbar. Kein neuer Schaden und keine Änderung von Werten oder Belohnungen.

## Tatsächlich geprüft

591 Assertions bestanden (551 bestehende + 40 neue). Neuer 0.5-Vergleich über 174 Punkte /
17.400 Schritte mit allen zehn Waffenwegen, Fähigkeiten, Arenen und Bossen in HIGH, LOW
und Splatter AUS identisch. Zusätzlich alter 33-Punkte-/3.600-Schritte-Vergleich bestanden.
18.000 Belastungsschritte mit allen zehn Varianten und gemischten Qualitätseinstellungen
bestanden. Sieben Godot/Mesa-Bilder geprüft und nach Entfernung überladener Todesringe
neu erzeugt. Bilder sind Fixtures/Nahansichten, keine Android-Aufnahmen.

## Nächster Schritt

Tatsächliche Android-Abnahme für 0.5-Waffenwege plus 0.5.1-Effekte, Lesbarkeit,
FPS/Temperatur und Audio. Version 0.4 hatte positives Nutzerfeedback; 0.5.1 noch nicht.
Details siehe TEST_REPORT.md und BUILD_REPORT.md.

---

# Historischer Stand 0.5

# Meilenstein 0.5.0 — 2026-11-16

## Nutzerabnahme des Vorgängers

Nutzer bestätigt zu 0.4: „Ja funktioniert, sie hilft und alles ist gut erkennbar“.
Damit liegt positives Praxisfeedback zu Funktion, Nutzen und Lesbarkeit der Fähigkeit vor.
Konkrete Helden, vollständige Run-Anzahl, Gerätemodell und FPS wurden nicht genannt.

## Aktuelle Phase

Alle zehn Waffenspezialisierungen implementiert und geprüft. Android-APK exportiert,
signiert, Paket/Version/ARM64/Berechtigungen und 16-KiB-Alignment geprüft.
Quell-ZIP frisch importiert und daraus erneut 108 Prüfungen bestanden. GitHub-Übergabe
vorbereitet. Keine physische Android-Hardware hier.

## Umgesetzt

Kostenlose verbindliche Auswahl direkt nach Stufe-5-Shopkauf, zwei Wege je Waffe.
Neue Rundumschläge, Einzeltreffer, Durchschlag, Explosionen, Fächer, Ketten und Klingenorbits.
Klassenbindung und Fähigkeiten erhalten. Auswahl pausiert die Simulation; mehrere
Auswahlen werden nacheinander abgearbeitet. Wellen behalten, neue Runs löschen die Wahl.
Symbole/Abzeichen, visuelle Effekte und eigene Synthsounds. Verlauf und Ergebnis
enthalten Spezialisierungen, Speicherformat 3 bleibt mit älteren Einträgen kompatibel.

## Tatsächlich geprüft

551 Assertions bestanden: bestehende 443 plus 108 neue Prüfungen. Referenzvergleich
33 Punkte / 3.600 Schritte ohne gewählte Spezialisierung weiterhin identisch.
Alle zehn Varianten jeweils 1.800 Belastungsschritte, insgesamt 300 simulierte Sekunden,
mit echten Fähigkeiten und bis zu 100 Gegnern geprüft. Zusätzlich 21.600 Schritte
Fähigkeiten-Stresstest bestanden. Kein daraus abgeleiteter Android-FPS-Nachweis.
13 UI-/Kampfbilder mit Godot/Mesa gerendert und geprüft. Überlappende Beschreibungstexte
bei der ersten Bildprüfung korrigiert und durch Layout-Regression abgesichert.

## Nächster Schritt

Echte Android-Runs mit den
beiden Wegen je Klassenwaffe prüfen: verständliche Auswahl, unterschiedliche Spielweise,
faire Gegenleistung für Reichweite/Tempo/Flächenschaden, Geräteleistung und Statistikerhalt.
Version 0.5 ist noch nicht physisch auf Android abgenommen. Details in TEST_REPORT.md
und BUILD_REPORT.md; keine offenen Pflichtmenüs oder bekannten Parserfehler.

---

# Historischer Stand 0.4

# Meilenstein 0.4.0 — 2026-11-16

## Aktuelle Phase

Heldenfähigkeiten und Trefferfeedback implementiert. Android-APK exportiert, Signatur,
ARM64, Paket/Version, Berechtigung und 16-KiB-Alignment geprüft. Quell-ZIP frisch
importiert und erneut getestet. GitHub-Übergabe vorbereitet. Keine Android-Hardware hier.

## Implementiert

- Bruiser: radiale Schockwelle, Nahkampfbonus, begrenzter Rückstoß für normale Gegner.
- Sparky: automatisch gezielte Impulsgranate mit Zünder, Flächenschaden und temporärem Slow.
- Shade: gerichteter Schattenschritt mit Swept-Kollision, einmaligem Schaden und Dash-Unverwundbarkeit.
- Rechter Touchbutton, visuelle Bereitschaft/Abklingzeit, getrennte Multitouch-Fingerverwaltung.
- Vollständiges Pausieren und Aufräumen; jede neue Welle beginnt bereit.
- Vibration optional und standardmäßig aus, Schadenanzeigen abschaltbar und qualitätsbegrenzt.
- Kritische Treffer hervorgehoben, eigener Schaden rot und mit kurzem Bildschirmrand-Feedback.
- Eigene SVG-Symbole und vier eigene WAV-Sounds inklusive Generator.
- Massen-XP-Drops sofort auf 240 Kristalle zusammengeführt, gesamte XP-Menge erhalten.
- Speicherformat 3 um optionale Einstellungen ergänzt; vorhandene Werte bleiben erhalten.

## Tatsächlich geprüft

443 Assertions bestanden (bestehende 367 plus 76 Fähigkeiten/Touch/Haptik/Speicherung).
Schrottplatz: alle 33 Referenzpunkte über 3.600 Schritte weiterhin identisch, sofern keine
aktive Fähigkeit ausgelöst wird. 21.600 zusätzliche Belastungsschritte mit 38 Aktivierungen
über alle sechs Arena-/Heldenkombinationen bestanden. Kein gemessener Android-FPS-Beleg.
Acht UI-/Effektbilder mit Godot/Mesa gerendert und visuell geprüft.

## Nächste Abnahme

Android-Update über bestehende App installieren. Statistikerhalt, zwei Finger gleichzeitig,
Fähigkeiten gegen beide Bosse und Vibrationsstärken prüfen. Komplette echte Runs je Held,
Balance, Displays mit Aussparung, FPS und Temperatur stehen noch aus. Keine neuen
Waffenspezialisierungen in diesem Meilenstein; diese folgen erst nach Fähigkeits-Praxistests.
Build- und Testdetails stehen in BUILD_REPORT.md und TEST_REPORT.md.

---

# Historischer Stand 0.3

# Meilenstein 0.3.0 — 2026-11-16

## Aktuelle Phase

Implementierung, automatisierte Prüfung und Android-Export abgeschlossen; GitHub-Übergabe.
Physische Android-Abnahme der neuen Inhalte steht aus. APK signiert und geprüft, Quell-ZIP frisch importiert und erneut getestet.

## Implementiert

- Arena-Katalog, Auswahl nach Charakterwahl, eigenständige Wellenkonfiguration.
- Reaktorzone nach erstem Sieg; vorhandene Siege werden berücksichtigt.
- Eigene Reaktorboden- und Wächtergrafik, drei vorangekündigte Bossangriffe.
- Ab Welle 3 wechselnde Strombahnen; keine Reaktorgefahren auf dem Schrottplatz.
- Durchgehender Ablauf mit allen drei Helden in beiden Arenen: zehn Wellen, Shop,
  Levels, Boss, Ergebnis, Timeout, Tod und sicherer Neustart.
- Arena- und Heldenstatistik, Verlauf, drei rein kosmetische Ringfreischaltungen.
- Speicherformat 3, Migration aus 1/2 samt Originalbackup, Einstellungserhalt.
- Bisherige Klassen-/Waffen-/Gegner-/Upgrade- und Schrottplatz-Wellendaten unverändert.

## Tests und behobene Fehler

367 Assertions bestanden; Referenzvergleich 33 Punkte/3.600 Schritte bestanden.
Zwei Belastungsläufe mit je 7.200 Schritten bestanden. Kontrollierter Schadenstest
aller drei Klassen bestanden. Lange Frames übersprangen zunächst die Warnzeit einer
neu erzeugten Strombahn: behoben, gezielter Regressionstest vorhanden. Bossleiste
verwendet tatsächliche Maximal-HP. Arena-Vorschaubilder bleiben innerhalb ihrer Karten.
Sieben UI-/Kampfbilder mit Godot/Mesa gerendert und geprüft; keine Android-Screenshots.

## Offen / nächster Schritt

APK auf bestehender Android-Installation aktualisieren; Erhalt der Werte, Freischaltung,
Touchbedienung, Warnlesbarkeit und vollständige Reaktorruns prüfen. Reaktorbalancing
mit allen Helden anhand echter Runs beurteilen. 60 FPS/Temperatur auf Geräten messen.
Keine offenen Pflichtmenüs oder bekannten Parserfehler. Builddetails siehe BUILD_REPORT.md.

---

# Historischer Referenzstand 0.2.3

# Grafik-/Feedback-/Komfortstand 0.2.3 — 2026-11-16

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

## Aktuelle Phase

Technische Übergabe und Android-Praxisabnahme. Nutzer hat Haltung und Klassenbindung aus
0.2.2 akzeptiert; diese bleiben unverändert. Die noch geplanten Weltgrafik-, Warnungs- und
Statistikarbeiten sind in dieser Testversion verbunden.

## Umgesetzt

Vier Gegnerfiguren, ein durchgehend begehbarer Industriehof als statische Textur,
Trefferaufhellung und begrenzte Todes-Snapshots. Keine neuen Hindernisse oder Kollisionswerte.
Bosswarnungen zeigen die tatsächliche Phase, verbleibende Warnzeit und das fixierte Sturmziel.
Warnungen benutzen eine reservierte Audiostimme. Zusätzliche Siegesfeier ohne neue Wartephase.
Bestwerte je Held und gefilterter Verlauf der letzten 20 neuen Runden, direkt an das Ergebnis
angeschlossen. Schema 1 wird mit Originalbackup nach Schema 2 übernommen; alte Gesamtwerte
bleiben erhalten, neue Charakterzuordnungen werden nicht rückwirkend erfunden.

## Tatsächlich geprüft

76 Integration + 28 Kampfeffekte + 42 Klassen/Haltung + 36 Welt/Warnungen + 28 Speicherung/
Bestwerte = 210 bestandene Prüfungen. Vergleich gegen akzeptiertes 0.2.2-Projekt über 3600
Schritte mit legalen Klassen-Loadouts: 33 Kontrollpunkte stimmen überein. Alle Spiel-JSON-Dateien,
PlayerController, WeaponManager, Projektilpool und Zweihand-Rig sind bytegleich zu 0.2.2.
120 simulierte Sekunden Belastungstest bestanden (synthetischer Vierwaffen-Stressfall).
Welt, 100 Gegner, Rand, beide Bosswarnungen, Sieg und drei Statistikansichten mit Godot gerendert.
Statistik-Renderbilder verwenden Testdaten, keine behaupteten Nutzerresultate.
APK tatsächlich gebaut, signiert und statisch geprüft; passende Assets verpackt.

## Offen / nächster Schritt

Nutzer-Praxistest mit Sparky erfolgreich; Bruiser und Shade noch bis zum Boss prüfen.
Statistikpersistenz nach Neustart, weitere Geräte, FPS und Temperatur bleiben offen.
Nächster vorgeschlagener Meilenstein: 0.3 mit datenbasierter Arena-Auswahl und einer zweiten
Arena samt eigenem Boss. Siehe `ROADMAP.md`. Dieser neue Inhalt ist noch nicht implementiert.
Der klassische Schrottplatz und seine Kampfwerte bleiben als Vergleich erhalten.


---

## Archiv: Stand 0.2.2

# Haltungs-/Klassenkorrektur 0.2.2 — 2026-11-16

## Aktueller Stand

Branch `fix/character-grips-v0.2.2`. Nutzer meldete vermeintliche vier Hände durch die
Überlagerung von vollständiger Figur und mehreren Waffen sowie fehlende Klassenspezialisierung.
Die Waffenbindung wurde als vorläufiger Testvorschlag umgesetzt; auf die Auswahlfrage im
Chat lag bei Umsetzung noch keine Antwort vor. Sie kann bei abweichendem Wunsch angepasst werden.

## Implementiert / geprüft

Getrennte Gameplay-Körper ohne eingemalte Arme; genau zwei Armketten und zwei Hände am
Griff einer sichtbar geführten Waffe. Nahaufnahmen und normale Spielszenen geprüft.
Auch Sparkys drei Schusswaffen erzeugen keine zusätzlichen gehaltenen Waffen oder Hände.
Orbit Blade schwebt frei. Menüporträts bleiben vollständig.

Bruiser darf Hammer kaufen, Sparky Blaster/Splitgun/Arc Cannon, Shade Orbit Blade.
Shopgenerierung UND Kaufvalidierung prüfen dies. Stat-Upgrades vergeben keine Waffen.
Unergiebige Projektil-/Multishot-Angebote werden bei reinen Nah-/Orbitklassen ausgefiltert.
76 bestehende + 28 Effekt- + 42 Klassen-/Haltungsprüfungen bestanden.
Alter synthetischer Formelnvergleich bestanden; keine neue Klassenbalance damit behauptet.
APK 0.2.2 gebaut und geprüft, VersionCode 4, gleiche Signatur, ARM64, keine Berechtigungen.

## Offen / nächster Schritt

Rückmeldung zur vorgeschlagenen Waffenbindung abwarten. APK auf Android als Update testen,
Hände bei Bewegung und Zielwechsel prüfen sowie neue Klassen über volle Runs spielen.
Waffen-/Gegnerwerte sind gleich; eingeschränkte Builds können die Schwierigkeit ändern.
Keine neue Hardware-FPS-Messung, keine vollständige Geräteabnahme behauptet.

---

## Archiv: Stand 0.2.1

# Waffen-/Geschossupdate 0.2.1 — 2026-11-16

## Aktueller Stand

Branch `art/weapons-v0.2.1`. Nutzerkritik umgesetzt: Figuren waren bereits verbessert,
Waffen und Schüsse verwendeten noch primitive Formen. Dieser Stand ersetzt alle fünf
Waffendarstellungen und ergänzt den restlichen visuellen und akustischen Angriffsablauf.

## Implementiert

- Gemeinsamer transparenter 3×3-Atlas für fünf Waffen, Bossprojektil und drei Heldenprojektile.
- Automatische Ausrichtung, Rückstoß, Mündungsfeuer und ausgeworfene Hülsen.
- Hammerschwung mit Bodenschock; sichtbare Orbitklinge mit Spur; Kettenblitz mit Zacken und Kern.
- Charakterbezogene Geschossform und -farbe, Trefferfunken und fünf neue Waffensounds.
- Echte Waffenbilder in Shop und HUD; alte überlappende Waffen-Textzeile entfernt.
- Kosmetische Zustände separat, zeitlich pausiert und beim Bereinigen zurückgesetzt.
- Gleiches Kampf-Balancing; unveränderte Spiel-JSON-Daten, Bewegungs- und Kollisionswerte.

## Tests / Export

76 bestehende + 28 neue Tests bestanden. 3600 Schritte mit allen drei Helden bei fester
Engine-Zeit gegen 0.1 verglichen: 33 Kontrollpunkte stimmen in den aufgezeichneten
Gameplay-Werten überein. 7200-Schritt-Belastungstest / 120 simulierte Sekunden bestanden.
Alle Waffen- und Munitionsdarstellungen mit Godot/Mesa gerendert; Shop und HUD geprüft.
APK 0.2.1 gebaut, ARM64, versionCode 3, Signatur wie 0.1, keine Berechtigungen,
16-KiB-Alignment geprüft. Protokolle unter `tests/results/v0.2.1/`.

## Offen / nächster Schritt

Auf Android als Update installieren und Waffenführung, Schusslesbarkeit, Lautstärke und
Effektdichte im echten Kampf prüfen. Neue Effekte sind begrenzt, aber die Geräteleistung
wurde hier nicht gemessen. Keine Änderungen an Gegnern oder Arena in diesem Waffenupdate.

---

## Archiv: Stand 0.2

# Charaktergrafik-Update 0.2 — 2026-11-16

## Aktueller Stand

Grafikänderung auf Branch `art/characters-v0.2`. Die Referenzversion 0.1 bleibt auf `main`.
Nach 15 gespielten Runden meldet der Nutzer sehr gutes Spielgefühl und bestätigt ausdrücklich
Gegner-/Schussbalance. Deshalb keinerlei Balancingänderungen.

## Implementiert und geprüft

- Drei neue Designs für vorhandene Charaktere nach den visuellen Nutzerreferenzen.
- Größere Auswahlporträts und vereinfachte Spielfiguren als gemeinsamer transparenter Atlas.
- Charakterkarten, Hauptmenü und Ergebnisporträts verbunden; Arenadarstellung mit Laufwippen,
  horizontaler Blickrichtung und Trefferaufhellung. Keine Änderung der Kollisionsgröße.
- 76 bestehende Integrationsprüfungen erneut bestanden.
- Auswahl, Arena und übrige Ansichten tatsächlich mit Godot gerendert und visuell geprüft.
- Atlaszellen auf Transparenz und sichtbaren Inhalt geprüft.
- Spieldaten und zentrale Kampfsysteme gegenüber 0.1 bytegleich geprüft.
- Android-Testbuild 0.2 wird mit gleicher Debug-Signatur und versionCode 2 bereitgestellt.

## Offen / nächster Schritt

Auf dem Nutzergerät als Update testen: Charakterkontrast bei voller Arena, Blickrichtung,
Trefferfeedback, Spritegröße und Erhalt der lokalen Statistik. Keine neue Android-FPS-Messung.
Die Bilder werden prozedural bewegt; separate Walk-/Attack-Spriteanimationen sind ein späterer
Grafikschritt. V0.2 ist hier ein Charaktergrafik-Testbuild, kein weiteres Gameplay-Update.

---

## Archiv: Stand 0.1

# Entwicklungsstand — 2026-11-15

## Aktuelle Phase

Phase 19: technische Übergabe. Phasen 1–18 wurden in einer kompakten Alpha-Implementierung
umgesetzt; die abschließende Abnahme auf echter Android-Hardware ist offen.

## Implementiert

- Startprojekt, verbundene Startszene, PlayerController und GameStateMachine.
- Hauptmenü, Charakterwahl, Vorbereitung, Kampf, Levelaufstieg, Shop, Pause, Sieg, Niederlage.
- Drei datenbasierte Helden und Boni, Touch-Joystick mit Multitouch-Fingerzuordnung.
- Arena 2400×1600, Kamera, Grenzen und Dekoration ohne Bewegungsblockaden.
- Drei Gegner mit Verfolgung, Separation, Treffern, Kontakt-Cooldown und einmaliger Belohnung.
- Fünf automatische Waffen, vier Slots, Waffenstufen 1–5, kritische Treffer und Projektilpool.
- XP-Kristalle mit Magnet, XP-Formel, sequenzielle Levelaufstiege, zehn gefilterte Upgrades.
- Neun 60-Sekunden-Wellen und Bosswelle mit 90-Sekunden-Limit; 100 Gegner als Obergrenze.
- Vier Shopangebote, Kaufen, Waffenverbesserung, Heilung, kostenloser/gebührenpflichtiger Reroll.
- THE OVERLORD mit Verfolgung, angekündigter Radialsalve und angekündigtem Sturmangriff.
- HUD-Balken und Zahlen, Statistik, Ergebnisdaten, sicherer Neustart.
- Lokale versionierte JSON-Speicherung mit Typprüfung, atomischem Schreiben und Korruptbackup.
- Prozedurale Cartoongrafiken und Animationen, Branding, elf Effekte und Musik, Lautstärkeregler.
- Effektstufen, Objektlimits, begrenzte Nachbarschaftsprüfung und wiederverwendete Projektile.
- Android-Exportpreset, tatsächlich signierte und verifizierte ARM64-APK.

## Tests und behobene Fehler

- 76 Integrationsprüfungen bestanden; siehe `tests/results/integration.log`.
- Belastungstest: 7200 Simulationsschritte, 120 simulierte Sekunden; Limits eingehalten.
- Godot-Import und Rendering mit Mesa/llvmpipe tatsächlich ausgeführt.
- Numerische JSON-Werte korrekt laden; beschädigte Daten abfangen.
- Tod während Gegneriteration sicher abbrechen; Boss startet ohne unangekündigten Sturm.
- Safe-Area-Eingabekoordinaten transformieren; Audiostreams beim Beenden stoppen.
- Android benötigt explizite mobile Compatibility-Einstellung und ETC2/ASTC-Import.
  Nach Korrektur konnte die APK exportiert werden.

## Offene Abnahme / Grenzen

- Installation und kompletter manueller Run auf einem physischen ARM64-Android-Gerät.
- Touchgefühl, Multitouch mit echter Hardware, Notches, runde Ecken und Systemleisten prüfen.
- 60-FPS-Ziel und thermisches Verhalten auf repräsentativen Geräten messen.
- Audio über echte Android-Lautsprecher/Kopfhörer und Lifecycle-Wechsel prüfen.
- Langfristiges Balancing und künstlerische Feinabnahme. Die Cartoonanimationen sind
  prozedural, keine handgezeichneten Animationsfilme.
- Mehrere Spiel- und UI-Systeme liegen noch im zentralen Run-Koordinator; weitere
  Modularisierung kann nach der Alpha erfolgen, ohne dass zum Starten Programmierung nötig ist.
- Bei sehr kurzem erzwungenem Headless-Abbruch kann eine Audio-ObjectDB-Shutdownwarnung auftreten; geordnete Tests sind ohne Warnung. Auf Android nachprüfen.
- Kein aktiver Run-Resume nach Prozessende (für 0.1 ausdrücklich nicht vorgesehen).

## Exportstatus

`builds/android/MayhemSurvivors-v0.1-debug.apk` wurde mit Godot 4.6.3 gebaut.
Debugsignatur sowie Paket, Architektur und Ausrichtung werden im BUILD_REPORT nachgewiesen.
Die endgültige Quellenübergabe enthält keine SDK-Downloads oder Editorcaches.

## Nächster Arbeitsschritt

APK auf physischem Android-Gerät installieren; komplette Abnahme über zehn Wellen mit
allen drei Helden, Displayvarianten, Unterbrechungen und Leistungsaufzeichnung durchführen.
Erst danach die Android-Abnahme als vollständig markieren.
