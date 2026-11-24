# Testbericht 0.28.1 Beta 2 — 2026-11-23

**41 Suiten / 10014 bestandene Prüfungen / 0 Fehler** im vollständigen Projektlauf.
Beide historischen Regressionstraces zusätzlich bestanden (33 + 87 Kontrollpunkte).
Die Zahlen beziehen sich auf automatisierte Prüfungen, nicht auf echte Android-Geräte.
Rohprotokolle: tests/results/v0.28.1-beta2-*.log.

Neue Erstspieler-Suite: 37 Prüfungen vom tatsächlichen Boot mit isoliertem leerem
App-Speicher bis zu Run-Belohnung, Weltfinale, einmaliger Weltbelohnung und erster
erspielter Crew-Case. Prüft alle 15 Kämpfersperren, keine Gratis-Cases, keine
Tutorial-Geschenke, Neustart, Zusatzprofil, unabhängige Fortschritte und Erhalt
bereits vorhandener Coins/Tickets bei einem Update.

Sammlungs-/Garage-/Weltkarten- und Fortschrittsprüfungen verwenden jetzt explizit
erarbeitete Test-Tickets statt Produktions-Gratistickets. Ein alter Erwartungswert
für kostenlose Cases wurde korrigiert; der abschließende vollständige Lauf ist grün.
Native Touch-Navigation unter Godot GL/Mesa: Profile 42/0, Cases 74/0. Ein zusätzlicher
Lauf während eines vollen Build-Dateisystems scheiterte am Anlegen des Testordners;
nach Freigabe von Platz erneut 42/0. Keine Daten produktiver Spieler wurden verwendet.

15 native Erstspieler-Ansichten in 1600×900, 2400×1080 und 1440×1080 erzeugt.
Willkommens- und Case-Ansicht mit Null-Guthaben, gesperrten Kaufbuttons und lesbarem
Einstieg visuell geprüft. Diese Aufnahmen sind Linux-Godot-Ansichten, keine Android-
Gerätescreenshots. Alle Headless-Tests und Native-Tests ersetzen keine echte Geräteabnahme.

Release-AAB mit Bundletool 1.18.3 validiert; JAR-Uploadsignatur überprüft. Manifest:
Paket/Version/API-Level richtig, debuggable false, allowBackup false, nur VIBRATE.
Ausschließlich ARM64-Libraries; beide ELF-LOAD-Segmente 16-KiB-kompatibel, BundleConfig
PAGE_ALIGNMENT_16K. ZIP-CRC korrekt, keine Testdateien, privaten Schlüssel oder Spieler-
Spielstände im Bundle. Alle signierten Einträge bleiben bei JAR-Reihenfolge-Korrektur
bytegleich (CRC/Größe); abschließende Signaturprüfung ohne Streaming-Inkonsistenz.

Offen: Play-Console-Annahme/Veröffentlichung, Installation und Erstspieler-Flow auf
realen Android-Geräten, Updateverhalten der späteren Store-Signatur, echte Safe Areas,
Sensorik, Tastatur, subjektiver Klang, Langzeitstabilität, Balance und Geräteperformance.
Aktive Runs werden nach vollständigem App-Ende weiterhin nicht wiederhergestellt.

Frisch entpackter Quellstand ohne Importcache ebenfalls vollständig importiert;
die 37 Erstspieler-Prüfungen erneut bestanden. 802 Laufzeit-/Konfigurationsdateien
bytegleich zum Snapshot des gebauten Release-Bundles. Quelle enthält keine
privaten Schlüssel, App-Spielstände oder generierten Android-/Godot-Build-Caches.

---

# Testbericht 0.28.0 Beta 1 — 2026-11-23

Godot 4.6.3 stable. Am frisch entpackten Projekt ohne vorhandenen Importcache:
**40 Suiten / 9973 bestandene Prüfungen / 0 Fehler**. Beide historischen Traces
mit eingefrorenen älteren Regeln zusätzlich bestanden (33 + 87 Kontrollpunkte).
800 Laufzeitdateien plus Projekt-/Exportkonfiguration und alle 109 Testskripte
sind bytegleich zum APK-Quellstand. Keine finalen Parser-/Script-/Ressourcenfehler.

## Eigene Spieler und Speicherhärtung

Profile-Store: 37 Prüfungen. Bestehender Spieler bleibt am ursprünglichen Pfad;
vier weitere Spieler starten unabhängig mit Bruiser. Grenzen, Namen/Umlaute,
doppelte Namen, feste IDs, Verzeichnis-Schutz und persistente Auswahl geprüft.
Aktiver und primärer Spieler geschützt; entfernte Dateien werden archiviert.
Katalog nach Neustart, Sicherung und Rekonstruktion aus gültigen Dateien geprüft.

Transaktionstests prüfen gültige Vorgängersicherung, beschädigte Hauptdatei,
Reparatur, verwaiste temporäre Datei, gültigen Primärstand als Autorität,
vollständige Beschädigung, Dateigrößenlimit, nicht beschreibbaren Zielpfad und
ungültige Daten. Fehlgeschlagene Writes melden Fehler, statt Persistenz zu behaupten.
Manuelles Restore betrifft ausschließlich den aktiven Spieler. Migrationen behalten
weiter exakte Originalbytes als Archiv; JSON-Versionen 1/2/3 werden erkannt.

