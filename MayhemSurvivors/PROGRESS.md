# 0.32.0 Beta6 — Implementierung und Build geprüft

Implementiert: individuelle Bossmuster für die Zwischenbosse und zehn Map-Finale,
angekündigte Biss-/Sprung-/Stampfangriffe für die drei Grundgegner, physische
wertabhängige Münzen (Gold/Grün/Blau/Violett), schräge Nahkampfposen,15 unterschiedliche
Fähigkeitensymbole, KRIT-Schrift und eigene synthetisierte Sounds. Case-Pool wird vor
gewichteter Ziehung gemischt; Öffnung zeigt echten, bereits gespeicherten Fund.
Bestehende Checkpoint-Struktur bleibt bestehen; Münzen als optionales Loot-Feld.

49 Suiten/10513 Prüfungen grün, Traces33/87, native Case-Navigation74/0, Python5/0.
Native GL-Motive aller15 Helden und wichtige Kampfsituationen geprüft. AABCode39
gebaut, signiert und validiert. Google Play Games bleibt ohne Projekt/IDs deaktiviert.
Frisches Quell-ZIP: Import fehlerfrei,429 Prüfungen und Python5/0 erneut grün;
849 Laufzeitdateien entsprechen dem signierten Export-Quellstand.
Veröffentlicht: feature/combat-identity-v0.32.0, Draft-PR #18, kein Merge.
AAB/ZIP/TXT vollständig anonym heruntergeladen und SHA256/Bytezahlen verglichen.
Nachweis: Downloads/VERIFY-v0.32.0-beta6.txt. Quell-ZIP enthält den geprüften Stand
vor diesem nachträglichen Übergabevermerk. Nächster Schritt: interner Play-TestCode39.
Offen danach: echter Android-Spieltest mit Fokus Ausweich-Balancing, Ton und Effektlast.

---

# Übergabe0.31.0 Beta5 — 26.11.2026

Code, signiertes AABCode38 und Quell-ZIP im Branch feature/combat-wow-v0.31.0
veröffentlicht. Draft-PR #17 erstellt, kein Merge. AAB/ZIP/TXT vollständig anonym
heruntergeladen und Bytezahlen/SHA256 mit den Originalen verglichen.
Nachweis separat: Downloads/VERIFY-v0.31.0-beta5.txt.229 gezielte Prüfungen und
beide Traces grün; native GL-Effekte gerendert. Nächster Schritt: interner Store-
ReleaseCode38 und echte Android-Abnahme von Lesbarkeit, Effektlast und Spielgefühl.
Google Play Games weiterhin deaktiviert; Projekt/IDs fehlen. Kein Console-Upload.
Quell-ZIP enthält den geprüften Stand vor dem nachträglichen Downloadnachweis.

---

# 0.31.0 Beta5 — kräftigeres Kampf-Feedback

Auftrag26.11.2026: mehr Effekte und stärkere Erfolgsmomente. Implementiert:
farbige Fähigkeiten-Bursts für alle15 Fighter, zusätzliche Explosions-Druckringe,
Krit-Trefferringe, Schuss-Speedlines, Boss-Phasenimpulse und animierte Schadenszahlen.
Effekte bleiben kosmetisch, begrenzt und verwenden ausschließlich visuellen RNG.
Ruhige Menüs reduziert Bewegung; LOW lässt Schuss-Speedlines weg.
229 Prüfungen und beide Traces bestanden; native Effektaufnahmen geprüft.
Signiertes Store-AABCode38 gebaut und validiert. Aktuell: Quellpaket und öffentliche Downloads prüfen.
Google Play Games bleibt mangels Spieleprojekt deaktiviert.

---

# Übergabe0.30.0 Beta4 — 26.11.2026

