# Google Play — Update Beta 3 (0.29.0)

Die App wurde inzwischen in deiner Play Console angelegt. Laut Screenshot wurde
0.28.1-beta2 / Code 35 verarbeitet. Der interne Tester-Kreis beziehungsweise die
Freigabe ist noch nicht bestätigt. Diese Übergabe lädt nichts automatisch hoch.

## Neue Version eintragen

1. Bestehende App **Mayhem Survivors** öffnen, Testen → Interner Test.
2. Neue Version erstellen; MayhemSurvivors-v0.29.0-beta3-store.aab hochladen.
3. Release-Name: **0.29.0 Beta 3 – Runs fortsetzen**.
4. Versionshinweise aus dem folgenden Block in das deutsche Feld kopieren.
5. Prüfen, speichern und den internen Test nach den Console-Hinweisen freigeben.
6. Unter Tester eine E-Mail-Liste mit deinem Google-Play-Konto und gegebenenfalls
   weiteren Testern hinterlegen. Den angezeigten Opt-in-Link mit diesem Konto öffnen.
7. Über den Store aktualisieren und BETA_TESTING.md auf einem echten Handy abnehmen.

```text
<de-DE>
Neu: Laufende Runs nach dem App-Ende fortsetzen.
Automatische Sicherungen und sicherer Wiedereinstieg über das Pause-Menü.
Profile inklusive Sammlung und Run als Datei exportieren und auf einem anderen Handy importieren.
Bestehende Spielstände bleiben erhalten. Neue Spieler starten weiterhin bei null.
Bitte Fortsetzen, Speichern und den Android-Dateidialog testen.
</de-DE>
```

## Buildidentität

- Paket com.rfworlds.mayhemsurvivors, Code **36**, Name **0.29.0-beta3**.
- Release-AAB / ARM64 / API 24–36 / Querformat / GL Compatibility.
- Derselbe private Upload-Schlüssel wie Code 35; private Dateien nicht im Repository.
- Google Play signiert Installationen weiterhin über Play App Signing.
- Nur VIBRATE, kein INTERNET, Android-Cloudbackup deaktiviert.
- Kein Neu-Anlegen der App und kein Zurücksetzen bestehender Spieler erforderlich.

Ein AAB ist keine direkt installierbare APK. Eine Store-App kann eine frühere
Debug-APK mit anderem Signierschlüssel nicht regulär aktualisieren. Vor einem
solchen Wechsel möglichst mit dieser Updateversion eine portable Sicherung anlegen.
Reguläre Updates derselben Store-App behalten lokale Profile. Frische Spieler
starten weiterhin nur mit Bruiser, Hammer Rang 1, Schrottplatz und null Fortschritt.

## Store-Einrichtung und Veröffentlichung

Für interne Tests mindestens das eigene Google-Konto als Tester verwenden.
Optionale Mapping-/Native-Symbol-Hinweise verhindern den internen Test allein nicht.
Für eine öffentliche Veröffentlichung die konkreten Console-Anforderungen für
dieses Entwicklerkonto, Inhaltsbewertung, Datensicherheit, Zielgruppe, Kontaktdaten,
öffentliche Datenschutzerklärung und Store-Grafiken vollständig erfüllen.
store/de-DE/listing.txt und store/PRIVACY_DE.md beschreiben den aktuellen Offline-Stand.

Keine Anmeldung, Werbung, Echtgeldkäufe, automatische Datenerhebung oder Server.
Zufalls-Cases werden nur mit erspielten Mitteln geöffnet. Manuelle Profildateien
entstehen ausschließlich auf Nutzerwunsch. Sie sind keine Cloud-Anmeldung.
Eine öffentliche Veröffentlichung oder erfolgreiche Geräteabnahme wird hier nicht behauptet.
