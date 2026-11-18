# Einzelprüfung des Auftrags — 0.21.0

| Punkt | Umsetzung / Abnahme |
| --- | --- |
| 01 Grundlagen | Godot 4.6.3, GDScript, Android ARM64, offline, Landscape; keine PC-Eingabe als Spielfeature |
| 02 Spielablauf | Menü → Held → Welt → zehn Wellen → Shops/Upgrades → Abschluss/Niederlage → Neustart geprüft |
| 03 Identität | Eigene Logos, Icon und Cartoon-Atlanten; gemeinsame Konturen, Proportionen, Palette |
| 04 Android/UI | GL Compatibility, 1920×1080-Layout, Safe Area, Vollbild/Edge-to-edge; echtes Gerät noch offen |
| 05 Struktur | Vorhandene Projektstruktur mit modularen Expansion-Managern erweitert |
| 06 Zustände | Zentrale Übergänge; Kampf nur COMBAT; neuer kompletter Lauf mit aktiver Wache getestet |
| 07 Hauptmenü | Branding, große Buttons, Hilfe, Garage, Aufgaben und bewegter Hintergrund verbunden |
| 08 Charaktere | 11 statt 3; nur Bruiser frei, übrige erspielbar; eigene Klassenwerte und Fähigkeiten |
| 09 Steuerung | Touch-Joystick, Deadzone, Multitouch, Bounds; Wischwahl für Helden und Welten |
| 10 Kampf | Autosuche/-angriff, Crit, Cooldowns, Klassenbindung, Slots und begrenzter Projektilpool |
| 11 Waffen | 13 statt 5; Stufen 1–5; je zwei Entwicklungen; neue Mechaniken direkt geprüft |
| 12 Gegner | 19 normale Rollen, davon 10 neu; Verfolgung, Warnangriffe, Caps und einmaliger Tod/Beute |
| 13 Arena | 10 eigene Bodenbilder, Grenzen, offene Bewegungsflächen und Folge-Kamera |
| 14 Wellen | Aktueller Auftrag: Bosse in 2/4/6/8/10; Normalwellen 60 s, Bosslimits 60–90 s |
| 15 XP | Kristalle, Magnet, Formel, mehrere Level-Up-Wahlen und Pause; Boss-XP vor Zwischen-Shop |
| 16 Upgrades | Zehn Basis-Upgrades, Gültigkeit und Caps; neue Projektilwaffen berücksichtigt |
| 17 Shop | Vier Angebote, Kaufen/Reroll, Items, Sets, Waffenaufwertung und Entwicklungen |
| 18 Bosse | Säurepanzer, Schrottwalze, Axel, Sturmadmiral und zehn eigene Arena-Endbossbilder/-namen |
| 19 HUD | HP/XP, Welle/Zeit, Coins/Waffen, Pause, Fähigkeiten, Bossphasen; optionale FPS |
| 20 Pause | Menüs nutzbar, Simulation und neue Zeitgeber angehalten, Lifecycle-Pause vorhanden |
| 21 Speicher | Lokales versioniertes JSON, Backups und beschädigte Daten abgefangen; neue Roster-Defaults |
| 22 Spielende | Sieg/Verlust, Run-Werte, Rekorde, Weltfreigabe, Belohnung, Neustart |
| 23 Ton | Eigene Effekte/Musik; 14 neue Cues; Master/Musik/SFX gespeichert; Gerätehören offen |
| 24 Performance | Zentrale Datenaktoren, Pool, Caps, gedrosselte DOT-Ticks; 110-Szenarien-Soak; Geräte-FPS offen |
| 25 Export | Tatsächliches signiertes ARM64-Debug-APK; Manifest und Inhalt geprüft |
| 26 Tests | 28 Suiten, historische Traces, neuer Produktions-/Soaktest und native Grafikprüfung |
| 27 Ablauf | Implementiert, importiert, Fehler korrigiert, geprüft, exportiert, dokumentiert |
| 28 Qualität | Keine bekannten Parser-/Ressourcenfehler; Geräte- und menschliche Balanceabnahme offen |
| 29 Fortschritt | PROGRESS.md enthält aktuellen Stand, offene Abnahme und nächste Schritte |
| 30 Übergabe | Godot-Projekt, Quell-ZIP, APK, Berichte und reproduzierbare Tests; öffentliche Downloads |

Zusätzlicher aktueller Umfang: fünf neue Helden Cinder/Frosty/Volt/Rook/Nyx; zehn neue
Gegnerrollen; sechs zusätzliche Arenen; gemeinsame Körper-/Hand-/Waffenanker;
elfteilige Heldendaten, zehnteilige Weltprogression, 26 Entwicklungen, 37 Sammelitems;
33 Bestiariumseiten, 11 Heldenseiten, Regeln/Technik, Tutorial-Anpassung, 14 neue Sounds.
„AAA“ bleibt ein Qualitätsziel. Dieses Alpha-Update besitzt keine behauptete Store-
Zertifizierung oder abschließende Geräte-/Balancingabnahme.
