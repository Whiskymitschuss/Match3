# Testbericht 0.17.0 — 2026-11-17

Godot4.6.3 stable: 23 Suites /1.747 Assertions /0 Fehler. Beide historischen Traces grün.
72 Steelfist-Checks: echter Auswahlbutton/Karussell, freie Verfügbarkeit, Klasse und
Upgradefilter, exakte Startwerte und Werkzeug-Formeln, vierteilige Schadensfolge mit
Halbkreis/Rückstoß, genau zwei Rig-Griffpunkte, einmalige Todesbelohnung, Rüstung/DR/
Kontaktcooldown, Regeneration nach5s/langer Frame/Max-HP-Upgrades/Overheal/Tod.
Echte Ultimate: Flächenschaden, Stun, Cooldown, temporärer Tempofaktor, Killverlängerung/
Cap/Ablauf und tatsächlicher Ultimate-Kill. Pausen-/Level-/Shop-Gates; Ravox/Longshot/
Spucker-Unterbrechung; alle vier Bosscontroller werden betäubt und erholen sich.
Beide Werkzeugentwicklungen mit tatsächlichem Schaden/Cooldown, echter Shopupgrade-
und Entwicklungsablauf, Neustart, Resultate, JSON-Roundtrip und0.16-Profilergänzung,
Erhalt alter Statistiken/Wallet, Statistik-Reitergrenzen und Audioressourcen.

Bestehende Integration-/Ability-/Twinkle-/Spezialisierungsfixtures um sechsten Helden
und16 Entwicklungen ergänzt. Generische Schadensprüfung bleibt mit Nicht-Tank-Fixture;
die neue Schadensreduktion wird separat geprüft. Nativer Capture fand einen fehlenden
Werkzeug-HUD-Schlüssel; korrigiert, danach alle acht Ansichten fehlerfrei neu erzeugt.
Der Effekte-Referenzlauf beschränkt sich ausdrücklich auf seine historischen fünf
Waffenfamilien; neue Werkzeuge werden separat getestet. Keine Referenzwerte überschrieben.

steelfist_soak.gd: 43.200 feste Schritte /720 simulierte Sekunden, vier Arenen × drei
Stufen × zwei Entwicklungen bei Endlos31, künstlicheHP und vorgegebener Pilot. Max100
Gegner; Positionen/HP endlich, Buff≤10s/Verlängerung≤5s, Sweep≤4/Pressure≤3 eingehalten.
Acht native GL-Compatibility-Vorgabeszenen geprüft: Auswahl, Leerlauf, Doppelschlag,
Ultimate, Entwicklung, Waffendetails, Meisterschaft, Statistik. Keine Android-Screenshots.
Physischer Android-Test, menschliche Balance, Update-Installation und FPS/Thermik offen.

Quell-ZIP zusätzlich frisch ohne Importcache entpackt und importiert. Alle23 Suites
(1.747 Assertions) und beide historischen Traces erneut bestanden. Logs unter
tests/results/v0.17-clean-import.log und v0.17-clean-tests.log.

---

## Historischer Stand vor 0.17

# Testbericht 0.16.0 — 2026-11-17

Godot4.6.3 stable: 22 Suites / 1.644 Assertions / 0 Fehler, beide historischen Traces grün.
80 Live-Checks: UTC-Tages-/Wochenwechsel, Ziele nur durch echte Run-Daten, Tutorial-
Ausschluss, drei verschiedene Arenen, Endlos zählt nicht als Kampagnensieg, wiederholte
Claims abgewiesen, Pass-Stufen/Erneuerung/XP-Überhang, getrennte Wallets, Käufe/Equip,
Doppelkäufe/ungültigeIDs/negativeCoins, echte JSON-Roundtrip-/Korruptdatenbereinigung.
Touchkoordinaten und Wischwahl für Held/Arena, vertikale Drags, Mehrfingerabbruch sowie
echte Input.parse_input_event-GUI-Sequenz innerhalb des Auswahlbuttons ohne Run-Start.

