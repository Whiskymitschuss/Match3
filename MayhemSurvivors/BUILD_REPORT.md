# Store-Build0.32.0-beta6 /Code39 — 27.11.2026

Release-AAB tatsächlich gebaut und mit dem bisherigen privaten Upload-Schlüssel signiert.
Datei: MayhemSurvivors-v0.32.0-beta6-store.aab /76467612 Bytes.
SHA256: 55959c508d8e8378d91a4856e4a39d0df11352cf53312b86f99512421d806d4b.
Godot4.6.3 /JDK21 /ARM64 /SDK24–36 /nur VIBRATE /kein INTERNET /allowBackup false.
Bundletool validate, JAR-Signatur, ZIP-CRC,25 Daten-JSONs und16-KiB-Ausrichtung bestanden.
Alle fünf neuen Controllerfamilien kompiliert im AAB vorhanden;849 Laufzeit-/Configdateien
als Export-Quellstand gehasht. Keine Tests, Schlüssel, Profile oder Spielstände im Bundle.
Google Play Games deaktiviert, kein Google-SDK im DEX. Versionsname0.32.0-beta6.
Zertifikat-SHA256: 2A:18:95:FA:8D:27:ED:97:53:0C:E0:18:F9:CC:AE:D3:E7:B2:82:43:62:5C:F1:EF:B4:AC:EA:F7:4D:23:4F:8C.

Android-Build war erfolgreich. ADB-Daemon war nicht erreichbar: kein Gerät angeschlossen.
Nach dem Build wurden502MB regenerierbare Gradle-Ergebnisse entfernt, um Quellprüfung
und Artefaktpakete zu ermöglichen. Templatequellen und signiertes AAB bleiben erhalten.
Kein Play-Console-Upload, kein physischer Android-Test und kein neuer Debug-APK-Build.

Frisches Quell-ZIP ohne Cache importiert: keine Parser-/Ressourcenfehler. Vier Suiten
mit429 Prüfungen und Python5/0 erneut bestanden;849 Laufzeit-/Konfigurationsdateien
bytegleich zum Export-Quellstand. Quellpaket enthält fünf aktuelle GL-Aufnahmen.

---

# Store-Build0.31.0-beta5 /Code38 — 26.11.2026

Release-AAB tatsächlich gebaut und mit unverändertem Upload-Schlüssel signiert.
76431537 Bytes; SHA256 b98783ae54a99102da1f6c0d0a89157cf6a55b1be3b74c2323595033f8500bb8.
Godot4.6.3 /ARM64 /SDK24–36 /nur VIBRATE /kein INTERNET /allowBackup false.
Bundletool, JAR-Signatur, ZIP-CRC,25 Daten-JSONs und16-KiB-Ausrichtung geprüft.
Google Play Games bleibt deaktiviert; keine echten Projekt-IDs vorhanden.
Kein Console-Upload oder physischer Android-Test. Quellarchiv separat geprüft.

---

# Google-Play-Build0.30.0 Beta4 — 24.11.2026

Tatsächlich gebautes, signiertes Release-App-Bundle nach allen Laufzeitänderungen.
Godot4.6.3 stable / OpenJDK21 / AndroidSDK36 / Build-Tools36.1.0 /
offizielle Gradle-Vorlage8.11.1 mit AGP8.6.1.

- Datei MayhemSurvivors-v0.30.0-beta4-store.aab / **76430402 Bytes**.
- SHA256 `e73ad3cbad2abd62062da8f551a26568cbbc79aa45b52d1266cfa9e1bb7d3e20`.
- com.rfworlds.mayhemsurvivors / Code37 /0.30.0-beta4 / ARM64-v8a ausschließlich.
- SDK24–36 / Release nicht debuggable / allowBackup false / nur VIBRATE.
- Gleicher privater Upload-Schlüssel wie Code35/36. Zertifikat-SHA256:
  `2A:18:95:FA:8D:27:ED:97:53:0C:E0:18:F9:CC:AE:D3:E7:B2:82:43:62:5C:F1:EF:B4:AC:EA:F7:4D:23:4F:8C`.

