# Google Play — Beta 2 (0.28.1)

Ziel ist eine neue Android-App in der vorhandenen Play Console von RF Worlds.
Die App wurde noch nicht in der Console angelegt. Dieser Quellstand veröffentlicht
keinen Store-Eintrag und lädt nichts in ein Google-Konto hoch.

## Neue Spieler starten bei null

Eine frische Installation ohne lokale App-Daten startet mit Bruiser, Hammer Rang 1
und Welt 1 (Schrottplatz). Studio-Coins, Run-Coins, Teile, Tickets, geöffnete Cases,
Statistiken, Weltabschlüsse und Passfortschritt sind null. Es gibt keine weiteren
freigeschalteten Kämpfer, Gegenstände, Skins oder Dekorationen. Kicksy bietet das
Tutorial an; Training vergibt keine dauerhaften Belohnungen. Weitere lokale
Profile beginnen unter denselben Bedingungen.

Runs, Aufgaben und Weltabschlüsse liefern erspielte Belohnungen. Nach dem ersten
Weltabschluss lässt sich die erste Crew-Case-Belohnung abholen. Eine bestehende
Installation behält ihren eigenen bisherigen Spielstand bei einem Update. Ein
Spielstand des Entwicklers wird niemals als Startstand mitgeliefert.

## Build und Schlüssel

- Paket: `com.rfworlds.mayhemsurvivors`
- Version: `0.28.1-beta2`, VersionCode `35`
- Google-Play-Preset: **Google Play**, Release / AAB / ausschließlich ARM64
- Mindestversion: Android API 24; Target SDK 36
- Renderverfahren: GL Compatibility; Querformat; lokale Daten, kein Internetzugriff
- Automatisches Android-Datenbackup deaktiviert; keine Cloud-Übertragung

Das AAB wird mit einem separaten Upload-Schlüssel signiert. Private Schlüssel und
Passwörter gehören außerhalb des GitHub-Repositories und des Quell-ZIPs sicher
aufbewahrt. Das Build-Werkzeug `tools/build_store.py` liest sie aus externen Dateien
und schreibt sie nicht ins Export-Preset. Die Android-Buildvorlage wird bei Bedarf
automatisch installiert; die Gradle-Abhängigkeiten benötigen beim Bauen Internet.

Für die neue App **Play App Signing mit einem von Google erzeugten App-Signierschlüssel**
verwenden. Der Upload-Schlüssel autorisiert spätere Bundles; Google signiert die
installierbaren Store-Versionen mit dem App-Signierschlüssel. Die bisherige
Debug-APK hat einen anderen Schlüssel und ist kein Store-Upload.

Ein Wechsel von der bisherigen Debug-Installation zur Store-App ist daher kein
garantiertes Update. Für einen sauberen Erstspieler-Test eine separate Android-
Testumgebung ohne vorhandene App-Daten verwenden. Normale künftige Store-Updates
setzen den Fortschritt nicht zurück.

## In der Play Console fertigzustellen

1. Neue App mit Name **Mayhem Survivors**, Standardsprache Deutsch und Typ Spiel
   anlegen. Paketname wird durch den ersten Bundle-Upload festgelegt.
2. Play App Signing aktivieren und das signierte Release-AAB in den internen Test
   hochladen. Einen höheren VersionCode für jeden späteren Upload verwenden.
3. Unter App-Inhalte die tatsächlichen Angaben zu Zielgruppe, Comic-Gewalt,
   Inhaltsbewertung, Werbung, App-Zugriff und Datensicherheit ausfüllen. Keine
   Anmeldung, Werbung, Echtgeldkäufe oder automatische Datenerhebung im Spiel.
   Die Zufalls-Cases werden ausschließlich mit erspielten Spielmitteln geöffnet.
4. Store-Texte aus `store/de-DE/listing.txt` übernehmen. Echte Kontaktangaben von
   RF Worlds ergänzen und die Datenschutzerklärung als öffentlich erreichbare
   Webseite verlinken. `store/PRIVACY_DE.md` beschreibt die aktuelle App.
5. Ein 512×512-App-Icon, eine 1024×500-Featuregrafik und aussagekräftige Android-
   Screenshots im geforderten Format hinterlegen. Vorhandene Spielgrafiken sind
   die Grundlage; echte Gerätescreenshots erst nach der Geräteabnahme verwenden.
6. Testerkreis hinzufügen, Testversion prüfen und Testlink teilen. Anschließend
   die für dieses Entwicklerkonto in der Console angezeigten Voraussetzungen
   für den geschlossenen Test beziehungsweise Produktionszugriff erfüllen.

Es fehlen bis zur tatsächlichen Store-Freigabe insbesondere Console-Einrichtung,
Kontakt-/Zielgruppenangaben, Store-Material, Prüfung durch Google und echte
Android-Gerätetests. Ein erfolgreicher AAB-Build ersetzt diese Schritte nicht.

## Erstspieler-Abnahme über den Store

- App aus dem Testlink neu installieren: ausschließlich Bruiser und Schrottplatz;
  sämtliche Guthaben und Fortschritte null, keine Gratistickets.
- Tutorial beenden: keine dauerhaften Coins, Gegenstände oder Kämpfer geschenkt.
- Einen regulären Run spielen, Belohnungen und Freischaltungen prüfen.
- Erstes Weltfinale besiegen, Weltbelohnung einmal abholen, erste Crew-Case öffnen.
- App schließen, erneut öffnen und später über den Store aktualisieren: nur der
  eigene erspielte Fortschritt bleibt erhalten.
- Zweites lokales Profil starten: erneut bei null, ohne Fortschritt des ersten.
- Android-Unterbrechung, Safe Area, Tastatur, Multitouch, Audio, lange Runs und
  unterschiedliche Geräte nach `BETA_TESTING.md` testen.

Ein aktiver Run wird nach vollständigem App-Ende weiterhin nicht wiederhergestellt.
Alle dauerhaften Daten bleiben offline auf dem jeweiligen Gerät. Eine Deinstallation
oder das Löschen der Android-App-Daten entfernt diese lokalen Daten.
