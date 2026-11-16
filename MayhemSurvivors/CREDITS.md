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
