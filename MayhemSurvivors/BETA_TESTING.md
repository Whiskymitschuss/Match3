# Mayhem Survivors — Beta5 /0.31.0 /Code38

Ergänzender Testplan für echte Android-Geräte. Automatisierte Tests und Linux-
Godot-Bilder ersetzen keine Geräteabnahme. Google Play Games ist in diesem Build
nicht aktiviert, weil Spieleprojekt und Kennungen fehlen. Keine Online-Tests behauptet.

## Neue Bedienwege

1. Über Play aktualisieren: bestehende0.29-Profile, Guthaben und gesicherten Run prüfen.
2. EXTRAS → DEINE STEUERUNG: mit zwei Fingern probieren, Vorschau ziehen, Linkshänder,
   Größe/Transparenz/Deadzone und festen Joystick testen. Abbrechen behält das alte
   Layout; Anwenden muss nach Neustart und profilbezogen erhalten bleiben.
3. Pause → Einstellungen → Steuerung → Touchlayout: ändern, zurück in denselben
   Kampf. Fähigkeit und Zauber mit dem zweiten Finger benutzen; Android unterbrechen.
4. Drei Builds im eigenen Fighter speichern, belegt ersetzen/abbrechen, anlegen und
   einen neuen Run starten. Bestehender gesicherter Run muss seine alte Ausrüstung behalten.
5. Normalen Run sichern. Boss-Training starten, Phase wählen, gewinnen/verlieren,
   pausieren, wiederholen und verlassen. Keine Coins/Aufgaben/Freischaltungen erhalten;
   den normalen Run danach tatsächlich weiterladen. Jede freigeschaltete Welt prüfen.
6. Profil mit Builds/Touchlayout/Run exportieren und auf einem anderen Handy importieren.
   Kein Überschreiben anderer Spieler. Die Android-Dateiauswahl inklusive Abbruch testen.
7. Persönliche Rekorde unter EXTRAS → BESTENLISTEN nach Arena/Schwierigkeit ansehen.
   Keine Online-Rangplätze oder Google-Anmeldung in dieser Version erwarten.

## Erstspieler und Profile

Frische Installation ohne App-Daten: Bruiser, Hammer Rang 1, Schrottplatz und null
Guthaben/Fortschritte. Keine mitgelieferten Entwicklerdaten oder Gratis-Cases.
Weitere Inhalte werden erspielt. Bis zu fünf unabhängige lokale Spielerprofile.
Reguläres Store-Update behält vorhandene eigene Daten; nicht vorher deinstallieren.
Ein Wechsel von einer Debug-APK zur Store-Signatur ist kein garantiertes Update.

Jedes Profil hat seinen eigenen gesicherten Run. Vor dem Wechsel SICHERN &
HAUPTMENÜ wählen. Keine Anmeldung oder automatische Synchronisation. Exportdateien
lassen sich selbst übertragen; ein Import benötigt einen freien Profilplatz.

## Neue Abnahmewege

1. Code 35 über Google Play auf Code 36 aktualisieren, eigene Figuren/Coins und
   Welten kontrollieren. Ein weiteres frisches Profil muss bei null beginnen.
2. Kampfrun starten, Pause, SICHERN & HAUPTMENÜ; App vollständig beenden und neu
   öffnen. FORTSETZEN muss in die Pause führen. Erst dort den Kampf starten.
3. Android Home/Telefonunterbrechung und harten Prozessabbruch ausprobieren.
   Letzter erfolgreicher Checkpoint muss erhalten sein, keine Offline-Kampfschäden.
4. Im Shop kaufen und neu würfeln, neu starten: identische verbleibende Angebote,
   Guthaben und Rerollkosten. Offene Levelwahl ebenfalls neu starten und vergleichen.
5. Während Boss-Ankündigung, Fähigkeit und Arenenereignis sichern/laden. Warnungen,
   Treffer, Timer und Gegner müssen plausibel fortsetzen. Sieg/Niederlage danach
   genau einmal belohnen, Neustart darf den abgeschlossenen Run nicht zurückbringen.
6. Profil wechseln und dessen anderen Run fortsetzen. Guthaben bleiben getrennt.
7. Export über Android-Dateidialog speichern, abbrechen, erneut exportieren. Auf
   einem zweiten Gerät importieren, Vorschau bestätigen und Run fortsetzen.
8. Import abbrechen, ungültige Datei wählen, fünf Plätze belegen: kein Überschreiben
   vorhandener Spieler. Android Zurück/Home während des Dateidialogs kontrollieren.
9. Wenig freien Speicher testen: sichtbarer Speicherfehler; weiter vorhandene gültige
   Sicherung und keine Behauptung eines erfolgreichen Transfers.
10. Multitouch, Safe Areas, Android-Tastatur, drei Grafikstufen, Musik/Audio,
    unterschiedliche Displayformate und längere Endlos-Runs auf echten Geräten prüfen.

Interne atomare Speicherung und vorherige Sicherung bleiben bestehen. EINSTELLUNGEN
→ PROFIL → SICHERUNG LADEN setzt nur den aktiven Spieler auf den letzten internen
Sicherungsstand zurück; EXPORT / IMPORT ist die separate portable Dateiübertragung.
Details und harte Abbruchgrenzen: RUN_RESUME_BACKUP.md.

## Fehler melden

EINSTELLUNGEN → PROFIL → BETA-HILFE enthält eine Anleitung und einen kopierbaren
lokalen Fehlerbericht ohne Spielernamen oder vollständigen Spielstand. Es wird
nichts automatisch hochgeladen. Schritte, Erwartung, tatsächliches Verhalten,
Handymodell und Screenshot ergänzen. Exportierte Profildateien können den selbst
gewählten Profilnamen enthalten; nicht unbedacht öffentlich teilen.

Automatisierte Tests und Linux-GL-Ansichten ersetzen keine physische Android-Abnahme.
Kein physisches Gerät oder Emulator wurde für dieses Update getestet.
