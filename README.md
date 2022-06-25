# Karakter One Piece

[![](https://img.shields.io/badge/Twitter-@onepiececharbot-white?style=flat&labelColor=blue&logo=Twitter&logoColor=white)](https://twitter.com/onepiececharbot) [![Monthly Scraping](https://github.com/alfanugraha/onepiece/actions/workflows/nakama-scrape.yml/badge.svg)](https://github.com/alfanugraha/onepiece/actions/workflows/nakama-scrape.yml) [![Daily Tweet](https://github.com/alfanugraha/onepiece/actions/workflows/nakama-tweet.yml/badge.svg)](https://github.com/alfanugraha/onepiece/actions/workflows/nakama-tweet.yml)

![Banner](https://static.wikia.nocookie.net/onepiece/images/0/09/Chapter_863.png/revision/latest/scale-to-width-down/1000?cb=20170424163639 "Banner")


One Piece adalah serial manga Jepang yang ditulis dan diilustrasikan oleh Eiichiro Oda. Manga ini dimuat di majalah Weekly Shonen Jump milik Shueisha sejak 1997, dan diadaptasi ke dalam serial anime yang diproduksi oleh Toei Animation, yang mulai tayang di Jepang pada tahun 1999. Berkisah tentang petualangan Monkey D. Luffy, seorang anak laki-laki yang memiliki tubuh elastis seperti karet setelah memakan Buah Iblis secara tidak sengaja. Dengan kru bajak lautnya, yang dinamakan Bajak Laut Topi Jerami, Luffy menjelajahi Grand Line untuk mencari harta karun terbesar di dunia yang dikenal sebagai **One Piece** dalam rangka untuk menjadi bajak laut berikutnya.


## Deskripsi 

Terdapat banyak sekali karakter yang mengisi jalannya cerita pada manga ini. Tercatat lebih dari 1000 karakter pada situs ensiklopedia One Piece [One Piece Fandom](https://onepiece.fandom.com/wiki/List_of_Canon_Characters). Dari berbagai macam karakter penting hingga cameo dan juga sebagai salah satu penikmat serial manga One Piece, maka dibangunlah aplikasi bot media sosial Twitter menggunakan R sebagai alat penambang data pada web dan MongoDB Cloud sebagai media penyimpanannya.

Secara teknis, terdapat dua pekerjaan yang dilakukan dalam aplikasi bot ini:

1. [nakama-scrape.R](nakama-scrape.R) terjadwal setiap bulannya melakukan pengambilan data pada situs, pemeriksaan dan pembersiahan data menggunakan paket R `rvest`, `tidyverse`, dan `janitor` kemudian tahap penyimpanan menggunakan `mongolite`

2. [nakama-tweet.R](nakama-tweet.R) terjadwal setiap harinya melakukan pengambilan satu karakter secara acak dengan ekspresif query pada `mongolite` kemudian tahap posting pada media sosial Twitter menggunakan `rtweet` 


## Contoh dokumen 

Berikut ini adalah contoh dokumen pada koleksi MongoDB yang sudah tersimpan

```
[{
	"name":"Wheel",
	"debut_manga":906,
	"debut_anime":"884",
	"year":2018,"id":1278,
	"japanese_name":"ホイール",
	"romanized_name":"Hoīru",
	"affiliations":"Levely",
	"occupations":"Prince",
	"status":"Alive",
	"japanese_va":"Unknown",
	"residence":"South Fire Kingdom",
	"ve":"",
	"note":"His name was revealed in Vivre Card.",
	"url":"https://onepiece.fandom.com/wiki/Wheel"
}] 
```