# Glutwerk 0.24.0

Ab der dritten normalen Welle gibt es zwei freiwillige Dampfventile, in Kampagne
und Endlos. Die bisherigen heißen Bodenbahnen bleiben aktiv. Der alte Schmelzsturm
wird durch die Ventile ersetzt. Gegnerwerte, Waffen und Boss-HP bleiben erhalten.

## Bedienung und Timing

Jedes Handrad zeigt einen wiederkehrenden Druckzyklus von zwölf Sekunden. 60–85 %
ist der grüne Bonusbereich. Am Rad 0,8 Sekunden anhalten löst einen Dampfstoß in der
angezeigten Richtung aus. Der Druckwert beim tatsächlichen Auslösen wird gespeichert;
er bestimmt Schaden und Bonusberechtigung. Die zwei Uhren beginnen versetzt.

Die Bahn startet 100 Einheiten vor dem Rad, ist 420 lang und 110 breit. Vorlauf
1,6 Sekunden, dann genau ein Treffer. Der Bedienpunkt liegt außerhalb der eigenen
Bahn. Wer anschließend in die Bahn läuft, kann getroffen werden. Gegner erhalten
(140 + 20 × lokale Welle) × (0,5 + 0,5 × Druck) Schaden vor ihren Schutzfaktoren.
Überlebende normale Gegner werden 170 Einheiten in Dampfrichtung zurückgestoßen;
angekündigte steuerbare Gegnerangriffe werden durch die vorhandenen Unterbrechungen
behandelt. Bosse widerstehen Rückstoß. Spieler erhalten zehn Basisschaden vor Rüstung.

Grüner Druck plus mindestens ein beseitigter Gegner bringt zusätzlich zur normalen
XP-/Coin-Beute 16 + 4 × lokale Welle Run-Coins. Ein Versuch je Handrad; maximal zwei
Manöver-Boni pro Welle. Ohne grünen Druck oder ohne Kill gibt es keinen Bonus.
Ignorieren verursacht keinen automatischen Dampfstoß. Unter vier verbleibenden
Sekunden werden keine neuen normalen Ventilaktionen begonnen.

## Ofenkönig und Integration

Der Zonenangriff des Ofenkönigs erzeugt zwei kreuzende, feste Dampfbahnen mit zwei
Sekunden Vorwarnung. Die bestehenden Regeln für Warnungsbesitzer, Phasen und Bereinigung
gelten weiter. Umweltschaden an Bossen bleibt auf 0,5 % Max-HP pro Treffer begrenzt.
Bossflächen erzeugen keinen Ventilbonus und schieben den Boss nicht weg.

Pause, Shop und Level-Up stoppen Druck, Haltezeit und Gefahren. Tod, Wellenende und
Neustart räumen auf. Gefahren bleiben auf sechs begrenzt. LOW/MEDIUM/HIGH verwenden
dieselben Werte. Eine schwache Rückreferenz verhindert einen Speicherzyklus zwischen
den zwei Managern. Datengrundlage: data/arenas/mechanics.json / foundry.

Kicksy erklärt die Mechanik beim ersten Auftreten; Hilfe ist in der Pause erreichbar.
Die drei Arenenhilfen beziehen Zahlen aus der Konfiguration. Weltkarte, HUD und
Ergebnisdetails passen zum Glutwerk. steam_valve.svg und vier kurze Audiocues sind
eigene Assets. Es kommen keine Online-Systeme oder bezahlten Abhängigkeiten hinzu.

Automatisierte Tests und native Linux-Ansichten ersetzen keine menschliche Balance-
oder physische Android-Geräteabnahme.