Beta-Profiles: 42 Funktionsprüfungen, nochmals nativ mit InputEventScreenTouch
bestanden. Wirkliche Case-, Aufgaben-, Weltbelohnungs- und Run-Ergebniswege speichern
im aktiven Profil. Guthaben, Freischaltungen, Daten, Einstellungen und Auswahl
werden nicht zwischen Spielern vermischt. Neue Game-Instanz lädt denselben Spieler.
Ein Save-Fehler blockiert den Profilwechsel ohne Datenverlust im Arbeitsspeicher.

Native UI-Wege umfassen Namen ändern, Profil anlegen/aktivieren, bestätigtes Restore,
Zurück aus Case-Reveal, Profil-/Settings-Menüs und Abbruchdialoge. Shop-Abbruch kann
ohne Neuwürfeln oder Simulationsfortschritt abgebrochen werden. Bestätigter Abbruch
aus Vorbereitung, Levelwahl und Shop zeichnet genau eine Niederlage auf. Unterbrechung
pausiert, Rückwege setzen korrekt fort; Profilmutationen sind in aktiven Runs gesperrt.
Beta-Bericht enthält keinen Spielernamen. Die neuen Profiltests verwenden private Testverzeichnisse.

## Regression, Belastung und Darstellung

- Bestehende Charakter-, Kampf-, Shop-, Cases-, Welt-, Belohnungs- und Analyseprüfungen
  am frischen Stand bestanden. Native Case-Navigation zusätzlich 74 Prüfungen grün.
- Analyse-Soak: 90 Szenarien / alle 15 Figuren / Kampagne und Endlos / drei Qualitäten;
  41.175 Schritte / 686,25 simulierte Sekunden. Kontrollierte Wellen-/Bossenden,
  korrekte gespeicherte Belege und begrenzte Historie. Kein menschlicher Schwierigkeitsbeleg.
- 16 native GL-Aufnahmen: Hauptmenü, Profile, Settings und Beta-Hilfe jeweils in
  1600×900, 2400×1080 und 1440×1080; zusätzlich Name, Wiederherstellung, Anleitung
  und Run-Abbruchdialog. Relevante Einzelbilder und Layouts kontrolliert. Bilder
  verwenden eigene Darstellungsfixtures, keine menschlichen Android-Runs.
- Tatsächlicher Debug-Export mit unverändertem Update-Schlüssel, gültiger Signatur,
  ARM64, korrektem Paket und importiertem Profilicon; Speicher-/Profilcontroller enthalten.

## Behobene Entwicklungsbefunde

JSON-Zahlen mussten mit numerischem Vergleich statt typabhängiger Listenmitgliedschaft
validiert werden. Originalbytes von Migrationsarchiven werden erhalten. Historische
Kampf-Fixtures setzen ihren alten Sessionkontext, damit gespeicherte Welt-/Stufenwahl
ihre festgelegten Erwartungen nicht beeinflusst. Menü-Animationstest wählt SPIELEN
statt den inzwischen neu hinzugekommenen Profilbutton. Schneller Audio-Testabschluss
wartet auf die Freigabe des Mischpuffers. Alle betroffenen Läufe erfolgreich wiederholt.

Reproduktion: `python tools/run_tests.py --traces`. Zusätzlich beta_profiles_test.gd
und case_navigation_test.gd mit `-- --native-touch` im GL-Fenster, recap_soak.gd und
beta_capture.gd; Godot mit `--fixed-fps 60`. Rohlogs: tests/results/v0.28.0-beta1-*.

## Beta-Grenzen

Geschlossener Android-Gerätetest steht aus: Installation über alte Daten, Tastatur,
Mehrfingergefühl, Safe Area, Sensoren, subjektiver Klang, menschliche Balance,
lange Runs, Temperatur, Akku und gemessene 60 FPS. Linux-GL und Headless beweisen
diese Punkte nicht. Aktive Runs werden nach vollständigem App-Ende nicht fortgesetzt;
dauerhafter Fortschritt und Profile schon. Keine Cloud/Anmeldung oder automatische
Übertragung zwischen Handys. Testanleitung: BETA_TESTING.md. Keine Tests im APK.

---

## Frühere Testberichte

# Testbericht 0.27.0 — 2026-11-23

Godot 4.6.3 stable. Frisch entpacktes Quellprojekt ohne Importcache:
**38 Suiten / 9.890 bestandene Prüfungen / 0 Fehler**. Beide historischen Traces
mit eingefrorenen alten Regeln zusätzlich bestanden: 33 + 87 Kontrollpunkte.
790 Laufzeitdateien plus project.godot/export_presets.cfg sowie Testskripte und
Runner sind bytegleich zum APK-Quellstand. Keine finalen Parser-, Script- oder
Ressourcenfehler. Rohprotokolle: tests/results/v0.27.0-*.

## Arena-Taktik und Vergleich

