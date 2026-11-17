# 0.18 — MAYHEM GARAGE — implementiert, geprüft und gebaut

Aktuelle Phase: Auslieferung und Android-Abnahme. Branch feature/mayhem-garage-v0.18.
Nur Bruiser frei, fünf weitere Helden über Crew-Cases. Drei Casearten mit je einem
kostenlosen Startticket, angezeigten echten Chancen, Duplikat-Bauteilen und garantierter
fehlender Crew nach zwei Duplikaten. Atomare Speicherung vor Reveal, ausstehender
Fund nach Neustart, vollständiger Rollback bei Speicherfehlern. Stats, Studio-Coins,
Meisterschaften und Dekoration erhalten; pre_garage-Backup bei Altprofilmigration.

Garage mit32 Inventareinträgen, sichtbarer Kopf-/Körper-/Schuh-Ausrüstung, Waffenstilen,
Modulen, drei zusätzlichen echten Zaubern und Werkstatträngen1–5. Klassenbindung,
individuelle Loadouts und unveränderliche Run-Snapshots. Eigene gemalte Case-/Gear-
Atlanten, Symbole, sieben neue Audiocues und Multitouch-Zauberbutton. Studio-Coins
als einmalige Run-Belohnung; Tutorial verwendet einen Leihhelden ohne Gratisfreigabe.

Abnahme:25 Suites /1.898 Assertions /0 Fehler und beide historischen Traces bestanden.
Quell-ZIP frisch ohne Cache importiert und gesamte Suite erneut bestanden, Laufzeit-
quellen bytegleich.86.400 feste Lastschritte /1.440 simulierte Sekunden /72 Szenarien,
max100 Gegner, keine ungültigen Positionen/HP.15 native GL-Ansichten geprüft und
Grafikanker verbessert. Keine GDScript-Parser-/Ressourcenfehler in finalen Prüfläufen.
Alle Logs unter tests/results/v0.18-*.log, aktuelle Galerie tests/garage_*.png.

Debug-APK0.18.0/Code22 erstellt: ARM64, Landscape, GL Compatibility, gleicher Paketname
und Signierschlüssel. Signatur v2/v3,16KB-Alignment, Manifest und neuer Payload geprüft.
SHA256:0be1b611d0e0c573d5c12a1b28054a7239c2f717077a994762388490f975c0f4.
Quell-ZIP enthält alle Laufzeitdateien/Tests/Berichte, keine privaten Schlüssel oder
Importcaches. GitHub-Downloads werden nach Push separat vollständig gehasht.

Offene fachliche Abnahme: physische Android-Updateinstallation, echtes Multitouch,
Gear-/Case-/Zauberbalance, Geräte-FPS und Thermik. Kein Gerätetest behauptet.
Keine offenen Implementierungsstubs im freigegebenen Garage-Umfang. Weltkarte und
lineare Arenenfreigabe bleiben der nächste separate Entwicklungsschritt.
Nächste Aktion: als Update installieren; Hauptmenü → CASES & GARAGE, Starttickets
öffnen, Ausrüstung anlegen, Run starten und nach Neustart Besitz/Studio-Coins prüfen.

---

## Historischer Stand vor0.18

# 0.17.0 — STEELFIST — implementiert und geprüft

Branch feature/steelfist-v0.17, Basis0.16. Timo als sechster sofort wählbarer Held mit
eigener Illustration, armloser Spielbasis, Handschuh und zwei Werkzeugen. 160 Basis-HP
plus30%=208 Start-HP; 25 Basisschaden plus25% Nahkampf; 0,8 Angriffe/s. Regeneration,
10% Schadensreduktion, vierter Doppelschlag und Rohrbruch-Chaos mit2s Stun auch für
Bosse und begrenztem Tempobonus. Zwei echte Level5-Entwicklungen. Auswahl/Wischkarussell,
HUD, Werkstatt, Statistik, Meisterschaften und Speicherung integriert. Drei eigene
Sounds. Bestehende Charakterwerte und0.16-Inhalte/Profile erhalten.

