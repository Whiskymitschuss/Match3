# Entwicklungsstand — 2026-11-15

## Aktuelle Phase

Phase 19: technische Übergabe. Phasen 1–18 wurden in einer kompakten Alpha-Implementierung
umgesetzt; die abschließende Abnahme auf echter Android-Hardware ist offen.

## Implementiert

- Startprojekt, verbundene Startszene, PlayerController und GameStateMachine.
- Hauptmenü, Charakterwahl, Vorbereitung, Kampf, Levelaufstieg, Shop, Pause, Sieg, Niederlage.
- Drei datenbasierte Helden und Boni, Touch-Joystick mit Multitouch-Fingerzuordnung.
- Arena 2400×1600, Kamera, Grenzen und Dekoration ohne Bewegungsblockaden.
- Drei Gegner mit Verfolgung, Separation, Treffern, Kontakt-Cooldown und einmaliger Belohnung.
- Fünf automatische Waffen, vier Slots, Waffenstufen 1–5, kritische Treffer und Projektilpool.
- XP-Kristalle mit Magnet, XP-Formel, sequenzielle Levelaufstiege, zehn gefilterte Upgrades.
- Neun 60-Sekunden-Wellen und Bosswelle mit 90-Sekunden-Limit; 100 Gegner als Obergrenze.
- Vier Shopangebote, Kaufen, Waffenverbesserung, Heilung, kostenloser/gebührenpflichtiger Reroll.
- THE OVERLORD mit Verfolgung, angekündigter Radialsalve und angekündigtem Sturmangriff.
- HUD-Balken und Zahlen, Statistik, Ergebnisdaten, sicherer Neustart.
- Lokale versionierte JSON-Speicherung mit Typprüfung, atomischem Schreiben und Korruptbackup.
- Prozedurale Cartoongrafiken und Animationen, Branding, elf Effekte und Musik, Lautstärkeregler.
- Effektstufen, Objektlimits, begrenzte Nachbarschaftsprüfung und wiederverwendete Projektile.
- Android-Exportpreset, tatsächlich signierte und verifizierte ARM64-APK.

## Tests und behobene Fehler

- 76 Integrationsprüfungen bestanden; siehe `tests/results/integration.log`.
- Belastungstest: 7200 Simulationsschritte, 120 simulierte Sekunden; Limits eingehalten.
- Godot-Import und Rendering mit Mesa/llvmpipe tatsächlich ausgeführt.
- Numerische JSON-Werte korrekt laden; beschädigte Daten abfangen.
- Tod während Gegneriteration sicher abbrechen; Boss startet ohne unangekündigten Sturm.
- Safe-Area-Eingabekoordinaten transformieren; Audiostreams beim Beenden stoppen.
- Android benötigt explizite mobile Compatibility-Einstellung und ETC2/ASTC-Import.
  Nach Korrektur konnte die APK exportiert werden.

## Offene Abnahme / Grenzen

- Installation und kompletter manueller Run auf einem physischen ARM64-Android-Gerät.
- Touchgefühl, Multitouch mit echter Hardware, Notches, runde Ecken und Systemleisten prüfen.
- 60-FPS-Ziel und thermisches Verhalten auf repräsentativen Geräten messen.
- Audio über echte Android-Lautsprecher/Kopfhörer und Lifecycle-Wechsel prüfen.
- Langfristiges Balancing und künstlerische Feinabnahme. Die Cartoonanimationen sind
  prozedural, keine handgezeichneten Animationsfilme.
- Mehrere Spiel- und UI-Systeme liegen noch im zentralen Run-Koordinator; weitere
  Modularisierung kann nach der Alpha erfolgen, ohne dass zum Starten Programmierung nötig ist.
- Bei sehr kurzem erzwungenem Headless-Abbruch kann eine Audio-ObjectDB-Shutdownwarnung auftreten; geordnete Tests sind ohne Warnung. Auf Android nachprüfen.
- Kein aktiver Run-Resume nach Prozessende (für 0.1 ausdrücklich nicht vorgesehen).

## Exportstatus

`builds/android/MayhemSurvivors-v0.1-debug.apk` wurde mit Godot 4.6.3 gebaut.
Debugsignatur sowie Paket, Architektur und Ausrichtung werden im BUILD_REPORT nachgewiesen.
Die endgültige Quellenübergabe enthält keine SDK-Downloads oder Editorcaches.

## Nächster Arbeitsschritt

APK auf physischem Android-Gerät installieren; komplette Abnahme über zehn Wellen mit
allen drei Helden, Displayvarianten, Unterbrechungen und Leistungsaufzeichnung durchführen.
Erst danach die Android-Abnahme als vollständig markieren.
