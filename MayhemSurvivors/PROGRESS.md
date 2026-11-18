# Mayhem Survivors 0.21.1 — Case-Navigation repariert

Stand 2026-11-18 / Branch fix/case-exit-v0.21.1 / Basis 0.21 (65fad26).

Ursache reproduziert: Beim Bestätigen wurde derselbe Dictionary-Beleg geleert, den
der Inventar-Callback danach noch las. Nach dem ersten Fehler funktionierten auch
weitere Klicks auf dem alten Bildschirm nicht mehr. Baseline: 58 bestandene und
14 absichtlich fehlgeschlagene Reproduktionsprüfungen gegen die alte Version.

Behoben: unabhängiger Beleg-Snapshot für die Button-Callbacks. Garage-Aktionen werden
nach der Touch-Verarbeitung ausgeführt; verspätete Klicks alter Menüseiten verworfen.
Keine Änderung an Wahrscheinlichkeiten, Preisen, freigeschalteten Helden/Items,
Währungen oder Save-Schema. Bereits gespeicherte Funde sind weiter verwendbar.

74 neue GUI-Prüfungen bestanden: Crew/Arsenal/Style, beide Zielbuttons, Zurück und
Hauptmenü, richtige Inventarkategorie, Duplikate, gespeicherter Fund, Speicherfehler
mit Wiederholung, Animation/Überspringen, Doppeltipp, Breitbild/Tablet. Derselbe Lauf
mit echten InputEventScreenTouch-Ereignissen im nativen GL-Fenster: ebenfalls 74/0.
29 Suiten / 3.838 Prüfungen und beide historischen Traces bestanden. Android-APK
exportiert, Signatur und Alignment geprüft, ARM64 / versionCode26 / versionName0.21.1.

APK/Quellprojekt/Prüfsummen liegen unter Downloads im Hotfix-Branch. Beide
Dateien vollständig anonym von GitHub zurückgeladen; SHA256 und Dateigrößen stimmen.
Prüfprotokoll: tests/results/v0.21.1-download.log; PR #5 ist offen, nicht gemergt.
Nächster Schritt: Update auf dem Android-Gerät installieren und den gemeldeten
Case-Ablauf dort abnehmen. Keine physische Installation hier behauptet.