686 Taktik-Prüfungen: sechs Welten × Bruiser/Steelfist/Viper × drei Qualitäten,
vollständige Vorwarnung, echte Kollisionsgeometrie und Gegnerbeute, einmaliger
Bonus, keine Extra-Krit-Zufallszüge, freundlicher Schaden, Filterreinigung,
Wärmeschutz und wirkliche Bewegung, langsame Gegner, fester Blitz, Stun,
Runenreihenfolge, Bombentakt, Ringsog mit Eliten-/Bosswiderstand und sichere Räume.
Pause, Shop, Levelwahl, kurze Restzeit, Tod, Wellenbereinigung, Endlos und Restart
geprüft. Alle sechs Bossvarianten besitzen Vorlauf, Besitzerbereinigung und
0,5-%-Schadensgrenze pro Einschlag. Keine zusätzlichen Boss-Manöverzahlungen.
Erstbesuch, Hilfe-Rückweg, gespeicherte Bestätigung und Managerfreigabe geprüft.

3.443 Fortschritts-/Vergleichsprüfungen: echte Case-Preise, Gratistickets, fehlende
Coins, schreibgeschützte Darstellung, vollständige Crew und 40 unabhängig gesetzte
Case-Seeds. Der angezeigte Schutz garantiert fehlende Kämpfer innerhalb der
bestehenden Obergrenze. Verglichen werden tatsächliche kontrollierte Spielbelege
mit gleichen Rahmenbedingungen. Andere Welten, Modi und Schwierigkeiten sowie
alte Runs ohne Messdaten werden ausgeschlossen. Werte werden nicht erfunden.
Statistik erreicht alle 15 Figuren; Tabs, früherer Run und Zurück bleiben nutzbar.

Die beiden neuen Suiten und Case-Navigation nochmals nativ im GL-Fenster mit
InputEventScreenTouch ausgeführt: 686 / 3.443 / 74 Funktionsprüfungen bestanden.
Diese Zahlen umfassen auch Modellprüfungen und sind keine Anzahl physischer
Fingerkontakte. Echte Touch-Wege umfassen sechs Arena-Hilfen, Rückwege zur Pause,
Vergleich/Filter/Tabs, alle Statistikseiten und Case-Öffnung/Inventar/Zurück.

## Belastung und Darstellung

- Taktik-Soak: 54 Szenarien, 64.800 Schritte / 1.080 simulierte Sekunden.
  Drei Klassen × sechs Welten × LOW/MEDIUM/HIGH, Normalwelle mit 100 Gegnern
  und Abschlussboss. Maximal drei neue Gefahren und neun Pool-Slots. Identische
  Schadens-, HP- und Beutewerte je Qualität bei gleichen Startbedingungen.
- Analyse-Soak: 90 Szenarien, alle 15 Figuren × Kampagne/Endlos × drei Qualitäten;
  41.175 Schritte / 686,25 simulierte Sekunden. Kontrollierte Wellen-/Bossenden,
  erhaltene Gesamtwerte und höchstens 20 gespeicherte Runs.
- 30 native GL-Aufnahmen: Werkzeug, Vorwarnung, Kicksy-Hilfe und Abschlussboss
  je neuer Welt, Wärmefeld, drei Vergleichsformate, Leerzustand und Case-Menü.
  Weltbilder in 1600×900; Vergleich zusätzlich 2400×1080 und 1440×1080.
  Galerie und relevante Einzelbilder kontrolliert. Vergleichsbilder zeigen
  kontrollierte Darstellungsbelege, keine menschlichen Android-Testläufe.
- Sechs eigene SVGs und drei PCM-Cues importiert und im APK nachgewiesen.
  Bestehende Musik, Mixer, Objektpools und Grafikbudgets bleiben angeschlossen.

## Entwicklungskorrekturen und Reproduktion

Ein Vergleichstest suchte nach dem Roh-Buttonnamen mit Pfeil, während die Skin den
Pfeil entfernt. Auf den sichtbaren Namen korrigiert; Rückweg ist nativ bestätigt.
Ein Test mit zurückgesetzter Standardlautstärke hielt beim schnellen Engine-Ende
noch einen Klick-Audiopuffer; UI-Tests sind jetzt ausdrücklich stumm. Alte Event-
Fixtures auf freiwillige Werkzeuge und neue volle Bosswarnzeit angepasst.
Ein veralteter X-Display-Socket verhinderte zunächst den nativen Start. Neuer
virtueller X-Server gestartet und alle betroffenen Läufe erfolgreich wiederholt.
Die frühere Nutzungslimit-Blockade wurde vor diesen finalen Ausführungen aufgehoben.
Keine fehlgeschlagenen Zwischenläufe gelten als erfolgreiche Nachweise.

Reproduktion: `python tools/run_tests.py --traces`. Zusätzlich tactics_soak.gd,
recap_soak.gd; tactics_test.gd / progress_comparison_test.gd /
case_navigation_test.gd mit `-- --native-touch` im GL-Fenster; tactics_capture.gd.
Godot jeweils mit `--fixed-fps 60`. Keine Testfunktionen im APK.

Offen: physisches Android-Gerät, echte Mehrfingerbedienung, Safe Area und Sensorik,
subjektiver Klang, menschliche Balance, lange Endlosläufe, Temperatur, Akku und
gemessene 60 FPS. Software-GL und kontrollierte Simulation belegen diese Punkte nicht.

---

## Frühere Testberichte

