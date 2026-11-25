# Arenenmechaniken 0.23.0

Zwei eigene Mechaniken ab der dritten normalen Welle, in Kampagne und Endlos.
Tutorial und die übrigen acht Arenen behalten ihre Regeln. Boss-HP, Waffenwerte,
Spawnregeln und der bisherige Fortschritt bleiben erhalten. Die alten automatischen
Ereignisse dieser beiden Arenen werden durch die neuen Mechaniken ersetzt.

## Reaktorzone

Jeder vierte mit einer Waffe/Fähigkeit besiegte normale Gegner erzeugt einen Kern.
Maximal drei Kerne pro Welle; Umweltschaden erzeugt keine weiteren Kerne. Der
Sammelradius zieht nahe Kerne an. Drei aufgesammelte Kerne laden das Terminal.
1,2 Sekunden im Radius 75 anhalten startet die freiwillige Überladung.

Die feste Einschlagposition wird 2,5 Sekunden gelb markiert. Radius 180;
220 + 20 × lokale Wellenzahl Schaden gegen Gegner, 14 Basisschaden gegen Spieler.
Rüstung und bestehende Schadensreduktion gelten weiter. Ein beseitigter Gegner
bringt zusätzlich zur regulären Beute einen Bonus von 18 + 4 × lokale Wellenzahl
Run-Coins. Ein Versuch pro Welle. Unter sieben verbleibenden Sekunden schließt
das Terminal; Kerne und angefangene Ladungen werden nicht in die nächste Welle getragen.
Die bisherigen periodischen Strombahnen bleiben; während einer Überladung pausiert
deren Erzeugung. Das alte Überlast-Ereignis entfällt.

## Neonhafen

Nach 16 und 40 Sekunden werden jeweils zwei Containerpositionen fest markiert.
180 × 140 Einheiten, zwei Sekunden Vorwarnung, ein Einschlag je Container.
200 + 20 × lokale Wellenzahl Gegnerschaden und 12 Basisschaden für Spieler.
Ziele bleiben nach der Ankündigung fest. Die Kisten versperren keine Wege.

Zwei beseitigte Gegner pro Doppelladung bringen einen Bonus von 12 + 4 × lokale
Wellenzahl Run-Coins. Reguläre XP-/Coin-Beute bleibt erhalten. Bonus und Einschlag
werden jeweils genau einmal verarbeitet. Die alten Bomben-/Flutereignisse entfallen.

## Bosse, Darstellung und Grenzen

Der Reaktorwächter und Dock-Tyrann nutzen für ihren Zonenangriff eigene Kern- bzw.
Containerflächen: drei feste Ziele mit zwei Sekunden Vorwarnung. Schaden an einem
Boss ist auf 0,5 % seines Maximallebens je Umwelttreffer vor vorhandenen Resistenzen
gedeckelt. Bossflächen erzeugen keinen Manöver-Bonus. Tote, verschwundene oder während
der Ankündigung versetzte Bosse verlieren ihre ausstehenden Warnflächen.

Arena-Treffer verwenden keine kritischen Würfe, Waffenboni oder Schadensmultiplikatoren.
Echte Gegnerbeute läuft durch das vorhandene Todessystem; dadurch gibt es keine
zweite Auszahlung und keine Kettenreaktion aus neuen Energiekernen.

Pause, Level-Up und Shop stoppen die gesamte Simulation. Nach Tod/Wellenwechsel
werden Gefahren bereinigt, nach Neustart auch die Run-Summen. Maximal sechs eigene
Gefahren und drei Kerne; gleiche Kampfregeln auf LOW, MEDIUM und HIGH.

Kicksy erklärt die Mechanik beim ersten Auftreten. Die Bestätigung wird lokal
gespeichert und defensiv geladen. ARENA-TIPPS in der Pause öffnet die Erklärung
erneut, ohne den Kampf fortzusetzen. HUD, Ergebnisdetails und Weltkarte zeigen
passende Informationen. Zwei eigene SVG-Illustrationen und fünf eigene Audiocues.

Alle Werte stehen in data/arenas/mechanics.json. Automatisierte Prüfungen und native
Linux-Ansichten ersetzen keine menschliche Balance- oder Android-Geräteabnahme.
