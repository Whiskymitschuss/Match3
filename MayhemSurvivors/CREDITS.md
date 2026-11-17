# Ergänzungen 0.15

Eigene Normal-/Veteran-/Mayhem-Symbole als SVG erstellt, keine externen Assets oder
neuen Plugins. Vorhandene eigene Mayhem-Menüs/Grafiken/Audio weiterverwendet.
Datenbasierte Schwierigkeitsprofile und Rekordsystem eigenständig implementiert.

---

## Historischer Stand vor 0.15

# Ergänzungen 0.14

Kicksy-Konzept/Profil und angehängte Referenz von Nutzer / RF Worlds; daraus eigener
an den Mayhem-Stil angepasster generierter Atlas (Portrait, armloser Körper, Handschuhe,
Fußball-Bombe). Grundlage ist die tatsächlich angehängte Kicksy-Referenz.
Neonhafen-/Glutwerk-Karten und Dock-Tyrann-/Ofenkönig-Grafiken eigens generiert.
Eigene SVG-Icons, Shader-/Canvas-Verläufe, UI-Bewegung und bearbeitbare Kicksy-Dialoge.
Zwei eigene Audio-Cues in tools/generate_kicksy_audio.py synthetisiert, ohne Fremdsamples.
Neue Bossgrafiken nutzen bestehende eigene Verhaltensarchetypen. Keine neuen Plugins.

---

## Historischer Stand vor 0.14

# Ergänzungen 0.13

Ravox-Name, Wutteufel-Konzept, Werte/Referenz und Zermalmer von Nutzer / RF Worlds.
Eigene generierte transparente Gegnerillustration, keine Übernahme fremder Spieleassets.
Orange Sturmbahn/Progressanzeige und Animationen mit Godot draw_*-Funktionen.
Zwei originale deterministisch synthetisierte Sounds; tools/generate_ravox_audio.py.
Keine neuen externen oder kostenpflichtigen Abhängigkeiten.

---

## Historischer Stand vor 0.13

# Ergänzungen 0.12

TWINKLE: Charakterkonzept, Name, Mechanik und Referenz vom Nutzer / RF Worlds.
Eigenständiger, generierter transparenter Twinkle-Atlas mit Portrait, Körper ohne Arme,
Handschuh-Komponenten und Turbo-Mopp. Sprühflasche, Seifen-/Gift-/Wirbeleffekte und
neue Fähigkeits-/Entwicklungs-Icons selbst mit Godot draw_* bzw. SVG erstellt.
Drei originale Audio-Cues (Wischgeräusch, Heilglöckchen, Tornadowirbel) deterministisch
synthetisiert, ohne externe Samples; tools/generate_twinkle_audio.py enthält Generator.
Keine neuen kostenpflichtigen Abhängigkeiten, keine fremden Spieleassets.

---

## Historischer Stand vor 0.12

# Ergänzungen 0.11

Vorhandene eigene Charaktergrafiken unverändert als Basis für kosmetische Farbtönungen.
Blitz-, Kronen- und Jägerschilde mit eigenen Godot draw_*-Funktionen gezeichnet.
Keine externen neuen Grafiken, Sounds oder kostenpflichtigen Plugins hinzugefügt.

---

## Historischer Stand vor 0.11

# Neue Inhalte 0.10 — RF Worlds

Zwei originale Elite-Sprites mit Bildgenerierung für diesen Spielstil erstellt,
Atlas assets/enemies/elites.png. Sturm-/Ring-/Kreuz-/Zielkreisgrafik direkt aus der
Gameplay-Geometrie gezeichnet, keine externen Effekte oder fremden Gegner kopiert.
Drei neue Audiocues mit eigener deterministischer Synthese, Quelle
 tools/generate_encounter_audio.py (Python-Standardbibliothek). Bisherige Fontlizenzen,
UI-/Audioherkunft und Bildquellen bleiben erhalten.

---

## Historischer Stand vor 0.10

# Gestaltung 0.9 — RF Worlds

Neon-Stadtmotiv, neue Silber/Magenta-Wortmarke und MS-Icon mit Bildgenerierung nach
der aktuellen Nutzerreferenz und vorhandenen Spielmarken erstellt. Tatsächlich im
Spiel eingebunden, Dateien assets/branding/. Studiomarke als eigene SVG-Pfade erneuert.
49 originale semantische UI-Badges sowie acht Item-, drei Ability- und zehn
Entwicklungsillustrationen als SVG generiert. Quelle tools/generate_interface_icons.py,
keine externen Iconfonts/Emoji nötig. Joystickgrafiken ebenfalls eigene SVGs.
Fonts und Audio aus 0.8 mit bisherigen Lizenz-/Herkunftsnachweisen erhalten.


---

## Historischer Stand vor 0.9

# Mayhem Survivors — RF Worlds / 0.8

Spiel-/Studiogestaltung: RF Worlds. Neue Wortmarke und MS-Icon wurden mit Bildgenerierung
an die beiden vom Nutzer gelieferten Feuer-/Metall-Referenzen angepasst; Originaldateien
im Projekt enthalten. Studiomarke als eigene SVG-Pfade. Bestehende Charakter-/Waffen-
und Weltgrafiken bleiben Bestandteil des vollständigen Projekts.

Fonts: Barlow SemiBold und Barlow Condensed Bold, Jeremy Tribby/Barlow Project,
SIL Open Font License 1.1. Originaldateien aus google/fonts, ofl/barlow und
ofl/barlowcondensed. Lizenztexte in assets/ui/fonts/ und in der APK.

Audio: eigene DSP-Sounds und Kompositionen von diesem Projekt, keine Fremdaufnahmen.
Generator tools/generate_presentation_audio.py: numpy/scipy und ffmpeg benötigt,
zum Spielen und Exportieren nicht. Ältere Generatoren bleiben für Herkunft erhalten;
für 0.8 nur den Präsentationsgenerator verwenden. Musiken als Vorbis, kurze Effekte WAV.
