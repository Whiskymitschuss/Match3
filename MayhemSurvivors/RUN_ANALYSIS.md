# Deine Run-Analyse — 0.26.0

RUN-ANALYSE auf dem Ergebnisbildschirm öffnet deine Bilanz. Später erreichst du
sie unter STATISTIK → LETZTE RUNDEN → ANALYSE. Kampagne und Endlos teilen sich die
letzten 20 gespeicherten Runden. Endlos-Runden erhöhen keine Kampagnen-Bestwerte.

## Drei Ansichten

- **Überblick:** aktive Kampfzeit, tatsächlicher HP-Verlust, Treffer mit HP-Verlust,
  ausgeteilter Schaden, Kills, verdiente Run-Coins, Fähigkeiten und Modulwirkung.
  Deine verwendeten Waffen und Entwicklungen bleiben sichtbar.
- **Wellen & Bosse:** einzelne Wellen mit Kampfzeit, Schaden, HP-Verlust, Kills,
  Coins, Modul-Auslösungen und Ausgang. NUR BOSSE filtert die Liste. Bosszeit wird
  vom Beginn der Bosswelle bis zum Sieg, Tod oder Zeitlimit gemessen. Sie enthält
  auch Zeit, die du zum Annähern oder Ausweichen brauchst.
- **Klassenmodul:** gekauftes Modul, seine Regeln und tatsächlich zusätzlich
  entfernter Gegner-HP. Ohne Kauf steht das ausdrücklich dabei. Die Übersicht
  enthält auch die Zahl eingesetzter aktiver Fähigkeiten aller elf Klassen.

Pause, Shop, Vorbereitung, Levelauswahl und eingefrorenes Tutorial zählen nicht
als Kampfzeit. Das Tutorial schreibt keine Run-Analyse. Shopausgaben mindern die
Anzeige verdienter Run-Coins nicht; Heilung zieht keinen erlittenen Schaden ab.
HP-Verlust zählt nach Rüstung und Schutz und höchstens bis zu deinen vorhandenen
HP. Ein vollständig absorbierter Treffer erzeugt keinen Treffer mit HP-Verlust.

## Was der Modulschaden bedeutet

Bruchkern und Schattenspule zeigen den tatsächlich zusätzlich entfernten Teil
eines verstärkten Treffers, einschließlich regulärem Krit und Zielresistenz. Ein
Grundtreffer, der den Gegner ohnehin besiegt hätte, erzeugt null Zusatzschaden.
Das Ionenrelais zählt den tatsächlichen Schaden seiner getrennten Kettentreffer.
Eine Auslösung ohne weitere erreichbare Ziele kann daher null Zusatzschaden haben.
Die Analyse verändert weder Treffer, Ziele, Zufallsfolge noch Belohnungen.

## Speicherung und Grenzen

Die Detaildaten liegen im bestehenden lokalen Profil, ohne Server oder neue
Berechtigung. Es werden keine nachträglichen Detailwerte für alte Runs erfunden:
Diese zeigen eine Erklärung statt einer Null-Bilanz. Bestehende Statistik und
Freischaltungen bleiben kompatibel. Ein aktiver Run wird weiterhin nicht nach
einem vollständigen App-Ende wiederhergestellt.

Pro Run werden höchstens 50 Wellenzeilen behalten. In langen Endlos-Runs bleiben
die vollständigen Gesamtwerte erhalten, während die Tabelle die letzten 50 Wellen
zeigt. Pro Profil bleiben höchstens 20 Runs gespeichert. Neue Daten werden beim
Laden typgeprüft und begrenzt; beschädigte optionale Analysen löschen kein Profil.
Alle Angaben beruhen auf dem jeweiligen Run und sind keine Bestenliste zwischen
Spielern oder eine automatische Bewertung deiner Leistung.

## Android-Praxistest

1. Einen normalen Run beginnen; mit und ohne Klassenmodul spielen.
2. Während einer Bosswelle pausieren, eine Weile warten und zurückkehren.
3. Nach Sieg oder Niederlage RUN-ANALYSE öffnen, Tabs und Bossfilter bedienen.
4. Mit ZURÜCK zum Ergebnis, dann über das Hauptmenü in den Verlauf gehen.
5. App vollständig schließen und die gespeicherte Analyse erneut öffnen.
6. Die Lesbarkeit auf einem kleinen und einem breiten Display sowie einen
   längeren Endlos-Run prüfen. Berichte über Spielgefühl sind weiter erforderlich.

Automatisierte Prüfungen und native Linux-Touchereignisse ersetzen keine physische
Android-Abnahme für echte Mehrfinger-Steuerung, Temperatur, Akku, Audio oder 60 FPS.
