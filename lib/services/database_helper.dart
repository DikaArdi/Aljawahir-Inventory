import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern: ensures only one instance of the DB exists
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('aljawahir_inventory.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path, 
      version: 4, 
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // Handle schema changes for version 2 (Transaction Items)
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE transaction_items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          transaction_id INTEGER NOT NULL,
          product_id INTEGER NOT NULL,
          quantity INTEGER NOT NULL,
          price INTEGER NOT NULL,
          FOREIGN KEY(transaction_id) REFERENCES transactions(id) ON DELETE CASCADE
        )
      ''');
    }
    
    // Version 3: Add Image Path
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE products ADD COLUMN image_path TEXT');
    }

    // Version 4: Add Archived Status
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE products ADD COLUMN is_archived INTEGER DEFAULT 0');
    }
  }

  Future _createDB(Database db, int version) async {
    // Note: REAL is used for money, INTEGER for stock
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cost_price REAL NOT NULL,
        sell_price REAL NOT NULL,
        stock INTEGER NOT NULL,
        barcode TEXT,
        image_path TEXT,
        is_archived INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total_amount REAL NOT NULL,
        profit REAL NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    
    // Version 2: Transaction Items
    await db.execute('''
      CREATE TABLE transaction_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transaction_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        price INTEGER NOT NULL,
        FOREIGN KEY(transaction_id) REFERENCES transactions(id) ON DELETE CASCADE
      )
    ''');
    
    // You can add a transaction_items table later for detailed breakdowns
  }

  // --- CRUD METHODS (Similar to Python functions) ---

  Future<int> createProduct(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('products', row);
  }

  Future<List<Map<String, dynamic>>> readAllProducts() async {
    final db = await instance.database;
    return await db.query('products', orderBy: 'name ASC');
  }

  Future<int> updateProduct(Map<String, dynamic> row) async {
    final db = await instance.database;
    int id = row['id'];
    return await db.update('products', row, where: 'id = ?', whereArgs: [id]);
  }
  // Inside DatabaseHelper class...

  Future<List<Map<String, dynamic>>> getTransactionsByDate(String dateStr) async {
    // dateStr format expected: "YYYY-MM-DD"
    final db = await instance.database;
    
    // SQLite doesn't have a DATE type, it stores strings. 
    // We use LIKE '2023-10-27%' to find all times on that day.
    return await db.query(
      'transactions',
      where: 'created_at LIKE ?',
      whereArgs: ['$dateStr%'],
      orderBy: 'created_at DESC', // Newest first
    );
  }

  // Delete Transaction and Restore Stock
  Future<void> deleteTransaction(int transactionId) async {
    final db = await instance.database;

    await db.transaction((txn) async {
      // 1. Get items for this transaction
      final List<Map<String, dynamic>> items = await txn.query(
        'transaction_items',
        where: 'transaction_id = ?',
        whereArgs: [transactionId],
      );

      // 2. Restore Stock
      for (var item in items) {
        int productId = item['product_id'];
        int quantity = item['quantity'];

        // We use raw SQL for simpler incrementing
        await txn.rawUpdate(
          'UPDATE products SET stock = stock + ? WHERE id = ?',
          [quantity, productId],
        );
      }

      // 3. Delete the transaction (DB Cascade will delete items, but we do it manually safely usually)
      await txn.delete(
        'transactions', 
        where: 'id = ?',
        whereArgs: [transactionId],
      );
    });
  }

  // Delete Product
  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  // 1. Expose the DB path so we know what file to backup
  Future<String> get dbPath async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, 'aljawahir_inventory.db');
  }

  // 2. Close the DB (Required before restoring)
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null; // Reset singleton so it re-opens next time
    }
  }
}