23 Suites /1.747 Assertions und beide historischen Traces grün. Quell-ZIP frisch ohne
Importcache importiert und vollständige Suite erneut bestanden. 72 Hero-Checks.
Native GUI-Prüfung: acht fehlerfreie Vorgabeszenen, Werkzeug-HUD korrigiert. Historische
Fixtures explizit auf Originalwaffen beschränkt, neue Pfade separat geprüft. Lastprobe
43.200 Schritte /vier Arenen ×drei Stufen ×zwei Entwicklungen /Endlos31, max100 Gegner,
keine NaNs, Buff-/Effektcaps eingehalten. APK exportiert/signiert, Alignment/Manifest/
ARM64/Payload geprüft. Alle Laufzeitquellen/Assets/Szenen/Tests/Berichte enthalten.
Keine offenen Implementierungsstubs. GitHub-Auslieferung mit Download-/Hashprüfung.

Nächste fachliche Abnahme: Android-Update mit vorhandenem Profil, Steelfist auswählen,
Regeneration/Doppelschlag/Ultimate gegen Wellen und Boss testen. Menschliches Balancing
(208HP/165Tempo), echte Touchbedienung und Geräte-FPS/Thermik offen. Keine physische
Installation behauptet. Aktive Run-Wiederherstellung bleibt außerhalb dieses Umfangs.

---

## Historischer Stand vor 0.17

# 0.16.0 — Wischwahl / Gegner / Aufgaben — implementiert und geprüft

Branch feature/live-rewards-v0.16. Einzelkarten für fünf Helden und vier Arenen mit
Touch-Wischgesten, Drag-/Multitouch-Schutz und Pfeilalternative. Drei neue Gegner mit
eigener Atlasgrafik, angekündigten Angriffen und Unterbrechungen. Vier Arenenereignisse.
Drei tägliche/drei wöchentliche Aufgaben, kostenloser erneuerbarer 7-Stufen-Pass,
separate dauerhafte Studio-Coins und sechs tatsächliche kosmetische Shopartikel.
Versionierte lokale Speicherung, kompatibel zu bisherigen Profilen. Kein bezahlter Pass.

22 Suites / 1.644 Assertions und beide historischen Traces grün. Quell-ZIP ohne Cache
frisch importiert und vollständige Suite erneut bestanden. 80 neue Live-Checks inklusive
echter GUI-Drag-Sequenz. Lastprobe21.600 Schritte / alle Stufen × vier Arenen, max39
Gegner/3 Arenagefahren in dieser Probe, Pack-Caps eingehalten, keine NaNs. Sechs native
Menü-/Kampfansichten geprüft. APK exportiert/signiert, Alignment/Manifest/ARM64/Payload
geprüft. Alle Laufzeitassets/Quellen/Tests/Berichte im Quellarchiv. Keine offenen Stubs
im freigegebenen Umfang. GitHub-Auslieferung mit nachgelagerter Download-/Hashprüfung.

Nächster fachlicher Schritt: Installation als Android-Update, echte Wischer, neue
Gegner-/Eventbalance, Aufgaben nach Run-Ende abholen, Einkäufe nach Neustart prüfen.
Physische Geräte-FPS/Thermik und Kalenderwechsel offen. Kalender vollständig offline
anhand Geräte-UTC. Aktive Run-Wiederherstellung bleibt außerhalb dieses Umfangs.

---

## Historischer Stand vor 0.16

# 0.15.0 — Schwierigkeitsgrade / implementiert und geprüft

Branch feature/difficulties-v0.15. Normal/Veteran/Mayhem für Kampagne und Endlos in
allen vier Arenen, Auswahlkarten mit exakten Faktoren, Stufe im Run festgeschrieben.
Normal behält 0.14-Werte. Warnzeiten und Gegnergrenze unverändert. Tutorial bleibt Normal.
Eigene Symbole, getrennte Rekorde je Stufe/Modus/Arena, alte Daten korrekt zu Normal
migriert, Stufe in HUD/Ergebnis/Verlauf. Keine offenen Stubs im freigegebenen Umfang.

21 Suites / 1.565 Assertions und beide historischen Traces grün. Quell-ZIP ohne Cache
frisch importiert und komplette Suite erneut bestanden. Neue Stufen: 52 spezifische Checks.
Lastprobe: 21.600 Schritte / alle Stufen × vier Arenen / Endlos31, maximal100 Gegner,
keine NaNs. Native Galerie aus drei Szenen geprüft. APK gebaut/signiert, Alignment,
Manifest, ARM64 und Payload geprüft. Veröffentlichung mit anschließender Hashprüfung.

