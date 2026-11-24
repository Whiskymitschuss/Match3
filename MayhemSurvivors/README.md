# RF Worlds — Mayhem Survivors 0.29.0 Beta 3

Android / Godot 4.6.3 stable / GDScript / ARM64 / vollständig offline.
15 Kämpfer, zehn Welten, Kampagne und Endlos. Store-Update mit fortsetzbaren Runs
und manueller Übertragung lokaler Spielerprofile.

## Spielen und sichern

Links per Touch-Joystick bewegen; Waffen greifen automatisch an. Rechts die
Fähigkeit benutzen. Bosse in Welle 2/4/6/8/10, Wellenshop, XP-Upgrades, Entwicklungen,
Cases und Sammlung. Aufgaben, Weltbelohnungen und Runs liefern erspielte Spielmittel.

Ein laufender Kampagnen-/Endlos-Run wird etwa alle zehn Kampfsekunden sowie an
wichtigen Übergängen gesichert. Pause und „SICHERN & HAUPTMENÜ“ sichern unmittelbar.
Nach einem Neustart im Hauptmenü FORTSETZEN wählen. Kämpfe werden pausiert geladen;
Shop und offene Levelwahl behalten ihre Angebote. Kein Fortschritt durch Offline-Zeit.

EINSTELLUNGEN → PROFIL → EXPORT / IMPORT erstellt eine portable JSON-Datei des
aktiven Spielers. Der Import zeigt eine Vorschau und legt nach Bestätigung ein
zusätzliches Profil an; er überschreibt keine anderen Spieler. Fünf Profilplätze.
Datei selbst auf ein anderes Gerät übertragen; keine automatische Cloud-Anbindung.
Details, Grenzen und Tests: [RUN_RESUME_BACKUP.md](RUN_RESUME_BACKUP.md).

## Der neue Spielerstart bleibt unverändert

Nur Bruiser, Hammer Rang 1 und Welt 1 sind verfügbar. Studio-Coins, Teile, Tickets,
Cases, Statistiken, Weltabschlüsse und Passfortschritt beginnen bei null. Weitere
Kämpfer, Gegenstände, Skins und Dekorationen werden erspielt. Kicksy erklärt im
Tutorial die Steuerung; Training schenkt keinen dauerhaften Fortschritt.

Bis zu fünf lokale Profile halten Sammlung, Aufgaben, Währungen, Einstellungen,
Statistiken und je einen aktiven Run getrennt. Bestehende eigene Daten bleiben bei
regulären Store-Updates erhalten. Keine Anmeldung, Werbung, Echtgeldkäufe oder Server.

## Godot-Projekt und Exporte

project.godot mit Godot 4.6.3 stable öffnen und importieren; Hauptszene und alle
Ressourcen sind konfiguriert. Keine Szenen oder Skripte müssen zusammengesetzt werden.
Paket com.rfworlds.mayhemsurvivors / VersionCode 36 / API 24–36 / Querformat /
GL Compatibility. Preset Android für Entwicklungs-APKs; Google Play für Release-AAB.

Store-Neubauten benötigen passende Android-Exportvorlagen, vollständiges JDK und
Android SDK. tools/build_store.py liest Keystore und Passwortdatei von außerhalb
des Projekts. Den bestehenden privaten Upload-Schlüssel sicher getrennt aufbewahren.
tools/run_tests.py --traces führt die ausgelieferten Tests mit isoliertem App-Speicher aus.
tools/package_source.py erstellt das vollständige Quell-ZIP ohne generierte Caches.

[Google-Play-Übergabe](PLAY_STORE_HANDOFF.md) · [Betatest](BETA_TESTING.md) ·
[Testbericht](TEST_REPORT.md) · [Buildbericht](BUILD_REPORT.md)
