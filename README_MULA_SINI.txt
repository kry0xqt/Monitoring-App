LABGUARD - 5 SKRIN FLUTTER/DART (DEMO)

CARA PALING MUDAH UNTUK PROJEK ZIKRY YANG SUDAH ADA
1. Extract ZIP. Jangan edit terus dari dalam ZIP.
2. Backup folder lib projek lama (rename sebagai lib_backup).
3. Copy folder lib daripada ZIP ke:
   C:\Users\zikry\StudioProjects\lab_guard\lib
   Pastikan main.dart terus dalam lib, BUKAN lib\lib\main.dart.
4. Kekalkan android/, pubspec.yaml dan fail lain projek lama.
   Kod ini hanya perlukan Flutter SDK, tiada package tambahan.
5. Buka terminal pada folder projek lama dan jalankan:
   flutter pub get
   flutter run

PILIHAN: PROJEK BARU DALAM FOLDER ZIP YANG DIEKSTRAK
Folder android/web tidak disertakan; jana menggunakan Flutter SDK sendiri:
   flutter create --project-name lab_guard --platforms android,web .
   flutter pub get
   flutter run
Jalankan dalam folder yang mengandungi pubspec.yaml.
Jika flutter create menghasilkan test/widget_test.dart contoh counter,
padam test contoh tersebut dan gunakan senarai semakan di bawah.

SKRIN
Home: ringkasan 3 bacaan, 2 actuator dan sambungan ESP32.
Monitor: nilai, progress indicators, masa sampel dan butang rekod.
Control: suis fan/buzzer; safety override semasa demo abnormal.
History: jadual sampel bertarikh, boleh scroll mendatar.
Alerts: kejadian abnormal, acknowledge, waktu resolved.

SEMAKAN MANUAL
- Buka semua lima tab.
- Control: hidupkan fan dan buzzer; semak status di Home.
- Home: Simulate Abnormal Condition; fan/buzzer ON.
- Monitor: suhu 42.5, humidity 72, gas raw 2800.
- Control: kedua-dua suis dikunci.
- History: ada sampel normal dan abnormal.
- Alerts: acknowledge; keadaan kekal ACTIVE.
- Home: Reset to Normal; Alerts bertukar RESOLVED.
- Monitor: Record Current Demo Sample; jumlah History bertambah.

HAD / RUBRIK
Ini lengkap untuk lima skrin DEMO yang diminta, bukan keseluruhan tugasan IoT.
Belum: Firebase/database kekal, PIN/authentication, hardware sebenar,
streaming real-time, ESP32 automatic safety response, APK/deployment.
Gas ialah RAW ADC, bukan ppm. Humidity ialah bacaan tambahan kepada suhu;
sahkan pemilihan hardware dengan pensyarah. History ialah historical table,
salah satu pilihan visualisasi yang dibenarkan dalam arahan tugasan.
Data demo disimpan dalam RAM sahaja dan hilang apabila app dimulakan semula.
Pengunci suis semasa abnormal BUKAN security feature.

PENGESAHAN
Import relatif dan integriti ZIP disemak semasa penyediaan.
Flutter/Dart SDK tidak tersedia pada environment penyediaan, jadi analyzer,
widget tests dan build Android belum dijalankan. Uji pada laptop sendiri.
Fahami dan sesuaikan kod serta patuhi arahan integriti akademik pensyarah.
