# BtcTurk Market

Bu uygulamayı BtcTurk Flutter Developer Code Case kapsamında geliştirdim. Temel amaç, public API’den gelen pariteleri listelemek, favorileri cihazda saklamak ve seçilen paritenin geçmiş fiyatlarını grafik üzerinde göstermekti.

Case küçük olsa da projeyi tek ekrana sıkışmış bir örnek olarak bırakmak istemedim. Yeni bir özellik eklendiğinde mevcut kodu dağıtmadan ilerleyebilmek için yapıyı `app / core / feature` şeklinde ayırdım. Bununla birlikte, yalnızca teorik olarak gerekebilir diye fazladan katmanlar da eklemedim.

## Uygulamada neler var?

- BtcTurk ticker endpoint’inden alınan parite listesi
- TRY, USDT ve tüm pariteler arasında filtreleme
- Parite veya coin sembolüne göre arama
- Cihazda kalıcı olarak saklanan favoriler
- Favoriler varsa görünen yatay ve kaydırılabilir favori listesi
- Günlük değişime göre yeşil veya kırmızı gösterilen fiyat değişim grafiği
- `1D`, `1W`, `1M` ve `3M` aralıklarında fiyat grafiği
- Grafik üzerinde basılı tutup sürükleyerek bir noktayı inceleme
- Seçilen mumun kapanış değeri ile ticker’dan gelen 24 saatlik hacim, en yüksek ve en düşük fiyat bilgileri
- Güncel alış ve satış fiyatları
- Türkçe ve İngilizce dil desteği
- Mobil, tablet ve web genişliklerine uyarlanan responsive arayüz
- Android ve iOS için uygulama ikonu ve native splash ekranı
- Loading, empty, bağlantı, sunucu hatası ve tekrar deneme durumları

## Proje yapısı

```text
lib/
├── app/
│   ├── components/       # Uygulama genelinde kullanılan widget'lar
│   ├── localization/     # Dil ayarları ve üretilen localization anahtarları
│   ├── routes/           # GoRouter ve route seviyesindeki Cubit tanımları
│   └── theme/            # Renkler, tema ve tipografi
├── core/
│   ├── constants/        # API adresleri ve ortak sabitler
│   ├── dimensions/       # Ortak ölçüler
│   ├── extensions/       # Context ve sayı formatlama extension'ları
│   ├── network/          # Ortak Dio kurulumu
│   └── responsive/       # Breakpoint ve ekran boyutu tanımları
└── feature/
    └── market/
        ├── cubit/        # Liste, favori ve grafik state'leri
        ├── models/       # API response ve uygulama modelleri
        ├── repo/         # Veri kaynaklarını birleştiren repository
        ├── services/     # Retrofit servisleri
        └── views/        # Sayfalar ve o özelliğe ait widget'lar
```

`app` klasörü uygulamanın genel kurulumunu, `core` tekrar kullanılabilen altyapıyı, `feature` ise market akışının kendi kodunu içeriyor. Böylece örneğin yeni bir ekran eklendiğinde market özelliğinin iç detaylarını uygulamanın geri kalanına taşımak gerekmiyor.

## Neden Cubit kullandım?

Bu uygulamadaki state geçişleri oldukça net: veri yükleniyor, başarılı oluyor veya hata veriyor; kullanıcı filtreyi, arama metnini ya da grafik aralığını değiştiriyor. Cubit bu akış için yeterli ve okunması kolay bir çözüm sunduğu için daha ağır bir event yapısına ihtiyaç duymadım.

State sınıfları immutable ve `Equatable` kullanıyor. UI tarafında `BlocSelector` ile yalnızca ihtiyaç duyulan state alanlarını dinliyorum. Grafik üzerinde seçilen nokta ise sadece o widget’ın kısa ömürlü UI durumu olduğu için Cubit’e taşınmadı; widget state’inde bırakıldı.

## Dependency injection yaklaşımı

`Dio`, Retrofit servisleri ve `BtcTurkMarketRepository` uygulama seviyesinde oluşturuluyor. Repository, `RepositoryProvider` üzerinden erişilebilir hale geliyor; ekran Cubit’leri ise route açılırken `BlocProvider` ile oluşturuluyor ve ihtiyaç duydukları repository’yi constructor üzerinden alıyor.

