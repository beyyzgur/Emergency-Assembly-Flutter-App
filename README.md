# Emergency Assembly App

Afet/acil durumda vatandaşa en yakın toplanma noktalarını harita üzerinde gösteren
Flutter uygulaması. Giriş, harita, ihtiyaç kayıtları ve durum bildirimi modüllerinden oluşur.

## Teknolojiler

Flutter · Riverpod (state) · go_router (navigasyon) · flutter_map (harita) ·
Firebase (Auth: Google, Firestore, Cloud Messaging).

Backend'den yalnızca **toplanma alanları** endpoint'i alınır; kimlik doğrulama ve diğer
veriler Firebase üzerinden yürür.

## Klasör Yapısı

```
lib/
  main.dart
  core/         # router, tema, config (harita katmanları)
  shared/
    models/     # ortak veri modelleri
  features/
    auth/       # giriş (Google)
    map/        # harita
      data/         # veriyi çeken/işleyen taraf
      presentation/ # ekranda gösteren taraf
      providers/    # iki tarafın ortak alanı
    needs/      # ihtiyaç kayıtları
    checkin/    # durum bildirimi + push
```

Her feature ayrı klasör → ayrı developer → ayrı branch. Çakışma riski böyle düşer.

## İki Developer'ın Ortak Çalışma Alanı

`shared/models/` ve `features/map/providers/` iki developer'ın da kullandığı **ortak
dosyalardır** (veri modelleri ve haritanın veri↔görsel bağlantısı). Buradaki bir dosyayı
değiştirmeden önce ikinizin anlaşması gerekir; aksi halde ayrı ayrı yazıp birbirinizi
kırarsınız. Bu yüzden bu iki klasörü CODEOWNERS'ta ikinizin de onayına bağlıyoruz.

## Görev Bölüşümü

Harita, iki developer da eşit teknik sorumluluk alsın diye ikiye bölünür:

| | Developer 1 | Developer 2 |
|---|---|---|
| **Harita** | veriyi çekme, mesafe/sıralama, clustering | harita çizimi, marker/poligon, liste, detay |
| **Diğer** | Giriş + İhtiyaç kayıtları | Durum bildirimi + Push |

## Firebase

Proje Firebase'e bağlıdır. `flutterfire configure` ile üretilen
`firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist` repoda
commit'lidir. Console'da açık servisler: Authentication (Google), Firestore,
Cloud Messaging.

## Başlangıç

```bash
git clone <repo-url>
cd emergency_assembly_app
flutter pub get
flutter run
```

## Git

`main` korumalıdır (doğrudan push yok, PR + 1 onay). Herkes kısa ömürlü feature
branch'te çalışır: `feature/map-data`, `feature/map-presentation`, `feature/auth`,
`feature/needs`, `feature/checkin`.
