# Testbericht 0.21.1 — 2026-11-18

Der gemeldete Fehler wurde vor der Korrektur über tatsächliche GUI-Mausereignisse
reproduziert: 58 Prüfungen bestanden, 14 fehlgeschlagen, Dictionary-Zugriff auf hero
nach geleertem Beleg. Dieses absichtliche Baseline-Fehlerprotokoll gehört zur alten
Version 0.21: tests/results/v0.21.1-reproduction-before.log.

Nach Korrektur: `python tools/run_tests.py --traces` / 29 Suiten / **3.838 bestanden,
0 fehlgeschlagen**, beide unveränderten historischen Traces bestanden. Kein Parser-,
Skript- oder Ressourcenfehler im endgültigen Lauf. Alle Gameplay-Fixtures und die
neue 0.21-Produktionstestabdeckung bleiben erhalten.

Neu: tests/case_navigation_test.gd / 74 Prüfungen. Die Tests bedienen echte Buttons
über Viewport-Eingaben, statt nur Bestätigungstransaktionen direkt aufzurufen.
Crew-, Arsenal- und Style-Case → Inventar oder weitere Cases; anschließende Zurück- /
Hauptmenü-Buttons; passende Inventarkategorie; exakte Coins/Tickets/Teile/Ownership;
Neuladen eines ausstehenden Belegs; Duplikat; fehlgeschlagenes Speichern mit realem
Retry; normale Animation und Überspringen; zwei Klicks in einem Frame; Layouts
1280×720, 2340×1080 und 1920×1440. Produktions-Zustandswache ist eingeschaltet.

Nativer GL-Compatibility-Lauf mit InputEventScreenTouch, Maus-Emulation und korrekter
Fensterskalierung: ebenfalls 74 Prüfungen / 0 Fehler. Screenshot vor der Bestätigung
und tatsächliches Zielinventar danach gespeichert. Keine „nicht mehr im Szenenbaum“-
Fehler während der finalen Touch-Navigation. Renderer Mesa llvmpipe / Linux, kein
Android-Gerät. Logs v0.21.1-tests.log, v0.21.1-touch.log; Bilder case_navigation_*.png.

Die Datenbestätigung wird weiterhin vor dem Verlassen gespeichert. Ein Speicherfehler
stellt den vollständigen Zustand wieder her und erlaubt Wiederholung. Freigaben und
Währungen werden durch Navigation nicht erneut vergeben oder berechnet.

Offen: physische Android-Update-/Touch-Abnahme. Die frühere Geräte-, Audio-, FPS- und
Balancingabnahme aus 0.21 wird durch diesen fokussierten Hotfix nicht ersetzt.