Burada özellikle service locator kullanmadım. Bağımlılıkların constructor üzerinde görünür olması, bir sınıfın çalışmak için neye ihtiyaç duyduğunu doğrudan göstermeyi ve testlerde mock vermeyi kolaylaştırıyor.

Projede şu anda tek market kaynağı olduğu için ayrıca bir `MarketRepository` interface’i bulunmuyor. Sadece tek implementasyonu olan bir abstraction bu ölçekte gereksiz bir katman oluşturuyordu. İleride Binance gibi başka bir kaynak eklenirse kendi concrete repository’si provider’a eklenebilir ve ihtiyaç duyan Cubit’e açıkça verilebilir.

## Ağ katmanı ve response modelleri

REST isteklerinde `Dio` ve `Retrofit`, JSON dönüşümlerinde `json_serializable` kullanılıyor. Ticker ve grafik servisleri farklı host’larda olduğu için iki ayrı Retrofit servisi var:

- Ticker: `https://api.btcturk.com/api/v2/ticker`
- Kline: `https://graph-api.btcturk.com/v1/klines/history`

Ticker response modeli yalnızca `data` alanını değil, BtcTurk’ün response zarfındaki `success`, `message` ve `code` alanlarını da karşılıyor. Backend başarısızlık mesajı gönderirse repository bu bilgiyi kaybetmeden üst katmana taşıyor.

Kline endpoint’i mum verilerini `t/o/h/l/c/v` şeklinde paralel listeler halinde döndürüyor. Listelerin uzunlukları beklenmedik biçimde farklı gelirse index hatası oluşmaması için en kısa liste uzunluğu esas alınıyor. Oluşturulan mumlar zaman sırasına konup değiştirilemeyen bir liste olarak UI’a veriliyor.

## Ticker cache’i ve liste performansı

Ticker endpoint’i bütün market snapshot’ını tek response içinde döndürüyor ve server-side pagination sunmuyor. Bu yüzden client tarafında gerçekte yeni veri çekmeyen yapay bir “load more” akışı oluşturmadım.

Repository ilk başarılı response’u bellekte cache’liyor. Aynı snapshot’a tekrar ihtiyaç duyulduğunda yeni bir network isteği atılmıyor; açıkça refresh istendiğinde cache güncelleniyor. Liste `List.unmodifiable` olarak tutulduğu için UI veya Cubit tarafında yanlışlıkla değiştirilemiyor.

Bütün response bellekte olsa da ekrandaki kartlar aynı anda oluşturulmuyor. Mobilde `ListView.separated`, tablet ve web düzeninde `GridView.builder` kullanıldığı için Flutter yalnızca görünür olan ve ekrana o anda görünen elemanları build ediyor.

## Favorileri neden HydratedCubit ile sakladım?

Favori verisi yalnızca küçük bir parite sembolleri kümesinden oluşuyor. Bu nedenle ayrı bir local database kurmak yerine `HydratedCubit` kullandım. Favori state’i değiştiğinde saklama ve uygulama tekrar açıldığında geri yükleme işlemi aynı yerde kalıyor.

Diskte yalnızca versiyon bilgisi ve sıralanmış semboller tutuluyor. `HydratedCubit` burada genel amaçlı bir veritabanı gibi kullanılmıyor. Uygulamaya sorgulanabilir, ilişkisel veya büyük miktarda offline veri eklenseydi bu veri ayrı bir local repository arkasına taşınırdı.

## Grafik aralıkları

Grafik ilk açıldığında `1W` seçili geliyor. Kullanıcı `1D`, `1W`, `1M` veya `3M` seçeneklerinden birine bastığında `PairChartCubit`, seçilen süreye göre yeni `from` ve `to` değerleri hesaplayıp Kline endpoint’ine yeniden istek atıyor.

Yeni istek sırasında eski grafik ekranda kalıyor ve ince bir progress göstergesi gösteriliyor. Günlük grafikte X ekseni saat ve dakika, daha uzun aralıklarda ise gün-ay formatında yazılıyor.

