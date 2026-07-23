// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ATIS';

  @override
  String get appFullName => 'ATIS: Emergency Assembly Area Marking System';

  @override
  String get brandLogoLabel =>
      'ATIS - Emergency Assembly Area Marking System logo';

  @override
  String get brandTagline => 'Every point is trust, every sign is a life.';

  @override
  String get navMap => 'Map';

  @override
  String get navNeeds => 'Needs';

  @override
  String get navSettings => 'Settings';

  @override
  String get secureSignIn => 'Secure sign in';

  @override
  String get loginSubtitle =>
      'Continue with your account to access assembly areas and need records.';

  @override
  String get emailAddress => 'Email address';

  @override
  String get emailRequired => 'Enter your email address.';

  @override
  String get emailInvalid => 'Enter a valid email address.';

  @override
  String get password => 'Password';

  @override
  String get passwordRequired => 'Enter your password.';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get login => 'Sign in';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get or => 'or';

  @override
  String get googleSigningIn => 'Opening Google account...';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get googleSignInFailed =>
      'Google sign-in could not be completed. Please try again.';

  @override
  String get authDataSecurityNote =>
      'Your information is stored securely for quick access in emergencies.';

  @override
  String get backToLogin => 'Back to sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get registerSubtitle =>
      'Sign up to quickly access need information in emergencies.';

  @override
  String get passwordMinimumHint => 'Use at least 6 characters.';

  @override
  String get passwordMinimumError =>
      'Your password must be at least 6 characters.';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get passwordMismatch => 'Passwords do not match.';

  @override
  String get alreadyAccount => 'Already have an account?';

  @override
  String get authUnexpectedError => 'An unexpected error occurred.';

  @override
  String get authUserNotFound =>
      'No registered user was found with this email address.';

  @override
  String get authWrongCredentials => 'Your email or password is incorrect.';

  @override
  String get authUserDisabled => 'This user account has been disabled.';

  @override
  String get authTooManyRequests =>
      'Too many attempts were made. Please try again later.';

  @override
  String get authNetworkError => 'Check your internet connection.';

  @override
  String get authEmailInUse =>
      'An account already exists with this email address.';

  @override
  String get authEmailPasswordDisabled =>
      'Email registration has not been enabled yet.';

  @override
  String get authRegistrationFailed => 'Account could not be created.';

  @override
  String get authLoginFailed => 'Could not sign in.';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get user => 'User';

  @override
  String get application => 'Application';

  @override
  String get security => 'Security';

  @override
  String version(Object version) {
    return 'Version $version';
  }

  @override
  String get statusCheck => 'Status check';

  @override
  String get startTenMinuteCheckIn => 'Start 10-minute check-in';

  @override
  String get signOut => 'Sign out';

  @override
  String get checkIn => 'Status check-in';

  @override
  String get checkInHeader => 'Share your route status safely';

  @override
  String get checkInDescription =>
      'When you start check-in, the app asks for your status every 10 minutes while it is open.';

  @override
  String get checkInActive => 'Check-in active';

  @override
  String get checkInActiveSubtitle =>
      'Your next route status check is pending.';

  @override
  String get checkInResponsePending => 'Your status response is pending';

  @override
  String get checkInResponsePendingSubtitle =>
      'Share whether you are on the way or arrived.';

  @override
  String get checkInPaused => 'Check-in paused';

  @override
  String get checkInPausedSubtitle =>
      'Ten minutes will be counted again when you return to the app.';

  @override
  String get checkInArrived => 'Your arrival was recorded';

  @override
  String get checkInArrivedSubtitle => 'You reported that you arrived safely.';

  @override
  String get checkInStopped => 'Check-in stopped';

  @override
  String get checkInStoppedSubtitle =>
      'You can start a new check-in whenever you want.';

  @override
  String get checkInAttentionTitle => '3 checks went unanswered';

  @override
  String get checkInAttentionSubtitle =>
      'Check-in was stopped for safety. You can start a new session.';

  @override
  String get checkInNotStarted => 'Check-in has not started yet';

  @override
  String get checkInNotStartedSubtitle =>
      'Start status checks when you set off.';

  @override
  String nextCheck(Object time) {
    return 'Next check: $time';
  }

  @override
  String get unansweredChecks => 'Unanswered checks';

  @override
  String get onTheWay => 'On the way';

  @override
  String get arrived => 'Arrived';

  @override
  String get stopCheckIn => 'Stop check-in';

  @override
  String get startCheckIn => 'Start 10-minute check-in';

  @override
  String get foregroundOnly =>
      'This version only works while the app is open. The timer is paused when the app goes to the background.';

  @override
  String get statusCheckDialogTitle => 'Status check';

  @override
  String get statusCheckPrompt =>
      'What is your route status? Share a brief update for your safety.';

  @override
  String unansweredStatusPrompt(Object count) {
    return '$count unanswered check(s) recorded. Please share your status.';
  }

  @override
  String get stop => 'Stop';

  @override
  String get checkInStoppedDialog => 'Check-in stopped';

  @override
  String get checkInStoppedDialogMessage =>
      'Check-in was ended because 3 status checks went unanswered. You can start a new check-in.';

  @override
  String get ok => 'OK';

  @override
  String get newNeedRequest => 'New need request';

  @override
  String get editNeedRequest => 'Edit request';

  @override
  String get basicInformation => 'BASIC INFORMATION';

  @override
  String get scopeAndUrgency => 'SCOPE AND URGENCY';

  @override
  String get needTitle => 'Need title';

  @override
  String get needTitleRequired => 'Enter a title.';

  @override
  String get detailedDescription => 'Detailed description';

  @override
  String get needDescriptionRequired => 'Enter a description.';

  @override
  String get category => 'Category';

  @override
  String get peopleCount => 'People count';

  @override
  String get peopleCountRequired => 'This field cannot be empty.';

  @override
  String get urgencyStatus => 'Urgency';

  @override
  String get saving => 'Saving...';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get submitNeed => 'Submit request';

  @override
  String get noSignedInUser => 'Error: No signed-in user was found.';

  @override
  String get needUpdated => 'Your request was updated successfully.';

  @override
  String get needSubmitted => 'Your need request was submitted successfully.';

  @override
  String get offlineNeedSaved =>
      'No internet connection. The request was saved on this device.';

  @override
  String get updateRequiresInternet =>
      'An internet connection is required to update.';

  @override
  String get categoryWater => 'Water';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryShelter => 'Shelter';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryOther => 'Other';

  @override
  String get urgencyLow => 'Low';

  @override
  String get urgencyMedium => 'Medium';

  @override
  String get urgencyHigh => 'High';

  @override
  String get urgencyCritical => 'Critical';

  @override
  String get needsBag => 'My emergency kit';

  @override
  String get addNeed => 'Add need';

  @override
  String get deleteNeed => 'Delete need';

  @override
  String get deleteNeedConfirmation =>
      'Are you sure that this need was met or that you want to remove the request completely?';

  @override
  String get cancel => 'Cancel';

  @override
  String get needDeleted => 'Need record was deleted successfully.';

  @override
  String get confirmDelete => 'Yes, delete';

  @override
  String get offlineSyncSuccess =>
      'All data was uploaded to the cloud successfully.';

  @override
  String get offlineSyncFailure =>
      'There is no data to upload or there was a connection error.';

  @override
  String get needsLoadError => 'An error occurred while loading the records.';

  @override
  String get noNeedsYet => 'No needs have been recorded yet.';

  @override
  String get untitledNeed => 'Untitled';

  @override
  String get noDescription => 'No description';

  @override
  String get unknownUrgency => 'Unknown';

  @override
  String people(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '$count person',
    );
    return '$_temp0';
  }

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get mapTitle => 'Emergency assembly map';

  @override
  String get nearestAreas => 'Nearest assembly areas';

  @override
  String get loadingAssemblyAreas => 'Loading assembly areas...';

  @override
  String get locationUnavailable => 'Location unavailable';

  @override
  String get selectDistrict => 'Select your district';

  @override
  String get myLocation => 'My location';

  @override
  String get close => 'Close';

  @override
  String get returnToGps => 'Return to GPS location';

  @override
  String get clearManualSelection => 'Clear manual selection';

  @override
  String get searchDistrict => 'Search district...';

  @override
  String get districtNotFound => 'District not found';

  @override
  String get noNearbyAreas =>
      'No nearby assembly area was found.\nLocation is required (GPS or district selection).';

  @override
  String capacity(num count) {
    return 'Capacity: $count people';
  }

  @override
  String walkingDistance(num distance, num minutes) {
    return '$distance m · ~$minutes min walk';
  }

  @override
  String get mapLayerRoad => 'Road';

  @override
  String get mapLayerSatellite => 'Satellite';

  @override
  String get mapLayerHybrid => 'Hybrid';

  @override
  String get mapLayerOpenStreetMap => 'OpenStreetMap';
}