Neue Gegner: echte gesäte Spawnentscheidung, Caps, vollständige Warnzeiten/fester Zielpunkt,
Unterbrechung vor Release, reale Projektil-/Bodengefahr, einmalige Selbstexplosion ohne
Beute, Pause. Vier echte Ereignisse mit zweitem Muster/Abschluss und Shop-/Bossausschluss.
Wave-/Fähigkeitszähler, tatsächliches Finish, Doppel-Finish, Reward-Hub-Kauf und Tabs.
Alte Twinkle-/Mastery-Fixtures an Einzelkarten angepasst. Alter Reaktor-Rollentest
isoliert bisherige Rollen explizit; neues Pack separat im echten Spawner geprüft.
Historische Traces deaktivieren neue Gegner/Ereignisse und frieren alte Wellenregeln ein;
sie behaupten keine Balanceidentität mit0.15. Aktuelle Inhalte separat getestet.

Lastprobe live_soak.gd: 21.600 feste Schritte / 360 simulierte Sekunden, alle drei
Stufen × vier Arenen auf Welle6, Twinkle mit künstlichenHP und vorgegebenem Pilot.
Jedes Ereignis abgeschlossen; maximal39 Gegner / 3 Arenagefahren in dieser Probe,
Gegnergrenze100, individuelle Pack-Caps, endliche Positionen/HP eingehalten.
Kein menschlicher Run, keine Android-FPS-/Thermikmessung. Sechs native GL-Compatibility-
Vorgabeszenen visuell geprüft: Held, Arena, Tagesaufgaben, Pass, Shop, Kampf.

Offen für physische Abnahme: Android-Update mit vorhandenen Daten, echte Wischer auf
verschiedenen Displays, Unterbrechungen, Uhr-/Tageswechsel, Belohnungstempo, Pack-/Event-
Balance und Leistung/Thermik. Kein Gerät perADB verbunden; keine Installation behauptet.

Quellarchiv zusätzlich frisch ohne Importcache entpackt und mit Godot importiert.
Die vollständigen22 Suites (1.644 Assertions) und beide Traces erneut bestanden.
Logs: tests/results/v0.16-clean-import.log und v0.16-clean-tests.log.

---

## Historischer Stand vor 0.16

# Testbericht 0.15.0 — 2026-11-17

Mit Godot 4.6.3 stable ausgeführt: 21 Suites / 1.565 Assertions / 0 Fehler.
52 neue Difficulty-Checks: unveränderte Normal-Startwerte, exakte HP/Tempo/Schaden/
Spawn-/Rewardwerte, alle vier Bosskämpfe auf Veteran/Mayhem, echte Siege mit getrennten
Rekorden, Endlos-Boss20 → Shop →21, Elitefaktoren genau einmal, nicht änderbare Run-Stufe,
volle Warnzeit, Tutorial-Normalzwang, reale JSON-Migration/Roundtrip/Korruptwerte/ungültige
IDs, doppelte Ergebnisverarbeitung, echte Auswahlbutton-Signale und Rekordboard.
Beide historischen Traces wie bisher explizit unter eingefrorenen alten Wellenregeln grün;
aktuelle Normal-Regeln und neue Stufen separat geprüft. Keine neue Balanceidentität der
höheren Stufen behauptet. Die tatsächliche Normal-Statsskalierung ist unverändert.

Lastprobe difficulty_soak.gd: 21.600 feste Schritte / 360 simulierte Sekunden, alle drei
Stufen × vier Arenen bei Endlos31. Maximal 100 Gegner, Positionen/HP endlich, Tempo<700.
Künstliche HP und vorgegebener Pilot mit Sparky; kein menschlicher Run und keine Android-
FPS-/Thermikmessung. Drei native GL-Compatibility-Vorgabeszenen visuell geprüft: Karten,
Mayhem-Endlos-HUD und getrennte Rekorde. Geräte-/Touch-/Balance-Abnahme noch offen.

---

## Historischer Stand vor 0.15

# Testbericht 0.14.0 — 2026-11-16