Bundletool1.18.3 validate, JAR-Signatur, ZIP-CRC und Manifest erfolgreich geprüft.
Beide nativen Bibliotheken besitzen16384-Byte-PT_LOAD-Ausrichtung und BundleConfig
PAGE_ALIGNMENT_16K.25 Laufzeit-JSONs bytegleich. Neue Trainings-/Touch-/Build-/
Leaderboard-GDScript-Controller im Assetpack. Keine Tests, privaten Schlüssel,
Spielstände, nativen Quellordner oder Editor-Addons als Spielressourcen im Bundle.

**Online-Status:** Nutzer wählt Google Play Games, hat aber noch kein Spieleprojekt.
Konfiguration bleibt disabled. Im AAB weder Google-Spiele-SDK noch native RFPlayGames-
Klasse im DEX/Manifest und kein INTERNET. Der eigene optionale Java-Adapter wurde
separat tatsächlich kompiliert (Compile-Check ohne echte Projekt-ID), aber nicht
als aktivierte Online-Funktion in diesen Store-Build aufgenommen. Kein erfundener
Projektwert und keine behauptete Google-Verbindung. PLAY_GAMES_SETUP.md beschreibt
die noch nötige Console-Konfiguration und den automatischen optionalen Build-Weg.

ADB tcp:5037 ist nicht erreichbar; dies verhindert den unabhängigen Export nicht.
AGP-Hinweis auf das gegenüber seinem Teststand neuere TargetSDK36 bleibt vorhanden;
Build und Bundlevalidierung bestehen. JAR-Hinweise zu selbstsigniertem Uploadzertifikat,
Trust-Chain und fehlendem Timestamp sind erwartbar; Signatur tatsächlich verifiziert.
Keine physische Installation oder Play-Console-Freigabe durch diesen Workspace.

Quellpaket zusätzlich ohne Cache frisch importiert:283 Prüfungen aus sechs Suiten
(Erstspieler37,Run61,Backup20,Komfort81,UI53,Online-Adapter31) und fünf Python-Tests
erneut bestanden. 833 Laufzeit-/Konfigurationsdateien entsprechen bytegleich
dem getesteten AAB-Quellstand; 141 Test-/Werkzeug-/Native-Quelldateien ebenfalls
bytegleich. Quelle enthält alle Assets, Daten, Szenen, Skripte, optionale Pluginquellen,
Tests, Berichte und zehn neue UI-Aufnahmen, keine Toolchains/Caches/privaten Spielstände.

---

# Google-Play-Build 0.29.0 Beta 3 — 2026-11-24

Tatsächlich gebautes und signiertes Release-App-Bundle mit Godot 4.6.3 stable,
OpenJDK21, Android SDK36 / Build-Tools36.1.0 und offizieller Gradle-Vorlage.

- MayhemSurvivors-v0.29.0-beta3-store.aab / **76388236 Bytes**.
- SHA256 `42184a1b4666226b3c350e77ba94e69e6d80c398240b719fa450cd0770ba3f4d`.
- Paket com.rfworlds.mayhemsurvivors / Code36 / Name0.29.0-beta3.
- Ausschließlich ARM64-v8a / minSDK24 / targetSDK36 / Release, nicht debuggable.
- Nur VIBRATE, kein INTERNET; allowBackup false, Querformat/GL Compatibility.
- Bestehender privater Upload-Schlüssel aus Code35 unverändert; Zertifikat-SHA256:
  `2A:18:95:FA:8D:27:ED:97:53:0C:E0:18:F9:CC:AE:D3:E7:B2:82:43:62:5C:F1:EF:B4:AC:EA:F7:4D:23:4F:8C`.

