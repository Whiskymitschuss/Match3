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