Godot 4.6.3 stable: 20 ausgeführte Suites / 1.513 Assertions / 0 Fehler.
Worlds/Endlos: 117 Checks, Kicksy: 34 Checks, zusätzliche Bestandsprüfungen wegen
vier Arenen/fünf Helden/14 Entwicklungen. Bestehende Display-Balance-Sollwerte wurden
an ausdrücklich gewünschte zusätzliche Faktoren angepasst, keine Fehler ausgeblendet.

Neue Prüffälle: vier Arenen mit echten Assets/Bossen, Kampagnen-Sieg; Endlos-Bosse
10/20/30 samt tatsächlichem Kill → Shop → 11/21/31, Timeout, Welle1001, Stats/JSON-
Migration/Doppelwertung, unabhängige Kampagnenzähler, unverfälschte HP im HUD;
strict steigende Wellenwerte, begrenztes Tempo, sichere XP-Formel/Levelcap-Rückkehr,
vorausschauende KI ohne manipulierte Bosszielrichtung, begrenzte Quoten-Speicherung,
echte Gefahrenwarnung beider Arenen, Filter/Kalibrierung des Neigungseffekts.

Tutorial komplett durch tatsächliche Bewegung, Kill, Loot-Pickup, Upgrade, Fähigkeit,
Ravox-Ausweichen, Kauf, Reroll, Werkstatt, Pause/Resume und Abschluss geprüft. Kein
Kampfrekord-/Modus-Leak. Coach-Touch kollidiert nicht mit Joystick-Aktivierung.
Kicksy: beide Freischaltkriterien einschließlich kombinierter Endlos-Kills, Lock-Bypass,
Speichern/Laden, Tempo 242, echter Bombenflug/Explosion/Poollimit, Multishot, beide
Entwicklungen, präzise Brand-Lebenszeit, keine Feldstapelung/Explosion-Rekursion,
Kettenreaktion, Pause/Level-up/Shop, reale Boss-Siege aller vier Arenen, Werkstatt und
sofortige Freischaltung bei Tutorialabschluss. Kein Selbstschaden.

Beide historischen Traces bestanden: Welt 33 Punkte/3.600 Schritte, Effekt 87/8.700.
Beide deaktivieren ausdrücklich die neue 0.14-Progression; Effekttrace außerdem neue
Encounters/Ravox und neuere Waffen. Sie prüfen Regressionen unter alten Regeln,
nicht unverändertes aktuelles Balancing. Aktuelle Regeln separat getestet.

Lastprobe worlds_soak.gd: 36.000 feste Schritte (~600 simulierte Sekunden), vier Arenen
× fünf Helden bei Endlos-Welle31, alle Qualitätsstufen enthalten. Peak 100 Gegner;
Bomben-/Folgeereignis-/Brandfeldcaps eingehalten, keine NaNs. Künstliche HP und Pilot,
keine Aussage über menschliche Fairness oder Android-FPS. Native Galerie aus neun
Vorgabeszenen geprüft, inklusive Coach, fünfter Heldin und Endlos-Bossen.
Zwei neue WAV-Cues auf gültiges Mono-44,1-kHz-Signal ohne Clipping geprüft.

Android-Sensor-Hardware, Touch auf echtem Gerät, Thermik und Kampagnen-/Endlos-Balance
noch offen. Keine physische APK-Installation oder AAA-Abnahme behauptet.

Abschließende Archivprüfung: frischer Import ohne .godot-Cache, gesamte Suite erneut
grün. Audiofreigabe beim Testende einer Produktionstouch-Fixture wird vor Quit
abgewartet; keine Ressourcenfehler im abschließenden Lauf.


---

## Historischer Stand vor 0.14

# Testbericht 0.13.0 — 2026-11-16

Tatsächlich ausgeführt mit Godot 4.6.3 stable: 18 Suites / 1.216 Assertions / 0 Fehler.
52 Ravox-Checks: beide Arenen und alle Wellen, Basis-/skalierte Werte, Chance/Fallback,
aktive Caps und Wellenkontingent über Tod/Cleanup/Neustart, volle Vorwarnung auch bei
langem Frame, fixes Ziel, Ausweichen, Swept-Kollision samt exaktem +15-%-Schaden,
Verlangsamung gegen vorausberechnete Falschtreffer, Knockback, reale Seife/Schockwelle/
Tornado/Schattenschritt, Pause/Level-up/Shop, sichtbare Warnung/Abbruch außerhalb der
Kamera, Tod/Beute genau einmal, korrektes Todessprite, Game Over und Neustart.