Nächste fachliche Abnahme: Android-Update, Bedienung, Normal-Vergleich und menschliche
Veteran-/Mayhem-Balance einschließlich Bonusbeute. Keine Geräte-FPS/Thermik behauptet.


---

## Historischer Stand vor 0.15

# 0.14.0 — Worlds / Endlos / Kicksy — implementiert und geprüft

Branch feature/worlds-endless-v0.14. Vier Arenen inklusive Neonhafen/Glutwerk mit
eigenen Böden und Bossgrafiken/Gefahren. Endlos-Bosse/Shop über Welle10 hinaus,
separate dauerhafte Rekorde, steigende Gegnerwerte und vorausschauende KI mit Caps.
13-Schritt-Aktionstutorial mit Kicksy nach angehängter Referenz; freischaltbare fünfte
Heldin (Tutorial + 500 Kampagnen-/Endlos-Kills), Bombenpool, Kettenreaktion und zwei
Entwicklungen. Fünf Helden vollständig in Auswahl/Statistik/Meisterschaft/Speichern.
UI-Verläufe, Pop-/Menüanimationen, Sensor-Parallaxe, Kalibrierung und ruhige Menüs.

20 Suites / 1.513 Assertions und beide historischen Traces bestanden. Traces frieren
alte Schwierigkeit ein; aktuelle Regeln separat geprüft. Quellarchiv frisch entpackt
und ohne vorhandenen Importcache importiert, abschließende vollständige Suite grün.
Test-Audiofreigabe vor Quit in Twinkle-Produktionstouch-Fixture stabilisiert; keine
Ressourcenfehler im abschließenden Durchlauf. Native Galerie aus neun Szenen geprüft.
Lastprobe: 36.000 Schritte / vier Arenen × fünf Helden / Endlos31, maximal 100 Gegner,
Bomben-/Folgeereignis-/Brandfeldcaps eingehalten. Keine NaNs oder offenen Pflichtstubs.
APK exportiert/signiert, ARM64/Manifest/Payload/Alignment geprüft. Veröffentlichung mit
anschließender anonymer Download-/Hashprüfung. Alle Quelldateien und Berichte vorhanden.

Nächste fachliche Abnahme: Android-Update mit echten Daten, komplettes Touch-Tutorial,
Sensor-Richtung/Komfort, neue Arenen, Kampagnen-/Endlos-Balance und FPS/Thermik auf Gerät.
Aktive Run-Wiederherstellung bleibt wie bisher außerhalb dieses Umfangs.


---

## Historischer Stand vor 0.14

# 0.13.0 — RAVOX / Implementierung abgeschlossen

Branch feature/ravox-v0.13. Gegner vollständig integriert: eigene Grafik, Verhalten,
Zermalmer-Sturm, Warnbahn, Sounds, HP/Name, Treffer/Tod/Beute und Vorbereitungshinweis.
Wellen 5–9 beider Arenen; maximal zwei aktiv / vier pro Welle, bestehendes Spawnbudget.
Seife, Schockwelle, Tornado, Slow, Unverwundbarkeit, Pause und Neustart geprüft.

1.216 Assertions / 18 Suites und beide historischen Traces grün. Anschließend ZIP
frisch ohne Importcache entpackt/importiert und dieselben Prüfungen erneut bestanden.
Lastprobe: 28.800 Schritte, vier Helden × beide Arenen, maximal 100 Gegner / zwei Ravox
und ein Ravox-Windup/Sturm zur Zeit. Native Galerie visuell geprüft. APK exportiert,
signiert, Alignment/ARM64/Manifest/Payload geprüft. GitHub-Downloadprüfung bei Veröffentlichung.
Keine offenen Implementierungsstubs im freigegebenen Ravox-Umfang.
Nächste fachliche Abnahme: Android-Update und menschlicher Test von Welle 5–9,
Warnbahn/Ausweichen/Unterbrechen, zusammen mit Twinkle-Balancing. Keine Geräte-FPS behauptet.


---

## Historischer Stand vor 0.13

# 0.12.0 — TWINKLE / aktuelle Umsetzung

