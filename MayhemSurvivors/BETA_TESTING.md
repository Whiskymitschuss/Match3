# Mayhem Survivors — Google Play Beta 2

Diese Version bereitet den Test einer neuen App über Google Play vor. Das Release-
AAB wird in der vorhandenen Play Console hochgeladen. Die App ist dort noch nicht
angelegt; es gibt daher noch keinen Store-Testlink. Siehe PLAY_STORE_HANDOFF.md.
Godot 4.6.3 / ARM64 / Android ab API 24 / Querformat / vollständig offline.

## Neue Installation und eigene Spielstände

Jeder neue Spieler startet mit Bruiser und Hammer Rang 1 auf dem Schrottplatz.
Coins, Teile, Tickets, Cases, Ausrüstung, Statistik, Weltabschlüsse und Passfortschritt
beginnen bei null. Es werden keine Entwickler-Spielstände mitgeliefert. Das Tutorial
bietet Hilfe und vergibt keine dauerhaften Geschenke. Weitere Inhalte werden erspielt.

Jedes Handy hat eigene lokale Daten. Innerhalb der App gibt es fünf getrennte
Profile mit eigenen Freischaltungen, Währungen, Ausrüstung, Statistiken, Aufgaben,
Passfortschritt, Einstellungen sowie zuletzt gewähltem Kämpfer und Arena. Jedes
zusätzliche Profil startet ebenfalls bei null. Nach einem Neustart lädt die App das
zuletzt aktive Profil. Ein laufender Run muss vor einem Profilwechsel beendet werden.

Reguläre Updates behalten bestehende eigene Spielstände. Die bisherige Debug-APK
hat einen anderen Schlüssel als eine von Google signierte Store-App. Für einen
Erstspieler-Test eine separate Android-Testumgebung ohne vorhandene App-Daten nutzen.
Eine Deinstallation oder Androids Funktion „Speicherinhalt löschen“ entfernt lokale
Daten. Die App überträgt keine Spielstände zwischen Handys.

Das aktive Profil und das Startprofil sind gegen Entfernen geschützt. Andere
Profile können bestätigt aus der Auswahl entfernt werden; Dateien bleiben intern
archiviert und werden nicht mit einem anderen Spieler vermischt.

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

1. Über den Play-Testlink frisch starten: nur Bruiser/Hammer und Schrottplatz; Coins, Teile, Tickets und Fortschritt null.
2. Zwei eigene Profile anlegen. Mit beiden getrennt spielen, Belohnungen verdienen und erst dann Cases öffnen.
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
