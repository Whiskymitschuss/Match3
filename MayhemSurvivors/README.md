# RF Worlds — Mayhem Survivors 0.26.0 Alpha

Android-Arena-Survival mit 15 Kämpfern, zehn freischaltbaren Welten, Kampagne und
Endlos. Godot 4.6.3 stable / GDScript / ARM64 / vollständig offline.

## Neu in diesem Update

- Vier zusätzliche Kämpfer im gemeinsamen Comicstil: **Viper**, **Echo**, **Nova**
  und **Rivet**. Eigene passive und aktive Fähigkeiten, Effekte und Sounds.
- Neues Hauptmenü mit SPIELEN, CHARAKTERE, AUFTRÄGE, STATISTIK, EINSTELLUNGEN und
  SAMMLUNG. Tutorial und Handbuch findest du unter Einstellungen → Steuerung.
- Aufgeräumte Einstellungen mit Audio, Grafik und Steuerung. Lautstärke, Qualität,
  Vibration, Neigung, ruhige Menüs und Trefferanzeigen bleiben lokal gespeichert.
- Fünf sichtbare Waffen-Skins mit Lackierung, Mustern, Schussfarben und Vorschau.
  Über Stil-Cases oder erspielte Studio-Coins erhältlich; keine Werteboni.
- Neue eigene Musik für Menü, Kampf und Boss. Überarbeitete Schuss-/Treffersounds,
  neue Fähigkeitensounds und ein Begrenzer für Pegelspitzen im gesamten Audiomix.
- Run-Analyse mit aktiver Kampfzeit, Wellen/Bossen, tatsächlichem HP-Verlust und
  zusätzlichem Modulschaden. Auch später im lokalen Verlauf erreichbar.

## Die Crew

Bruiser, Sparky, Shade, Twinkle, Kicksy, Steelfist, Cinder, Frosty, Volt, Rook, Nyx,
Viper, Echo, Nova und Rivet. Bruiser ist zu Beginn frei; weitere Figuren werden mit
Crew-Cases freigeschaltet. Vorhandene Figuren und Spielstände bleiben erhalten.

| Neue Figur | Startwerte | Spielweise |
| --- | --- | --- |
| Viper | 95 HP / 215 Tempo / Blaster | Direkttreffer vergiften; Toxinnebel trifft einen Bereich |
| Echo | 110 HP / 205 Tempo / Splitgun | +12 % Fernschaden; Bassstoß unterbricht normale Gegner |
| Nova | 105 HP / 200 Tempo / Arc Cannon | Heilung je 25 Kills; Lichtpuls heilt und schützt; auch Blaster verfügbar |
| Rivet | 100 HP / 220 Tempo / Blaster | +20 % Projektiltempo; Reparaturdrohne kämpft mit und heilt |

Alle Figuren nutzen dieselbe modulare Darstellung mit genau zwei Armen/Händen.
Waffenlevel 1–5 und die bestehenden Entwicklungen bleiben für ihre Klassen verfügbar.

## Spielen und installieren

Die signierte Debug-APK als Update über die vorhandene App installieren. Paketname:
`com.rfworlds.mayhemsurvivors`, versionCode 32. Gleiches Update-Zertifikat.
Android ARM64, minSDK 24, Querformat, GL Compatibility. Nur Vibration als Berechtigung.

Im Spiel links mit dem Touch-Joystick bewegen. Waffen greifen automatisch an.
Rechts die Fähigkeit benutzen. Zehn Wellen pro Welt; Boss in 2 / 4 / 6 / 8 / 10.
Zwischen Wellen einkaufen, aufrüsten und Entwicklungen wählen. Run-Coins gehören
zum Durchlauf; Studio-Coins dienen der dauerhaften Sammlung. Keine Werbung,
Echtgeldkäufe oder Onlinepflicht. Ein aktiver Run wird nach vollständigem App-Ende
noch nicht wiederhergestellt.

Für das Quellprojekt `project.godot` mit Godot 4.6.3 stable öffnen und starten.
Alle notwendigen Grafiken, Musikstücke, Sounds und Konfigurationen sind enthalten.
Python, NumPy und FFmpeg sind nur zur optionalen Neugenerierung der Musik erforderlich,
nicht zum Importieren oder Spielen. Es gibt ausschließlich ein Android-Exportpreset.

## Sammlung, Hilfe und Prüfung

- [Präsentationsupdate und neue Kämpfer](PRESENTATION_UPDATE.md)
- [Run-Analyse und Messgrenzen](RUN_ANALYSIS.md)
- [Klassenmodule](SYNERGIES.md)
- [Testbericht](TEST_REPORT.md), [Buildbericht](BUILD_REPORT.md)
- [Fortschritt](PROGRESS.md), [Änderungen](CHANGELOG.md), [Roadmap](ROADMAP.md)

Automatisierte Suiten: `python tools/run_tests.py --traces`. Godot muss auf PATH
liegen. Zusätzliche native Touch- und Darstellungsprüfungen sind unter tests enthalten.
Automatisierte Tests und Linux-GL-Aufnahmen ersetzen keine physische Android-Abnahme,
menschliche Balancebewertung oder Messungen von Akku, Temperatur und 60 FPS.
