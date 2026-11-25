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