Beide historischen Traces bestanden (Welt 33 Punkte/3.600 Schritte, Effekt 87/8.700).
Effekt-Fixture deaktiviert ausdrücklich neue Ravox-Spawns; die aktuelle 52-Check-Suite
und Lastprobe prüfen diese. Der neue spätere Wellenmix ist absichtlich verändert.

Lastprobe in ravox_soak.gd: 28.800 feste Schritte (~480 simulierte Sekunden), vier Helden
in beiden Arenen; alle drei Qualitätsstufen enthalten. Künstliche HP / vorgegebener Pilot.
Maximal 100 Gegner, zwei Ravox gleichzeitig, vier Ravox pro Welle, ein Sturm/Windup zur
Zeit. Keine NaN-Positionen, keine Caps-Verletzung. Keine Android-FPS-Aussage oder
menschliche Balanceabnahme. Drei native GL-Compatibility-Vorgabeszenen visuell geprüft:
Schrottplatz-Warnbahn, Reaktor-Warnbahn und Seifenunterbrechung. Keine Android-Screenshots.
Zwei selbst synthetisierte WAVs auf gültiges Mono-44,1-kHz-Format/Signal/Clipping geprüft.

Während Umsetzung Konstanten-Parserfehler und unpassende Kameratestposition behoben;
abschließende Import-/Test-/Galerielogs fehlerfrei. Geräte-/Touch-/Schwierigkeitsabnahme offen.

---

## Historischer Stand vor 0.13

# Testbericht 0.12.0 — 2026-11-16

Godot 4.6.3 stable: 17 tatsächlich ausgeführte Suites / 1.164 Assertions, 0 Fehler.
65 neue Twinkle-Assertions: Werte/Klassenbindung, Halbkreis vorne/seitlich/hinten/weit,
exakter Flächenbonus, Stun/Bewegung/Kontaktschaden/Resistenz, Gift-DPS/Überlagerung/
Austritt/Lebenszeit bei langem Frame, Heilung bei Kill 19/20/40 und doppeltem Tod,
Bossimmunität, komplette Tornadodauer/DPS/Cooldown/Rückstoß, alle Pausenzustände,
Grafikstufen, beide Entwicklungen und Arenen, echte Boss-Victory und Game Over,
Neustart, Shopkauf/Upgrade/Entwicklung, echte Menü-Buttons, Produktion-State-Machine,
Touch-Fähigkeitsbutton, Statistik/Historie sowie Laden eines alten Schema-3-Profils.
Meisterschaftssuite prüft nun auch den vierten Helden (53 Checks), vorhandene Tests
für Charakterzahl/Entwicklungen sachlich erweitert, keine neuen Fälle ausgeblendet.

Beide historischen Traces weiterhin grün: Welt 33 Punkte/3.600 Schritte, Effekt 87
Punkte/8.700 Schritte. Die Effekt-Fixture bleibt ausdrücklich bei zehn ursprünglichen
Entwicklungen und deaktiviert neue 0.10-Encounters; aktuelle Mechaniken separat geprüft.

Lastprobe: 46.482 feste Schritte (~774,7 simulierte Sekunden), beide Arenen × drei
Qualitätsstufen, Welle-9-Last und folgende Bossphase. Peak 52 Gegner, 5 Felder, 1 Sweep.
Künstlich hohe HP und festgelegter Pilot, keine menschliche Spielprobe. Schrottplatz
3/3 Siege, Reaktor 3/3 Zeitlimits. Die Probe zeigt Funktion/Caps/Bereinigung, keine
bestätigte Boss-Fairness. Neue Android-Performance-/Thermik-/Touch-Abnahme bleibt offen.

