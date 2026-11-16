# Mayhem Survivors — RF Worlds

Android Alpha **0.4.0** · Godot **4.6.3 stable** · GDScript · GL Compatibility

## Spielen

`project.godot` in Godot importieren und starten. Ausschließlich Android-Export:
ARM64, Querformat, Android 7.0+, Paket `com.rfworlds.mayhemsurvivors`, offline.
Links unten per Touch-Joystick bewegen, Waffen greifen automatisch an. XP einsammeln,
Upgrades wählen, zwischen neun 60-Sekunden-Wellen einkaufen. Welle zehn hat ein
90-Sekunden-Limit: Boss besiegen oder verlieren. Pause oben rechts.

## Neu in 0.4

Rechts unten liegt ein eigener Fähigkeitenbutton mit Symbol und Abklinganzeige.
Joystick und Fähigkeit lassen sich mit zwei Fingern gleichzeitig bedienen.

| Held | Fähigkeit | Abklingzeit |
|---|---|---|
| Bruiser | Schockwelle: 48 Basisschaden, Nahkampfbonus, Radius 250; normale Gegner werden um 90 zurückgestoßen | 12 s |
| Sparky | Impulsgranate: nächstes Ziel bis 450, 0,65 s Zünder, 40 Basisschaden in Radius 180; normale Gegner zwei Sekunden auf 40 % Tempo | 10 s |
| Shade | Schattenschritt: 300 Einheiten in Bewegungsrichtung, 0,18 s unverwundbar; 26 Basisschaden pro durchquertem Gegner | 8 s |

Aktive Fähigkeiten skalieren mit Schaden/Kritchance; Bruisers Schockwelle zusätzlich
mit seinem Nahkampfbonus. Bosse sind gegen Rückstoß und Verlangsamung immun.
Ohne Ziel wirft Sparky nach vorne; ohne Bewegungsschub nutzt Shade seine Blickrichtung.
Ein Schritt direkt gegen die Arenagrenze verbraucht keine Abklingzeit. Jede Welle
beginnt mit bereiter Fähigkeit. Pause, Shop und Levelaufstieg halten alle Fähigkeitstimer an.

Eigener Schaden erscheint rot mit kurzem Randfeedback, kritische Treffer größer und
gold mit Ausrufezeichen. Schadenszahlen sind abschaltbar; LOW/MEDIUM/HIGH begrenzen
deren Anzahl auf 24/40/64. Vibration ist standardmäßig AUS, optional DEZENT oder STARK.
Vibration benötigt die normale Android-Berechtigung `VIBRATE`; kein Berechtigungsdialog.
Die tatsächliche Stärke hängt vom Gerät ab. Eigene SVG-Symbole und vier synthetisierte
WAV-Sounds; Generator unter `tools/generate_ability_audio.py`.

Diese Erweiterung fügt aktive Möglichkeiten hinzu. Grundwerte der Waffen/Gegner,
Klassenbindung und Wellen bleiben gleich; ohne Fähigkeitseinsatz besteht der
bisherige deterministische Schrottplatzvergleich weiter.

## Arenen aus 0.3

Nach der Charakterwahl folgt die Arena-Auswahl. Der Schrottplatz behält seine
bisherigen Kampfwerte. Die Reaktorzone wird durch den ersten Sieg freigeschaltet;
Siege aus älteren Versionen zählen mit. Eigener Boden, Gegnerzusammensetzung und
ab Welle drei angekündigte Strombahnen. Diese sind vor der Aktivierung ungefährlich.

Der Reaktorwächter ist eine eigene vierbeinige Maschine mit 4.200 HP: angekündigte
Kreuzlaser, drei fixierte Kernbomben und ein gerichteter Impulsfächer mit vier Salven.
Keine beweglichen Hindernisse. Alle Warnungen und Angriffe pausieren gemeinsam mit
dem Kampf und werden beim Wellenende/Neustart entfernt.

Statistik und Verlauf lassen sich nach Arena und Held filtern. Unter „Ziele & Stile“
sind drei Bodenringe erspielbar: erster Sieg, 1.000 Gesamtkills, Reaktorsieg.
Die Auswahl wird gespeichert und beeinflusst keine Kampfwerte.

| Held | Waffen |
|---|---|
| Bruiser | Hammer |
| Sparky | Blaster, Splitgun, Arc Cannon |
| Shade | Orbit Blade |

Die akzeptierte Haltung mit zwei Händen und einer sichtbar gehaltenen Waffe bleibt.
Sparkys weitere ausgerüstete Waffen greifen weiterhin automatisch an.

## Lokaler Speicher

`user://save.json`, Format 3. Format 1/2 wird automatisch geladen und vor der
Übernahme als `save.v1.backup.json` beziehungsweise `save.v2.backup.json` gesichert.
Bisherige Gesamtwerte und Einstellungen bleiben erhalten. Alte Runs gehörten zum
Schrottplatz; fehlende historische Heldenzuordnungen werden nicht erfunden.
Beschädigte Dateien erhalten ein `.corrupt.json`-Backup. Kein aktiver Run-Resume.

## Prüfen und bauen

```sh
godot --headless --path . --editor --import --quit
godot --headless --path . --fixed-fps 60 --script res://tests/integration.gd
godot --headless --path . --fixed-fps 60 --script res://tests/reactor_test.gd
godot --headless --path . --fixed-fps 60 --script res://tests/world_trace.gd
godot --headless --path . --export-debug Android builds/android/MayhemSurvivors-v0.4-debug.apk
```

Für Export Godot-Android-Template, JDK 21 und Android SDK konfigurieren. Private
Signierschlüssel/SDK sind nicht Teil des Quellprojekts. Test-APK separat verfügbar.
Weitere Tests und tatsächliche Ergebnisse: [TEST_REPORT.md](TEST_REPORT.md).
Exportdetails: [BUILD_REPORT.md](BUILD_REPORT.md).

## Assets und Grenzen

Eigene generierte Comic-Grafiken und prozedurale Effekte; eigene synthetisierte
WAV-Effekte/Musik. Keine kopierten Figuren, Sounds oder Oberflächen aus Brotato.
Keine Werbung, Käufe, Server oder bezahlten Plugins. LOW/MEDIUM/HIGH begrenzen nur
Effekte. Ziel 60 FPS auf geeigneten Geräten, keine gemessene Android-FPS-Zusage.

Version 0.4 wurde automatisiert und mit Godot/Mesa geprüft. Ihr kompletter
Android-Praxistest, echte Multitouch-/Vibrationsprüfung, Geräteleistung und das Balancing aller drei Helden stehen noch aus.
Der Nutzer hat den älteren Schrottplatz mit Sparky erfolgreich durchgespielt.
