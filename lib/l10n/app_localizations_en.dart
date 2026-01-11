// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Aljawahir Inventory';

  @override
  String get ownerMode => 'Owner Mode 🔓';

  @override
  String get employeeMode => 'Employee Mode 🔒';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get cashierTitle => 'Cashier (POS)';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get addProductTitle => 'Add Product';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get ownerLoginTitle => 'Owner Login';

  @override
  String get enterPin => 'Enter PIN';

  @override
  String get cancel => 'Cancel';

  @override
  String get unlock => 'Unlock';

  @override
  String get switchedToEmployee => 'Switched to Employee Mode';

  @override
  String get welcomeOwner => 'Welcome Back, Owner!';

  @override
  String get wrongPin => 'Wrong PIN!';

  @override
  String get addNewItem => 'Add New Item';

  @override
  String get editItem => 'Edit Item';

  @override
  String get deleteProductTitle => 'Delete Product?';

  @override
  String deleteProductConfirm(String name) {
    return 'Are you sure you want to delete \'$name\'?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get productNameLabel => 'Product Name';

  @override
  String get productNameError => 'Please enter a name';

  @override
  String get barcodeLabel => 'Barcode (Optional)';

  @override
  String get costPriceLabel => 'Buy Price (Cost)';

  @override
  String get sellPriceLabel => 'Sell Price';

  @override
  String get requiredError => 'Required';

  @override
  String get currentStockLabel => 'Current Stock';

  @override
  String get retiredProductTitle => 'Retired Product';

  @override
  String get retiredProductSubtitle => 'Hide from cashier but keep history';

  @override
  String get saveProductButton => 'SAVE PRODUCT';

  @override
  String get tapToAddImage => 'Tap to add image';

  @override
  String scannedCodeMessage(String code) {
    return 'Scanned: $code';
  }

  @override
  String get stationeryShop => 'Stationery Shop';

  @override
  String get showRetired => 'Show Retired';

  @override
  String get hideRetired => 'Hide Retired';

  @override
  String get searchProduct => 'Search Product';

  @override
  String get noProductsFound => 'No products found';

  @override
  String itemAddedMessage(String name) {
    return '$name Added!';
  }

  @override
  String get productNotFound => 'Product not found!';

  @override
  String outOfStockMessage(String name) {
    return 'Out of Stock! Cannot add $name.';
  }

  @override
  String get retiredLabel => 'RETIRED';

  @override
  String stockLabel(int stock) {
    return 'Stock: $stock';
  }

  @override
  String itemsCount(int count) {
    return '$count Items';
  }

  @override
  String get transactionSaved => 'Transaction Saved!';

  @override
  String get payButton => 'PAY';

  @override
  String get currentCart => 'Current Cart';

  @override
  String get cannotSellRetired => 'Cannot sell retired product.';

  @override
  String get dailyReportTitle => 'Daily Report';

  @override
  String get totalSales => 'Total Sales';

  @override
  String get profit => 'Profit';

  @override
  String get noSalesDate => 'No sales on this date.';

  @override
  String saleAtTime(String time) {
    return 'Sale at $time';
  }

  @override
  String get deleteTransactionTitle => 'Delete Transaction?';

  @override
  String get deleteTransactionConfirm =>
      'This will remove the sale record. If this transaction was made recently, stock will be restored.';

  @override
  String get transactionDeleted => 'Transaction deleted.';

  @override
  String get backupRestoreTitle => 'Backup & Restore';

  @override
  String get noDatabaseFound => 'No database found to backup!';

  @override
  String backupFailed(String error) {
    return 'Backup failed: $error';
  }

  @override
  String get overwriteConfirmTitle => '⚠️ Overwrite Data?';

  @override
  String get overwriteConfirmMessage =>
      'This will DELETE your current inventory and replace it with the backup file.\n\nAre you sure?';

  @override
  String get restoreButton => 'RESTORE';

  @override
  String get restoreSuccess => 'Restore Successful! Please restart the app.';

  @override
  String restoreFailed(String error) {
    return 'Restore failed: $error';
  }

  @override
  String get backupDataButton => 'Backup Data';

  @override
  String get backupDataSubtitle => 'Save your data to Google Drive or WhatsApp';

  @override
  String get restoreDataButton => 'Restore Data';

  @override
  String get restoreDataSubtitle => 'Overwrite current data with a backup file';

  @override
  String get changePinTitle => 'Change PIN';

  @override
  String get oldPinLabel => 'Old PIN';

  @override
  String get newPinLabel => 'New PIN';

  @override
  String get confirmPinLabel => 'Confirm New PIN';

  @override
  String get pinChangedSuccess => 'PIN Changed Successfully!';

  @override
  String get pinMismatchError => 'PINs do not match';

  @override
  String get wrongOldPinError => 'Wrong Old PIN';

  @override
  String get changePinButton => 'Change PIN';
}