Branch feature/twinkle-v0.12. Vierte Heldin tatsächlich implementiert: eigene Grafik,
zweihändiges Rig ohne zusätzliche Körperarme, Mopp und sichtbare Sprühflasche,
Halbkreis, Giftfelder, Seifenbetäubung, Heilpassiv, fünfsekündiger Tornado/45 s,
zwei Waffenentwicklungen, Menüseite, Statistik, Historie, Meisterschaft, Speicherung.

1.164 Assertions / 17 Suites und beide historischen Traces bestanden.
Lastprobe: 46.482 Schritte, maximal 52 Gegner / 5 Felder / 1 Sweep;
3/6 Siege (Schrottplatz), Reaktorpilot jeweils Zeitlimit. Kein Android-FPS-Test.
Native Galerie nach letztem Code visuell geprüft. APK exportiert, signiert und geprüft.
Quellarchiv frisch entpackt/importiert: alle 1.164 Assertions und beide Traces erneut grün.
Veröffentlichung auf GitHub mit anschließender Download-/Hashprüfung.
Nächste fachliche Abnahme: Android-Update, Touch, Twinkle-Reichweite/Kontrolle und
menschliches Boss-Balancing, insbesondere Reaktor. Kein offenes Implementierungsstub.

---

## Historischer Stand vor 0.12

# 0.11.0 — Charakter-Meisterschaften

Aktueller Branch: feature/character-mastery-v0.11.
Implementiert: Ziele je Held, rückwirkende Rekordanrechnung, Farbvarianten/Abzeichen,
Titel, Vorschau, gesperrte Auswahl, Auswahl je Held, Menü-/Kampfdarstellung,
Ergebnisankündigung, kompatible lokale Speicherung. Keine offenen Pflichtfunktionen
innerhalb dieses Umfangs. Schwierigkeitsgrade/Arena-Ereignisse bewusst später.

Import und 16 Test-Suites bestanden: 1.075 Assertions, beide historischen Traces.
Native Engine-Galerie geprüft: gesperrte Vorschau, vollständige Meisterschaft, Kampf.
Android-APK erfolgreich exportiert, Signatur/Alignment/ARM64/Manifest geprüft.
Quell-ZIP frisch entpackt und importiert; erneut alle 1.075 Assertions und beide
Traces bestanden. GitHub-Downloadprüfung erfolgt bei Veröffentlichung.
Nächste fachliche Abnahme: Android-Update/Neustart mit echten bestehenden Rekorden,
Touch auf verschiedenen Seitenverhältnissen und Outfits im laufenden Kampf.
Keine physische Android-Installation oder neue FPS-Messung in dieser Umgebung.

---

## Historischer Stand vor 0.11

# Version 0.10.0 — 2026-11-16

## Aktueller Stand

