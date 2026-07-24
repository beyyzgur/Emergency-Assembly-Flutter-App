import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('tr'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ATIS'**
  String get appTitle;

  /// No description provided for @appFullName.
  ///
  /// In en, this message translates to:
  /// **'ATIS: Emergency Assembly Area Marking System'**
  String get appFullName;

  /// No description provided for @brandLogoLabel.
  ///
  /// In en, this message translates to:
  /// **'ATIS - Emergency Assembly Area Marking System logo'**
  String get brandLogoLabel;

  /// No description provided for @brandTagline.
  ///
  /// In en, this message translates to:
  /// **'Every point is trust, every sign is a life.'**
  String get brandTagline;

  /// No description provided for @navMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get navMap;

  /// No description provided for @navNeeds.
  ///
  /// In en, this message translates to:
  /// **'Needs'**
  String get navNeeds;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @secureSignIn.
  ///
  /// In en, this message translates to:
  /// **'Secure sign in'**
  String get secureSignIn;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Continue with your account to access assembly areas and need records.'**
  String get loginSubtitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address.'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get emailInvalid;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get passwordRequired;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get login;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @googleSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Opening Google account...'**
  String get googleSigningIn;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in could not be completed. Please try again.'**
  String get googleSignInFailed;

  /// No description provided for @authDataSecurityNote.
  ///
  /// In en, this message translates to:
  /// **'Your information is stored securely for quick access in emergencies.'**
  String get authDataSecurityNote;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToLogin;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to quickly access need information in emergencies.'**
  String get registerSubtitle;

  /// No description provided for @passwordMinimumHint.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters.'**
  String get passwordMinimumHint;

  /// No description provided for @passwordMinimumError.
  ///
  /// In en, this message translates to:
  /// **'Your password must be at least 6 characters.'**
  String get passwordMinimumError;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordMismatch;

  /// No description provided for @alreadyAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyAccount;

  /// No description provided for @authUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get authUnexpectedError;

  /// No description provided for @authUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No registered user was found with this email address.'**
  String get authUserNotFound;

  /// No description provided for @authWrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Your email or password is incorrect.'**
  String get authWrongCredentials;

  /// No description provided for @authUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This user account has been disabled.'**
  String get authUserDisabled;

  /// No description provided for @authTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts were made. Please try again later.'**
  String get authTooManyRequests;

  /// No description provided for @authNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection.'**
  String get authNetworkError;

  /// No description provided for @authEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email address.'**
  String get authEmailInUse;

  /// No description provided for @authEmailPasswordDisabled.
  ///
  /// In en, this message translates to:
  /// **'Email registration has not been enabled yet.'**
  String get authEmailPasswordDisabled;

  /// No description provided for @authRegistrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Account could not be created.'**
  String get authRegistrationFailed;

  /// No description provided for @authLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in.'**
  String get authLoginFailed;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(Object version);

  /// No description provided for @statusCheck.
  ///
  /// In en, this message translates to:
  /// **'Status check'**
  String get statusCheck;

  /// No description provided for @startTenMinuteCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Start 10-minute check-in'**
  String get startTenMinuteCheckIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Status check-in'**
  String get checkIn;

  /// No description provided for @checkInHeader.
  ///
  /// In en, this message translates to:
  /// **'Share your route status safely'**
  String get checkInHeader;

  /// No description provided for @checkInDescription.
  ///
  /// In en, this message translates to:
  /// **'When you start check-in, the app asks for your status every 10 minutes while it is open.'**
  String get checkInDescription;

  /// No description provided for @checkInActive.
  ///
  /// In en, this message translates to:
  /// **'Check-in active'**
  String get checkInActive;

  /// No description provided for @checkInActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your next route status check is pending.'**
  String get checkInActiveSubtitle;

  /// No description provided for @checkInResponsePending.
  ///
  /// In en, this message translates to:
  /// **'Your status response is pending'**
  String get checkInResponsePending;

  /// No description provided for @checkInResponsePendingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share whether you are on the way or arrived.'**
  String get checkInResponsePendingSubtitle;

  /// No description provided for @checkInPaused.
  ///
  /// In en, this message translates to:
  /// **'Check-in paused'**
  String get checkInPaused;

  /// No description provided for @checkInPausedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ten minutes will be counted again when you return to the app.'**
  String get checkInPausedSubtitle;

  /// No description provided for @checkInArrived.
  ///
  /// In en, this message translates to:
  /// **'Your arrival was recorded'**
  String get checkInArrived;

  /// No description provided for @checkInArrivedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You reported that you arrived safely.'**
  String get checkInArrivedSubtitle;

  /// No description provided for @checkInStopped.
  ///
  /// In en, this message translates to:
  /// **'Check-in stopped'**
  String get checkInStopped;

  /// No description provided for @checkInStoppedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can start a new check-in whenever you want.'**
  String get checkInStoppedSubtitle;

  /// No description provided for @checkInAttentionTitle.
  ///
  /// In en, this message translates to:
  /// **'3 checks went unanswered'**
  String get checkInAttentionTitle;

  /// No description provided for @checkInAttentionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check-in was stopped for safety. You can start a new session.'**
  String get checkInAttentionSubtitle;

  /// No description provided for @checkInNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Check-in has not started yet'**
  String get checkInNotStarted;

  /// No description provided for @checkInNotStartedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start status checks when you set off.'**
  String get checkInNotStartedSubtitle;

  /// No description provided for @nextCheck.
  ///
  /// In en, this message translates to:
  /// **'Next check: {time}'**
  String nextCheck(Object time);

  /// No description provided for @unansweredChecks.
  ///
  /// In en, this message translates to:
  /// **'Unanswered checks'**
  String get unansweredChecks;

  /// No description provided for @onTheWay.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get onTheWay;

  /// No description provided for @arrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get arrived;

  /// No description provided for @stopCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Stop check-in'**
  String get stopCheckIn;

  /// No description provided for @startCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Start 10-minute check-in'**
  String get startCheckIn;

  /// No description provided for @foregroundOnly.
  ///
  /// In en, this message translates to:
  /// **'This version only works while the app is open. The timer is paused when the app goes to the background.'**
  String get foregroundOnly;

  /// No description provided for @statusCheckDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Status check'**
  String get statusCheckDialogTitle;

  /// No description provided for @statusCheckPrompt.
  ///
  /// In en, this message translates to:
  /// **'What is your route status? Share a brief update for your safety.'**
  String get statusCheckPrompt;

  /// No description provided for @unansweredStatusPrompt.
  ///
  /// In en, this message translates to:
  /// **'{count} unanswered check(s) recorded. Please share your status.'**
  String unansweredStatusPrompt(Object count);

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @checkInStoppedDialog.
  ///
  /// In en, this message translates to:
  /// **'Check-in stopped'**
  String get checkInStoppedDialog;

  /// No description provided for @checkInStoppedDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Check-in was ended because 3 status checks went unanswered. You can start a new check-in.'**
  String get checkInStoppedDialogMessage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @newNeedRequest.
  ///
  /// In en, this message translates to:
  /// **'New need request'**
  String get newNeedRequest;

  /// No description provided for @editNeedRequest.
  ///
  /// In en, this message translates to:
  /// **'Edit request'**
  String get editNeedRequest;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'BASIC INFORMATION'**
  String get basicInformation;

  /// No description provided for @scopeAndUrgency.
  ///
  /// In en, this message translates to:
  /// **'SCOPE AND URGENCY'**
  String get scopeAndUrgency;

  /// No description provided for @needTitle.
  ///
  /// In en, this message translates to:
  /// **'Need title'**
  String get needTitle;

  /// No description provided for @needTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a title.'**
  String get needTitleRequired;

  /// No description provided for @detailedDescription.
  ///
  /// In en, this message translates to:
  /// **'Detailed description'**
  String get detailedDescription;

  /// No description provided for @needDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a description.'**
  String get needDescriptionRequired;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @peopleCount.
  ///
  /// In en, this message translates to:
  /// **'People count'**
  String get peopleCount;

  /// No description provided for @peopleCountRequired.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty.'**
  String get peopleCountRequired;

  /// No description provided for @urgencyStatus.
  ///
  /// In en, this message translates to:
  /// **'Urgency'**
  String get urgencyStatus;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @submitNeed.
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get submitNeed;

  /// No description provided for @noSignedInUser.
  ///
  /// In en, this message translates to:
  /// **'Error: No signed-in user was found.'**
  String get noSignedInUser;

  /// No description provided for @needUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your request was updated successfully.'**
  String get needUpdated;

  /// No description provided for @needSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Your need request was submitted successfully.'**
  String get needSubmitted;

  /// No description provided for @offlineNeedSaved.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. The request was saved on this device.'**
  String get offlineNeedSaved;

  /// No description provided for @updateRequiresInternet.
  ///
  /// In en, this message translates to:
  /// **'An internet connection is required to update.'**
  String get updateRequiresInternet;

  /// No description provided for @categoryWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get categoryWater;

  /// No description provided for @categoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get categoryFood;

  /// No description provided for @categoryShelter.
  ///
  /// In en, this message translates to:
  /// **'Shelter'**
  String get categoryShelter;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @urgencyLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get urgencyLow;

  /// No description provided for @urgencyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get urgencyMedium;

  /// No description provided for @urgencyHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get urgencyHigh;

  /// No description provided for @urgencyCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get urgencyCritical;

  /// No description provided for @needsBag.
  ///
  /// In en, this message translates to:
  /// **'My Emergency Kit'**
  String get needsBag;

  /// No description provided for @addNeed.
  ///
  /// In en, this message translates to:
  /// **'Add need'**
  String get addNeed;

  /// No description provided for @deleteNeed.
  ///
  /// In en, this message translates to:
  /// **'Delete need'**
  String get deleteNeed;

  /// No description provided for @deleteNeedConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure that this need was met or that you want to remove the request completely?'**
  String get deleteNeedConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @needDeleted.
  ///
  /// In en, this message translates to:
  /// **'Need record was deleted successfully.'**
  String get needDeleted;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Yes, delete'**
  String get confirmDelete;

  /// No description provided for @offlineSyncSuccess.
  ///
  /// In en, this message translates to:
  /// **'All data was uploaded to the cloud successfully.'**
  String get offlineSyncSuccess;

  /// No description provided for @offlineSyncFailure.
  ///
  /// In en, this message translates to:
  /// **'Offline needs could not be sent. Check your connection and try again.'**
  String get offlineSyncFailure;

  /// No description provided for @needsLoadError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading the records.'**
  String get needsLoadError;

  /// No description provided for @noNeedsYet.
  ///
  /// In en, this message translates to:
  /// **'No needs have been recorded yet.'**
  String get noNeedsYet;

  /// No description provided for @untitledNeed.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitledNeed;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// No description provided for @unknownUrgency.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownUrgency;

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} person} other{{count} people}}'**
  String people(num count);

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency Assembly Map'**
  String get mapTitle;

  /// No description provided for @nearestAreas.
  ///
  /// In en, this message translates to:
  /// **'Nearest assembly areas'**
  String get nearestAreas;

  /// No description provided for @loadingAssemblyAreas.
  ///
  /// In en, this message translates to:
  /// **'Loading assembly areas...'**
  String get loadingAssemblyAreas;

  /// No description provided for @locationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location unavailable'**
  String get locationUnavailable;

  /// No description provided for @selectDistrict.
  ///
  /// In en, this message translates to:
  /// **'Select your district'**
  String get selectDistrict;

  /// No description provided for @myLocation.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get myLocation;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @returnToGps.
  ///
  /// In en, this message translates to:
  /// **'Return to GPS location'**
  String get returnToGps;

  /// No description provided for @clearManualSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear manual selection'**
  String get clearManualSelection;

  /// No description provided for @searchDistrict.
  ///
  /// In en, this message translates to:
  /// **'Search district...'**
  String get searchDistrict;

  /// No description provided for @districtNotFound.
  ///
  /// In en, this message translates to:
  /// **'District not found'**
  String get districtNotFound;

  /// No description provided for @noNearbyAreas.
  ///
  /// In en, this message translates to:
  /// **'No nearby assembly area was found.\nLocation is required (GPS or district selection).'**
  String get noNearbyAreas;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity: {count} people'**
  String capacity(num count);

  /// No description provided for @walkingDistance.
  ///
  /// In en, this message translates to:
  /// **'{distance} m · ~{minutes} min walk'**
  String walkingDistance(num distance, num minutes);

  /// No description provided for @mapLayerRoad.
  ///
  /// In en, this message translates to:
  /// **'Road'**
  String get mapLayerRoad;

  /// No description provided for @mapLayerSatellite.
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get mapLayerSatellite;

  /// No description provided for @mapLayerHybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get mapLayerHybrid;

  /// No description provided for @mapLayerOpenStreetMap.
  ///
  /// In en, this message translates to:
  /// **'OSM'**
  String get mapLayerOpenStreetMap;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @directions.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get directions;

  /// No description provided for @routeOrigin.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get routeOrigin;

  /// No description provided for @routeDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get routeDestination;

  /// No description provided for @startRoute.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startRoute;

  /// No description provided for @routeCalculating.
  ///
  /// In en, this message translates to:
  /// **'Calculating route...'**
  String get routeCalculating;

  /// No description provided for @routeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Route unavailable, showing straight line.'**
  String get routeUnavailable;

  /// No description provided for @routePreviewHint.
  ///
  /// In en, this message translates to:
  /// **'Route preview — start must be GPS for live tracking'**
  String get routePreviewHint;

  /// No description provided for @closeRoute.
  ///
  /// In en, this message translates to:
  /// **'Close route'**
  String get closeRoute;

  /// No description provided for @nearerAreaTitle.
  ///
  /// In en, this message translates to:
  /// **'There is a closer area'**
  String get nearerAreaTitle;

  /// No description provided for @nearerAreaBody.
  ///
  /// In en, this message translates to:
  /// **'There is a closer assembly area about {distance} away. Would you like to see it?'**
  String nearerAreaBody(Object distance);

  /// No description provided for @showNearer.
  ///
  /// In en, this message translates to:
  /// **'Show nearer'**
  String get showNearer;

  /// No description provided for @arrivedMessage.
  ///
  /// In en, this message translates to:
  /// **'🎉 You have arrived at the assembly area.'**
  String get arrivedMessage;

  /// No description provided for @myLocationGps.
  ///
  /// In en, this message translates to:
  /// **'My location (GPS)'**
  String get myLocationGps;

  /// No description provided for @selectDistrictAction.
  ///
  /// In en, this message translates to:
  /// **'Select district'**
  String get selectDistrictAction;

  /// No description provided for @pickOnMap.
  ///
  /// In en, this message translates to:
  /// **'Pick on map'**
  String get pickOnMap;

  /// No description provided for @tapMapForStart.
  ///
  /// In en, this message translates to:
  /// **'Tap the map to set the start'**
  String get tapMapForStart;

  /// No description provided for @manualPointLabel.
  ///
  /// In en, this message translates to:
  /// **'Point selected on map'**
  String get manualPointLabel;

  /// No description provided for @selectedPoint.
  ///
  /// In en, this message translates to:
  /// **'Selected point'**
  String get selectedPoint;

  /// No description provided for @routeModeWalking.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get routeModeWalking;

  /// No description provided for @routeModeDriving.
  ///
  /// In en, this message translates to:
  /// **'Driving'**
  String get routeModeDriving;

  /// No description provided for @unitMinuteShort.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get unitMinuteShort;

  /// No description provided for @unitHourShort.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get unitHourShort;

  /// No description provided for @checkInStarted.
  ///
  /// In en, this message translates to:
  /// **'Check-in started'**
  String get checkInStarted;

  /// No description provided for @onTheWayReported.
  ///
  /// In en, this message translates to:
  /// **'Your on-the-way status was reported'**
  String get onTheWayReported;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