Code und geprüfte Artefakte im Branch feature/beta-all-six-v0.30.0 veröffentlicht.
Draft-PR #16 erstellt, nicht zusammengeführt. AAB, Quell-ZIP und Update-TXT komplett
anonym heruntergeladen; Bytezahlen und SHA256 stimmen mit den lokalen Originalen
überein. Nachweis: Downloads/VERIFY-v0.30.0-beta4.txt, nach dem Quellpaket erstellt.
AAB76430402 Bytes, ZIP77507846 Bytes. Arbeitsstand sauber; kein Console-Upload.

Fünf lokale Funktionen fertig: Run-Fortsetzen, Profil-Dateien, Touchlayout,
Boss-Training und Ausrüstungs-Builds. Google-Play-Anbindung implementiert/vorbereitet,
aber im Store-Build deaktiviert. Nutzer hat Google Play Games gewählt und noch
kein Spieleprojekt angelegt. Nächster erforderlicher Schritt: Play-Spieldienste-
Projekt und zwei Listen nach PLAY_GAMES_SETUP.md erstellen. Numerische Projekt-ID
und beide Bestenlisten-IDs fehlen. Keine echte Google-Anmeldung oder Geräteabnahme.

Der Nutzer kann Code37 bereits über den internen Store-Test installieren und die
lokalen Funktionen prüfen. Für aktivierte Online-Funktionen nach Erhalt der IDs
einen höheren VersionCode bauen und reale SDK-/Kontotests durchführen. Das ZIP
bildet den geprüften Quellstand vor diesem nachträglichen Downloadnachweis ab.

---

# 0.30.0 Beta4 — Implementierung und Store-Build geprüft

Stand24.11.2026. Branch feature/beta-all-six-v0.30.0.
Nutzerauftrag: alle sechs Ideen. Google Play Games ausdrücklich gewählt; Nutzer
bestätigt, dass das Spieleprojekt noch nicht angelegt ist. Keine echten Kennungen.

Fertig spielbar: Run-Fortsetzen, portable Profile, Touchlayout-Editor, Boss-Training
und drei Ausrüstungs-Builds je Fighter. Native Touch-/Safe-Area-Bedienung verbunden;
Training/Tutorial verändern keinen vorherigen Run oder dessen Ranking-Ticket.
Presets/Touchlayout sind profilbezogen und portabel. Online-Bindungen werden nicht kopiert.

Punkt6 technisch vorbereitet: eigener Java-/Godot-Adapter, bewusste Verbindung,
Konto-/Profilprüfung, qualifizierte Run-Tickets, getrennte Kategorien, Offline-
Warteschlange, Fehler-/Timeoutbehandlung und optionaler AAB-Build. Java kompiliert,
Adapter-Testdouble31/0; echte Google-Verbindung weiterhin offen und im AAB deaktiviert.

Prüfungen: vollständige47 Suiten10293/0 plus beide Traces, abschließende Ergänzungen
im aktuellen Suite-Stand10296/0. Komfort81/0, native UI53/0, Python-Konfiguration5/0.
Zehn UI-Ansichten in drei Formaten. Keine offenen Parser-/Laufzeitfehler in finalen Logs.
Finales signiertes AAB Code37 /76430402 Bytes, Signatur/Manifest/CRC/16-KiB grün.
Offline-Manifest und Abwesenheit von Google-SDK/Plugin im DEX geprüft.833 Laufzeit-
Dateien für den Quellabgleich gesichert. Private Schlüssel außerhalb des Projekts.

Quellprüfung abgeschlossen: frischer Import,283 Godot-Prüfungen und Python5/0,
833 bytegleiche Laufzeitdateien sowie vollständige Native-/Test-/Toolquellen.
Aktuelle Phase: geprüfte Artefakte veröffentlichen und anonyme Downloads verifizieren. Danach: Android-Geräteabnahme und Nutzer legt nach
PLAY_GAMES_SETUP.md das Spieleprojekt mit zwei Listen an. Es fehlen numerische
Spieleprojekt-ID und beide Bestenlisten-IDs. Erst damit realen Online-Build aktivieren.
Keine Console-Veröffentlichung, kein PR-Merge, keine echten Google-/Android-Tests behaupten.

