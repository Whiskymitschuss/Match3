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