Grafikteki kapanış değeri seçilen mumdan geliyor. Hacim, en yüksek ve en düşük değerler ise ticker snapshot’ındaki 24 saatlik alanlar olduğu için grafik aralığı değiştiğinde değişmiyor. UI’da bu değerlerin yanına `(24h)` eklenmesinin sebebi de iki veri kapsamını birbirine karıştırmamak.

Grafik ve detay alanı birlikte `SingleChildScrollView` içinde. Böylece grafiği okunabilir tutacak bir yükseklik verebiliyor, küçük ekranlarda aşağıdaki detaylara scroll ederek ulaşabiliyorum.

## Responsive ve adaptive davranış

Uygulamada üç temel ekran aralığı var:

- Mobil: 600 logical pixel’den küçük
- Tablet: 600–1023 logical pixel
- Desktop/web: 1024 logical pixel ve üzeri

Mobilde pariteler tek sütunlu listede, tablet ve web’de grid olarak gösteriliyor. Grafik ve detaylar mobil/tablet görünümünde alt alta, desktop görünümünde yan yana yerleşiyor. Ortak içerik genişliği büyük ekranlarda 1200 logical pixel ile sınırlandırılıyor.

Loading göstergelerinde ve platform davranışı olan uygun noktalarda adaptive Flutter widget’ları kullanılıyor.

## Localization ve tema

UI’da kullanıcıya gösterilen metinler doğrudan widget içine yazılmıyor; `Easy Localization` üzerinden Türkçe ve İngilizce karşılıkları alınıyor. Renkler ve text style erişimleri de merkezi tema ile `BuildContext` extension’larından geliyor.

Bu yaklaşım hem widget kodunu sade tutuyor hem de ileride yeni bir dil veya tema eklendiğinde ekranları tek tek değiştirme ihtiyacını azaltıyor.

## WebSocket branch’i

Case dokümanı iki REST endpoint’i istediği için `main` branch’i yalnızca bu kapsamı içeriyor. Böylece değerlendiren kişinin karşısına istenmeyen bir network davranışı çıkmıyor ve temel çözüm daha kolay incelenebiliyor.

Canlı ticker güncellemelerini denediğim WebSocket entegrasyonu ise `websocket_included` branch’inde duruyor. Bu branch, `main`deki güncel UI ve grafik özelliklerine ek olarak socket bağlantısı, reconnect akışı ve bağlantı durumunu gösteren UI bileşenini içeriyor.

## Kurulum

Gereksinimler:

- Flutter `>=3.44.0`
- Dart `>=3.12.0`

Bağımlılıkları yüklemek ve Retrofit/JSON dosyalarını üretmek için:

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Uygulamayı çalıştırmak için:

```bash
flutter run
```

Belirli bir cihaz seçmek istersen:

```bash
flutter run -d android
flutter run -d ios
flutter run -d chrome
```

## Üretilen dosyalar

Localization dosyaları değiştiğinde anahtarları yeniden üretmek için:

```bash
dart run easy_localization:generate \
  -S assets/translations \
  -f keys \
  -O lib/app/localization \
  -o locale_keys.g.dart
```

Uygulama ikonu veya splash görselleri değiştiğinde:

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Kontroller

```bash
flutter analyze
```

Web release almak için ayrıca:

```bash
flutter build web --release
```

## Web hakkında not

Arayüz web boyutlarına uyumlu ve web build alınabiliyor. Ancak BtcTurk public REST servisleri tarayıcıdan yapılan doğrudan istekleri CORS politikası nedeniyle engelleyebilir. Android ve iOS bu tarayıcı kısıtından etkilenmiyor.

Web tarafı production ortamına taşınacaksa REST çağrılarının izin verilen same-origin bir backend proxy veya API gateway üzerinden geçirilmesi gerekir. Network erişimi service/repository katmanında tutulduğu için bu değişiklik UI koduna dokunmadan yapılabilir.

## Daha sonra eklenebilecekler

- Firebase Crashlytics veya Sentry ile merkezi hata takibi ve loglama
- Analyze ve release build adımlarını çalıştıran CI akışı
- Backend ekibiyle birlikte tasarlanacak OAuth 2.0 authentication akışı
- Access ve refresh token yönetimi, token yenileme akışı ve güvenli cihaz depolaması