---

# Übergabe 0.29.0 Beta 3 — abgeschlossen am 24.11.2026

Code, Dokumentation, signiertes AAB und vollständiges Quell-ZIP im Branch
feature/run-resume-backups-v0.29.0 veröffentlicht. Draft-PR #15 erstellt, nicht
zusammengeführt. Alle drei öffentlichen Downloads (AAB/ZIP/TXT) vollständig ohne
Anmeldung gelesen und SHA256/Bytezahl mit lokalen Originalen abgeglichen.
Nachweis: Downloads/VERIFY-v0.29.0-beta3.txt, separat nach dem Quellpaket erstellt.
AAB 76388236 Bytes, ZIP 76929693 Bytes; Prüfsummen im Downloadverzeichnis.

Implementierung und automatisierte Prüfung dieses Updates erledigt. Nächster
Schritt beim Nutzer: neues internes Play-Release Code36 mit bestehendem Schlüssel;
echter Android-Test für Fortsetzen, Store-Update und nativen Dateidialog. Kein
Console-Upload, keine Play-Freigabe oder Geräteinstallation durch diese Sitzung.
Das Quell-ZIP bildet den geprüften Stand vor dem nachträglichen Downloadnachweis ab.

---

# 0.29.0 Beta 3 — Run fortsetzen und portable Profil-Dateien

Stand 2026-11-24. Branch feature/run-resume-backups-v0.29.0.
Aktuelle Phase: Implementierung, Tests, signierter Store-Build und Quellprüfung abgeschlossen.

Implementiert: atomare profilbezogene Run-Checkpoints; Gegner-/Projektilreferenzen,
Bossphasen, Arenagefahren, Fähigkeiten, RNG, Run-Werte, Shop und feste Levelwahl.
Neustart → Hauptmenü → Fortsetzen → Pause. Sichern & Hauptmenü, Profilwechsel und
bestätigter Ersatz/Abbruch. Alle zehn Kampfsekunden Autosave im Hintergrund;
wichtige Übergänge/Lifecycle synchron. Abschluss nach Worker-Join atomar mit Belohnung.

Portable JSON-Sicherung: Version, SHA256, acht MiB, native Dateiauswahl, Rücklese-
Kontrolle, Vorschau und expliziter Import als zusätzliches Profil. Keine Mischung
oder Überschreibung anderer Spieler. Neuer Besitzer für enthaltenen Run.
Fünf Profilplätze, vollständig offline, keine breite Speicherberechtigung.
Neue Spieler weiterhin Bruiser/Hammer/Schrottplatz, null Guthaben/Fortschritt.

Verifiziert: 44 Suiten / 10127 Prüfungen / 0 Fehler, beide Traces. Neue Suiten
Run61/0, Backup20/0, UI32/0; UI nativ32/0, elf Ansichten in drei Formaten.
100-Gegner-/320-Projektil-Fixture, deterministisches Weiterspielen nach Neustart,
Worker-Reihenfolge und I/O-Ausfälle geprüft. Keine offenen Parserfehler.

Export: signiertes Store-AAB0.29.0-beta3 / Code36 / 76388236 Bytes gebaut.
Bundletool, gleiche Uploadsignatur, Manifest, CRC und 16-KiB-Ausrichtung bestanden.
812 Laufzeit-/Konfigurationsdateien für Quellenabgleich gesnapshottet.

Quellprüfung bestanden: frischer Import, 150 Zusatzprüfungen und 812 bytegleiche
Laufzeit-/Konfigurationsdateien. Vollständiges Quell-ZIP ohne private Daten.
Nächster Arbeitsschritt: Artefakte im Branch veröffentlichen und anonyme Downloads verifizieren.
Danach Nutzer: interner Store-ReleaseCode36 und echte Android-Abnahme inklusive
SAF-Dateidialog/content://, Unterbrechung, Speicher und Langzeitperformance.
Keine bestätigte Play-Freigabe oder Geräteinstallation. Keine Server/Bestenliste.

