# 0.24.0 Alpha — Glutwerk (2026-11-18)

- Zwei freiwillige Dampfventile mit Druckfenster, klarer Richtung und einmaligem Gebrauch je Welle.
- Druckabhängiger Flächenschaden, Rückstoß für normale Gegner und begrenzte Manöver-Boni.
- Eigene kreuzende Dampfbahnen für den Ofenkönig; voller Vorlauf und bestehende Boss-Schadensgrenze.
- Datengestützte Kicksy-Erklärungen, gespeicherte Hilfe, HUD und Weltkarteninfo für das Glutwerk.
- Eine eigene SVG-Ventilgrafik und vier Audiocues. Schwache Rückreferenz verhindert einen Manager-Zyklus.
- Bodenbahnen, Waffenwerte, Boss-HP, Case-Fix und vorhandene Profile erhalten.

---

# 0.23.0 Alpha — Reaktorzone & Neonhafen (2026-11-18)

- Energiekerne und freiwillige Überladung als eigene Reaktor-Mechanik ab Welle 3.
- Container-Doppelladungen mit festen Warnflächen, Gegner- und Spielerschaden im Neonhafen.
- Begrenzte Manöver-Boni plus reguläre Gegnerbeute; keine kritischen Umwelttreffer.
- Passende Zonenangriffe für Reaktorwächter und Dock-Tyrann mit gedeckeltem Umweltschaden.
- Kicksy-Einführung, erneut erreichbare Pause-Hilfe, HUD-Status, Weltkarteninfo und Beutedetails.
- Zwei eigene SVG-Illustrationen und fünf Soundeffekte; sämtliche Qualitätsstufen gleich balanciert.
- Boss-HP, Waffenwerte, Case-Fix und vorhandene Profile erhalten. Keine Online-Systeme.

---

# 0.22.0 Alpha — Schrottplatz & Bruiser (2026-11-18)

- Erster Einstieg mit Kicksy: Training mit dem freien Bruiser statt gesperrtem Leihhelden.
- Echte Hammer-, Schockwellen-, Shop- und Pausenlektionen; passende Tasten markiert.
- Freiwillige Schrottplatz-Bergung ab Welle 3 mit voller Vorwarnung und einmaliger Run-Beute.
- Hammer-Pfade zeigen beide Entwicklungen und eine Vorschau mit aktuellen Spielerwerten.
- Ergebnisdetails erklären Studio-Coins, Run-Coins und einmalige Weltbelohnungen.
- Boss-/Spieleranzeigen getrennt, Warntext gold; dekorative Labels blockieren keine Eingaben.
- Neue Seiten wechseln nach dem Touch-Ereignis; veraltete Doppeltipps werden verworfen.
- Drei eigene Audiocues. Bossbalance 0.21.2, Case-Hotfix und bestehende Profile erhalten.

---

# 0.21.2 Alpha — Bossbalance (2026-11-18)

- Robustere Bossleiter:600/1800/3200/5500/12500 Basis-HP mit bisherigen Weltfaktoren.
- Unterschiedliche Eröffnungen, frühere Attacken, kürzere Erholung und mehr Beweglichkeit.
- Phasenschaden bricht laufende Angriffswarnungen nicht mehr ab; keine Unverwundbarkeit.
- Orbit/Tesla mit sichtbarem Bossbonus für faire Klassenchancen. Normale Wellen und Sprengkern unverändert.
- Boss-HP und tatsächliche Waffen-/Bosswerte in Menüs korrigiert. Case-Hotfix erhalten.
- 30 Suiten /4590 Checks,91 Durchsatzszenarien,110 Soak-Szenarien und15 native Ansichten geprüft.

---

# 0.21.1 Alpha — Case-Navigation (2026-11-18)

