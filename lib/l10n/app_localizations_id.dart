// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Inventaris Aljawahir';

  @override
  String get ownerMode => 'Mode Pemilik 🔓';

  @override
  String get employeeMode => 'Mode Karyawan 🔒';

  @override
  String get welcomeBack => 'Selamat Datang!';

  @override
  String get cashierTitle => 'Kasir (POS)';

  @override
  String get reportsTitle => 'Laporan';

  @override
  String get addProductTitle => 'Tambah Produk';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get ownerLoginTitle => 'Login Pemilik';

  @override
  String get enterPin => 'Masukkan PIN';

  @override
  String get cancel => 'Batal';

  @override
  String get unlock => 'Buka Kunci';

  @override
  String get switchedToEmployee => 'Beralih ke Mode Karyawan';

  @override
  String get welcomeOwner => 'Selamat Datang, Pemilik!';

  @override
  String get wrongPin => 'PIN Salah!';

  @override
  String get addNewItem => 'Tambah Barang Baru';

  @override
  String get editItem => 'Edit Barang';

  @override
  String get deleteProductTitle => 'Hapus Produk?';

  @override
  String deleteProductConfirm(String name) {
    return 'Anda yakin ingin menghapus \'$name\'?';
  }

  @override
  String get delete => 'Hapus';

  @override
  String get productNameLabel => 'Nama Produk';

  @override
  String get productNameError => 'Mohon masukkan nama';

  @override
  String get barcodeLabel => 'Barcode (Opsional)';

  @override
  String get costPriceLabel => 'Harga Beli (Modal)';

  @override
  String get sellPriceLabel => 'Harga Jual';

  @override
  String get requiredError => 'Wajib diisi';

  @override
  String get currentStockLabel => 'Stok Saat Ini';

  @override
  String get retiredProductTitle => 'Produk Pensiun (Arsip)';

  @override
  String get retiredProductSubtitle =>
      'Sembunyikan dari kasir namun simpan riwayat';

  @override
  String get saveProductButton => 'SIMPAN PRODUK';

  @override
  String get tapToAddImage => 'Ketuk untuk tambah foto';

  @override
  String scannedCodeMessage(String code) {
    return 'Terpindai: $code';
  }

  @override
  String get stationeryShop => 'Toko Alat Tulis';

  @override
  String get showRetired => 'Tampilkan Pensiun';

  @override
  String get hideRetired => 'Sembunyikan Pensiun';

  @override
  String get searchProduct => 'Cari Produk';

  @override
  String get noProductsFound => 'Produk tidak ditemukan';

  @override
  String itemAddedMessage(String name) {
    return '$name Ditambahkan!';
  }

  @override
  String get productNotFound => 'Produk tidak ditemukan!';

  @override
  String outOfStockMessage(String name) {
    return 'Stok Habis! Tidak bisa menambah $name.';
  }

  @override
  String get retiredLabel => 'PENSIUN';

  @override
  String stockLabel(int stock) {
    return 'Stok: $stock';
  }

  @override
  String itemsCount(int count) {
    return '$count Item';
  }

  @override
  String get transactionSaved => 'Transaksi Disimpan!';

  @override
  String get payButton => 'BAYAR';

  @override
  String get currentCart => 'Keranjang Saat Ini';

  @override
  String get cannotSellRetired => 'Tidak bisa menjual produk pensiun.';

  @override
  String get dailyReportTitle => 'Laporan Harian';

  @override
  String get totalSales => 'Total Penjualan';

  @override
  String get profit => 'Keuntungan';

  @override
  String get noSalesDate => 'Tidak ada penjualan pada tanggal ini.';

  @override
  String saleAtTime(String time) {
    return 'Penjualan jam $time';
  }

  @override
  String get deleteTransactionTitle => 'Hapus Transaksi?';

  @override
  String get deleteTransactionConfirm =>
      'Ini akan menghapus catatan penjualan. Jika transaksi baru saja dilakukan, stok akan dikembalikan.';

  @override
  String get transactionDeleted => 'Transaksi dihapus.';

  @override
  String get backupRestoreTitle => 'Cadangkan & Pulihkan';

  @override
  String get noDatabaseFound => 'Database tidak ditemukan!';

  @override
  String backupFailed(String error) {
    return 'Pencadangan gagal: $error';
  }

  @override
  String get overwriteConfirmTitle => '⚠️ Timpa Data?';

  @override
  String get overwriteConfirmMessage =>
      'Ini akan MENGHAPUS inventaris saat ini dan menggantinya dengan file cadangan.\n\nAnda yakin?';

  @override
  String get restoreButton => 'PULIHKAN';

  @override
  String get restoreSuccess => 'Pemulihan Berhasil! Silakan restart aplikasi.';

  @override
  String restoreFailed(String error) {
    return 'Pemulihan gagal: $error';
  }

  @override
  String get backupDataButton => 'Cadangkan Data';

  @override
  String get backupDataSubtitle => 'Simpan data ke Google Drive atau WhatsApp';

  @override
  String get restoreDataButton => 'Pulihkan Data';

  @override
  String get restoreDataSubtitle => 'Timpa data saat ini dengan file cadangan';

  @override
  String get changePinTitle => 'Ganti PIN';

  @override
  String get oldPinLabel => 'PIN Lama';

  @override
  String get newPinLabel => 'PIN Baru';

  @override
  String get confirmPinLabel => 'Konfirmasi PIN Baru';

  @override
  String get pinChangedSuccess => 'PIN Berhasil Diganti!';

  @override
  String get pinMismatchError => 'PIN tidak cocok';

  @override
  String get wrongOldPinError => 'PIN Lama Salah';

  @override
  String get changePinButton => 'Ganti PIN';
}
