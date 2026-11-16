# Android-Buildbericht 0.10.0 — 2026-11-16

Erfolgreich mit Godot 4.6.3 stable, JDK 21, SDK Platform 36 / Build Tools 36.0.0,
nativem Debug-Template ohne Gradle exportiert.

- Datei builds/android/MayhemSurvivors-v0.10-debug.apk, 51,521,249 Bytes.
- SHA256 `13a76dc607332a446676906b5f669fd8bd1985ae8a6ec007ca4fd912e6e7ba51`.
- Paket com.rfworlds.mayhemsurvivors, versionCode 14 / versionName 0.10.0.
- Nur ARM64-v8a, minSDK 24, targetSDK 36, Landscape, GL Compatibility.
- apksigner v2/v3 erfolgreich; gleiches Zertifikat wie bisher:
  `5257c320e25fd161cf38a6c39194379ffede531877b53f1eeb9df62e47d875ce`.
- zipalign -c -P 16 4 erfolgreich. Berechtigung ausschließlich VIBRATE.
- Keine Netzwerkpflicht, Werbung oder Bezahlfunktionen; lokaler Speicher unverändert.

APK als Update über bestehende Installation vorgesehen. Kein ADB-Gerät hier;
„cannot connect to daemon at tcp:5037“ verhindert den erfolgreichen Export nicht.
Keine physische Installation, FPS-/Temperatur- oder Fairnessabnahme behauptet.

Quell-ZIP mit sämtlichen Szenen/Skripten/Daten/Grafiken/Audio/Tests/Berichten;
keine .godot-Caches, APKs, SDKs oder privaten Schlüssel. Fertige APK separat.
Serieller Editor-Import aus 0.9 erhalten. Import/Start braucht keine Asset-Erzeugung;
Generatoren nur optional für Änderungen. Eigener Export benötigt SDK/JDK/Template
und privaten Debugschlüssel; offizielles Update benötigt bisherigen Signierschlüssel.

Abschließende Quell-ZIP-Prüfung: frisch entpackt, seriell importiert, alle 1.030
Assertions und beide Regressionstraces bestanden (v0.10-final-*.log).