Vier native GL-Compatibility-Screenshots nach finalem Code geprüft (Auswahl, Mopp,
Tornado, Entwicklung). Vorgabeszenen mit festgelegten Gegnerpositionen, keine Android-
Screenshots. WAV-Audit: drei originale Mono-44,1-kHz-Cues, nicht stumm, kein Clipping.
Logs/Manifest/Signatur/Audit: tests/results/v0.12-*. Mehrere während Entwicklung
gefundene Fixture-/HUD-Fehler behoben; abschließende Suite ohne diese Fehler grün.

---

## Historischer Stand vor 0.12

# Testbericht 0.11.0 — 2026-11-16

Ausgeführt mit Godot 4.6.3 stable: 16 Suites, 1.075 Assertions, 0 Fehler.
Davon 44 neue Meisterschaftsprüfungen; bestehende UI-Suite zählt mit zusätzlichem
Menübutton nun 102 Assertions. Beide historischen Regressionstraces ebenfalls grün.
Die historische Effekt-Fixture deaktiviert weiterhin ausdrücklich 0.10-Encounters;
diese werden von ihrer eigenen 104-Assertion-Suite geprüft.

Neue Prüfungen: Schwellen unmittelbar darunter/darauf für alle drei Helden;
Fortschritt getrennt je Held; kumulative Kills; Titel; gesperrte/fremde IDs;
echte JSON-Datei speichern/laden, bestehende Schema-3-Profile, Schema-1-Totals ohne
falsche Zuordnung, ungültige Auswahl; tatsächliche UI-Buttons für Navigation,
Vorschau/Ausrüsten/Zurück; Portraitauswahl; unveränderte Kampfwerte; echtes finish()
bei Niederlage/Sieg, Ergebnistext und Schutz vor doppelter Wertung.

Native GL-Compatibility-Captures in tests/mastery_*.png visuell geprüft, inklusive
prozeduraler Abzeichen und lesbarer Fortschrittsbalken. Vorgabeszenen, kein echter Run.
Keine neue Lastprobe nötig: keine Kampfmechanik ergänzt; frühere Lastproben bleiben
historisch ausgewiesen. Android-Gerät, FPS/Temperatur und Touch-Abnahme noch offen.
Logs: tests/results/v0.11-*.log. Reproduktion: python3 tools/run_tests.py --traces.

---

## Historischer Stand vor 0.11

# Testbericht 0.10.0 — 2026-11-16

Godot 4.6.3 stable, Linux Headless und native Mesa-Ansichten. Logs tests/results/v0.10-*.
1.030 Assertions bestanden: 926 bestehende plus 104 Encounter-Prüfungen. Keine Parser-/
Ressourcenfehler oder Fehlassertions in finalen Suiten.

Neue Suite prüft 20 Arena-/Wellenkombinationen, echten Spawn-Ersatz/Cap/Einführungszeit,
HP/Identität, fixierte Warnung, volle Warnzeit trotz großem Frame, einmaligen Swept-
Sturmtreffer, Angriffabbruch durch Knockback/Schockwelle auch an Wänden und Offscreen-
Schutz. Der Kameratest setzt echte Landscape-Sicht und verschiebt Kamera/Spieler in
andere Arenaecken; er verlässt sich nicht nur auf Spielerabstand.
Ringöffnung/Innen-/Außenzone und echter Schaden geprüft, Elite-Tod löscht eigene
Gefahren. Keine doppelte Belohnung, Zusatzcoins/XP, Cache über Wellenende, echte
Wahlwirkungen und Item-Synchronisation. Marktaktionen/Weitergehen während Cache blockiert,
Nonce nicht wiederverwendbar, Übergabe an obligatorische Entwicklung und dann Markt.
Pause/Level-up/Shop frieren neue Systeme ein; Neustart löscht Runzustand.

Beide Bossphasen-Schwellen, direkte Phase-III-Sprünge, keine Rückstufung, vollständige
neue Warnung, arenaeigene Muster, sichtbare sichere Ringöffnung, alte Feindschüsse weg/
eigene behalten, Ablauf nach großem Frame, Sieg und Tod durch neue Gefahr während
Iteration geprüft. Shade-Dash bleibt gegen diese Treffer geschützt. Elite-Runrecord
wird kompatibel sanitisiert. Normale Charakter-/Waffen-/Wellen-JSONs unverändert.

