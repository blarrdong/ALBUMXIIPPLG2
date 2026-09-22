# albumXIIPPLG2 — Android + Supabase

Wrapper Android native untuk galeri web `albumXIIPPLG2`. UI dan backend tetap menggunakan file web + Supabase, sehingga data/foto tetap online dan dapat dipakai bersama website.

## Sebelum build

1. Buka `app/src/main/assets/config.js`.
2. Isi `SUPABASE_URL` dan `SUPABASE_ANON_KEY` dengan **anon/public key** dari Supabase.
3. Jangan masukkan `service_role` key.

Contoh:
```js
window.SUPABASE_URL = "https://xxxx.supabase.co";
window.SUPABASE_ANON_KEY = "ey...";
```

## Build sekali

Di komputer yang sudah terpasang Android Studio/SDK:

```bash
gradle assembleDebug
```

Atau buka folder ini di Android Studio lalu pilih **Build > Make Project**. APK debug akan bernama:

`app/build/outputs/apk/debug/albumXIIPPLG2.apk`

## GitHub Actions

Workflow `.github/workflows/build-apk.yml` dapat dipakai agar GitHub yang melakukan build. Setelah push ke GitHub, jalankan workflow **Build APK** dari tab Actions. Hasil APK tersedia sebagai artifact `albumXIIPPLG2-apk`.

## Catatan

- Internet diperlukan karena Supabase dan library Supabase JS di-load online.
- Upload foto dari Android didukung melalui pemilih file multi-select.
- Login admin menggunakan Supabase Auth.
- Foto publik tetap mengikuti bucket/policy Supabase yang sudah dibuat oleh `supabase.sql`.