# Testbericht 0.26.0 — 2026-11-19

Godot 4.6.3 stable. Am frisch entpackten Quellprojekt ohne vorhandenen Importcache:
**36 Suiten / 5.761 Prüfungen / 0 Fehler**. Beide historischen Traces zusätzlich
bestanden: 33 + 87 Kontrollpunkte mit bewusst eingefrorenen alten Kampfregeln.
767 Laufzeitdateien und project.godot/export_presets.cfg sind bytegleich zum
Arbeitsstand der Android-APK. Testskripte und Runner ebenfalls verglichen.
Keine Parser-, Script- oder Ressourcenfehler in den finalen Läufen.

## Neue Inhalte und native Bedienung

- Presentation-Pack: 130 Prüfungen für 15 Figuren, Klassenwerte, echte Gift-/
  Schall-/Schild-/Drohnenwirkung, Passiven, Pause, Wellenbereinigung und Freigabe.
  Skin-Kauf, unzureichende Coins, Doppelkauf, Ausrüstung und Laden geprüft.
  Alle fünf Skins lassen Schaden, kritischen Zufall, Kills und Beute unverändert.
- Run-Analyse: 88 Prüfungen für aktive Kampfzeit, tatsächlichen HP-Verlust,
  begrenzten Modulbonus, Wellen/Bosse, Endlos, History, Filter, Seiten und Laden.
  Alte Runs bekommen keine erfundenen Detailwerte. Manager und Views werden frei.
- Beide Suiten zusätzlich im nativen GL-Fenster mit InputEventScreenTouch:
  **218 bestandene Touch-/Funktionsprüfungen**, keine Enginefehler. Wege umfassen
  Hauptmenü, Settings, Handbuch, Garage, Skin-Kauf, Ausrüstung, Pause/Fortsetzen,
  Ergebnis, Run-Analyse, Verlauf und Zurück.
- 40 native GL-Aufnahmen: 22 für Menü, drei Settings-Tabs, Skins und vier neue
  Figuren in Auswahl/Kampf; 18 für Analyse, Ergebnis, Verlauf und alte Runs.
  1600×900, 2400×1080 und 1440×1080; Galerie und relevante Einzelbilder geprüft.
  Gemeinsames Zwei-Hand-Rig, lesbare Inhalte und keine fehlenden Texturen.

## Belastung und Medien

- Recap: 90 Szenarien (15 Figuren × Kampagne/Endlos × drei Qualitätsstufen),
  41.175 Schritte / 686,25 simulierte Sekunden; kontrollierte Wellen-/Bossenden.
- United: 150 Figuren-/Arena-Kombinationen, 126.000 Schritte / 2.100 simulierte
  Sekunden. Spitzen: 38 Gegner, 22 Pool-Slots und vier United-Gefahren.
- Klassenmodule: 27 Szenarien / 16.200 Schritte / 270 simulierte Sekunden;
  bis 100 Gegner und zwölf neue Effekte. Gleicher Schaden und gleiche Auslösungen
  bei LOW/MEDIUM/HIGH mit identischen Startwerten und Zufallsseeds.
- Neue Crew: zwölf Szenarien / 7.200 Schritte / 120 simulierte Sekunden mit
  100 Gegnern; maximal drei Pool-Slots und 67 Partikel. Gleiche Kampfergebnisse
  in allen drei Qualitätsstufen; Bereinigung vollständig.
- FFmpeg hat alle drei Original-Musikstücke unabhängig dekodiert: Stereo,
  endliche Samples, hörbarer RMS-Pegel und keine geclippten Einzeldateien.
  Längen: Menü 36,923 s, Kampf 28,235 s, Boss 25,946 s. Importierte neue SFX und
  aktiver Master-Hard-Limiter mit -0,8 dB geprüft. Dies ersetzt keinen Hörtest.

## Korrekturen und Reproduktion

Ein echter GUI-Lebensdauerfehler beim Fortsetzen wurde durch Menüwechsel nach
Abschluss des Inputcallbacks behoben und nativ erneut geprüft. Ein älterer GUI-Test
wartet nun ebenfalls auf diesen Übergang. Alte Elf-Figuren-Fixtures wurden auf
15 Figuren, 14 Case-Freischaltungen und 39 Sammlungsgegenstände erweitert.
Fehlgeschlagene Zwischenläufe werden nicht als erfolgreiche Nachweise verwendet.

`python tools/run_tests.py --traces` führt alle ausgelieferten Suiten aus.
Zusätzlich: crew_soak.gd, recap_soak.gd, united_soak.gd, synergies_soak.gd;
presentation_pack_test.gd / recap_test.gd mit `-- --native-touch` im GL-Fenster.
Aufnahmen: presentation_pack_capture.gd und recap_capture.gd. Godot-CLI jeweils
mit `--fixed-fps 60`. Rohprotokolle: tests/results/v0.26.0-*.

Offen bleiben physische Android-Geräteprüfung, echtes Mehrfingergefühl,
subjektive Musik-/Sound-/Haptikabnahme, menschliche Balance, Safe-Area-/Sensor-
Verhalten am Gerät, Temperatur, Akku und gemessene 60 FPS. Kontrollierte Simulation
und Linux-/Mesa-Aufnahmen belegen diese Punkte nicht. Keine Tests im APK.

