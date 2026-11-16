# Comic-Kampf-Atlas

Mit Bildgenerierung für dieses Projekt erstellt, passend zu den neuen Helden.
PNG RGBA, 3×3 Raster. Regionen werden aus der tatsächlichen Texturgröße berechnet.

Zeile 1: Blaster / Kriegshammer / Splitgun.
Zeile 2: Arc Cannon / Orbit Blade / Boss-Feuerprojektil.
Zeile 3: Bruiser-Goldgeschoss / Sparky-Plasmalanze / Shade-Energiedorn.

Alle Waffen zeigen nach rechts; die Darstellungslogik richtet sie aus und animiert Rückstoß
oder Hammerschwung. Projektile behalten ihre ursprünglichen Kollisionswerte und Flugbahnen.
Mündungsfeuer, Patronenhülsen, Kettenblitz, Klingenspur und Trefferfunken werden in Godot
begrenzt und prozedural gezeichnet; keine Partikel-Nodes pro Schuss.