Bundletool1.18.3 validate erfolgreich, JAR-Signatur verifiziert. Self-signed-/
Trust-Chain-/Timestamp-Hinweise sind bei diesem Uploadzertifikat erwartbar.
Manifest zuerst im JAR; keine Streaming-Inkonsistenz. Alle ZIP-CRCs korrekt.
Beide nativen Bibliotheken haben 16384-Byte-PT_LOAD-Ausrichtung, BundleConfig
PAGE_ALIGNMENT_16K. 24 Laufzeit-JSONs entsprechen exakt den Quellen. Compilierte
Checkpoint-, Session-, Graph-, Backup- und Transfer-Controller nachgewiesen.
Keine Tests, privaten Schlüssel oder App-Spielstände im AAB.

ADB-Daemon tcp:5037 nicht erreichbar; der unabhängige Export war erfolgreich.
AGP8.6.1 weist auf das gegenüber seinem Teststand neuere TargetSDK36 hin; Build
und Bundlevalidierung sind bestanden. Keine Geräteinstallation behauptet.
Der private Schlüssel bleibt außerhalb von Repository und Quell-ZIP.

Das AAB als neue Version derselben Play-Console-App in den internen Test laden.
Code35 wurde laut Nutzer bereits verarbeitet, Code36 ist noch nicht hochgeladen.
Keine direkt installierbare APK. Play-Console-Freigabe und Geräteabnahme bleiben
beim tatsächlichen Store-Test zu erledigen; PLAY_STORE_HANDOFF.md enthält die Schritte.

Quell-ZIP ohne Import-/Buildcache frisch entpackt und importiert: keine Parser- oder
Ressourcenfehler. Erstspieler37/0, Run61/0, Backup20/0 und UI32/0 nochmals bestanden.
812 Laufzeit-/Konfigurationsdateien entsprechen bytegleich dem Snapshot des
gebauten AAB; 130 Test-/Werkzeugskripte ebenfalls bytegleich. Quellpaket enthält
Projekt, Assets, Daten, Szenen, Skripte, Tests, Berichte und neun neue UI-Aufnahmen;
keine Toolchains, Caches, privaten Schlüssel oder Spielerdateien.

---

# Google-Play-Build 0.28.1 Beta 2 — 2026-11-23

Tatsächlich gebautes **Release-App-Bundle** für die neue Play-Console-App.
Godot 4.6.3 stable / vollständiges OpenJDK 21.0.13 / Android SDK 36 / Build-Tools 36.1.0 /
offizielle Android-Gradle-Vorlage (AGP 8.6.1, Gradle 8.11.1).

- Datei: MayhemSurvivors-v0.28.1-beta2-store.aab / **76353437 Bytes**.
- SHA256: `252886e9a650cbc02014aa42bce307e890090661fd422d10b08afbb350815e95`.
- Paket com.rfworlds.mayhemsurvivors / Code 35 / Name 0.28.1-beta2.
- Release, debuggable false / ARM64 ausschließlich / minSDK 24 / targetSDK 36.
- Nur VIBRATE, keine Internetberechtigung, Android-Cloudbackup deaktiviert.
- Eigener RSA-4096-Uploadschlüssel; SHA256 des Zertifikats:
  `2A:18:95:FA:8D:27:ED:97:53:0C:E0:18:F9:CC:AE:D3:E7:B2:82:43:62:5C:F1:EF:B4:AC:EA:F7:4D:23:4F:8C`.
- Private Schlüssel und Passwort nur außerhalb des öffentlichen Repositories;
  separates privates Backup im Workspace. Keine Geheimnisse im Preset/Quellpaket.

Bundletool-Validierung, JAR-Signatur, vollständiger ZIP-CRC und Release-Manifest
geprüft. Native ARM64-Bibliotheken behalten die Bytes der offiziellen Vorlage;
16-KiB-ELF-Ausrichtung und BundleConfig PAGE_ALIGNMENT_16K bestätigt. Keine
mitgelieferten Spielstände, Schlüssel oder Tests. JAR-Manifest zuerst angeordnet,
damit Streaming- und Random-Access-Leser dieselbe Signatur sehen. Bei einem eigenen
Uploadzertifikat sind Self-Signed-/Trust-Chain-/Timestamp-Hinweise von jarsigner
zu erwarten; die tatsächliche JAR-Signatur wurde verifiziert.

