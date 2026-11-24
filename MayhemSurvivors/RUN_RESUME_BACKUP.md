# Runs fortsetzen und Profile übertragen — 0.29.0 Beta 3

## Nach einer Unterbrechung weiterspielen

1. Spiel normal öffnen und das richtige lokale Profil aktivieren.
2. Im Hauptmenü FORTSETZEN wählen. Ein Kampf wird zuerst pausiert geladen.
3. Im Pause-Menü bewusst fortsetzen. Im Shop oder bei einer Levelwahl geht es mit
   denselben noch offenen Angeboten weiter.

Gesichert werden Kampagne und Endlos, ein Run je Profil. Tutorial-Training ist
keine fortsetzbare Sitzung. Gegner, Projektile, Trefferlisten, Boss-Ankündigungen,
Wellen-/Kampftimer, Fähigkeiten, Arenengefahren, Run-Werte, XP, Shop, Levelwahl und
Zufallszustand gehören zum Checkpoint. Flüchtige rein visuelle Partikel werden
neu aufgebaut. Während die App geschlossen ist, läuft kein Kampf weiter.

Die periodische Sicherung erfolgt alle zehn Kampfsekunden im Hintergrund. Bei
hartem Beenden kann der Abschnitt seit der letzten erfolgreich geschriebenen
Sicherung fehlen, üblicherweise bis etwa zehn Sekunden. Ein Speicherausfall kann
den Abstand vergrößern; das Pause-/Profil-Menü zeigt den Fehler. Pause, Android-
Unterbrechung, Zustandswechsel und SICHERN & HAUPTMENÜ sichern zusätzlich.

Ein neuer Run ersetzt den bisherigen nach Bestätigung. RUN ABBRECHEN beendet
den Run nach Bestätigung als Niederlage. Ein normaler Abschluss entfernt seinen
Checkpoint zusammen mit dem Belohnungs-Commit; Wiederladen zahlt ihn nicht erneut aus.
Sichern & Hauptmenü erlaubt danach einen Profilwechsel ohne diesen Run zu verlieren.

## Sicherungsdatei exportieren

Im Hauptmenü EINSTELLUNGEN → PROFIL → EXPORT / IMPORT → SICHERUNG EXPORTIEREN.
Im Android-Dateidialog einen selbst gewählten Speicherort verwenden. Enthalten
sind Profilname, Sammlung, Währungen, Ausrüstung, Aufgaben, Einstellungen,
Statistiken und gegebenenfalls der gesicherte Run des aktiven Spielers.

Das Spiel lädt die Datei nicht selbst ins Netz. Ein vom Nutzer ausgewählter
Dateianbieter kann eigene Synchronisationsfunktionen anbieten. Die Kopie getrennt
von der App aufbewahren: Deinstallation oder App-Daten löschen entfernt interne
Spielstände. Eine externe Datei bleibt abhängig vom gewählten Speicherort erhalten.

## Auf einem anderen Handy importieren

1. Exportdatei selbst auf das Zielgerät übertragen und dieselbe App-Version verwenden.
2. EINSTELLUNGEN → PROFIL → EXPORT / IMPORT → DATEI IMPORTIEREN.
3. Datei auswählen, Profilvorschau kontrollieren, als neues Profil importieren.
4. Das zusätzliche Profil wird aktiviert. Enthält es einen Run, im Hauptmenü fortsetzen.

Ein freier der fünf Profilplätze ist erforderlich. Andere Spieler werden nicht
überschrieben, Guthaben werden nicht addiert. Doppelte Namen erhalten einen Zusatz.
Abbrechen ändert keinen Spielstand. Eine Sicherungsdatei ist eine Kopie, kein
kontogebundener Transfer und keine Zusammenführung zweier Fortschritte.

## Technische Grenzen

Versionskennung, SHA256-Inhaltsprüfung, bekannte Katalogkennungen und begrenzte
JSON-Datenstruktur; maximal acht MiB pro Export. Kein Laden ausführbarer Objekte
oder beliebiger Ressourcendateien. Prüfsummen schützen vor versehentlicher
Beschädigung und sind kein Manipulationsschutz für eine Online-Bestenliste.
Run-Schema/Regelsatz 1 und lokales Profilschema 3; alte Profile bleiben kompatibel.
Unbekannte oder beschädigte Run-Daten werden abgewiesen, dauerhafter Fortschritt
wird defensiv geladen. Ein portabler Import mit ungültigem Run wird vorab abgelehnt.

Die native Android-Dateiauswahl verwendet Godots vorhandene SAF-Anbindung ohne
breite Speicherberechtigung. Datei-Schreib-/Leselogik und native Linux-Touchmenüs
sind getestet. Der Android-Dateianbieter einschließlich content://, Abbruch und
Neustart muss noch auf echten Geräten abgenommen werden.
