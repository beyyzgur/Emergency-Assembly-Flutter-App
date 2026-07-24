import '../../../l10n/l10n.dart';
import '../data/auth_service.dart';

extension AuthFailureMessage on AuthFailure {
  String localizedMessage(AppLocalizations l10n) {
    switch (this) {
      case AuthFailure.unexpected:
        return l10n.authUnexpectedError;
      case AuthFailure.userNotFound:
        return l10n.authUserNotFound;
      case AuthFailure.wrongCredentials:
        return l10n.authWrongCredentials;
      case AuthFailure.invalidEmail:
        return l10n.emailInvalid;
      case AuthFailure.userDisabled:
        return l10n.authUserDisabled;
      case AuthFailure.tooManyRequests:
        return l10n.authTooManyRequests;
      case AuthFailure.network:
        return l10n.authNetworkError;
      case AuthFailure.emailInUse:
        return l10n.authEmailInUse;
      case AuthFailure.weakPassword:
        return l10n.passwordMinimumError;
      case AuthFailure.emailPasswordDisabled:
        return l10n.authEmailPasswordDisabled;
    }
  }
}
