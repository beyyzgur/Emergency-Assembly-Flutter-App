// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'ATİS';

  @override
  String get appFullName => 'ATİS: Afet Toplanma Alanı İşaretleme Sistemi';

  @override
  String get brandLogoLabel =>
      'ATİS - Afet Toplanma Alanı İşaretleme Sistemi logosu';

  @override
  String get brandTagline => 'Her nokta bir güven, her işaret bir hayat.';

  @override
  String get navMap => 'Harita';

  @override
  String get navNeeds => 'İhtiyaçlar';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get secureSignIn => 'Güvenli giriş';

  @override
  String get loginSubtitle =>
      'Toplanma alanlarına ve ihtiyaç kayıtlarına erişmek için hesabınla devam et.';

  @override
  String get emailAddress => 'E-posta adresi';

  @override
  String get emailRequired => 'E-posta adresinizi girin.';

  @override
  String get emailInvalid => 'Geçerli bir e-posta girin.';

  @override
  String get password => 'Şifre';

  @override
  String get passwordRequired => 'Şifrenizi girin.';

  @override
  String get showPassword => 'Şifreyi göster';

  @override
  String get hidePassword => 'Şifreyi gizle';

  @override
  String get login => 'Giriş Yap';

  @override
  String get noAccount => 'Henüz hesabın yok mu?';

  @override
  String get signUp => 'Kayıt ol';

  @override
  String get or => 'veya';

  @override
  String get googleSigningIn => 'Google hesabı açılıyor...';

  @override
  String get continueWithGoogle => 'Google ile devam et';

  @override
  String get googleSignInFailed =>
      'Google ile giriş şu an tamamlanamadı. Tekrar deneyin.';

  @override
  String get authDataSecurityNote =>
      'Acil durumlarda hızlı erişim için bilgilerin güvenle saklanır.';

  @override
  String get backToLogin => 'Giriş ekranına dön';

  @override
  String get createAccount => 'Hesap oluştur';

  @override
  String get registerSubtitle =>
      'Acil durumlarda ihtiyaç bilgilerine hızlıca ulaşmak için kaydol.';

  @override
  String get passwordMinimumHint => 'En az 6 karakter kullanın.';

  @override
  String get passwordMinimumError => 'Şifreniz en az 6 karakter olmalı.';

  @override
  String get confirmPassword => 'Şifre tekrar';

  @override
  String get passwordMismatch => 'Şifreler birbiriyle eşleşmiyor.';

  @override
  String get alreadyAccount => 'Zaten hesabın var mı?';

  @override
  String get authUnexpectedError => 'Beklenmeyen bir hata oluştu.';

  @override
  String get authUserNotFound =>
      'Bu e-posta adresiyle kayıtlı kullanıcı bulunamadı.';

  @override
  String get authWrongCredentials => 'E-posta veya şifreniz hatalı.';

  @override
  String get authUserDisabled => 'Bu kullanıcı hesabı devre dışı bırakılmış.';

  @override
  String get authTooManyRequests =>
      'Çok fazla deneme yapıldı. Lütfen biraz sonra tekrar deneyin.';

  @override
  String get authNetworkError => 'İnternet bağlantınızı kontrol edin.';

  @override
  String get authEmailInUse => 'Bu e-posta adresiyle zaten bir hesap var.';

  @override
  String get authEmailPasswordDisabled =>
      'E-posta ile kayıt henüz etkinleştirilmemiş.';

  @override
  String get authRegistrationFailed => 'Kayıt oluşturulamadı.';

  @override
  String get authLoginFailed => 'Giriş yapılamadı.';

  @override
  String get settings => 'Ayarlar';

  @override
  String get profile => 'Profil';

  @override
  String get user => 'Kullanıcı';

  @override
  String get application => 'Uygulama';

  @override
  String get security => 'Güvenlik';

  @override
  String version(Object version) {
    return 'Sürüm $version';
  }

  @override
  String get statusCheck => 'Durum Bildirimi';

  @override
  String get startTenMinuteCheckIn => '10 dakikalık check-in başlat';

  @override
  String get signOut => 'Çıkış Yap';

  @override
  String get checkIn => 'Durum Bildirimi';

  @override
  String get checkInHeader => 'Yol durumunu güvenle paylaş';

  @override
  String get checkInDescription =>
      'Check-in başlattığında uygulama açıkken her 10 dakikada bir durumunu sorar.';

  @override
  String get checkInActive => 'Check-in aktif';

  @override
  String get checkInActiveSubtitle =>
      'Yol durumun için bir sonraki kontrol bekleniyor.';

  @override
  String get checkInResponsePending => 'Durum yanıtın bekleniyor';

  @override
  String get checkInResponsePendingSubtitle =>
      'Yoldayım veya vardım bilgisini paylaş.';

  @override
  String get checkInPaused => 'Check-in bekletildi';

  @override
  String get checkInPausedSubtitle =>
      'Uygulamaya geri döndüğünde 10 dakika yeniden sayılır.';

  @override
  String get checkInArrived => 'Vardığın kaydedildi';

  @override
  String get checkInArrivedSubtitle => 'Güvenli şekilde vardığını bildirdin.';

  @override
  String get checkInStopped => 'Check-in durduruldu';

  @override
  String get checkInStoppedSubtitle =>
      'İstediğinde yeni bir check-in başlatabilirsin.';

  @override
  String get checkInAttentionTitle => '3 kontrol yanıtsız kaldı';

  @override
  String get checkInAttentionSubtitle =>
      'Check-in güvenlik için durduruldu. Yeni bir oturum başlatabilirsin.';

  @override
  String get checkInNotStarted => 'Check-in henüz başlamadı';

  @override
  String get checkInNotStartedSubtitle =>
      'Yola çıktığında durum kontrolünü başlatabilirsin.';

  @override
  String nextCheck(Object time) {
    return 'Sonraki kontrol: $time';
  }

  @override
  String get unansweredChecks => 'Yanıtsız kontroller';

  @override
  String get onTheWay => 'Yoldayım';

  @override
  String get arrived => 'Vardım';

  @override
  String get stopCheckIn => 'Check-in’i durdur';

  @override
  String get startCheckIn => '10 dakikalık check-in başlat';

  @override
  String get foregroundOnly =>
      'Bu sürüm yalnızca uygulama açıkken çalışır. Uygulama arka plana geçtiğinde sayaç bekletilir.';

  @override
  String get statusCheckDialogTitle => 'Durum kontrolü';

  @override
  String get statusCheckPrompt =>
      'Yol durumun nedir? Güvenliğin için kısa bir bilgi paylaş.';

  @override
  String unansweredStatusPrompt(Object count) {
    return '$count. yanıtsız kontrol kaydedildi. Lütfen durumunu paylaş.';
  }

  @override
  String get stop => 'Durdur';

  @override
  String get checkInStoppedDialog => 'Check-in durduruldu';

  @override
  String get checkInStoppedDialogMessage =>
      '3 durum kontrolü yanıtsız kaldığı için check-in sonlandırıldı. Yeni bir check-in başlatabilirsin.';

  @override
  String get ok => 'Tamam';

  @override
  String get newNeedRequest => 'Yeni İhtiyaç Talebi';

  @override
  String get editNeedRequest => 'Talebi Düzenle';

  @override
  String get basicInformation => 'TEMEL BİLGİLER';

  @override
  String get scopeAndUrgency => 'KAPSAM VE ACİLİYET';

  @override
  String get needTitle => 'İhtiyaç Başlığı';

  @override
  String get needTitleRequired => 'Lütfen bir başlık girin';

  @override
  String get detailedDescription => 'Detaylı Açıklama';

  @override
  String get needDescriptionRequired => 'Lütfen bir açıklama girin';

  @override
  String get category => 'Kategori';

  @override
  String get peopleCount => 'Kişi Sayısı';

  @override
  String get peopleCountRequired => 'Boş bırakılamaz';

  @override
  String get urgencyStatus => 'Aciliyet Durumu';

  @override
  String get saving => 'Kaydediliyor...';

  @override
  String get saveChanges => 'Değişiklikleri Kaydet';

  @override
  String get submitNeed => 'Talebi İlet';

  @override
  String get noSignedInUser => 'Hata: Oturum açmış bir kullanıcı bulunamadı.';

  @override
  String get needUpdated => 'Talebiniz başarıyla güncellendi!';

  @override
  String get needSubmitted => 'İhtiyaç talebi başarıyla iletildi!';

  @override
  String get offlineNeedSaved => 'İnternet yok! Kayıt cihaza alındı.';

  @override
  String get updateRequiresInternet =>
      'Güncelleme için internet bağlantısı gerekiyor.';

  @override
  String get categoryWater => 'Su';

  @override
  String get categoryFood => 'Erzak';

  @override
  String get categoryShelter => 'Barınma';

  @override
  String get categoryHealth => 'Sağlık';

  @override
  String get categoryOther => 'Diğer';

  @override
  String get urgencyLow => 'Düşük';

  @override
  String get urgencyMedium => 'Orta';

  @override
  String get urgencyHigh => 'Yüksek';

  @override
  String get urgencyCritical => 'Kritik';

  @override
  String get needsBag => 'Afet Çantam';

  @override
  String get addNeed => 'İhtiyaç Ekle';

  @override
  String get deleteNeed => 'İhtiyacı Sil';

  @override
  String get deleteNeedConfirmation =>
      'Bu ihtiyacınız karşılandı mı veya ilanı sistemden tamamen silmek istediğinize emin misiniz?';

  @override
  String get cancel => 'İptal';

  @override
  String get needDeleted => 'İhtiyaç kaydı başarıyla silindi.';

  @override
  String get confirmDelete => 'Evet, Sil';

  @override
  String get offlineSyncSuccess => 'Tüm veriler başarıyla buluta aktarıldı!';

  @override
  String get offlineSyncFailure =>
      'Offline ihtiyaçlar aktarılamadı. Bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get needsLoadError => 'Veriler çekilirken bir hata oluştu.';

  @override
  String get noNeedsYet => 'Henüz bir ihtiyaç kaydedilmemiş.';

  @override
  String get untitledNeed => 'Başlıksız';

  @override
  String get noDescription => 'Açıklama yok';

  @override
  String get unknownUrgency => 'Bilinmiyor';

  @override
  String people(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kişi',
      one: '$count kişi',
    );
    return '$_temp0';
  }

  @override
  String get edit => 'Düzenle';

  @override
  String get delete => 'Sil';

  @override
  String get mapTitle => 'Afet Toplanma Haritası';

  @override
  String get nearestAreas => 'En Yakın Toplanma Alanları';

  @override
  String get loadingAssemblyAreas => 'Toplanma alanları yükleniyor...';

  @override
  String get locationUnavailable => 'Konum alınamadı';

  @override
  String get selectDistrict => 'Bulunduğunuz ilçeyi seçin';

  @override
  String get myLocation => 'Konumum';

  @override
  String get close => 'Kapat';

  @override
  String get returnToGps => 'GPS Konumuna dön';

  @override
  String get clearManualSelection => 'Manuel seçimi kaldır';

  @override
  String get searchDistrict => 'İlçe ara...';

  @override
  String get districtNotFound => 'İlçe bulunamadı';

  @override
  String get noNearbyAreas =>
      'Yakında toplanma alanı bulunamadı.\nKonum gerekiyor (GPS veya ilçe seçimi).';

  @override
  String capacity(num count) {
    return '$count kişi kapasiteli';
  }

  @override
  String walkingDistance(num distance, num minutes) {
    return '$distance m · ~$minutes dk yürüme';
  }

  @override
  String get mapLayerRoad => 'Yol';

  @override
  String get mapLayerSatellite => 'Uydu';

  @override
  String get mapLayerHybrid => 'Hibrit';

  @override
  String get mapLayerOpenStreetMap => 'OSM';

  @override
  String get language => 'Dil';

  @override
  String get directions => 'Yol Tarifi';

  @override
  String get routeOrigin => 'Başlangıç';

  @override
  String get routeDestination => 'Hedef';

  @override
  String get startRoute => 'Başlat';

  @override
  String get routeCalculating => 'Rota hesaplanıyor...';

  @override
  String get routeUnavailable => 'Rota alınamadı, düz çizgi gösteriliyor.';

  @override
  String get routePreviewHint =>
      'Rota önizleme — canlı takip için başlangıç GPS olmalı';

  @override
  String get closeRoute => 'Rotayı kapat';

  @override
  String get nearerAreaTitle => 'Daha yakın bir alan var';

  @override
  String nearerAreaBody(Object distance) {
    return 'Yaklaşık $distance uzaklıkta daha yakın bir toplanma alanı var. Onu görmek ister misiniz?';
  }

  @override
  String get showNearer => 'Yakını Gör';

  @override
  String get arrivedMessage => '🎉 Vardınız! Toplanma alanına ulaştınız.';

  @override
  String get myLocationGps => 'Konumum (GPS)';

  @override
  String get selectDistrictAction => 'İlçe seç';

  @override
  String get pickOnMap => 'Haritadan seç';

  @override
  String get tapMapForStart => 'Başlangıç için haritaya dokunun';

  @override
  String get manualPointLabel => 'Haritadan seçilen nokta';

  @override
  String get selectedPoint => 'Seçilen nokta';

  @override
  String get routeModeWalking => 'Yürüyüş';

  @override
  String get routeModeDriving => 'Araç';

  @override
  String get unitMinuteShort => 'dk';

  @override
  String get unitHourShort => 'sa';

  @override
  String get checkInStarted => 'Check-in başladı';

  @override
  String get onTheWayReported => 'Yolda olduğunuz bildirildi';
}
