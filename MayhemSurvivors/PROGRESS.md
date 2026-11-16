# Grafik-/Feedback-/Komfortstand 0.2.3 — 2026-11-16

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

Auf dem Nutzergerät Update und alte Gesamtstatistik prüfen. Neue Charakterwerte starten ab
0.2.3. Gegnerlesbarkeit bei voller Arena, Warnungen, Audio und zehn Wellen je Klasse praktisch
abnehmen. Geräte-FPS und thermische Stabilität noch messen. Gegnerbewegung ist derzeit eine
prozedurale Spriteanimation; Mehrbild-Animationssätze sind ein späterer Grafikschritt.
Keine Android-Abnahme oder unverifizierte Leistungsangabe behauptet.

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
