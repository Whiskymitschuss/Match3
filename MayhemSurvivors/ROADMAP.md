# Stand 0.7.0

Shop-Ausbau, Vollbild und schwerere Spätwellen für beide Arenen implementiert.
Nächster Schritt ist eine gemeinsame Android-Abnahme: sichere Bildschirmränder,
Shop-Lesbarkeit/-Bedienung, Schwierigkeit ab Welle vier und Item-/Set-Kombinationen.
Vor weiterem Inhalt konkrete Runs mit Charakter, Arena, Endwelle und Build auswerten.
FPS/Temperatur auf echter Hardware bleiben offen.

---

## Historischer Stand (vor 0.7)

# Stand 0.6.0

Taktische Gegnerrollen in der Reaktorzone umgesetzt: angekündigter Fernkämpfer ab
Welle zwei und Schilddrohne ab Welle vier. Der Schrottplatz bleibt Referenz. Nächster
Schritt: Android-Abnahme, insbesondere faire Schüsse und Priorisierung der Drohnen,
anschließend gezieltes Balancing anhand echter Runs. Details in PROGRESS.md.

---

# Stand 0.5.1

Vom Nutzer vor der 0.5-Abnahme gewünschtes Effektpaket integriert: Cartoon-Splatter,
Schuss-, Treffer-, Todes- und Spezialeffekte. Keine neuen Kampfregeln. Nächster Schritt:
Android-Praxisabnahme der kombinierten Waffen-/Effektversion. Details in PROGRESS.md.

---

# Stand 0.5.0

Zwei verbindliche, kostenlose Entwicklungen je Waffe ab Stufe fünf implementiert und
automatisiert geprüft. Nächster Schritt: Android-Praxisabnahme und gezieltes Balancing
beider Wege pro Klassenwaffe anhand echter Runs. Fähigkeiten aus 0.4 wurden vom Nutzer
positiv zu Funktion, Nutzen und Lesbarkeit bewertet. Details in PROGRESS.md.

---

# Stand 0.4.0

Drei aktive Heldenfähigkeiten, eigener Multitouch-Button, optional gespeicherte Vibration
und neues Trefferfeedback implementiert und automatisiert geprüft. Nächster Schritt:
Android-Praxisabnahme und gezieltes Fähigkeitsbalancing. Waffenspezialisierungen folgen
als separater Meilenstein nach dieser Abnahme. Details in PROGRESS.md.

---

# Stand 0.3.0

Die unten beschriebene Erweiterung ist implementiert und automatisiert geprüft.
Android-Praxisabnahme und Reaktor-Feinbalancing stehen aus. Siehe PROGRESS.md.

---

# Nächster Meilenstein: 0.3 — mehr Abwechslung

Status: konkreter Entwicklungsvorschlag, noch keine Implementierung oder neue APK.

## Referenz erhalten

0.2.3 (`a4efbc4`) ist die unveränderte Vergleichsversion. Der Nutzer hat einen Sparky-Sieg
über zehn Wellen bestätigt. Gegner-/Waffenwerte, Klassenbindung und Zweihandhaltung des
klassischen Schrottplatzes bleiben bei der nächsten Erweiterung erhalten. Keine pauschalen
permanenten Schadensboni, die diese Balance unbemerkt verändern.

## Empfohlener Inhalt

1. **Arena-Auswahl:** Nach der Charakterwahl zwischen Schrottplatz und neuem Gebiet wählen.
   Jede Arena besitzt eine eigene Kennung, Grafik, Wellenkonfiguration und Bosszuordnung.
2. **Reaktorzone:** Zweite, visuell unterscheidbare Arena im bestehenden Comic-Stil.
   Abwechslung entsteht durch eigene Gegnerzusammenstellung und angekündigte Gefahren;
   neue Werte betreffen das neue Gebiet, nicht den bestehenden Schrottplatz.
3. **Eigener Endboss:** Ein Reaktorwächter mit klar angekündigten Angriffen, separaten Regeln
   und passenden Effekten. Kein bloß umgefärbter Overlord.
4. **Freischaltung und Ziele:** Reaktorzone nach einem ersten Sieg freischalten; bereits
   gespeicherte Siege zählen. Einige klar beschriebene Herausforderungen können kosmetische
   Varianten freischalten. Keine Werbung, Käufe, Server oder Internetpflicht.

## Reihenfolge und Abnahme

Zuerst Arena-System und Auswahl mit funktionsfähiger Schrottplatz-Rückwärtskompatibilität.
Dann Reaktorzone und Wellen, anschließend Boss und Freischaltung. Erst nach einem verbundenen
Run bis zum Ergebnis eine neue Android-Test-APK übergeben. Keine unfertigen Menüpunkte.

- Referenzdaten und deterministische Schrottplatz-Tests weiter bestehen lassen.
- Speicherstände aus Format 1 und 2 ohne Verlust übernehmen; Arena-Kennung bei neuen
  Ergebnissen berücksichtigen. Keine alten Charakterresultate erfinden.
- Nur Touch, Querformat, ARM64 und Compatibility Renderer; Pools und Gegnerobergrenze behalten.
- Beide Gebiete mit allen drei Klassen prüfen; Bosswarnungen und neue Gefahren eindeutig.
- Geräte-Framerate und Bedienung tatsächlich messen/testen, ohne Headlesswerte gleichzusetzen.

## Weitere spätere Schritte

Mehrbild-Lauf-/Angriffsanimationen und charakterbezogene Herausforderungen nach der zweiten
Arena. Weitere Charaktere oder Waffen erst mit eigenen Design- und Balanceprüfungen.