Behobene Buildhindernisse: Java-Proxy-Konfiguration, fehlende Build-Tools 36.1,
unvollständige Java-Laufzeit ohne javac und knapper Workspace-Speicher. Installierte
Compilerpakete liegen im beschreibbaren Toolchain-Verzeichnis. Historische Git-
Binärdateien platzsparend gepackt, Originalhistorie erhalten. Nicht benötigte
native ABIs aus der generierten Release-AAR entfernt; nur ARM64 wird ausgeliefert.
AGP weist darauf hin, dass SDK 36 neuer ist als sein getestetes SDK 35; der Build
und die anschließende Bundle-Validierung waren erfolgreich. Kein ADB-Gerät verbunden.

Das Bundle ist noch nicht in einer Play Console angenommen oder veröffentlicht.
Es ist keine direkt installierbare APK. Play App Signing, App-Eintrag, Kontakt- und
Inhaltsangaben, Store-Grafiken, Testerkreis und Android-Geräteabnahme stehen aus;
PLAY_STORE_HANDOFF.md führt die tatsächlichen nächsten Schritte auf.

---

# Android-Build 0.28.0 Beta 1 — 2026-11-23

Tatsächlicher Debug-Export nach allen Laufzeitänderungen: Godot 4.6.3 stable,
JDK 21, SDK 36 und Build Tools 36.0.0.

- MayhemSurvivors-v0.28.0-beta1-debug.apk / **78383759 Bytes**.
- SHA256: `e421b13f789b766ae111514e802864c12bfcb5944f6665da0131baa31a60c8c5`.
- com.rfworlds.mayhemsurvivors / versionCode 34 / versionName 0.28.0-beta1.
- Nur ARM64-v8a / minSDK 24 / targetSDK 36 / Querformat / GL Compatibility.
- Signatur v2/v3 und 16-KiB-zipalign tatsächlich geprüft. Gleiches Zertifikat:
  `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- Nur VIBRATE-Permission, keine Internetberechtigung. APK-CRC, Daten, kompilierte
  Speicher-/Profil-/Beta-Controller und originales Profilicon nachgewiesen.
  Spielinhalte, bestehende Musik und Sounds enthalten. Keine Tests/Capturegalerien.
- Frisches Quellprojekt: 40 Suiten / 9973 Prüfungen und beide Traces grün;
  800 Laufzeitdateien plus Konfiguration sowie Tests/Runner bytegleich zum APK-Stand.
- Quell-ZIP enthält alle Assets, Szenen, Daten, Skripte, Tests, Generatoren und
  Berichte sowie 13 ausgewählte Abnahmebilder. Kein Cache, SDK, APK, privater
  Schlüssel oder persönlicher Spielstand. Finale Archivintegrität separat geprüft.

Über die vorhandene App installieren, nicht vorher deinstallieren. Paketname,
Signierschlüssel und Datenformat 3 bleiben kompatibel; der bisherige Spielstand
bleibt Spieler 1 am bisherigen Pfad. Zusätzliche Daten liegen im lokalen Profilbereich.
Android-Backup ins Netz bleibt deaktiviert. Details: BETA_TESTING.md.

Der nicht erreichbare lokale ADB-Daemon (tcp:5037) verhindert den Export nicht.
Keine physische Installation oder Android-Leistungsmessung behauptet. Diese
Debug-APK dient dem geschlossenen Test, keiner Store-Veröffentlichung. Für letztere
werden später ein Release-Build und ein Android App Bundle benötigt.

Logs: tests/results/v0.28.0-beta1-{build,signature,alignment,manifest,payload,
clean-import,clean-tests,source-integrity,archive}.log. Öffentliche Artefakte und
Prüfsummen unter Downloads. Vollständiger anonymer Downloadnachweis nach dem Upload
separat unter Downloads/VERIFY-v0.28.0-beta1.txt.

---

## Frühere Builds

# Android-Build 0.27.0 — 2026-11-23

Tatsächlicher Debug-Export nach den finalen Laufzeitänderungen: Godot 4.6.3 stable,
JDK 21, Android SDK 36 und Build Tools 36.0.0.

- MayhemSurvivors-v0.27.0-debug.apk / **78354194 Bytes**.
- SHA256: `209e6e4bbb6d59603f4345e79a756f94e98c69c00021e1aacf91ea6ece5f9df2`.
- com.rfworlds.mayhemsurvivors / versionCode 33 / versionName 0.27.0.
- Nur ARM64-v8a / minSDK 24 / targetSDK 36 / Querformat / GL Compatibility.
- Signatur v2/v3 und 16-KiB-zipalign tatsächlich geprüft. Gleiches Zertifikat:
  `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- Nur VIBRATE-Permission; keine Internetberechtigung. APK-CRC und exakte Arena-/
  Taktik-/Charakter-/Sammlungs-/Fähigkeitsdaten verifiziert. Kompilierte Taktik- und
  Vergleichscontroller, sechs Werkzeug-SVGs und drei neue Soundimporte vorhanden.
  Bestehende Musik und Funktionen enthalten. Keine Tests oder Capturegalerien im APK.
