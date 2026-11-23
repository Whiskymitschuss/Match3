# Mayhem Survivors — geschlossene Beta 1

Diese Android-Debug-Version ist für einen kleinen geschlossenen Testkreis gedacht.
Godot 4.6.3 / ARM64 / Android ab API 24 / Querformat. Sie spielt vollständig offline.
Es gibt keine Anmeldung, Server, Werbung oder Echtgeldkäufe.

## Installieren und Spielstand behalten

Die Beta als Update über die vorhandene Version installieren. Nicht vorher
Deinstallieren: Android löscht bei einer Deinstallation die lokalen App-Daten.
Paketname und Signierschlüssel bleiben gleich. Der bisherige Fortschritt bleibt
als **Spieler 1** erhalten. Über den Profilbutton oben im Hauptmenü kannst du ihn
umbenennen und bis zu vier weitere Spieler anlegen.

Jedes Handy hat eigene lokale Daten. Innerhalb der App gibt es fünf getrennte
Profile mit eigenen Freischaltungen, Coins, Ausrüstung, Statistiken, Aufgaben,
Passfortschritt, Einstellungen sowie zuletzt gewähltem Kämpfer und Arena.
Nach einem Neustart lädt die App das zuletzt aktive Profil. Ein laufender Run
muss beendet werden, bevor du das Profil wechseln kannst.

Das aktive Profil und das Startprofil sind gegen Entfernen geschützt. Andere
Profile kannst du nach Bestätigung aus der Auswahl entfernen. Ihre lokalen
Dateien werden intern archiviert und nicht mit einem anderen Profil vermischt.
Es gibt keine automatische Übertragung zwischen Handys.

## Sicherungen

Vollständige Spielstände und die Profilübersicht werden über temporäre Dateien
geprüft und atomar ersetzt. Der vorherige gültige Stand bleibt als lokale
Sicherung erhalten. Beschädigte Hauptdateien werden archiviert; eine gültige
Sicherung wird automatisch geladen. Falls nötig, wird die Profilübersicht aus
vorhandenen gültigen Spielerdateien wiederaufgebaut.

Unter EINSTELLUNGEN → PROFIL kannst du speichern oder nach Bestätigung den letzten
Sicherungsstand des aktiven Spielers laden. Das kann dessen neuere Fortschritte
zurücksetzen. Andere Spieler bleiben getrennt. Bei einem Schreibfehler bleiben
Käufe zurückgerollt und ein Profilwechsel wird blockiert, bis Speichern gelingt.

**Dauerhafter Fortschritt wird gespeichert. Ein aktiver Run lässt sich nach
vollständigem Beenden der App weiterhin nicht fortsetzen.** Bei einer normalen
Android-Unterbrechung pausiert das Spiel; die Simulation läuft dabei nicht weiter.

## Die wichtigsten Testwege

1. Update über 0.27 installieren und alte Figuren, Welten, Coins und Ausrüstung prüfen.
2. Zwei eigene Profile anlegen. Mit beiden getrennt spielen und Cases öffnen.
3. Aufgabe beziehungsweise Weltbelohnung abholen. Danach zum anderen Profil wechseln
   und sicherstellen, dass es dessen Guthaben und Freischaltungen nicht verändert.
4. Musik, Grafik und Kämpfer je Profil unterschiedlich einstellen. App komplett
   schließen und neu öffnen. Aktives Profil, Auswahl und Fortschritt kontrollieren.
5. Namen mit Umlauten eingeben. Android-Tastatur und Zurücknavigation ausprobieren.
6. Mit zwei Fingern spielen; Android unterbrechen, zurückkehren und sicher fortsetzen.
7. Im Shop oder bei einer Auswahl Zurück drücken. Abbruchdialog abbrechen und prüfen,
   dass dieselben Angebote und Auswahlmöglichkeiten erhalten bleiben.
8. Alle zehn Wellen, Bosswechsel, Sieg/Niederlage, Cases, Inventar und Endlos testen.
9. Drei Runs mit Bruiser, Steelfist und einer neuen Figur bei gleichen Rahmenbedingungen
   in der Run-Analyse vergleichen. Schwierigkeit und unverständliche Treffer melden.
10. Auf kleinen, breiten und ausgeschnittenen Displays testen; lange Runs auf Klang,
    Touchgefühl, FPS, Akku und Temperatur prüfen.

## Fehler melden

EINSTELLUNGEN → PROFIL → BETA-HILFE zeigt Anleitung und einen kopierbaren Bericht.
Er enthält Version, Gerät/Ansicht, lokale Profil-ID, Speicherstatus und Spielzustand,
aber keinen Spielernamen und keinen vollständigen Spielstand. Es wird nichts
automatisch hochgeladen. Du entscheidest selbst, wo du den Bericht teilst.

Ergänze: Schritte zum Fehler, erwartetes Verhalten, tatsächliches Verhalten,
Häufigkeit und möglichst ein Bild. Bei Leistungsproblemen Grafikstufe, Handymodell
und ungefähre Spieldauer nennen.

## Vor öffentlicher Veröffentlichung

Der geschlossene Test muss die physische Android-Abnahme, menschliche Balance,
Mehrfingerbedienung, Tastatur/Safe Area, Sensorik, Audio und Langzeitstabilität
bestätigen. Automatisierte Tests und Linux-GL-Bilder ersetzen das nicht.
Eine spätere Store-Veröffentlichung benötigt einen Release-Build mit dauerhaft
verwaltetem Release-Schlüssel und ein Android App Bundle sowie Store-Material.
Dieses Paket bleibt eine signierte Debug-APK für den geschlossenen Betatest.