Welttrace 33 Punkte/3.600 Schritte bestanden, neue Begegnungen dabei regulär aktiv,
aber frühe Wellen unverändert. Effekttrace 87 Punkte/8.700 Schritte unter eingefrorenen
alten Wellen und ausdrücklich deaktiviertem 0.10-Director: prüft Legacy-Verhalten,
keine Behauptung unveränderter später Kämpfe mit neuen Bossphasen.

Lastprobe: 43.200 Schritte / 720 simulierte Sekunden, beide Arenen × drei Helden,
LOW/MEDIUM/HIGH, Start mit 100 Gegnern, echte Elite- und Bossphasen. Peaks: 100 Gegner,
3 Zusatzgefahren, 25 Poolobjekte, 1 wartende Beute. Gegner-/Rollen-/Loot-/Poolcaps
gehalten. HP/Zeit für Lastprüfung künstlich hochgehalten; falls nötig wird Elite
nach 55 Sekunden über reale Schaden-API getötet, um Beutefluss zu testen. Boss-HP in
Lastfixture 500.000, Phasen zeitlich angesteuert. Keine reale Run- oder Fairnessabnahme.

20 isolierte Boss-DPS-Proben mit vorgegebenem Build/zehn Entwicklungen × zwei Arenen
unter 90 Sekunden; Boss-KI und eingehender Schaden darin aus. Keine Ausweichprüfung.
Sechs tatsächliche Godot-Renderbilder zeigen Elitewarnungen, offene/aktive Ringe,
Beutewahl und beide Boss-Zusatzmuster. Zustände/Stats per Fixture vorgegeben.
Offen: neue Mechaniken, Lesbarkeit/Audio und Ökonomie auf physischem Android-Gerät,
FPS/Temperaturmessung. Automatisierte/native Prüfungen ersetzen diese Abnahme nicht.

Weitere Regression: Boss-Grundangriffscursor bleiben bei Specials erhalten.
Verlangsamte Stürme treffen nur entlang der tatsächlich zurückgelegten Strecke.
Alle drei Beutebuttons wurden über ihre echten Signale betätigt; auch ein zweiter
Klick auf denselben alten Button gewährt keine weitere Belohnung.


---

## Historischer Stand vor 0.10

# Testbericht 0.9.0 — 2026-11-16

Godot 4.6.3 stable, Headless plus natives Mesa-Rendering. Logs tests/results/v0.9-*.
926 Assertions bestanden: 825 bisherige + 101 neue Neon-Interface-Prüfungen.
Keine Parser-/Ressourcenfehler oder fehlgeschlagenen Assertions im finalen Lauf.

Neue Suite: alle 49 semantischen Grafikressourcen, zehn Upgrade-IDs, passende
Aktionsicons, tatsächliche Buttons/Touchgrößen und LOW/MEDIUM/HIGH; LOW ohne Motion/
Weichzeichner. Illustration wirklich integriert, Statistik mit Lesbarkeitsscrim trotz
unverändertem Main-Menu-Spielzustand, echte Angebots- und Level-up-Grafiken statt
Symbolzeichen, Kampf während Shop angehalten. Produktionsübergang beginnt transparent
und endet auf exakter Touchposition; rasche Wechsel ignorieren alte Revisionen,
keine unsichtbar bleibenden Buttons. Acht Gegenstände am Run-Ende passen mit Umbruch
in die Ergebnisfläche. Test enthält echte Prozessframes, keine bloßen Mock-Callbacks.

Referenztraces weiterhin bestanden: Welt 33 Punkte/3.600 Schritte, Effekte 87 Punkte/
8.700 Schritte unter ausdrücklich historischen eingefrorenen Wellen. Keine Aussage,
dass heutige späte Wellen mit Versionen vor 0.7 identisch wären. Datenverzeichnis
gegenüber 0.8 unverändert; Änderungen an game.gd betreffen Darstellung/Navigation.

