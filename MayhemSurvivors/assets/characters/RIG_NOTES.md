# Gameplay-Rig 0.2.2

Aus den bestehenden Charakterreferenzen mit Bildgenerierung erzeugt. Der Atlas hat
1536×1024 RGBA-Pixel und drei Spalten. Oben je ein Körper ohne Arme/Hände,
Region y=0 bis 640; unten je eine einzelne Handschuhkomponente, y=640 bis 1024.
Die Handschuhregion wird zweimal verwendet, keine zusätzlichen Hände im Körperbild.

Zwei getrennte Armketten verbinden Schulterpunkte mit den Griffpunkten der gehaltenen
Hauptwaffe. Ausrichtung, Rückstoß und Hammerschwung bewegen Waffen und Griffe zusammen.
Die Orbit Blade erhält keine Arme. Menübilder verwenden weiterhin den kompletten alten
Porträtatlas; der Körper im Kampf nutzt ausschließlich die neue Basistextur.