- „ZUM INVENTAR“ liest nach Bestätigung einen unabhängigen Öffnungsbeleg und hängt nicht mehr fest.
- „WEITERE CASES“, Inventar-Zurück und Hauptmenü bleiben nach der Fundanzeige erreichbar.
- Garage-Navigation läuft nach dem Touch-Ereignis; verspätete Doppeltipps alter Seiten werden verworfen.
- Bereits gespeicherte Funde, Eigentum und Währungen erhalten; keine Änderung der Case-Ökonomie.
- 74 GUI-Prüfungen, nativer Touch-Lauf, 29 Regressionstestsuiten und Android-Debug-Build geprüft.

---

# 0.21.0 Alpha — MAYHEM UNITED (2026-11-18)

- Zehn Arenen mit schrittweiser Freigabe und eigenen Abschlussbossen; fünf Bosswellen pro Run.
- Fünf neue Helden samt Klassenwaffen, aktiven Fähigkeiten und zehn echten Entwicklungen.
- Zehn zusätzliche Gegner mit Schutz, Heilung, Teleport, Sturm, Frost, Beschwörung und Fernangriffen.
- Gemeinsamer Comic-Stil für alle Helden/Gegner/Bosse/Waffen/Böden; identische Rig-Anker in Menü/Kampf.
- Handbuch/Bestiarium/Technik, größere paginierte Kataloge, Tutorial, Icons, Sounds und Effekte abgestimmt.
- Kompatible lokale Profile und Cases; Flammen-Deko bleibt getrennt von der neuen Flamer-Waffe.
- Projectile-Pool setzt Waffenmetadaten vollständig zurück; neuer Run startet ohne alten Trefferschutz.
- Android 0.21.0 / versionCode25 / ARM64; Tests, Belastung und native Grafikprüfung dokumentiert.

---

# 0.20.0 Alpha — 2026-11-17

- Weltkarte mit vier echten Arenenvorschauen und eigenen Metall-Emblemen, Touchkarten,
  Wischwahl, subtiler Vorschau-Bewegung, bestehenden Neigungs-/Ruhe-Einstellungen.
- Neue Profile: Schrottplatz zuerst; Kampagnensieg in10 öffnet Reaktorzone, danach
  Neonhafen und Glutwerk. Endlos nutzt freigeschaltete Arenen ohne Kampagnenfreigaben.
- Einmalige Erstbelohnungen mit40/60/80/100 Studio-Coins,20/35/50/70 Teilen und
  insgesamt fünf Case-Tickets. Atomarer Claim mit vollständigem Rollback/Retry.
- Eigene versionierte Fortschrittssektion und pre_world_map-Backup. Explizite alte
  Freigaben, bereits gespielte Arenen und echte Siege erhalten; alte Siege nachträglich
  genau einmal belohnbar. Unbespielte Arenen folgen der Freischaltkette.
- Ergebnis führt direkt zum verdienten Geschenk. Persönliche Kampagnen-/Endlosrekorde,
  goldene Abholpunkte, Währungshilfe, verständliche Run-/Studio-Coin-Bezeichnungen.
- Fehlgeschlagene Run-End-Speicherung kann auf der Weltkarte erneut versucht werden.
  Bestehende Meisterschaftsmeldungen bleiben neben neuer Weltmeldung sichtbar.
-27 Suiten /2.256 Prüfungen;112 neue Checks, beide alten Traces unverändert grün.

---

## Historischer Stand vor0.20

# 0.19.0 Alpha — 2026-11-17

- Breaker Axel als eigenständiger Boss in Welle5 aller Arenen, wiederkehrend im Endlosmodus.
- Eigene Grafik nach Fotovorlage, mutierter Presslufthammer und sechs originale Sounds.
- Drei Bossphasen: Ringstoß, drei/fünf Hammerschläge, gesperrte Sturmspur, Sturm-Ring-
  Kombinationen und verzögert gefährliche Risse. Rage bei40%, feste Warnzeit1,25s.
- Schaden/Resistenz, Rückstoß, kurze Bewegungssperre und Slow mit vorhandener Rüstung,
  Unverwundbarkeit, Frost und Steelfist-Stun verbunden. Hazardcaps unabhängig von Qualität.
