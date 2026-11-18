# Mayhem Survivors — 0.21.0 MAYHEM UNITED

Stand: 2026-11-18. Phase 19: Implementierung, Export und Quellarchiv-Abnahme abgeschlossen.
Branch feature/mayhem-united-v0.21, Basis feature/world-map-v0.20.

Implementiert: 11 Helden, 19 normale Gegner (10 neu), 10 Arenen, Bosse 2/4/6/8/10,
Axel in 6, eigene Arena-Endbosse, 13 Waffen/26 Entwicklungen, alle neuen aktiven
Fähigkeiten, Cases/Garage/Werkstatt/Meisterschaft/Statistik, Ereignisse, gemeinsamer
Comic-Stil samt Zwei-Hand-Rigs, gepaginte Menüs, Handbuch, Tutorial und 14 Sounds.
Alte Profile und Flammen-Deko erhalten; Namenskollision durch flamer-Waffen-ID behoben.

Prüfung: 28 Suiten / 3764 Checks bestanden; beide unveränderten historischen
Referenztraces bestanden. Neuer Produktionstest 589 Checks, tatsächliche zehnwellige
Zustandsübergänge inklusive. Soak 110 Kombinationen / 92.400 Schritte bestanden.
38 native GL-Aufnahmen geprüft. Keine bekannten Parser-/Skript-/Ressourcenfehler.
APK exportiert, signiert, ARM64/Manifest/Alignment geprüft. SHA256 bac59810199b766622b8f8fba15dc3c206d47a68ab06e3285777ecbbffcc86ab.

Quellarchiv ohne Cache frisch importiert: alle 28 Suiten / 3.764 Prüfungen plus beide
Traces erneut bestanden. 662 Laufzeitdateien bytegleich. APK und ZIP samt SHA256
werden im Downloads-Verzeichnis des Branches bereitgestellt; öffentliches Prüfprotokoll
liegt im Repository. Nächster Arbeitsschritt: die unten genannten Geräte-/Balancetests.

Offene Abnahme: reales Android-Update/Start, Touch/Sensoren/Safe Area, gehörter Ton,
FPS/Thermik und menschliches Balancing der neuen zehnweltigen Bosskampagne. Keine
bekannten Pflichtfunktionen als leere Menüs oder unverbundene Daten zurückgelassen.
Nächster Inhaltsschritt nach Abnahme: Gerätefeedback und Balance-Telemetrie ohne Server.