Nutzer bestätigt 0.9 mit „Yes alles top“; danach Elitegegner, Bossphasen und besondere
Belohnungen ausdrücklich freigegeben („Let's go“). Branch feature/elite-encounters-v0.10.
Gameplay, Grafik, Audio, Beute-/Shopfluss und Persistenz integriert. Import, 1.030
Assertions, beide historischen Traces und Lastprobe bestanden. APK exportiert/signiert;
Quell-ZIP frisch entpackt, neu importiert und alle 1.030 Prüfungen sowie beide Traces
erneut bestanden. GitHub-Downloads werden bei der Veröffentlichung verifiziert.

## Implementiert

Maximal eine Elite ab Sekunde 18 in Welle 4/6/8/9 durch Aufwertung eines normalen Spawns.
Schrottbrecher mit geradem, fixiert angekündigtem Sturm; Impulswächter mit offenem Ring.
Eigene Spritegrafiken/Animation, Krone und HP, Ereignisfeld, drei neue Sounds.
Schockwelle unterbricht auch bei blockiertem Knockback; Schutz/Schaden über bestehende APIs.
Tankbelohnung +12 Coins/+12 XP, danach einmalige Wahl aus +5 % Basisschaden, +10 HP
oder Wellen-Coins im Shop. Nonce pro Run/Welle, kein Überspringen/Mehrfachclaim,
Waffenentwicklung bleibt verbindlich. Elite-Kills in Ergebnis/Historie, altes JSON lädt.
Bossphasen bei 65/30 % mit Trümmerfeldern/Kreuzlinien und offenen Impulsringen; alte
Feindangriffe beim Wechsel bereinigt, Warnzeit/Erholung, Grundangriffe zwischen Specials.
Boss-HP und Zeit unverändert, normale Wellen-/Charakter-/Waffendaten unverändert.

## Prüfung / nächste Schritte

104 neue Encounter-Assertions; zusammen 1.030 grün. Neue Angriffsgeometrie, komplette
Warnzeit auch bei langem Frame, Kamerasicht, Pause/Level-up, echte Schockwelle/Dash,
Tod während Iteration, Belohnungseinmaligkeit, Weitergabe an Entwicklung/Shop,
Neustart und Phasenwechsel geprüft. 43.200 Schritte / 720 simulierte Sekunden unter
Last, beide Arenen × drei Helden und alle Grafikstufen. Caps eingehalten.
Native Engine-Galerie aus sechs Vorgabeszenen geprüft, keine physischen Android-Runs.
Historischer Effekttrace deaktiviert ausdrücklich neue 0.10-Begegnungen in seinem
Legacy-Fixture; neue Mechanics haben eigene Tests. Keine behauptete Balanceidentität.

Nächste Abnahme: auf Android beide Eliten in Welle 4/6/8/9 und beide Bosskämpfe mit
verschiedenen Helden spielen. Fairness, Fluchtöffnungen und Bonuswert anhand realer
Runs nachjustieren; Geräte-FPS/Temperatur noch messen. Keine bekannten Parserfehler.


---

## Historischer Stand vor 0.10

# Version 0.9.0 — 2026-11-16

## Aktuelle Phase

Menü-/Branding-/Icon-Rework implementiert und nativ gerendert. 926 Assertions und
beide dokumentierten Referenztraces bestanden. Android-Export, Signatur und finaler ZIP-Neuimport geprüft.
GitHub-Downloadkontrolle folgt. Branch `feature/neon-interface-v0.9`.

## Auftrag / umgesetzt

Nutzer wünscht sämtliche Logos/Icons fertig, alle Menüs hochwertig und leichte
Animationen/Blur-Übergänge anhand der Neon-Comic-Vorlage. Neues vollflächiges Motiv,
kompakte Wortmarke, App-Icon, Studiomarke, 49 semantische UI-Icons, alle Item-/Ability-/
Entwicklungsicons und Joystickgrafik integriert. Jede bestehende Menüfunktion bleibt
verbunden. Gemeinsame Skins, Lesbarkeitsscrims und Auswahl-/Informationskarten.
Leicht gestaffelte Einblend-/Positionsanimationen, Buttonfeedback, Hintergrundschwenk,
Lichtpartikel, kurzzeitiger 5-Sample-Weichzeichner ausschließlich auf der Bildebene.
Schnelle Navigation generationsgesichert; LOW statisch ohne neue Shader/Animation.
Statistik-Headerüberlagerung und volle Ergebnisliste korrigiert. Alte Icon-/Splash-
Assets ohne verbleibende Laufzeitverweise entfernt. Keine Kampf-/Economy-Daten geändert.

## Tests / Restabnahme

926 Assertions: 825 Bestand + 101 neue UI-Prüfungen. 49 Icons geladen, Upgrade-Icons,
semantische Aktionen, drei Qualitätsstufen, echte Produktionsanimation, schnelle
Navigation, Shop/Level-up-Pause und vollständiger Ergebnisumbruch geprüft.
Native Galerie und kurzer Menü-GIF-Mitschnitt erstellt, Glyphen und volle Ergebnisse
kontrolliert. Weichzeichner auf separater TextureRect-Ebene; UI-Rendering bleibt separat.
Breite Darstellung und Tablet geprüft; dunkle einzelne Motivpixel sind keine Letterbox.
Keine bekannten Parser-/Ressourcenfehler in finalen Suiten. Keine Geräte-FPS behauptet.

Nächster Schritt: finale APK/Signatur/Downloads verifizieren;
danach Android-Praxisabnahme für neue Übergänge, Lesbarkeit, Launcher-Maske und
Temperatur/FPS. Die vom Nutzer bestätigte Spielbalance bleibt unangetastet.

---

## Historischer Stand vor 0.9

# Version 0.8.0 — 2026-11-16

## Aktuelle Phase

Design und Audio implementiert; Import/825 Assertions/Referenztraces erfolgreich.
Android-APK exportiert, Signatur/Alignment/Paket/Berechtigungen geprüft.
Branch `feature/presentation-audio-v0.8`; Quell-ZIP frisch importiert und vollständig erneut getestet.

## Bestätigter Nutzerstand und neue Umsetzung

Nutzer bestätigt Vollbild, anspruchsvollere Wellen beider Arenen und Shop aus 0.7 mit
„Ja – Ja – Ja“. Neues Ziel: alles aufhübschen, Logos und richtige Sounds einarbeiten.
Feuer-/Metall-Wortmarke und MS-Icon nach beiden Bildreferenzen erstellt und tatsächlich
integriert. Crew-Menü, Studiomarke, Schriftpaar, Stahlrahmen, Warnstreifen, Glut,
HUD-Kontrast, größere Regler. Alle Untermenüs erben den Stil. 31 neu produzierte
Effekte, zwei eigene Musiken, AudioDirector mit festen Stimmenbudgets und reservierten
Warn-/UI-Stimmen. Spielwerte, Setregeln und Preise nicht geändert.

## Prüfung / bekannte Grenzen

825 Assertions bestanden; Kampftraces unverändert unter ihren dokumentierten Fixtures.
Aktuelle Menüs, Karten, Einstellungen, Kampf und Resultate nativ gerendert; breite
Seitenkanten geprüft. 31 WAVs auf Stille/digitales Clipping geprüft, Musik decodiert.
Keine bekannten Parser-/Ressourcenfehler im finalen Import oder finalen Suiten.
Headless-Testende wartet kurz echte Mixerzeit, da --fixed-fps Simulation schneller
als Audio-Echtzeit laufen lässt. Keine neue Audioverzögerung im Spiel eingeführt.
Keine physische Android-Abnahme der neuen Version, keine Geräte-FPS/Temperaturwerte.

## Nächster Schritt

Auf dem Nutzergerät neue Menüs/Logo/Icon und Touch-Lesbarkeit abnehmen; Musik vs.
Waffen/Bosswarnungen über Handylautsprecher/Kopfhörer prüfen. Falls nötig Lautstärken
gezielt nachjustieren. Bestätigte 0.7-Balance beibehalten. Aktive Runs bleiben nicht
wiederherstellbar; lokale Statistik/Einstellungen bleiben bei Update erhalten.

---

## Historischer Stand vor 0.8

# Version 0.7.0 — 2026-11-16

## Aktuelle Phase

Implementierung verbunden, Regressionstests bestanden. Android-Export, Signatur/Architektur/
Berechtigungen/Startargumente und ZIP-Neuimport erfolgreich geprüft. Arbeitsbranch `feature/shop-fullscreen-v0.7`.
Interne 0.6.1 wurde um den neuen Nutzerwunsch erweitert und nicht veröffentlicht.

## Nutzerfeedback und Umsetzung

Nutzer spielt flüssig, Wellen ab vier zu leicht; Screenshot Reaktor-Sieg 09:08,
520 Kills, Level 21, 56.363 Schaden, 1.780 verdiente Coins. Keine Geräte-FPS-Messung.
Explizite Auswahl „Beide Arenen“ umgesetzt. Schwarze Seitenränder per expand/immersiv/
Edge-to-edge behoben; Safe-Area-Layout berücksichtigt Aussparungen/Systemleisten.
Neu gewünschte Shopreferenzen als eigene RF-Worlds-Oberfläche umgesetzt: acht Items,
drei Sets, Werte, Inventar, Waffenwerkstatt/Verwerten, kurze Hilfe. Keine Ads/VIP.

## Implementiert und geprüft

798 Assertions: 657 Bestand + 100 Display/Balance + 41 Shop. Keine gemeldeten Fehler
in finalen Suiten. 21.600 Lastschritte mit allen Helden/beiden Arenen und acht Items;
alle Caps eingehalten. 20 isolierte Boss-Build-Proben unter 90 Sekunden; keine
vollständigen Android-Runs. Historischer Vergleich nutzt eingefrorene alte Wellendaten
nur im Test, behauptet keine unveränderte neue Spätspielbalance.
Shopkarten/Inventar/Sets/Werte/Werkstatt/Hilfe bei 1280×591 nativ gerendert;
Vollbild an 16:9, breitem Display und Tablet geprüft. Kein physisches Android-Gerät.

## Offen / nächster Schritt

Auf dem Nutzergerät Vollbild inkl. Systemleisten/Notch und Erreichbarkeit aller
Touchbuttons prüfen. Beide Arenen mit allen Helden ab Welle vier sowie neue Item-Builds
spielen; Fairness/Ökonomie anhand echter Runs nachjustieren. FPS/Temperatur messen.
Keine bekannten offenen Pflichtfunktionen des implementierten Alpha-Spielablaufs.
Android-Hardwareabnahme ist ausdrücklich noch offen.

Quell-ZIP in leeres Verzeichnis entpackt: Import ohne Parser-/Ressourcenfehler,
41 Shop- und 100 Display-/Balance-Prüfungen daraus erneut bestanden.
GitHub-Übergabe wird mit direkten Downloadlinks und SHA256SUMS-v0.7.txt bereitgestellt.

---

## Historischer Stand (vor 0.7)

# Version 0.6.0 — 2026-11-16

## Aktuelle Phase

Neue Gegner vollständig implementiert und getestet. APK signiert, ARM64/Paket/Version/
Berechtigungen/16-KiB-Alignment geprüft. Quell-ZIP frisch importiert, 66 neue Prüfungen
daraus erneut bestanden. GitHub-Übergabe vorbereitet. Kein Android-Gerät hier.
Nutzerfeedback zur vorigen Übergabe: „Sehr geil. Weiter geht's“. Kein Nachweis einer
bestimmten Run-Anzahl, Geräte-FPS oder abgeschlossener Runs aller Helden daraus abgeleitet.

## Implementiert

Reaktorspucker ab Welle zwei: sichtbare fixierte Ziellinie, 0,9 s Warnzeit,
langsamer Einzelschuss, Abstands-KI. Schilddrohne ab Welle vier: 30 % Reduktion für
normale Gegner im Radius 180, kein Stapeln/Bossschutz, sofortiges Ende nach Drohnentod.
Maximal sechs Spucker, zwei Drohnen und zwei Schusswarnungen. Eigene Grafiken, Effekte,
Sounds, Schussdarstellung und Hinweise vor der Welle. Alle üblichen Zustände verbunden.
Nur die Reaktor-Zusammensetzung geändert, Spawnintervalle/Wellendauern/Gesamtlimit gleich.
Schrottplatz bekommt keine neuen Gegner; Charaktere, Waffen, Fähigkeiten und alte
Gegnerdaten bleiben erhalten. Speicherung weiterhin Format 3, keine Run-Wiederherstellung.

## Tatsächlich geprüft

657 Assertions bestanden (591 bestehende + 66 Gegnerrollen-Prüfungen).
Alter Schrottplatzvergleich 33 Punkte / 3.600 Schritte bestanden; 87 klassische Punkte /
8.700 Schritte aus 0.5 mit allen Waffenwegen/Fähigkeiten/Boss in HIGH und LOW identisch.
Der historische Reaktorvergleich wird ausdrücklich nicht als unverändert behauptet,
weil neue Rollen dort Spielverlauf und RNG-Verbrauch durch Kämpfe ändern.
Belastung: 10.800 Schritte / 180 simulierte Sekunden mit allen drei Helden, bis 100 Gegner,
maximal 6 Spucker, 2 Drohnen und begrenzte Warnungen/Projektile. Zusätzlich alle zehn
Waffenwege im 18.000-Schritte-Effekttest bestanden. Keine Android-FPS-Messung.
Fünf Godot/Mesa-Bilder mit Vorgabefiguren geprüft. Kein Parser-/Ressourcenfehler bekannt.

## Nächster Schritt

Echte Android-Runs für Fairness der Reaktorgegner, Sichtbarkeit von Warnungen,
Konter mit allen Helden, Balance der Schutzaura sowie Geräte-FPS/Temperatur.
Version 0.6 ist noch nicht auf physischer Android-Hardware abgenommen.

---

# Historischer Stand 0.5.1

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