- Boss-XP garantiert eingesammelt, mehrere Levelwahlen vor dem Shop; danach Welle6.
  Timeout verliert, finale Arenabosse und Victory in Welle10 erhalten.
- Neue Bossvorstellung und gemeinsamer HP-Balken mit Phasenmarkierungen; doppelte alte
  Balkendarstellung entfernt. Kurze Todesanimation verdeckt keine Upgrade-Karte.
- Historische Flowtests erwarten jetzt echten Sieg in Welle5. Ravox-/Hazardprüfungen
  auf normale Welle6 verlegt. Keine Testmodus-Sonderregel in der Produktionslogik.
-26 Testsuiten /2.144 Prüfungen plus beide unveränderten historischen Vergleichsläufe grün.

---

## Historischer Stand vor0.19

# 0.18.0 Alpha — 2026-11-17

- Mayhem Garage: echte Case-Öffnung, Sammlung, Ausrüstung und Werkstatt.
- Nur Bruiser frei; fünf andere Fighter samt Startwaffe über Crew-Cases.
- Drei erspielbare Cases, Starttickets, echte Einzelchancen und Neuzugangs-Garantie.
- Atomare Buchung/Rollback, Neustartbeleg, Duplikatteile und Fundjournal.
- 32 Einträge, individuelle Loadouts, Werkstattränge1–5 und feste Kampf-Snapshots.
- Gemalte Ausrüstung, sichtbare Kopf-/Körper-/Schuhteile, Waffenstile und Dekovorschau.
- Drei zusätzliche aktive Zauber mit getrenntem Multitouch-Button.
- Dauerhafte Studio-Coins nach echten Runs; Training ohne Farmbelohnung.
- Gesicherte Profilergänzung: Stats/Coins/Deko erhalten, Roster-Regel umgestellt.
- 25 Suites /1.898 Assertions, beide historische Traces und Lastprobe grün.

---

## Historischer Stand vor0.18

# 0.17.0 Alpha — 2026-11-17

- STEELFIST / Timo als sechster sofort spielbarer Tank mit eigener Illustration und Rig.
- Werkzeugduo mit zwei echten Werkzeugen, 25% Nahkampfbonus und jedem vierten Doppelschlag.
- 208 Start-HP aus160+30%, 10% Schadensreduktion, 2% Max-HP Regeneration je5s.
- Rohrbruch-Chaos: Fläche, Rückstoß,2s Stun und begrenzter Kill-Tempobonus; 35s Cooldown.
- Werkzeuglevel1–5, Druckbrecher/Ratschenrausch mit echter Werkstattintegration.
- Eigene Icons und drei Sounds; HUD, Statistik, Meisterschaften, Verlauf und Speicher ergänzt.
- Sechs Helden in den Reitern ohne Überlauf; vorherige Charakterwerte unverändert.
- 72 neue Hero-Checks, Gesamt1.747 Assertions /23 Suites, beide historischen Traces grün.

---

## Historischer Stand vor 0.17

# 0.16.0 Alpha — 2026-11-17

- Große Helden-/Arena-Karten mit horizontalen Wischgesten und Pfeilalternative.
- Drag-/Multitouch-Schutz: Wischen über Auswahlbuttons startet keinen Run.
- Bombling, Longshot und Hexling mit eigenem Atlas und angekündigten Spezialangriffen.
- Vier Arenenereignisse: Schrottregen, Reaktor-Überlast, Flutalarm, Schmelzsturm.
- Drei Tagesaufgaben, drei Wochenziele, kostenloser wiederholbarer 7-Stufen-Pass.
- Dauerhafte Studio-Coins und sechs echte kosmetische Shopartikel im Kampf.
- Lokaler Fortschritt, atomare Käufe/Claims, Korruptdatenprüfung, kompatible Profile.
- Arenafilter der Statistik erreicht jetzt alle vier Arenen.
- 80 neue Checks; Gesamt1.644 Assertions, 22 Suites und zwei historische Traces.

---

## Historischer Stand vor 0.16