---

# Ergänzung 24.11.2026 — Inhaltsübersicht und Console-Fortschritt

Nutzer-Screenshots bestätigen: App in Google Play Console angelegt, Release-AAB
mit VersionCode 35 hochgeladen und verarbeitet; Entwurf des internen Testreleases.
Letzter gezeigter Stand: Tester noch nicht hinterlegt, Freigabe und Testlink nicht
bestätigt. Nutzer kann sein eigenes Google-Konto als ersten internen Tester nutzen.
Mapping-/Native-Symbol-Hinweise sind für den internen Test nicht blockierend.

Angeforderte teilbare TXT-Übersicht erstellt:
Downloads/MayhemSurvivors-v0.28.1-Beta2-Spielumfang.txt.
Inhalte aus aktuellem Katalog abgeglichen: 15 Kämpfer, 10 Welten, 13 Waffen,
26 Entwicklungen, 39 Sammlungseinträge, Profile, Quests, Pass, UI/Audio und Grenzen.
Keine Änderung am Spiel/Bundle und keine neue Store-Version. UTF-8 gelesen und
Inhalte geprüft; kein neuer Gameplay-Testlauf für diese Dokumentationsänderung.

---

# 0.28.1 Beta 2 — neuer Store-Spieler startet bei null

Stand 2026-11-23. Branch feature/store-beta-v0.28.1. Nutzerkorrektur: neue App
in vorhandener Google Play Console, noch kein App-Eintrag. Alle neuen Spieler
starten bei null. Vollständig offline; lokale Profile bleiben getrennt.

Implementiert: keine kostenlosen Start-Cases mehr; nur Bruiser/Hammer Rang 1,
Schrottplatz, keine Guthaben, Tickets, Teile, Statistiken, Welt- oder Passfortschritte.
Kicksy-Einstieg und leeres Case-Journal entsprechend erklärt. Bestehende eigene
Spielstände bleiben bei Updates erhalten; keine globale Rücksetzung. Neue Tests
prüfen den echten Produktionsstart bis zur ersten erspielten Crew-Case und
Profiltrennung. Alte Tests erhalten benötigte Tickets jetzt ausdrücklich als Fixture.

Verifiziert: vollständiger Lauf von 41 Suiten / 10014 Prüfungen / 0 Fehler,
zusätzlich beide Regressionstraces (33 / 87 Checkpoints). Native Case-Navigation
74/0 und Profile 42/0. 15 Erstspieler-Ansichten in drei Formaten aufgenommen;
Willkommens- und Case-Ansicht visuell geprüft. Kein physisches Android-Gerät.

Google-Play-Preset: Release AAB / ARM64 / API 24–36 / VersionCode 35. Separater
privater Upload-Schlüssel außerhalb des Repositories erzeugt; keine Geheimnisse
im Export-Preset. Standard-Androidvorlagen, SDK Build-Tools 36.1 und vollständiger
OpenJDK-21-Compiler eingerichtet. Store-Build erfolgreich; Bundletool, Signatur, Manifest, CRC und native 16-KiB-
Ausrichtung verifiziert. Store-Texte, Datenschutzhinweise und Console-Übergabe vorbereitet.

Öffentliche vollständige AAB-/ZIP-Downloads und Prüfsummendatei anonym geprüft.
Offen: neuen App-Eintrag/Testerkreis in der Play Console einrichten. Keine Store-Veröffentlichung
behaupten. Store-Bilder, echte Kontakt-/Zielgruppenangaben und Android-Geräteabnahme
stehen aus. Aktive Runs nach vollständigem App-Ende nicht wiederherstellbar.

