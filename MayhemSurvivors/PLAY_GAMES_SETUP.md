# Google Play Games — Einrichtung für die optionale Bestenliste

Stand0.30.0 Beta4: Nutzer wünscht Google Play Games; ein Spieleprojekt ist laut
Rückmeldung noch nicht angelegt. Dieser Build ist vollständig offline. Der eigene
Java-Adapter ist gegen Godot4.6.3 und GamesServicesv2 SDK21.0.0 kompiliert. Tatsächliche
Google-Anmeldung, Scoreübermittlung und nativer Ranglistendialog sind noch ungetestet.

## In der Play Console

1. Bestehende App **Mayhem Survivors** öffnen. **Play-Spieldienste → Einrichtung
   und Verwaltung → Konfiguration** suchen; Menünamen können leicht abweichen.
2. Ein neues Play-Games-Spieleprojekt erstellen beziehungsweise mit einem passenden
   Google-Cloud-Projekt verknüpfen. App-Name und weitere angeforderte Basisangaben ergänzen.
3. Android-Anmeldedaten für `com.rfworlds.mayhemsurvivors` verknüpfen. Für Installationen
   aus Google Play den **SHA-1 des App-Signaturschlüssels** aus **App-Integrität →
   App-Signatur** verwenden. Der Upload-Schlüssel des AAB ist ein anderer Zweck;
   dessen Fingerabdruck ersetzt den späteren Store-App-Schlüssel nicht.
4. Zwei Bestenlisten anlegen:

| Name | Kategorie im Spiel | Sortierung | Anzeigeformat |
| --- | --- | --- | --- |
| Schrottplatz / Normal / schnellster Sieg | campaign:scrapyard:normal | Kleiner ist besser | Zeit in Millisekunden |
| Schrottplatz / Normal / geschaffte Endloswellen | endless:scrapyard:normal | Größer ist besser | Ganze Zahl, keine Dezimalstellen |

5. Das eigene Testkonto auch für die Play-Spieldienste freigeben. App-interner Test
   und Spieldienste-Testerkreis sind getrennte Einstellungen. Konfiguration gemäß
   Console für Tester verfügbar machen; noch keine öffentliche App-Freigabe erforderlich.
6. Folgende **drei Werte als Text an Codex schicken**: numerische Spieleprojekt-ID
   sowie die beiden Bestenlisten-IDs (üblicherweise `Cgk…`). Keine Passwörter,
   privaten Schlüssel, OAuth-Tokens oder Google-Zugangsdaten schicken.

Mit diesen Werten wird der vorbereitete Adapter eingebaut und ein neuer höherer
VersionCode erstellt. Danach über den internen Store-Test installieren und echte
Anmeldung, Abbruch, Offline-Fall, Übermittlung und Ranglistendialog testen.

## Technischer Build-Weg — für die Entwicklung

`data/network/play_games.json` steht aktuell auf `provider: disabled`, ohne erfundene
Kennungen. Reale Konfiguration besitzt `provider: google_play`, eine numerische
`project_id` als String und `boards` als Zuordnung der obigen Kategorie zu ihrer
Console-ID. Für weitere Arenen/Schwierigkeitsstufen sind separate Listen nötig.
Maximal60 Kategorien: zwei Modi × zehn Arenen × drei Schwierigkeiten. Die ersten
beiden Listen reichen für eine klar abgegrenzte erste Online-Beta auf dem Schrottplatz.

`tools/build_store.py --play-games-config DATEI` validiert die Kennungen, baut das
eigene Android-Plugin, setzt die Ressource und exportiert das signierte AAB. Keystore
und Passwortdatei werden wie bisher getrennt übergeben. Das native Build benötigt
JDK17+, Android SDK36 und die passende Godot-Android-Buildvorlage; keine kostenpflichtigen
Plugins oder eigenen Server. `tools/build_play_games.py --compile-check` prüft nur
den Java-Build und aktiviert kein Online-Feature.

Das Editor-Export-Plugin liefert AAR und Maven-Abhängigkeit nur bei real konfiguriertem
Dienst. Dann benötigt die App INTERNET. Ohne Konfiguration sind AAR, Google-SDK und
Internetberechtigung nicht im ausgelieferten Bundle. Der standardmäßige GamesInitProvider
wird entfernt; der eigene Adapter initialisiert das SDK erst bei bewusster Verbindung.
Keine Cloud-Speicherfunktion oder automatische Anmeldung beim frischen Spielstart.

## Verhalten der implementierten Anbindung

- Verbindung je lokalem Profil nach ausdrücklichem Antippen. Google-Play-Name wird
  nur für den Verbindungsstatus verwendet; der lokale Profilname bleibt erhalten.
- Neue qualifizierte Runs erhalten ein Ticket aus Run-ID, Konto, Kategorie und Fighter.
  Kampagnen-Siege melden die aktive Kampfzeit in Millisekunden; Endlos meldet tatsächlich
  abgeschlossene Wellen. Unterschiedliche Karten/Schwierigkeiten teilen keine Liste.
- Bereits vorhandene Rekorde, Training und importierte Run-Tickets werden nicht
  nachträglich hochgeladen. Sammlung, Ausrüstung, lokale Profilnamen und komplette
  Spielstände werden nicht zur Rangliste übertragen.
- Bis zu20 ausstehende Ergebnisse bleiben offline gespeichert. Übertragung im Menü
  oder Ergebnisbildschirm. Fehler, Timeout und fehlgeschlagenes Speichern der Bestätigung
  behalten die Warteschlange. Google Play behält den besten Wert statt Werte zu addieren.
- Run-ID-Deduplizierung, Profil-/Request-Prüfung und zusätzliche Kontoprüfung direkt
  im nativen Adapter verhindern versehentliches Posten in ein anderes Konto.
- Ausschalten löscht die lokale Bindung und Warteschlange. Bereits bei Google
  gespeicherte Ranglistenwerte werden dadurch nicht gelöscht. Kontoverwaltung liegt
  bei Google Play Games; das Spiel besitzt keine eigenen Online-Konten.

Die Prüfungen sind Plausibilitäts- und Zuordnungsprüfungen. Lokale Spielstände sind
weiterhin vom Nutzer kontrolliert; es gibt keine serverseitige Kampf-Nachsimulation
und keine fälschungssichere Wettbewerbswertung. Keine Geldpreise oder bezahlten Inhalte.

Vor Aktivierung die Datenschutzerklärung und Play-Datensicherheitsangaben für die
Google-SDK-Anbindung aktualisieren und tatsächliche Geräte-/Kontotests dokumentieren.
Automatisierte Adaptertests verwenden ausdrücklich ein Testdouble; sie belegen
keine erfolgreiche Anmeldung an einem realen Google-Projekt.