# 0.15.0 Alpha — 2026-11-17

- Normal, Veteran und Mayhem mit eigener Auswahl für Kampagne/Endlos und alle Arenen.
- Transparente Gegner-/Boss-/Spawn-/Beutefaktoren, feste Warnzeiten und Gegnerlimits.
- Schwierigkeit im Run festgeschrieben; Tutorial verwendet immer Normal.
- Getrennte Stufenrekorde je Arena/Modus, echte Normal-Migration alter Profile.
- Stufe in HUD, Ergebnis und Verlauf; eigene Symbole und übersichtliche Karten.
- 52 neue Prüfungen, Gesamt 1.565 Assertions und beide bisherigen Traces grün.

---

## Historischer Stand vor 0.15

# 0.14.0 Alpha — 2026-11-16

- Neonhafen und Glutwerk mit eigenen Karten/Bossgrafiken und Gefahrenmustern.
- Endlosmodus mit Bossen alle zehn Wellen, Shop-Fortsetzung und eigener Rekordwertung.
- Stetige HP-/Tempo-/Schadensprogression und vorausschauende/flankierende Gegner-KI.
- Interaktives 13-Schritt-Tutorial mit Kicksy, echter Aktionsprüfung und Pop-Animation.
- Freischaltbare Kicksy: Tutorial + 500 Gegner; Bombenpool, Kettenreaktion, zwei Entwicklungen.
- Fünf Helden in Statistik, Historie, Auswahl, Meisterschaft und Speicherung.
- Sensor-Parallaxe, Verläufe, ruhige Menüoption und Kalibrierung; Touchziele bleiben fest.
- 20 Test-Suites / 1.513 Assertions grün, beide historischen Traces mit explizit eingefrorener
  alter Schwierigkeit. Neue Lastprobe: 36.000 Schritte, vier Arenen × fünf Helden.

---

## Historischer Stand vor 0.14

# 0.13.0 Alpha — 2026-11-16

- Ravox als seltener Gegner für beide Arenen, Wellen 5–9, Basis 140 HP / Tempo 220.
- Eigene Grafik, Zermalmer-Sturm mit +15 % Schaden, fester Warnbahn und Erholung.
- Maximal zwei aktive / vier pro Welle; ersetzt normale Spawns im bisherigen Budget.
- Seife/Schockwelle/Tornado unterbrechen; Slow und Unverwundbarkeit berücksichtigt.
- Eigene Warn-/Sturm-Sounds, Name/HP/Treffer/Tod/XP/Coins und Vorbereitungshinweis.
- 52 neue Ravox-Prüfungen, 1.216 Assertions insgesamt; beide Regressionstraces grün.

---

## Historischer Stand vor 0.13

# 0.12.0 Alpha — 2026-11-16

- TWINKLE als vierte, sofort spielbare Heldin mit eigenem Portrait und armlosen Rig.
- Wischmopp, Chemie-Sprühflasche, Halbkreis, Betäubung, Giftfelder und 20-Kill-Heilung.
- Fünf Sekunden Twinkle Tornado / 45 Sekunden Cooldown, ohne Boss-Kontrollschleife.
- Zwei vollständige Level-5-Entwicklungen und eigene UI-Symbole/Sounds/Effekte.
- Zweite Charakterseite; vier Helden in Meisterschaft, Statistik, Verlauf und Speicherung.
- 65 neue Twinkle-Checks, erweiterte Bestandsprüfungen; insgesamt 1.164 Assertions grün.
- Historischer Effekttrace explizit auf seine zehn ursprünglichen Entwicklungen begrenzt;
  neuer Mopp in eigenen Tests und erweiterten Boss-Spezialisierungsprüfungen erfasst.

---

## Historischer Stand vor 0.12

# 0.11.0 Alpha — 2026-11-16