- Frisch entpacktes Projekt: 38 Suiten / 9.890 Prüfungen und beide Traces grün.
  790 Laufzeitdateien plus Konfiguration sowie Tests/Runner bytegleich geprüft.
- Quell-ZIP mit allen Laufzeitdateien, Szenen, Assets, Daten, Tests, Berichten und
  Generatoren; 13 ausgewählte Abnahmebilder. Kein Cache, SDK, APK oder privater
  Signierschlüssel. Finale Archivbytes werden gegen den getesteten Stand verglichen.

Als Update über die bestehende App installieren. Paketname, Signierschlüssel und
lokales Profilschema 3 bleiben kompatibel. Figuren, Welten, Gegenstände und bisherige
Statistik bleiben erhalten. Die neuen Arena-Hilfen werden defensiv geladen.

Nicht erreichbarer lokaler ADB-Daemon (tcp:5037) im Exportlog; der Export und die
unabhängigen SDK-Prüfungen waren erfolgreich. Keine physische Android-Installation
oder Leistungsmessung behauptet. Details: TEST_REPORT.md und ARENA_TACTICS.md.

Protokolle unter tests/results/v0.27.0-*: build, signature, alignment, manifest,
payload, clean-import, clean-tests, source-integrity und archive. Öffentliche APK,
ZIP und SHA256SUMS unter Downloads. Der nach dem Upload erstellte vollständige
anonyme Downloadnachweis liegt separat unter Downloads/VERIFY-v0.27.0.txt.

---

## Frühere Builds

# Android-Build 0.26.0 — 2026-11-19

Tatsächlicher Debug-Export mit Godot 4.6.3 stable, JDK 21, Android SDK 36 und
Build Tools 36.0.0 nach den finalen Laufzeitänderungen.

