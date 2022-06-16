# Twitter Bot Jadwal Sholat 

[![extracting](https://github.com/sta562/jadwalsholat/actions/workflows/prayers-api.yml/badge.svg)](https://github.com/sta562/jadwalsholat/actions/workflows/prayers-api.yml) [![postwit](https://github.com/sta562/jadwalsholat/actions/workflows/prayers-post.yml/badge.svg)](https://github.com/sta562/jadwalsholat/actions/workflows/prayers-post.yml) [![mention_check](https://github.com/sta562/jadwalsholat/actions/workflows/prayers-reply.yml/badge.svg)](https://github.com/sta562/jadwalsholat/actions/workflows/prayers-reply.yml) [![](https://img.shields.io/badge/Twitter-@SholatBot-white?style=flat&labelColor=blue&logo=Twitter&logoColor=white)](https://twitter.com/SholatBot)

Aplikasi jadwal sholat online bot menggunakan Twitter. Jadwal sholat yang akan dipost melalui tweets pada SholatBot yaitu jadwal sholat wajib 5 waktu dan ditambahkan jadwal imsak. 

## Deskripsi

Mengembalikan semua waktu sholat untuk tanggal tertentu di kota tertentu menggunakan [aladhan API](https://aladhan.com/prayer-times-api).

## Parameter

- `date_or_timestamp` (string) - Tanggal dalam format DD-MM-YYYY atau stempel waktu UNIX. Default untuk tanggal saat ini.
- `city` (string) - Nama kota. Contoh: London
- `country` (string) - Nama negara atau 2 karakter alpha ISO 3166 code. Contoh: GB atau United Kingdom
- `state` (string) - State atau provinsi. Nama negara bagian atau singkatan. Contoh: Colorado / CO / Punjab / Bengal
- `metode` (angka) - Metode penghitungan waktu sholat. Metode mengidentifikasi berbagai aliran pemikiran tentang bagaimana menghitung timing. Jika tidak ditentukan, defaultnya adalah otoritas terdekat berdasarkan lokasi atau koordinat yang ditentukan dalam panggilan API. Parameter ini menerima nilai dari 0-12 dan 99, sebagaimana ditentukan di bawah ini:

    * 0 - Shia Ithna-Ansari
    * 1 - University of Islamic Sciences, Karachi
    * 2 - Islamic Society of North America
    * 3 - Muslim World League
    * 4 - Umm Al-Qura University, Makkah
    * 5 - Egyptian General Authority of Survey
    * 7 - Institute of Geophysics, University of Tehran
    * 8 - Gulf Region
    * 9 - Kuwait
    * 10 - Qatar
    * 11 - Majlis Ugama Islam Singapura, Singapore
    * 12 - Union Organization islamic de France
    * 13 - Diyanet İşleri Başkanlığı, Turkey
    * 14 - Spiritual Administration of Muslims of Russia
    * 15 - Moonsighting Committee Worldwide (juga membutuhkan shafaq parameter)
    * 99 - Custom. Lihat https://aladhan.com/calculation-methods

- `shafaq` (string) - Shafaq mana yang digunakan jika metodenya adalah Moonsighting Commitee Worldwide. Pilihan yang dapat diterima adalah 'general', 'ahmer' dan 'abyad'. Default ke 'general'.
- `tune` (string) - String bilangan bulat yang dipisahkan koma untuk mengimbangi pengaturan waktu yang dikembalikan oleh API dalam hitungan menit. Contoh: 5,3,5,7,9,7. Lihat https://aladhan.com/calculation-methods
- `school` (angka) - 0 untuk Syafi (atau cara standar), 1 untuk Hanafi. Jika Anda membiarkan ini kosong, defaultnya adalah Shafii.
- `midnightMode` (angka) - 0 untuk Standar (Mid Sunset to Sunrise), 1 untuk Jafari (Mid Sunset to Fajr). Jika Anda membiarkannya kosong, defaultnya adalah Standar.
- `latitudeAdjustmentMethod` (angka) - Metode untuk menyesuaikan waktu lintang yang lebih tinggi - misalnya, jika Anda memeriksa pengaturan waktu di Inggris atau Swedia.

    * 1 - Middle of the Night
    * 2 - One Seventh
    * 3 - Angle Based


- `penyesuaian` (angka) - Jumlah hari untuk menyesuaikan tanggal Hijriah. Contoh: 1 atau 2 atau -1 atau -2
- `iso8601` (boolean) - Apakah akan mengembalikan waktu sholat dalam format iso8601. Contoh: true akan kembali 2020-07-01T02:56:00+01:00 bukannya 02:56

## Parameter yang diatur pada pengambilan data

`city` = Kota Padang \
`country` = Indonesia \
`method` = 8 

metode yang digunakan adalah metode nomor 8 yaitu metode Gulf Region, karena metode tersebut memiliki hasil perhitungan waktu sholat yang paling mendekati waktu sholat sebenarnya di Indonesia.
Parameter lainnya dibiarkan kosong dan menggunakan nilai defaultnya.