---

## Frühere Testberichte

# Testbericht 0.25.0 — 2026-11-18

Godot 4.6.3 stable. Vollständiger Testlauf am frisch entpackten Quellprojekt ohne
vorhandenen Importcache: **34 Suiten / 5.434 Prüfungen / 0 Fehler**. Beide historischen
Traces zusätzlich bestanden (33 + 87 Kontrollpunkte; bewusst eingefrorene alte
Kampfregeln in deren Test-Fixtures). Parserimport ohne Script-/Ressourcenfehler.
720 Laufzeitdateien und project.godot/export_presets.cfg bytegleich zum Arbeitsstand.

Neue Synergien-Suite: **240 Prüfungen**, nochmals mit echten InputEventScreenTouch-
Ereignissen durch die native GL-Oberfläche bestanden. Geprüft: Klassen-/Waffenbindung,
garantiertes relevantes Shopangebot, Kaufpreis, unzureichende Coins, Doppelkauf,
Markierung/Ladung, reale Basis- und entwickelte Waffen, Impuls/Arc, exakte Boni,
Kettenreichweite/-anzahl, globale Abklingzeit, kein rekursiver Proc/Krit-Zufallszug,
Pause/Shop/Levelauswahl, Wellenende, Boss-Ende, normale XP-/Coin-Beute, Game Over,
Neustart, Statistik-IDs, Ressourcen und Freigabe des Managers. Native Touch-Wege:
HUD → Regeln → Kampf; Shop → Regeln → Shop; Kauf → Inventar → Modulregeln → Inventar.

27 gezielte Belastungsszenarien: drei Helden × Basis/zwei Entwicklungen × drei
Qualitätsstufen; **16.200 Schritte / 270 simulierte Sekunden**, maximal 100 Gegner
und 12 neue visuelle Impulse. Bei identischem Seed und Startwinkel liefern LOW,
MEDIUM und HIGH exakt denselben Schaden und dieselbe Zahl an Auslösungen.
Zusätzlich bestehender Soak: **110 Helden-/Arena-Kombinationen**, 92.400 Schritte /
1.540 simulierte Sekunden; Spitzen 38 Gegner, 22 Pool-Projektile und 4 United-Gefahren.
Doppelte Bereinigung, Pause und Bossmuster bleiben stabil.

54 stationäre Bossproben, jeweils 15 Sekunden kontrollierte Treffergelegenheit;
Wellen 2/4/6/8/10, drei Helden, relevante Entwicklungen, mit/ohne Modul.
Bruiser: +3,05 bis +8,73 % Schaden; Shade: +2,47 bis +16 %. Sparky am isolierten
Boss: 0 % Zusatzschaden, weil keine anderen Kettenziele vorhanden sind. Bestehende
Waffenwerte, Boss-HP und Resistenzen wurden nicht verändert. Projektionen sind
weder tatsächliche Boss-Kampfdauern noch ein Nachweis fairer menschlicher Balance;
unterschiedliche Builds behalten deutlich unterschiedliche stationäre DPS.

16 native GL-Ansichten mit Mesa/llvmpipe bei 1600×900, 2400×1080 und 1440×1080
aufgenommen; Galerie und entscheidende Einzelansichten kontrolliert. HUD, drei
Regelansichten, drei Shopmodule und Bossmarkierung sind enthalten. Verdeckte Shop-
Unterzeile, zu große HUD-Symbole und verdeckte Gegnerzeichen korrigiert und erneut
aufgenommen. Kein fehlendes Asset oder Scriptfehler in der finalen Ausführung.

Entwicklungsfehler: Ein Soak-Vergleich startete mit unterschiedlichen Orbitwinkeln;
Fixture zurückgesetzt und kompletter Vergleich wiederholt. Zwei vorläufige Script-
Indentations-/Variablennamenfehler wurden vor dem finalen Import behoben. Keine
fehlgeschlagenen Zwischenläufe werden als erfolgreicher Nachweis verwendet.

Reproduktion: `python tools/run_tests.py --traces`; zusätzliche Scripts:
`tests/synergies_test.gd -- --native-touch` (native GL), `synergies_soak.gd`,
`synergies_probe.gd`, `synergies_capture.gd`, `united_soak.gd`. Godot-CLI im Projekt
mit `--fixed-fps 60`; Details und Rohprotokolle unter tests/results/v0.25.0-*.
Im Build gibt es keine Tests oder Test-Schalter als Spielerfunktion.

Offen: physisches Android-Gerät, subjektiver Sound-/Haptik-/Balancecheck, echte
Mehrfinger-Bedienung am Gerät, thermische Stabilität, Akku und 60 FPS. Native Linux-
Touchereignisse und ein installierbares APK ersetzen diese Abnahme nicht.
Build-/Signaturprüfung: BUILD_REPORT.md. Spieleranleitung: SYNERGIES.md.

---

## Frühere Testberichte

# Testbericht 0.24.0 — 2026-11-18

**33 Suiten / 5.194 bestandene Prüfungen / 0 Fehler**, nach frischem Entpacken und
Import ohne Projektcache. Beide historischen Vergleichsläufe unverändert bestanden.
Godot 4.6.3 stable. Rohprotokolle unter tests/results/v0.24.0-*.