- Drei Meisterschaftsziele pro Held aus bestehenden dauerhaften Charakterrekorden.
- Neon-/Gold-Farbvarianten, Jägerabzeichen und persönliche Meistertitel.
- Eigene responsive Meisterschaftsseite, Vorschau, Sperren, Auswahl und Ergebnisankündigung.
- Kompatible Speicherung je Held; keine Kampf-/Wellen-/Bosswerte verändert.
- 44 neue Assertions, Gesamtsuite 1.075 inklusive aktualisierter UI-Prüfung.

---

## Historischer Stand vor 0.11

# 0.10.0 Alpha — 2026-11-16

- Schrottbrecher und Impulswächter mit eigener Grafik, Krone, HP-Leiste und Angriffswarnung.
- Pro ausgewählter Welle maximal ein normaler Spawn aufgewertet; Gegnercap bleibt 100.
- Fixierter Sturm mit Swept-Trefferprüfung; offener Impulsring mit gemeinsamer Warn-/Treffergeometrie.
- Bruisers Schockwelle unterbricht Eliten auch an Wänden; Shade-Dash schützt wie bisher.
- Einmalige Elite-Beute nach Wellenende, drei echte Run-Optionen; doppelte/alte Auswahl gesperrt.
- Beute, Waffenentwicklung und Markt in korrekter Reihenfolge verbunden.
- Boss-Gesundheitsphasen bei 65/30 %, arenaeigene Zusatzmuster und offene Ringe in Phase III.
- Musterwechsel räumt alte Feindangriffe auf, behält eigene Schüsse; keine HP-/Zeit-Limit-Erhöhung.
- Elite-Killzahl in Ergebnis/Run-Historie, Speicherformat weiterhin rückwärtslesbar als Version 3.
- Drei eigene Sounds; LOW verändert keine Warn- oder Treffergeometrie.
- 104 neue Assertions, insgesamt 1.030; 43.200 Schritte Lastprobe und native Galerie.
- Android 0.10.0 / Code 14. Bewährte UI/Audio-/Touchbasis aus 0.9 erhalten.

---

## Historischer Stand vor 0.10

# 0.9.0 Alpha — 2026-11-16

- Menülandschaft, Wortmarke, MS-App-Icon und RF-Worlds-Marke an Neon-Referenz angepasst.
- 49 finale semantische UI-Icons statt Textzeichen, acht Item-, drei Fähigkeits-
  und zehn Entwicklungsillustrationen sowie neuer Joystick.
- Durchgängige violette Karten/Buttonzustände; informative Auswahl-, Upgrade-/Statistikflächen.
- Leicht gestaffelte Seitenübergänge, Button-Glanz, sanft bewegtes Motiv und Lichtpartikel.
- Kurzer Hintergrund-Weichzeichner in eigener Bildebene; Text bleibt davon unabhängig.
- LOW ohne neue Bewegung/Shader, schnelle Navigation verwirft veraltete Übergänge.
- Statistik-Kopf entzerrt, vollständige achtteilige Ergebnisliste innerhalb der Karte umbrochen.
- Alte unbenutzte Icon-/Splashassets entfernt, keine Laufzeitverweise darauf.
- 101 neue UI-Assertions, insgesamt 926; neue Galerie und animierter Engine-Mitschnitt.
- Bestehende Kampf-/Economy-Daten und Audiopaket erhalten; Android Code 13 / Name 0.9.0.

---

## Historischer Stand vor 0.9

# 0.8.0 Alpha — 2026-11-16

- Gelieferte Logoideen als transparente Wortmarke und installierbares MS-App-Icon adaptiert.
- Eigene RF-Worlds-Studiomarke mit SVG-Pfadschrift, Splash aktualisiert.
- Crew-Hauptmenü, durchgängige Stahlrahmen/Orange-Akzente/Warnstreifen/Glutpartikel.
- Barlow-Schriftpaar inkl. OFL-Lizenzen, Buttonzustände und neue HUD-Kontrastflächen.
- Größere Audio-Schieberegler mit Prozentwerten; kurze Menüeinblendung, LOW statisch.
- 31 Originaleffekte neu produziert, zwei eigene acht Takte lange Musikstücke.
- AudioDirector mit Cache, festen Stimmenlimits, reservierten UI-/Warnstimmen,
  Pickup-Begrenzung, Zustandsmusik, leiseren Pausen und wirksamer Null-Lautstärke.
