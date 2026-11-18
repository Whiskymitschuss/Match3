# Kampf-Kombinationen — 0.25.0

Drei optionale Klassenmodule verbinden bestehende Waffen mit aktiven Fähigkeiten.
Sie verändern keine Grundwerte anderer Helden und sind vollständig lokal.

| Held / Modul | Vorbereitung | Wirkung | Grenze |
| --- | --- | --- | --- |
| Bruiser / Bruchkern | Schockwelle trifft ein überlebendes Ziel | Nächster Hammertreffer auf dieses Ziel: +60 % | Markierung 6 s, einmal pro Ziel |
| Sparky / Ionenrelais | Arc Cannon oder Impulsgranate trifft ein überlebendes Ziel | Blaster-Direkttreffer springt zu bis zu 2 anderen Zielen: je 55 % seines Schadens vor Krit | Markierung 4 s; 180 Sprungweite; global 0,75 s Cooldown |
| Shade / Schattenspule | Schattenschritt aktivieren | Nächster Orbit-Blade-Treffer: +80 % gegen genau ein Ziel | 4 s Zeit; eine Ladung, nicht stapelbar |

Beide Entwicklungen jeder beteiligten Waffe sind verbunden. Bruiser und Shade
verstärken den vorhandenen Treffer vor dessen regulärem Krit-/Resistenzschritt.
Das Relais verursacht getrennten Schaden mit der regulären Zielresistenz, ohne
kritischen Treffer oder zusätzlichen Zufallszug. Sekundäre Impulse markieren nicht
und lösen keine weitere Kette aus. Piercer-Direkttreffer können das Relais auslösen,
solange seine globale Abklingzeit frei ist; Sprengkern-Flächenschaden kann das nicht.
Ein isolierter Boss bietet dem Relais keine weiteren Kettenziele.

## Kaufen und verstehen

- Im Wellenshop kostet ein Modul 30 + 4 × abgeschlossene Wellennummer Run-Coins:
  nach Welle 1 also 34. Keine Studio-Coins, Teile oder Echtgeld notwendig.
- Das passende, noch nicht gekaufte Modul belegt in jedem Shop einen garantierten
  der vier Angebotsplätze, auch nach Rerolls. Alle anderen Plätze bleiben zufällig.
- Nur für den zugehörigen Helden und mit ausgerüsteter Hauptwaffe erhältlich.
  Im Tutorial gibt es kein Modulangebot. Ein Exemplar pro Run; keine Set-Zählung.
- KLASSENMODUL / REGELN im Shop erklärt den Effekt vor dem Kauf. Gegenstände im
  Inventar öffnen dieselbe Erklärung. Die allgemeinen Werte bleiben unverändert.
- Im Kampf zeigt links das Modulsymbol Vorbereitung, markierte Ziele bzw. Restzeit.
  Antippen pausiert und öffnet die Regeln. ZURÜCK setzt denselben Kampf fort.
  Alternativ über die Pause erreichbar.
- Orange Hammerzeichen und türkise Blitze kennzeichnen markierte Gegner. Eine
  violette Kontur am Spieler zeigt Shades aufgeladene Klinge. Eigene Impulsringe
  und drei eigene synthetisierte Sounds ergänzen die vorhandenen Waffen-Effekte.

## Lebensdauer und Grenzen

Markierungen, Ladung, Cooldown und Effekte laufen nur im aktiven Kampf. Pause,
Levelauswahl, Shop und eingefrorene Tutorialabschnitte halten sie an. Beim Ende
einer Welle oder eines Runs werden sie verworfen; gekaufte Module bleiben zwischen
Wellen erhalten. Ein neuer Run startet ohne Module. Normale XP-/Coin-Belohnungen
gelten für jeden Gegner genau einmal. Nach Boss-Tod gibt es keine späten Ketten.

Markierungen liegen direkt an bestehenden Gegnerdaten und benötigen keine neuen
Nodes. Effektobergrenze: LOW 4 / MEDIUM 8 / HIGH 12. Die Qualität ändert weder Ziele
noch Schaden. Der zentrale Manager hält nur eine schwache Besitzerreferenz.

## Android-Praxistest

1. Bruiser: Welle 1 überleben, Bruchkern kaufen. In Welle 2 Schockwelle benutzen,
   auf Hammerzeichen achten und anschließend in Hammerreichweite bleiben.
2. Sparky: Ionenrelais kaufen, Gegnergruppe mit der Impulsgranate laden. Der nächste
   Blastertreffer soll zwei Nachbarn elektrisch treffen. Auch mit Arc testen.
3. Shade: Schattenspule kaufen, Schattenschritt nutzen und innerhalb von 4 s eine
   Klinge treffen lassen. Nach dem ersten Treffer erlischt die Aufladung.
4. HUD-Hilfe öffnen/schließen; bei laufender Ladung pausieren, App kurz verlassen,
   fortsetzen, Welle wechseln, verlieren und neu starten.
5. Mit mehreren Grafikstufen, unterschiedlichen Seitenverhältnissen und den
   Waffenentwicklungen wiederholen. Berichte gern über Lesbarkeit und Spielgefühl.

Automatisierte Tests und stationäre Schadenstests ersetzen weder menschliches
Balancing noch einen physischen Android-Test für Touch, Audio und Bildrate.