## Glutwerk

foundry_test: 217 Prüfungen, zusätzlich alle 217 im nativen GL-Fenster mit
InputEventScreenTouch-Ereignissen bestanden. Bruiser, Sparky und Steelfist sowie
LOW/MEDIUM/HIGH: tatsächliches Anhalten, voller Vorlauf, gespeicherter Druck,
richtungsgebundener Schaden, Rückstoß, sichere Bedienposition, normales XP-/Coin-Loot
und begrenzte Bonuszahlung. Niedriger und hoher Druck sowie leere Bahnen geben keinen
Bonus. Verwendete Ventile sind gegen Wiederholung geschützt.

Pause, Level-Up und Shop frieren Druck und Warnungen ein. Letzte Sekunden, lange
Frames, Randpositionen, eigener Schaden, Tod und Neustart werden abgefangen.
Ofenkönig: echte kreuzende Dampfbahnen, vollständige Vorwarnung, HP-Phasen, Besitzertod
und Versetzen, gedeckelter Umweltschaden, kein Boss-Rückstoß oder Ventilbonus.
Kampagne/Endlos/Tutorial, Hilfestatus, native Hilfe-Rückwege und vier Soundimporte
geprüft. Beide Manager werden nach der vorgesehenen UI-Bereinigung freigegeben;
eine schwache Rückreferenz verhindert einen dauerhaften Referenzzyklus.

## Regression, Belastung und Darstellung

- Alle bisherigen Mechanik-, Case-, Welt-, Waffen-, Save- und Bossprüfungen bestanden.
- Foundry-Soak: 9 Szenarien (drei Helden × drei Grafikstufen), 23.760 Schritte / 396 s,
  Normalwelle und Boss, bis 100 Gegner, zwei eigene Gefahren und zehn Pool-Slots.
  Level-Ups werden auch im Bossabschnitt korrekt durch den Test verarbeitet.
- United-Soak: elf Helden × zehn Arenen / 110 Szenarien / 92.400 Schritte / 1.540 s;
  Spitzenwerte 38 Gegner, 22 Pool-Slots und vier United-Gefahren. Bestanden.
- 16 native GL-Ansichten in 1600×900, 2400×1080 und 1440×1080: Coach, Weltkarte,
  Druck, Richtung, Vorwarnung, Einschlag, vertikaler Stoß, Pause und Ofenkönig.
- World-Trace: 33 Punkte / 3.600 Schritte. Effects-Trace: 87 Punkte / 8.700 Schritte.
- Frischer Quellimport: 706 Laufzeitdateien sowie Projekt-/Exportkonfiguration
  bytegleich; alle 33 Suiten und beide Traces erneut bestanden.
- Android-Debug-APK tatsächlich gebaut; Signatur, Architektur, Manifest, Alignment,
  exakte Daten, Controller, Textur-/Soundimporte und Archiv-CRC geprüft.

## Offene Abnahme

Keine physische Android-Geräteprüfung. Native Linux-/Mesa-Bilder und Headless-Tests
belegen keine menschliche Schwierigkeit, 60 FPS, Akkulaufzeit, Temperatur oder
Cutout-/Sensorverhalten auf jedem Gerät. Keine Script-/Parser-/Ressourcenfehler in
den finalen Läufen; fehlende V-Sync-Steuerung und kein erreichbarer ADB-Daemon sind
bekannte Grenzen der lokalen Umgebung.

Nächster Praxistest: Glutwerk, beide Handräder, unterschiedliche Druckwerte und
Ofenkönig; freiwillige Nutzung und Nichtbenutzung vergleichen.

---

## Vorherige Prüfberichte

# Testbericht 0.23.0 — 2026-11-18

**32 Suiten / 4.977 bestandene Prüfungen / 0 Fehler**, nach frischem Entpacken und
Import ohne Projektcache. Beide historischen Vergleichsläufe unverändert bestanden.
Godot 4.6.3 stable. Rohprotokolle unter tests/results/v0.23.0-*.

## Neue Arenenmechaniken

arena_mechanics_test: 220 Prüfungen, zusätzlich alle 220 im nativen GL-Fenster mit
InputEventScreenTouch-Ereignissen bestanden. Geprüft sind tatsächliche Hammer- und
Blasterangriffe, Kernerzeugung/-aufnahme, bewusstes Aktivieren, vollständige Warnzeit,
Gegner- und Spielerschaden, normale Beute plus begrenzter Bonus, keine kritischen
Arena-Treffer und unverbrauchter Crit-RNG, kein Doppelschaden oder wiederholter Bonus.

Feste Containerpositionen, seitliches Ausweichen, zwei begrenzte Doppelladungen,
leere Abwürfe ohne Bonus, genaue Kollisionsränder und lange Frames sind geprüft.
Pause, Level-Up, Shop, Tod und Neustart halten bzw. bereinigen die neuen Systeme.

Die tatsächlichen Arenenbosse kündigen drei eigene Ziele mit zwei Sekunden an.
HP-Phasen löschen laufende Warnungen nicht; Tod und Versetzen des Besitzers bereinigen
sie. Umweltschaden am Boss ist auf 0,5 % je Treffer begrenzt. Bossflächen bezahlen
keinen Bonus. Andere Arenen und Tutorial bleiben isoliert; Endlos wiederholt die Regeln.