- MayhemSurvivors-v0.26.0-debug.apk / **78.253.509 Bytes**.
- SHA256: `7b391770889ef82cba735e8f50a5f8e2a10a509c0e254d5f1618e5c51988702f`.
- com.rfworlds.mayhemsurvivors / versionCode 32 / versionName 0.26.0.
- ARM64-v8a ausschließlich / minSDK 24 / targetSDK 36 / Querformat / GL Compatibility.
- Signatur v2/v3 und 16-KiB-zipalign tatsächlich verifiziert. Gleiches Zertifikat:
  `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- Nur VIBRATE-Permission, keine Internetberechtigung. APK-CRC und exakte Item-/
  Fähigkeits-/Boss-/Charakter-/Sammlungsdaten geprüft. Kompilierte Crew-, Settings-,
  Analyse- und Skincontroller, neue Figuren-/Icon-/SFX-Importe sowie drei Musikstücke
  und Mastermix vorhanden. Keine Tests oder Screenshotgalerien im APK.
- Frischer Quellimport ohne Cache: 36 Suiten / 5.761 Prüfungen, beide Traces grün.
  767 Laufzeitdateien plus Projekt-/Exportkonfiguration bytegleich zum APK-Stand.
  Finale ZIP-Inhalte zusätzlich gegen diese geprüften Dateien verglichen.
- Quell-ZIP enthält Projekt, Assets, Szenen, Daten, Scripts, Tests, ausgewählte
  Abnahmebilder, Berichte und Werkzeuge; keinen Cache, SDK oder privaten Schlüssel.

Über die vorhandene App installieren. Paketname, Signierschlüssel und Profilschema 3
bleiben kompatibel. Alte Figuren, Freischaltungen, Bestwerte und Ausrüstung erhalten;
neue Figuren kommen über Crew-Cases, neue Details werden defensiv geladen.

Der Export meldet einen nicht erreichbaren ADB-Daemon (tcp:5037); das APK wurde
unabhängig davon erfolgreich gebaut und mit SDK-Werkzeugen geprüft. Kein Gerät
angeschlossen, keine tatsächliche Android-Installation oder Geräteleistung behauptet.

Rohprotokolle: tests/results/v0.26.0-{build,signature,alignment,manifest,payload,
clean-import,clean-tests,source-integrity,archive}.log. Öffentliche Artefakte und
SHA256SUMS unter Downloads. Der nach dem Upload erstellte anonyme vollständige
Downloadnachweis liegt separat im GitHub-Repo unter Downloads/VERIFY-v0.26.0.txt.

---

## Vorherige Builds

# Android-Build 0.25.0 — 2026-11-18

Tatsächlicher Debug-Export mit Godot 4.6.3 stable, JDK 21, Android SDK 36 und
Build Tools 36.0.0. Nach den letzten UI-Korrekturen erneut erzeugt und geprüft.

- MayhemSurvivors-v0.25.0-debug.apk / 76180130 Bytes.
- SHA256: `60fca96d5cc2262388d9454b781d7f13f88c72408f9c2f29ab127550c5173f7d`.
- com.rfworlds.mayhemsurvivors / versionCode 31 / versionName 0.25.0.
- Nur ARM64-v8a / minSDK 24 / targetSDK 36 / Querformat / GL Compatibility.
- Signatur v2/v3 und 16-KiB-zipalign tatsächlich verifiziert. Gleiches Zertifikat:
  `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- Nur VIBRATE-Permission, kein Internetrecht. APK-CRC, exakte Item-/Fähigkeits-/
  Bossdaten, kompilierter Synergiencontroller und Aufrufer, drei importierte Icons
  und drei Soundimporte geprüft. Keine Tests im APK.
- Quell-ZIP ohne Cache, SDK, APKs und private Schlüssel. Frisch entpackt/importiert:
  34 Suiten / 5.434 Prüfungen und beide Traces grün. 720 Laufzeitdateien und beide
  Projekt-/Exportkonfigurationen bytegleich zur geprüften Entpackung.

Über die vorhandene App installieren. Paketname, Schlüssel und Profilschema 3
bleiben kompatibel; die neue Run-Item-Historie erkennt alle drei Modulkennungen.
Der Export meldet einen nicht erreichbaren ADB-Daemon (tcp:5037); das APK wurde
unabhängig davon erfolgreich gebaut und mit den SDK-Werkzeugen verifiziert.
Es wurde kein Gerät angeschlossen und keine Installation auf Android behauptet.

Rohprotokolle: tests/results/v0.25.0-{build,signature,alignment,manifest,payload,
clean-import,clean-tests,source-integrity}.log. Öffentliche Artefakte und SHA256SUMS
unter Downloads. Der vollständige anonyme Downloadnachweis wird nach dem Upload
separat in Downloads/VERIFY-v0.25.0.txt und einem Downloadprotokoll dokumentiert.

---

## Vorherige Builds