Native Galerie: Hauptmenü, Charaktere, Arenen, Vorbereitung, Einstellungen, Pause,
Sieg; Shop/Inventar/Sets/Werte/Werkstatt/Hilfe; Statistik, Verlauf, Ziele, Level-up,
Bestätigungen, Entwicklung und vollständiger Niederlagen-Build. Neue Bildebene mit
Weichzeichner separat von Text/Bedienung. Mehrfachnavigation und Glyphen im nativen
Render kontrolliert. Teststatistiken sind Vorgaben und keine gespielten Android-Runs.

Zusätzlich Engine-Mitschnitt aus 84 gerenderten Frames bei festem 30-Hz-Zeitmaß,
als 2,8-Sekunden-GIF kodiert. Kein gemessener 30-/60-FPS-Android-Nachweis.
16:9, 1280×591 und Tablet: Hintergrundgeometrie deckt den Viewport ab. Einzelne sehr
dunkle Motivpixel in alten Kanten-Helligkeitsproben sind keine Balken; aktuelle
Darstellung anhand Geometrie und sichtbarem Motiv geprüft. Safe-Area-/Touchtests grün.

Offen: neue Oberfläche auf echter Android-Hardware einschließlich Notch/Launcher-
Maske, Schriften, Übergängen und Last/FPS/Temperatur abnehmen. Export und native
Renderprüfung ersetzen diese Abnahme nicht.

---

## Historischer Stand vor 0.9

# Testbericht 0.8.0 — 2026-11-16

Godot 4.6.3 stable. Tatsächliche Logs in `tests/results/v0.8-*`.
825 Assertions bestanden: 798 bestehende und 27 Präsentation/Audio. Final keine
Parser-, Ressourcen- oder Testfehler. Ausführung mit --headless --fixed-fps 60.

Die neue Suite prüft eingebaute Logo-/Iconressourcen, zwei Fonts, echtes Logo im
Menübaum, touchdurchlässige Dekoration, ausreichend große Menübuttons, Zustand für
Musikauswahl, beide Looplängen, Pause/Resume-Lautstärke, eingefrorenen Kampf,
separate Null-/Masterregler, reservierte UI-/Bossstimmen bei zwölf belegten Effekten,
Cacheidentität, Pickup-Begrenzung und weiterhin verbundenen Shop/Resultat/Neustart.
Mixerfreigabe am Testende wartet echte Millisekunden, unabhängig von der beschleunigten
Simulationszeit. Quellen/Datenpreise nicht geändert; Git-Diff data/ bleibt leer.

Weltvergleich 33 Punkte/3.600 Schritte bestanden. Effektvergleich 87 Punkte/8.700
Schritte mit historischen eingefrorenen Wellendaten bestanden. Letzterer prüft
weiterhin ausdrücklich alte Regeln, keine neue Balanceidentität zu Versionen vor 0.7.

Native Mesa-Renderbilder: sieben neue Bildschirmansichten (Menü, Charakterwahl,
Arenen, Vorbereitung, Einstellungen, Pause, Sieg); sechs Shopansichten; Vollbild
16:9/breit/Tablet. Vorgabeszenen mit Teststatistiken, keine echten Android-Runs.
Neue Regler/Schrift/Studio-/Wortmarke visuell kontrolliert. Alle gemessenen breiten
Renderkanten ohne schwarze Seitenpixel. Bilder tests/presentation_*.png und shop_*.png.

Audiotechnik: 31 WAVs nicht stumm, ohne digital geclippte Samples; zwei Ogg-Musiken
decodiert und auf endliche, nicht stumme Samples geprüft. Das ist keine subjektive
Hörabnahme der Mischung auf Android. Kein physisches Gerät, keine FPS-/Hitzeprüfung.
Hardwareabnahme von UI, Icon/Launcher-Maskierung, Lautsprecher/Kopfhörer noch offen.


---

## Historischer Stand vor 0.8

# Testbericht 0.7.0 — 2026-11-16