Kicksy-Einführung, gespeicherte/sanitisierte Bestätigung, reale Touch-Rückwege und
erneutes Öffnen in der Pause sind getestet. Fünf eigene Soundimporte geprüft.

## Belastung und Darstellung

- Arena-Soak: 12 Szenarien (Bruiser/Sparky × zwei Arenen × LOW/MEDIUM/HIGH),
  28.800 Simulationsschritte / 480 s, bis 100 Gegner, zwei eigene Gefahren und
  25 Projektilpool-Slots. Begrenzungen, Pause und Bereinigung bestanden.
- United-Soak: elf Helden × zehn Arenen / 110 Szenarien / 92.400 Schritte / 1.540 s,
  inklusive neuer Bossflächen; Spitzenwerte 38 Gegner, 22 Pool-Slots, vier United-
  Gefahren. Eigene Gefahren ≤6 und Kerne ≤3 sowie zweimalige Bereinigung geprüft.
- 21 native GL-Ansichten: Coach, Status, Kerne, Entladung, Container, Bossmuster,
  Pause-Hilfe und Weltkarte. Ansichten in 1600×900, 2400×1080 und 1440×1080.
  Die zu lange Abwurfmeldung wurde gekürzt und erneut gerendert/geprüft.
- Vergleichsläufe: World 33 Punkte / 3.600 Schritte; Effects 87 Punkte / 8.700 Schritte.
- Frischer Quellimport: 694 Laufzeitdateien und Projekt-/Exportkonfiguration
  bytegleich. Alle 32 Suiten und beide Traces erneut bestanden.
- Android-APK tatsächlich gebaut, Signatur, Manifest, ARM64, Alignment, exakte Daten,
  neue Controller, Textur-/Soundimporte und Archiv-CRC geprüft.

## Grenzen

Keine physische Android-Geräteabnahme. Diese Tests belegen keine menschliche
Schwierigkeit, 60 FPS, Akkulaufzeit, Temperatur oder korrektes Verhalten auf jedem
Cutout-/Sensorgerät. Die nativen Bilder stammen von Linux/Mesa. Fehlende V-Sync-
Steuerung und kein erreichbarer ADB-Daemon sind erwartete Umgebungsgrenzen;
keine Parser-, Script- oder Ressourcenfehler in den finalen Prüfläufen.

Nächster Praxistest: in beiden Arenen Nah- und Fernkampf, Überladung bewusst nutzen
bzw. ignorieren, Gegner unter Container locken, Bonus prüfen und Arenaboss besiegen.

---

## Vorherige Prüfberichte

# Testbericht 0.22.0 — 2026-11-18

**31 Suiten / 4.757 bestandene Prüfungen / 0 Fehler**, nach frischem Entpacken und
Import ohne Projektcache. Beide historischen Vergleichsläufe unverändert bestanden.
Godot 4.6.3 stable, GDScript. Alle Rohprotokolle unter tests/results/v0.22.0-*.

## Neuer erster Durchlauf

first_arena_test: 167 Prüfungen; zusätzlich dieselben 167 im nativen GL-Fenster
mit echten InputEventScreenTouch-Ereignissen bestanden. Geprüft sind:

- Neuer Spieleinstieg, gespeicherte Wahl, erfahrene Profile, Abbruch und Neustart.
- Vollständiges produktives Bruiser-Training: Bewegung, echter automatischer
  Hammertreffer, XP, Upgrade, Schockwelle, Warnspur, Kauf, Reroll, Aufrüstung, Pause.
- Trainingsfortschritt ohne erspielte Profil-Coins, Kills, Siege oder fremde Fighter.
- Freiwillige Bergung, Mindesthaltezeit, kein automatischer Start beim Vorbeilaufen
  oder in Arenenecken, voller Warnzeitraum, tatsächlicher Schaden, Auszahlung,
  Wiederholungsschutz, Tod, Neustart, abgelaufenes Annahmefenster und alle Qualitäten.
- Auftrag eingefroren bei Pause, Level-Up und Shop. Andere Arenen, Bosswellen und
  Spielmodi behalten ihre bisherigen Regeln.
- Beide Hammer-Pfade durch sämtliche zehn Wellen mit echten Waffen-/Fähigkeitstreffern
  bis Sieg und Freischaltung der Reaktorzone. Normalwellen werden dafür verkürzt und
  Bossziele festgehalten; dies ist ein Integrations- und Durchsatztest, kein menschlich
  gespielter Schwierigkeitsnachweis. Keine zusätzliche Sieges-Schadensfunktion.
- Ergebnisdetails, genaue Coin-Formel, wiederholte Navigation ohne Doppelauszahlung,
  einmaliger Erstabschluss samt Speichern/Laden und sicherer neuer Run.
- Native Touch-Rückwege und veraltete, gleichzeitig vorgemerkte Seitenwechsel.
- HUD-Trennung und dekorative, eingabedurchlässige Labels in drei Seitenverhältnissen.
- Drei neue importierte, kurze eigene Audiocues.

## Regression, Darstellung und Belastung