- Bestehende Spielwerte/Ökonomie/Klassenbindung unverändert.
- 27 neue Präsentations-/Audioprüfungen; 825 Gesamtassertions bestanden.
- Android-Version 0.8.0 / Code 12, installierbares Update mit bestehender Signatur.

---

## Historischer Stand vor 0.8

# 0.7.0 Alpha — 2026-11-16

- Eigener Mayhem Market nach Nutzerreferenzen: Karten, Werte, Inventar-Tabs, Details und drei Hilfeseiten.
- Acht echte Run-Gegenstände mit Vor-/Nachteilen, eigene SVG-Symbole und drei 2-/3-Teile-Sets.
- Waffenwerkstatt: Werte, direkte kostenpflichtige Upgrades, Entwicklung ab Lv5,
  Verwerten mit Bestätigung und Schutz der letzten Waffe; keine Duplikatfusion.
- Set-Verlust sofort neu berechnet, keine wiederholte Bonusanrechnung; Gegenstände in Run-Historie.
- Versionskompatibles Speichern der Shop-Hilfe, keine Wiederherstellung laufender Runs.
- Vollbild per expand/Edge-to-edge, Hintergrund über ganzen Viewport, Safe-Area-HUD und Touchsteuerung.
- Schrottplatz UND Reaktorzone ab Welle 4 verstärkt; erste drei Wellen erhalten.
- Begrenzte Gruppen, angepasste Belohnungen, Endboss-HP 6.000/7.560.
- Zusätzliche Layout-/Balance- und Shopprüfungen, Lastproben und gerenderte UI-Abnahme.
- Android-Version 0.7.0 / Code 11. Interne Zwischenfassung 0.6.1 nicht veröffentlicht.

---

## Historischer Stand (vor 0.7)

# 0.6.0 Alpha — 2026-11-16

- Reaktorspucker ab Welle zwei mit angekündigtem, fixiertem Fernschuss und Abstands-KI.
- Schilddrohne ab Welle vier mit nicht stapelnder 30-%-Schutzaura für normale Verbündete.
- Kein Schutz für Bosse/Drohnen; Schutz endet sofort bei Entfernung oder Drohnentod.
- Eigene Grafik, Schwebe-/Treffer-/Todesdarstellung, Sounds und orange Gegnerprojektile.
- Sichtbarkeitsprüfung, 0,9 Sekunden Vorwarnzeit, höchstens zwei gleichzeitige Warnungen.
- Maximal sechs Spucker/zwei Drohnen; volle Rolle wird beim Spawn durch Grunt ersetzt.
- Spielerfähigkeiten, Rüstung, Pause, Shop, Level-up, Bossablauf und Speicherung verbunden.
- Reaktor-Zusammensetzung erweitert; Schrottplatz und Grundwerte alter Inhalte erhalten.
- 66 neue Assertions, Lasttests und aktualisierte, ausdrücklich klassische Referenzprüfung.

# 0.5.1 Alpha — 2026-11-16

- Cartoon-Splatter bei Treffern/Tod, farbige Tropfen und ausblendende Bodenspuren.
- Mündungsblitze, Geschossspuren, Einschlagfunken, Rauch und Münz-Popups.
- Hammerbögen/Bodenrisse, Blitzverästelungen, Explosionen und Schatten-Nachbilder.
- Kritische Treffer mit kurzen Sternblitzen; alte generische Todesringe entfernt.
- Mechanische Boss-Treffer mit Funken, Effekte beim tatsächlichen Bomben-/Laserstart.
- Zwei zusätzliche selbst synthetisierte Sounds, eigener SVG-Splatter.
- Gespeicherter Splatter-Schalter; sofortige Effektlimits bei Qualitätssenkung.
- Eigener visueller RNG und wiederverwendeter Partikelpool; keine Kampfwertänderung.
- 40 neue Effektprüfungen und Gameplayvergleich mit 0.5 für alle Waffenwege/Arenen/Bosse.