# Android-Build 0.24.0 — 2026-11-18

Tatsächlicher erfolgreicher Debug-Export mit Godot 4.6.3 stable, JDK 21,
Android SDK 36 und Build Tools 36.0.0.

- MayhemSurvivors-v0.24.0-debug.apk / 76145918 Bytes.
- SHA256: `7beeaccb66d0ee0f9103fb4e8df8d86ec58e8f358e57b3549a942ad8d2b68b0a`.
- com.rfworlds.mayhemsurvivors / versionCode 30 / versionName 0.24.0.
- ARM64-v8a ausschließlich / minSDK 24 / targetSDK 36 / Querformat / GL Compatibility.
- Signatur v2/v3 und 16-KiB-zipalign geprüft. Zertifikat unverändert:
  `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- Nur VIBRATE-Permission, keine Internetberechtigung. APK-CRC, exakte Arenendaten,
  kompilierter Ventilcontroller, Texturimport und vier Soundimporte verifiziert.
- Keine Tests im APK. Quellprojekt mit allen notwendigen Dateien, ohne Cache,
  SDK, APKs oder private Schlüssel. Frisch importiert: 33 Suiten / 5.194 Prüfungen,
  beide Traces und 706 bytegleiche Laufzeitdateien plus Konfigurationen.

Als Update über die vorhandene App vorgesehen. Profilschema 3 bleibt kompatibel;
vorhandene Arenenhilfen bleiben erhalten, der neue Glutwerk-Status wird defensiv geladen.
Keine tatsächliche Installation auf einem physischen Android-Gerät erfolgt.

Rohprotokolle unter tests/results/v0.24.0-*: build, signature, alignment, manifest,
payload, clean-import, clean-tests und source-integrity. Artefakte/Prüfsummen unter
Downloads; vollständige anonyme Downloadprüfung folgt separat nach dem Upload.

---

## Vorherige Builds

# Android-Build 0.23.0 — 2026-11-18

Tatsächlicher erfolgreicher Debug-Export: Godot 4.6.3 stable, JDK 21, Android SDK 36,
Build Tools 36.0.0.

- MayhemSurvivors-v0.23.0-debug.apk / **76,103,712 Bytes**.
- SHA256: `7a1e8343408b2b5d76e931536b402a9e16ceeda2ed08f2513586f211c0be605f`.
- com.rfworlds.mayhemsurvivors / versionCode 29 / versionName 0.23.0.
- ARM64-v8a ausschließlich / minSDK 24 / targetSDK 36 / Querformat / GL Compatibility.
- Signatur v2/v3 und 16-KiB-zipalign erfolgreich geprüft. Gleicher Update-Schlüssel:
  Zertifikat-SHA256 `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- Nur VIBRATE-Permission; keine Internetberechtigung. APK-CRC, exakte Arenen-JSONs,
  zwei kompilierte neue Controller, zwei SVG-Texturimporte und fünf Soundimporte geprüft.
- Keine Testdateien im APK. Die Quellübergabe enthält alle Assets, Szenen, Daten,
  Skripte, Tests, Berichte und Werkzeuge, ohne Cache/SDK/APKs/private Schlüssel.

Als Update über die bestehende App vorgesehen. Profilschema 3 kompatibel; der neue
optionale Hilfestatus wird defensiv geladen. Eine physische Geräteinstallation
wurde hier nicht durchgeführt.

Frisches Quellprojekt ohne Cache importiert: alle 32 Suiten / 4.977 Prüfungen und
beide Traces bestanden, 694 Laufzeitdateien plus Konfigurationen bytegleich.
Rohprotokolle: tests/results/v0.23.0-build.log, -signature.log, -alignment.log,
-manifest.log, -payload.log, -clean-import.log, -clean-tests.log, -source-integrity.log.
Öffentliche Artefakte und Prüfsummen unter Downloads. Die vollständige anonyme
Downloadprüfung wird nach dem Upload separat protokolliert.

---

## Vorherige Builds

# Android-Build 0.22.0 — 2026-11-18