- Case-Navigation: alle 74 GUI-Prüfungen erneut mit nativem Touch bestanden.
- Bossbalance: 748 Prüfungen erhalten, inklusive aller Welten und Schwierigkeitsstufen.
- World-Trace: 33 Kontrollpunkte, 3.600 Schritte. Effects-Trace: 87 Punkte, 8.700 Schritte.
- United Soak: 110 Helden-/Arenenkombinationen, 92.400 Simulationsschritte / 1.540 s;
  Spitzenwerte 38 Gegner, 22 Projektilpool-Slots und 4 United-Gefahren. Bestanden.
- 18 native GL-Ansichten: Willkommen, Coach, Shop, Pfade, Entwicklung, Werkstatt,
  Bergung, Boss-HUD, Ergebnis und Weltbelohnung. 1600×900, 2400×1080 und 1440×1080.
- Sauberer Quellimport: 674 Laufzeitdateien sowie Projekt- und Exportkonfiguration
  bytegleich zur getesteten Entpackung. Keine fehlenden Ressourcen oder Parserfehler.
- Android-APK tatsächlich exportiert; Signatur, Architektur, Manifest, Alignment,
  neue Daten, kompilierte Controller, Soundimporte und Archiv-CRC geprüft.

## Grenzen der Abnahme

Kein physisches Android-Gerät verfügbar. Installation über eine alte App, Cutouts,
Neigungssensoren, Temperatur, Akku, wahrgenommene Fairness und 60 FPS müssen auf
Geräten geprüft werden. Linux-Mesa-Rendering und Headless-Ergebnisse belegen dies
nicht. Die lokale Umgebung meldet erwartbar fehlende V-Sync-Steuerung und keinen
ADB-Daemon; die erfolgreichen Prüfungen enthalten keine GDScript-/Ressourcenfehler.

Nächste menschliche Abnahme: Bruiser auf dem Schrottplatz, beide Hammer-Entwicklungen,
eine ignorierte und eine angenommene Bergung, danach Weltbelohnung abholen.

---

## Vorherige Prüfberichte

# Testbericht 0.21.2 — 2026-11-18

`python tools/run_tests.py --traces`:30 Suiten /4.590 bestandene Prüfungen,0 Fehler,
beide unveränderten historischen Vergleichstraces bestanden. Alle bisherigen
Case-Navigationstests inklusive gespeichertem Fund/Retry bleiben grün.

Neu: boss_balance_test.gd /748 Prüfungen. Tatsächliches Spawnen/Belohnen/Abschließen
in zehn Arenen, drei Schwierigkeiten und allen fünf Bosswellen; HP-Faktoren,
unveränderte Kontaktschäden/Zeitlimits/Beute, unterschiedliche voll angekündigte
Eröffnungen, tatsächlicher Projektilschaden nach Warnzeit, Pause/Shop/Level-Up,
Schwellenschaden während einer laufenden Attacke, ausstehende Rage, keine versteckte
Unverwundbarkeit, fortbestehende Warnflächen, Axel, Boss-Modifier nur an Bossen,
normaler Trefferschaden, unveränderter Sprengkern-Direkttreffer, Endlos und Build-
unabhängige HP. Der 0.21-Produktionstest besitzt jetzt593 Prüfungen.

Stationärer Durchsatztest:91 Waffen-/Wellen-Szenarien, je15 Sekunden vor/nach Änderung,
fester Seed. Echte Waffen/Projektile/Pfützen/Orbits; gegnerspezifische Trefferintervalle
werden fortgeschrieben, Knockback zur Messung des reinen Durchsatzes zurückgesetzt.
Dies ist kein menschlicher Kampftest. Rohdaten und CSV dokumentieren auch schwächere
Flächenspezialisierungen. Details und Ableitungen: BOSS_BALANCE.md.

united_soak.gd:110 Helden/Arenen-Szenarien,92.400 Schritte,1.540 simulierte Sekunden;
38 Gegner /22 Pool-Projektile /4 Gefahrenflächen als beobachtete Spitzen. Caps,
endliche Zustände, Pause, alle vier Bossangriffe, Rage und Bereinigung geprüft.
Keine Aussage über physische FPS oder eine Messung auf Android.

15 native GL-Aufnahmen: Boss-Intros/Eröffnungen aller fünf Bosswellen, Heldenauswahl,
Handbuch und tatsächliche Orbit-/Tesla-Werkstattwerte. Schrift, HP-Werte,
Bonusangaben und Warnflächen kontrolliert. Keine Parser-/Skript-/Ressourcenfehler.
Mesa llvmpipe unter Linux; keine Android-Gerätebilder.

Offen: erneuter menschlicher Neonhafen-Durchlauf mit Sparky/Sprengkern, danach weitere
Klassen/Welten. Physische Android-Update-/Touch-/Audio-/FPS-/Thermikabnahme bleibt nötig.

Quell-ZIP zusätzlich ohne Importcache frisch entpackt und importiert. Alle30 Suiten /
4590 Prüfungen und beide Traces erneut bestanden;662 Laufzeitdateien bytegleich.
Logs:v0.21.2-clean-import.log, v0.21.2-clean-tests.log, v0.21.2-source-integrity.log.