Abschließender Paketnachweis: Quell-ZIP CRC/sichere Pfade, 802 Laufzeit-/Konfigurations-
dateien bytegleich, frischer Import ohne Cache und Erstspieler-Test 37/0 bestanden.
Private Upload-Schlüssel im separaten Workspace-Backup; niemals öffentlich veröffentlichen.

Veröffentlicht auf GitHub: Source 9ff3b1d, Artefakte 06b6000; AAB 76353437 Bytes,
Quell-ZIP 79644097 Bytes, SHA256 nach vollständigem anonymem Download bestätigt.
Nachweis Downloads/VERIFY-v0.28.1-beta2.txt. Draft-PR #14 offen, nicht gemergt.
Technische Übergabe fertig; kein Store-Testlink und keine Play-Console-Veröffentlichung.
Nächster Schritt: Store-Eintrag, App-Signierung, Inhalte/Kontakt/Grafiken und Testerkreis
in der vorhandenen Console einrichten, Release-AAB hochladen, Geräteabnahme durchführen.

---

# 0.28.0 Beta 1 — lokale Spielerprofile

Stand 2026-11-23. Phase 19: Implementierung und technische Übergabe für den
geschlossenen Betatest abgeschlossen. Basis 0.27.0 / e1e59cb.
Branch feature/offline-beta-v0.28.0. Nutzerentscheidung: vollständig offline.

Implementiert: fünf Profile, bisheriger Spieler erhalten, getrennte Freischaltungen,
Coins, Ausrüstung, Einstellungen, Aufgaben und Statistiken. Spieler-/Arena-Auswahl
und aktives Profil persistent. Alle Schreibwege umgestellt. Gültige Vorgängersicherung,
atomare Ersetzung, automatische Wiederherstellung, defensive Profilindex-Reparatur
und bestätigtes manuelles Restore. Touchgerechte Verwaltung/Namen, Android-Zurück,
geschützte aktive Profile, Run-Abbruchdialoge und Beta-Hilfe mit manuellem Bericht.

Frisch entpacktes Projekt: 40 Suiten / 9973 Prüfungen / 0 Fehler plus zwei Traces.
800 Laufzeitdateien plus Konfiguration und 109 Tests bytegleich zum APK-Stand.
Neue Profil- und Speichertests (37/42) sowie native Case-Navigation (74) bestanden;
16 GL-Ansichten in drei Formaten geprüft. Analyse-Soak: 90 kontrollierte Szenarien.
Beta-APK tatsächlich gebaut: Code34, ARM64, gleicher Schlüssel/Paketname, Signatur,
Alignment und Inhalte geprüft. Übergabe mit Quell-ZIP, Testanleitung und Prüfsummen.
Öffentlicher Downloadbeleg wird nach dem Upload separat im Repo dokumentiert.

Offen bleibt die physische Android-Beta-Abnahme: Update, echte Tastatur, Touch,
Safe Area, Sensoren, Klang, Balance, Stabilität, Akku/Temperatur und 60 FPS.
Aktive Runs werden nach vollständigem App-Ende nicht fortgesetzt. Kein Cloud-Sync,
keine Anmeldung. Kein persönlicher Spielstand oder privater Schlüssel im Quellpaket.
Nächster Schritt: geschlossener Gerätetest nach BETA_TESTING.md und gezielte Befundkorrektur.

## Veröffentlichung abgeschlossen

Geschlossene Beta 1 auf GitHub: Quellstand 4a99671, Artefakte e12b430.
APK (78.383.759 Bytes) und vollständiges Quell-ZIP (79.397.772 Bytes) ohne Anmeldung
komplett heruntergeladen. Beide SHA256-Werte und öffentliche Prüfsummendatei bestätigt.
Nachweis: Downloads/VERIFY-v0.28.0-beta1.txt. PR #13 offen und konfliktfrei, nicht
automatisch gemergt: https://github.com/Whiskymitschuss/Match3/pull/13.
Jetzt folgt die physische geschlossene Android-Beta nach BETA_TESTING.md.
