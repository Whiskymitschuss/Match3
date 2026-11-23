# RF Worlds — Mayhem Survivors 0.28.1 Beta 2

Android / Godot 4.6.3 stable / GDScript / ARM64 / vollständig offline.
15 Kämpfer, zehn Welten, Kampagne und Endlos. Store-Beta für eine neue Play-Console-App.

## Der neue Spielerstart

Nur Bruiser, Hammer Rang 1 und Welt 1 sind verfügbar. Studio-Coins, Teile, Tickets,
Cases, Statistiken, Weltabschlüsse und Passfortschritt beginnen bei null. Weitere
Kämpfer, Gegenstände, Skins und Dekorationen müssen erspielt werden. Kicksy erklärt
im Tutorial die Steuerung. Training schenkt keinen dauerhaften Fortschritt.

Bis zu fünf lokale Profile halten ihre Sammlungen, Aufgaben, Währungen,
Einstellungen und Statistiken getrennt. Jeder neue Spieler startet unter denselben
Bedingungen. Bestehende eigene Daten bleiben bei Updates erhalten. Atomare
Speicherung, automatische Wiederherstellung und Sicherungen bleiben verfügbar.
Keine Anmeldung, Werbung, Echtgeldkäufe, Server oder Internetberechtigung.

[Google-Play-Übergabe](PLAY_STORE_HANDOFF.md) · [Betatest](BETA_TESTING.md) · [Arena-Taktik](ARENA_TACTICS.md)

## Spielen und testen

Links per Touch-Joystick bewegen; Waffen greifen automatisch an. Rechts die
Fähigkeit benutzen. Bosse in Welle 2/4/6/8/10, Wellenshop, XP-Upgrades, Entwicklungen,
Cases und Sammlung. Aufgaben, Weltbelohnungen und Runs liefern erspielte Spielmittel.
Dauerhafter Fortschritt wird gesichert. Ein aktiver Run wird nach vollständigem
App-Ende nicht wiederhergestellt. Normale Android-Unterbrechung pausiert.

Das signierte Release-AAB gehört in die Google Play Console. Die App wurde dort
noch nicht angelegt oder veröffentlicht. Der Testlink entsteht nach Einrichtung
der App und Tester. Google Play signiert die installierbare App über Play App Signing;
die bisherige Debug-APK besitzt einen anderen Schlüssel. Details in der Übergabe.

## Godot-Projekt und Exporte

project.godot mit Godot 4.6.3 stable öffnen und importieren; die Hauptszene ist bereits
konfiguriert. Keine Szenen oder Skripte müssen von Hand zusammengesetzt werden.
Android-Paket com.rfworlds.mayhemsurvivors / VersionCode 35 / API 24–36 / Querformat /
GL Compatibility. Preset Android für Entwicklungs-APKs; Preset Google Play für Release-AAB.

Für Store-Neubauten: passende Android-Exportvorlagen, vollständiges JDK und Android SDK
in Godot konfigurieren. tools/build_store.py liest externen Keystore und Passwortdatei,
installiert bei Bedarf die passende Vorlage und hält nur die benötigten ARM64-Bibliotheken.
Private Schlüssel niemals im Projekt oder GitHub speichern. Der tatsächliche Upload-Schlüssel
wurde getrennt im privaten Workspace-Verzeichnis gesichert.

## Nachweise

41 Suiten / 10014 Prüfungen bestanden, dazu beide historischen Regressionstraces.
Native Profil- und Case-Touchtests: 42 beziehungsweise 74 Prüfungen bestanden.
15 neue UI-Ansichten in drei Formaten erzeugt; relevante Willkommens- und Case-
Ansichten visuell geprüft. Keine Aussage über echte Geräte-FPS oder Store-Freigabe.
TEST_REPORT.md und BUILD_REPORT.md enthalten die tatsächlichen Prüfungen und Grenzen.
