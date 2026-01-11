import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Aljawahir Inventory'**
  String get appTitle;

  /// No description provided for @ownerMode.
  ///
  /// In en, this message translates to:
  /// **'Owner Mode 🔓'**
  String get ownerMode;

  /// No description provided for @employeeMode.
  ///
  /// In en, this message translates to:
  /// **'Employee Mode 🔒'**
  String get employeeMode;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @cashierTitle.
  ///
  /// In en, this message translates to:
  /// **'Cashier (POS)'**
  String get cashierTitle;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @addProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProductTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @ownerLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Owner Login'**
  String get ownerLoginTitle;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get enterPin;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @switchedToEmployee.
  ///
  /// In en, this message translates to:
  /// **'Switched to Employee Mode'**
  String get switchedToEmployee;

  /// No description provided for @welcomeOwner.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back, Owner!'**
  String get welcomeOwner;

  /// No description provided for @wrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN!'**
  String get wrongPin;

  /// No description provided for @addNewItem.
  ///
  /// In en, this message translates to:
  /// **'Add New Item'**
  String get addNewItem;

  /// No description provided for @editItem.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get editItem;

  /// No description provided for @deleteProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Product?'**
  String get deleteProductTitle;

  /// No description provided for @deleteProductConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \'{name}\'?'**
  String deleteProductConfirm(String name);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @productNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productNameLabel;

  /// No description provided for @productNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get productNameError;

  /// No description provided for @barcodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Barcode (Optional)'**
  String get barcodeLabel;

  /// No description provided for @costPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Buy Price (Cost)'**
  String get costPriceLabel;

  /// No description provided for @sellPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Sell Price'**
  String get sellPriceLabel;

  /// No description provided for @requiredError.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredError;

  /// No description provided for @currentStockLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Stock'**
  String get currentStockLabel;

  /// No description provided for @retiredProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Retired Product'**
  String get retiredProductTitle;

  /// No description provided for @retiredProductSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide from cashier but keep history'**
  String get retiredProductSubtitle;

  /// No description provided for @saveProductButton.
  ///
  /// In en, this message translates to:
  /// **'SAVE PRODUCT'**
  String get saveProductButton;

  /// No description provided for @tapToAddImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to add image'**
  String get tapToAddImage;

  /// No description provided for @scannedCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Scanned: {code}'**
  String scannedCodeMessage(String code);

  /// No description provided for @stationeryShop.
  ///
  /// In en, this message translates to:
  /// **'Stationery Shop'**
  String get stationeryShop;

  /// No description provided for @showRetired.
  ///
  /// In en, this message translates to:
  /// **'Show Retired'**
  String get showRetired;

  /// No description provided for @hideRetired.
  ///
  /// In en, this message translates to:
  /// **'Hide Retired'**
  String get hideRetired;

  /// No description provided for @searchProduct.
  ///
  /// In en, this message translates to:
  /// **'Search Product'**
  String get searchProduct;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @itemAddedMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} Added!'**
  String itemAddedMessage(String name);

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found!'**
  String get productNotFound;

  /// No description provided for @outOfStockMessage.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock! Cannot add {name}.'**
  String outOfStockMessage(String name);

  /// No description provided for @retiredLabel.
  ///
  /// In en, this message translates to:
  /// **'RETIRED'**
  String get retiredLabel;

  /// No description provided for @stockLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock: {stock}'**
  String stockLabel(int stock);

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Items'**
  String itemsCount(int count);

  /// No description provided for @transactionSaved.
  ///
  /// In en, this message translates to:
  /// **'Transaction Saved!'**
  String get transactionSaved;

  /// No description provided for @payButton.
  ///
  /// In en, this message translates to:
  /// **'PAY'**
  String get payButton;

  /// No description provided for @currentCart.
  ///
  /// In en, this message translates to:
  /// **'Current Cart'**
  String get currentCart;

  /// No description provided for @cannotSellRetired.
  ///
  /// In en, this message translates to:
  /// **'Cannot sell retired product.'**
  String get cannotSellRetired;

  /// No description provided for @dailyReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Report'**
  String get dailyReportTitle;

  /// No description provided for @totalSales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get totalSales;

  /// No description provided for @profit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get profit;

  /// No description provided for @noSalesDate.
  ///
  /// In en, this message translates to:
  /// **'No sales on this date.'**
  String get noSalesDate;

  /// No description provided for @saleAtTime.
  ///
  /// In en, this message translates to:
  /// **'Sale at {time}'**
  String saleAtTime(String time);

  /// No description provided for @deleteTransactionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction?'**
  String get deleteTransactionTitle;

  /// No description provided for @deleteTransactionConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will remove the sale record. If this transaction was made recently, stock will be restored.'**
  String get deleteTransactionConfirm;

  /// No description provided for @transactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted.'**
  String get transactionDeleted;

  /// No description provided for @backupRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupRestoreTitle;

  /// No description provided for @noDatabaseFound.
  ///
  /// In en, this message translates to:
  /// **'No database found to backup!'**
  String get noDatabaseFound;

  /// No description provided for @backupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup failed: {error}'**
  String backupFailed(String error);

  /// No description provided for @overwriteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Overwrite Data?'**
  String get overwriteConfirmTitle;

  /// No description provided for @overwriteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will DELETE your current inventory and replace it with the backup file.\n\nAre you sure?'**
  String get overwriteConfirmMessage;

  /// No description provided for @restoreButton.
  ///
  /// In en, this message translates to:
  /// **'RESTORE'**
  String get restoreButton;

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Restore Successful! Please restart the app.'**
  String get restoreSuccess;

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed: {error}'**
  String restoreFailed(String error);

  /// No description provided for @backupDataButton.
  ///
  /// In en, this message translates to:
  /// **'Backup Data'**
  String get backupDataButton;

  /// No description provided for @backupDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save your data to Google Drive or WhatsApp'**
  String get backupDataSubtitle;

  /// No description provided for @restoreDataButton.
  ///
  /// In en, this message translates to:
  /// **'Restore Data'**
  String get restoreDataButton;

  /// No description provided for @restoreDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Overwrite current data with a backup file'**
  String get restoreDataSubtitle;

  /// No description provided for @changePinTitle.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePinTitle;

  /// No description provided for @oldPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Old PIN'**
  String get oldPinLabel;

  /// No description provided for @newPinLabel.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get newPinLabel;

  /// No description provided for @confirmPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New PIN'**
  String get confirmPinLabel;

  /// No description provided for @pinChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'PIN Changed Successfully!'**
  String get pinChangedSuccess;

  /// No description provided for @pinMismatchError.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get pinMismatchError;

  /// No description provided for @wrongOldPinError.
  ///
  /// In en, this message translates to:
  /// **'Wrong Old PIN'**
  String get wrongOldPinError;

  /// No description provided for @changePinButton.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePinButton;
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
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
