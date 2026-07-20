// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get welcome => 'Hoş geldin!';

  @override
  String get loginButton => 'Giriş Yap';

  @override
  String get loginGoogle => 'Google ile Giriş Yap';

  @override
  String get loginApple => 'Apple ile Giriş Yap';

  @override
  String get appTitle => 'AFAD Koordinasyon Paneli';

  @override
  String get activeNeeds => 'Aktif İhtiyaçlar';
}