Godot 4.6.3 stable, Linux Headless und native Mesa Compatibility. Tatsächliche Logs:
`tests/results/v0.7-*.log`. Keine physische Android-Abnahme/FPS-Messung.

| Suite | Bestanden |
|---|---:|
| Integration | 76 |
| Kampfgrafik | 28 |
| Klassenbindung/Haltung | 42 |
| Welt/Bosswarnungen | 36 |
| Statistik/Speicherung | 28 |
| Reaktor/Migration | 157 |
| Fähigkeiten/Touch/Haptik | 76 |
| Waffenspezialisierungen | 108 |
| Effekte | 40 |
| Reaktorgegner | 66 |
| Display/Balance | 100 |
| Shop/Items/Sets | 41 |
| Gesamt | 798 |

Shop prüft echte Käufe/Einmalabzug, Tradeoffs, Set-Aktivierung/-Verlust, wiederholtes
Synchronisieren, Erhalt von Levelboni, direkte Waffenupgrades bis Entwicklung,
Verwertungsrefunderstattung/letzte-Waffe-Schutz, unzureichende Coins, gültige Angebote,
Stats-/Detailansichten, eingefrorene Simulation, Wellenpersistenz und Neustartreset,
Crit-/Rüstungscap, HP-Untergrenze, Item-Historie und gespeicherten Hilfezustand.

Displayprüfung: fünf Seitenverhältnisse inkl. 32:9, drei simulierte Safe-Areas,
Kamera innerhalb Arena, echtes GUI-Pause-Klicken außerhalb der alten 1920er Breite,
Multitouch an drei Formen, Ablehnung neuer Touches in unsicheren Aussparungsbereichen.
Erste drei Wellen gegen eingefrorene 0.6-JSONs geprüft, beide späten Arenen stärker,
Belohnungen und Spawngruppen begrenzt. Fixture-Provenienz: Commit 72b145d.

Native Renderprüfung: Menü/Kampf 16:9, 1280×591 und Tablet; Ergebnis breit/Tablet.
Shop zusätzlich sechs 1280×591-Ansichten. Keine schwarzen Seitenpixel an den
geprüften Renderkanten. PNGs in tests/. Mesa warnt mangels VSync-Unterstützung;
Dummy-Audio beim visuellen Test. Das prüft keine Android-Systemleisten auf Hardware.

Regressionsvergleich Welt: 33 Kontrollpunkte/3.600 Schritte mit früherem Schrottplatz.
Effektvergleich: 87 Punkte/8.700 Schritte, alle zehn Waffenwege/Fähigkeiten/alter Boss.
Dafür werden ausdrücklich ALTE eingefrorene Wellen im Test injiziert; neue späte
Balance wird nicht als identisch behauptet. Produktion nutzt neue WaveBalance-Daten.

Lastprobe: 21.600 Schritte/360 simulierte Sekunden, beide Arenen × drei Helden,
LOW/MEDIUM/HIGH, Start mit 100 Gegnern und acht Items. Caps 100 Gegner, 6 Spucker,
2 Drohnen, 2 Warnungen, 320 Schüsse, 240 Loot und Effektlimits eingehalten.
Bot flieht auf festem Kreis; Shade teils null Kills, kein Fairness-/Run-Sieg-Beweis.

20 isolierte Boss-DPS-Proben (10 Entwicklungen × 2 Arenen) jeweils unter 90 Sekunden,
mit definiertem spätem Build ohne Itemboni. Gegnerbewegung/eingehender Schaden dabei
ausgeschaltet; beweist Erreichbarkeit des HP-Ziels, keine vollständigen Runs.
Analytische Druckprobe vergleicht Spawn-/HP-/Belohnungsfluss vor Caps/Spielerkills.
Offen: echte Android-Runs für neue Schwierigkeit und Shopökonomie, FPS/Temperatur,
Notch/immersiver Modus und alle Touch-Flows auf Hardware.

Quell-ZIP frisch in leeres Verzeichnis entpackt: Godot-Import ohne Parser-/Ressourcenfehler;
Shop 41/41 und Display/Balance 100/100 daraus erneut bestanden. Logs v0.7-clean-*.log.

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
