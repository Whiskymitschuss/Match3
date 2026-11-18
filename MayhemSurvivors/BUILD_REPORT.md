# Android-Hotfix 0.21.1 — 2026-11-18

Godot 4.6.3 stable / JDK21 / Android SDK36 / Build Tools36.0.0.
Tatsächlicher Debug-Export mit `--export-debug Android` erfolgreich.

- MayhemSurvivors-v0.21.1-debug.apk / 76014568 Bytes.
- SHA256 `17e554a6aee05b43ef563b7044953f1775918f4adbaf90689058e48218db989c`.
- com.rfworlds.mayhemsurvivors / versionCode26 / versionName0.21.1.
- Ausschließlich ARM64-v8a / minSDK24 / targetSDK36 / Landscape / GL Compatibility.
- v2/v3-Signatur und zipalign -c -P16 4 geprüft. Identischer Update-Schlüssel:
  5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce.
- Kompilierter Garage-Controller vorhanden; Archiv-CRC geprüft. Nur VIBRATE-Permission,
  kein INTERNET. Keine Änderung am lokalen Save-Schema.

Über die vorhandene Version installieren, keine Deinstallation nötig. Bereits
freigeschaltete Figuren und zuvor gespeicherte Case-Funde bleiben erhalten.
ADB-Geräteinstallation war hier nicht möglich; der native Touch-Test ist ein Linux-
GL-Test. Keine physische Android-Abnahme behauptet.

Quell-ZIP mit vollständigen Laufzeitquellen, Assets, Szenen, Tests und Berichten;
keine Importcaches, SDKs, APKs oder privaten Schlüssel. Inhalt per CRC und bytegleichem
Vergleich mit den getesteten Projektdateien geprüft. Öffentliche Downloads und
Prüfsummen im Downloads-Verzeichnis, separates Downloadprotokoll im Repository.