# 0.5.0 Alpha — 2026-11-16

- Zwei kostenlose Stufe-5-Entwicklungen für jede der fünf Waffen, insgesamt zehn Wege.
- Verbindliche Auswahl direkt nach dem Shopkauf, mehrere Auswahlen nacheinander.
- Rundumschlag/Einzeltreffer, Durchschlag/Explosion, enger/breiter Fächer,
  lange Kette/Einzelblitz und weiter/schneller Klingenorbit tatsächlich implementiert.
- Eigene SVG-Symbole, Waffenabzeichen, Geschossspuren, Orbitgeometrie und begrenzte Effekte.
- Zusätzliche eigene synthetisierte Audioeffekte und Auswahlton.
- Ergebnis und Verlauf speichern die Wahl; ältere Formate bleiben kompatibel.
- Projektilpool setzt Spezialisierung und Trefferlisten bei Wiederverwendung zurück.
- 108 neue Prüfungen und Belastung aller zehn Varianten.
- Nutzer bestätigt Funktion, Nutzen und Lesbarkeit der Fähigkeiten aus 0.4;
  kein daraus abgeleiteter Nachweis vollständiger Runs aller Helden oder gemessener FPS.

# 0.4.0 Alpha — 2026-11-16

- Drei datenbasierte Heldenfähigkeiten: Schockwelle, Impulsgranate, Schattenschritt.
- Großer Touchbutton mit Symbol, Bereitschaft und Abklingbalken; eigener Finger pro Aktion.
- Begrenzter Rückstoß/Slow für normale Gegner; Bosse erhalten nur Schaden.
- Dash mit Streckenprüfung, einmaligem Schaden und zeitlich begrenzter Unverwundbarkeit.
- Gespeicherte Vibration AUS/DEZENT/STARK und abschaltbare Schadenszahlen.
- Größere goldene kritische Treffer, rote eigene Schadenszahlen und dezentes Randfeedback.
- Eigene Fähigkeits-Symbole und vier reproduzierbar synthetisierte Audioeffekte.
- Sofortiges Zusammenführen zu vieler XP-Kristalle ohne XP-Verlust nach Flächenkills.
- Grundwerte/Auto-Waffen und bisherige Arenen unverändert; Fähigkeiten sind aktive Ergänzungen.
- 76 neue Assertions und Belastungsläufe mit regelmäßigen Fähigkeiten in beiden Arenen.

# 0.3.0 Alpha — 2026-11-16

- Arena-Auswahl und nach erstem Sieg freigeschaltete Reaktorzone.
- Zehn eigene Wellen mit angekündigten Strombahnen und Reaktorwächter.
- Drei Bossattacken: Kreuzlaser, Kernbomben, gerichtete Impulssalven.
- Getrennte Arena-Statistiken und Verlauf mit Arenazuordnung.
- Drei erspielbare Bodenringe ohne permanente Kampfboni.
- Schema-3-Speicher mit Migration und Backups aus Schema 1/2.
- Schrottplatz-Balance und akzeptierte Klassenbindung/Waffenhaltung erhalten.
- Neue Integrations-, Migrations-, Gefahren-, Boss- und Belastungstests.

# Changelog

## 0.2.3 Alpha — 2026-11-16

- Eigenständige Gegner- und Bossgrafiken sowie eine gezeichnete, frei begehbare Industriearena.
- Treffer-/Todeseffekte, phasengenaue Radial- und Sturmwarnung, Countdown und zwei Warntöne.
- Reservierte Audiostimme für Warnungen und Ergebnisse; zusätzliche Siegesfeier.
- Bestwerte und Bilanz je Charakter, Verlauf der letzten 20 neuen Runden mit Filter und Seiten.
- Speicherformat 2; Format-1-Gesamtwerte/Einstellungen werden übernommen und vorher gesichert.
- Neue Charakterbestwerte beginnen ohne erfundene alte Zuordnungen ab dieser Version.
- 210 Prüfungen bestanden; 33 Regression-Kontrollpunkte mit erlaubten 0.2.2-Loadouts identisch.
- Keine Änderungen an Kampf-/Klassendaten, Trefferberechnung, Zwei-Hand-Rig, Waffen oder Spawns.
- Android-Debugbuild versionCode 5, gleiche Signatur und ARM64-Paketidentität.