Tatsächlicher erfolgreicher Debug-Export mit Godot 4.6.3 stable / JDK 21 /
Android SDK 36 / Build Tools 36.0.0.

- Datei: MayhemSurvivors-v0.22.0-debug.apk / **76.052.611 Bytes**.
- SHA256: `307330fe72bd4620c10b15c3b15747dc445ee9f6e3d84d893a37aceaad7a08f9`.
- Paket: com.rfworlds.mayhemsurvivors / versionCode 28 / versionName 0.22.0.
- ARM64-v8a ausschließlich / minSDK 24 / targetSDK 36 / Querformat / GL Compatibility.
- Signaturen v2 und v3 sowie zipalign -c -P 16 -v 4 erfolgreich verifiziert.
- Signierschlüssel unverändert: Zertifikat-SHA256
  `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- Nur VIBRATE-Berechtigung; keine Internetberechtigung, keine Online-Abhängigkeit.
- APK-CRC, exakte Tutorial-/Arenendaten, drei neue kompilierte Controller und drei
  Soundimporte geprüft. Keine Testdateien im APK.

Die APK ist als Update über die bestehende App vorgesehen. Profil-Schema 3 bleibt
kompatibel; die neue optionale Einführungsmarkierung wird defensiv geladen.
Eine Installation auf einem physischen Gerät wurde hier nicht durchgeführt.

Das vollständige Godot-Quellprojekt enthält Szenen, GDScript, Daten, alle notwendigen
Assets, Tests, Werkzeuge, Lizenzen und Berichte. Cache, SDK, APKs und private Schlüssel
sind ausgeschlossen. Nach frischem Quellimport sind alle 31 Suiten / 4.757 Prüfungen
und beide Traces bestanden; 674 Laufzeitdateien und beide Konfigurationen bytegleich.

Rohprotokolle: tests/results/v0.22.0-build.log, -signature.log, -alignment.log,
-manifest.log, -payload.log, -clean-import.log, -clean-tests.log und -source-integrity.log.
Öffentliche Artefakte und ihre Prüfsummen liegen im Repository unter Downloads.
Die anonyme vollständige Downloadprüfung wird nach dem Upload separat protokolliert.

---

## Vorheriger Build

# Android-Build 0.21.2 — 2026-11-18

Godot4.6.3 stable / JDK21 / Android SDK36 / Build Tools36.0.0.
Tatsächlicher signierter Debug-Export erfolgreich.

- MayhemSurvivors-v0.21.2-debug.apk / 76014568 Bytes.
- SHA256 `83f428e40f8f2bb004eb58894542384524d32b60a25345c32874e3282cfadabb`.
- com.rfworlds.mayhemsurvivors / versionCode27 / versionName0.21.2.
- ARM64-v8a ausschließlich / minSDK24 / targetSDK36 / Landscape / GL Compatibility.
- v2/v3-Signatur und zipalign -c -P16 4 geprüft. Gleicher Update-Schlüssel wie0.21.1:
  5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce.
- Exakte neue Boss-/Waffen-/Entwicklungsdaten, kompilierter Controller, Archiv-CRC
  geprüft. Keine Tests im APK. Nur VIBRATE-Permission, kein INTERNET.

Über die bisherige App installieren. Case-Hotfix, Helden, Coins und Statistiken bleiben
erhalten; kein Save-Schemawechsel. Kein erreichbares Android-Gerät zur Installation.
Quell-ZIP mit kompletten Laufzeitdateien, Assets, Szenen, Daten, Tests und Berichten;
ohne Cache/SDK/APKs/private Schlüssel. Öffentliche Downloads mit separaten Prüfsummen.

Quell-ZIP zusätzlich ohne Importcache frisch entpackt und importiert. Alle30 Suiten /
4590 Prüfungen und beide Traces erneut bestanden;662 Laufzeitdateien bytegleich.
Logs:v0.21.2-clean-import.log, v0.21.2-clean-tests.log, v0.21.2-source-integrity.log.