## 0.2.2 Alpha — 2026-11-16

- Gameplay-Körper von Armen/Händen getrennt; genau zwei animierte Hände an Griffpunkten.
- Nur eine Waffe sichtbar gehalten; Orbit Blade bleibt frei schwebend.
- Vorläufige Klassenbindung: Bruiser Hammer; Sparky Blaster/Splitgun/Arc; Shade Orbit.
- Klassenfilter für Shop und Kaufprüfung; nutzlose Projektil-Upgrades ausgeblendet.
- Auswahl und Shop zeigen die Spezialisierung. 42 neue Klassen-/Rigprüfungen bestanden.
- Zahlenwerte unverändert, mögliche Builds bewusst eingeschränkt; Klassenbalance offen.
- VersionCode 4, gleicher Paketname und Signierschlüssel.

## 0.2.1 Alpha — 2026-11-16

- Fünf echte Comic-Waffensprites statt geometrischer Platzhalter, auch in Shop und HUD.
- Charakterbezogene Geschossformen: Goldgeschoss / Plasmalanze / Energiedorn.
- Neues Bossprojektil; automatische Waffenausrichtung, Rückstoß, Mündungsfeuer, Hammerschwung,
  Bodenschock, Kettenblitz, Klingenspur, Trefferfunken und begrenzte Patronenhülsen.
- Fünf eigene Waffen-Sounds; Darstellung pausiert und wird beim Runwechsel zurückgesetzt.
- 76 bestehende plus 28 neue Tests bestanden. Reproduzierbarer Balancevergleich gegen 0.1.
- Gleicher Paketname und Signaturschlüssel, versionCode 3. Keine Änderung der Kampfwerte.

## 0.2.0 Alpha — 2026-11-16

- Neue detailreiche Comic-Charakterbilder nach den visuellen Studioreferenzen.
- Gemeinsamer transparenter 1536×1024-Atlas mit drei Auswahlbildern und drei Spielfiguren.
- Größere Charakterkarten mit klarer Silhouette, Werten und großen Auswahlbuttons.
- Sprite-Darstellung in der Arena mit Blickrichtungswechsel, Laufwippen und Trefferfeedback.
- Neue Porträts in Hauptmenü und Ergebnisbildschirm; Splash-Versionsanzeige aktualisiert.
- Die von Nutzertests über 15 Runden bestätigte Balance von 0.1 vollständig beibehalten.
- Keine neuen Charakterfähigkeiten, Waffen, Gegner oder Spielwerte.

## 0.1.0 Alpha — 2026-11-15

- Verbundener Offline-Run mit Charakterauswahl, zehn Wellen, Level-Upgrades, Shop,
  Boss, Ergebnissen, Wiederholung und lokaler Statistik.
- Drei Helden mit Boni und individuellen Startwaffen; fünf Waffen mit fünf Stufen,
  zehn Upgrades, drei Gegner und Boss mit angekündigten Spezialangriffen.
- Touch-Joystick mit Fingerzuordnung, Pause und Android-Unterbrechungsschutz.
- Eigene prozedurale Cartoonfiguren, Arena, Porträts, Treffer- und Todeseffekte,
  Icon, Splashscreen, Sounds und synthetische Hintergrundmusik.
- Begrenzte Objektpools, drei Effektstufen, Safe-Area-Skalierung, robuste JSON-Speicherung.
- Automatisierte Integrations-, Belastungs- und Renderprüfungen.
- ARM64-Debug-APK mit Paket `com.rfworlds.mayhemsurvivors` erzeugt.
