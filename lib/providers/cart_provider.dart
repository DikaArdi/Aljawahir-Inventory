import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../services/database_helper.dart';

// 'ChangeNotifier' is the mixin that lets us update the UI
class CartProvider with ChangeNotifier {
  
  // Private list to store items (encapsulation)
  final List<CartItem> _items = [];

  // Public getter (read-only access for UI)
  List<CartItem> get items => _items;

  // --- CALCULATIONS (Computed Properties) ---

  double get totalAmount {
    // Python equivalent: sum(item.subtotal for item in _items)
    return _items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  double get totalProfit {
    return _items.fold(0.0, (sum, item) {
      double profitPerItem = item.product.sellPrice - item.product.costPrice;
      return sum + (profitPerItem * item.quantity);
    });
  }

  int get totalItemsCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // --- ACTIONS ---

  bool addToCart(Product product) {
    // 1. Check if item is already in cart
    int index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      // 2. Check if enough stock to add one more
      if (_items[index].quantity + 1 > product.stock) {
        return false; // Not enough stock
      }
      _items[index].quantity++;
    } else {
      // 3. Check if product has any stock at all
      if (product.stock <= 0) {
        return false; // Out of stock
      }
      _items.add(CartItem(product: product));
    }
    
    notifyListeners(); 
    return true; // Added successfully
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // --- CHECKOUT (Async Database Logic) ---
  
  Future<bool> checkout() async {
    if (_items.isEmpty) return false;

    final db = DatabaseHelper.instance;
    final now = DateTime.now().toIso8601String();

    try {
      // 1. Record the Transaction
      await db.database.then((database) async {
        
        await database.transaction((txn) async {
          
          // A. Insert into 'transactions' table
          int txnId = await txn.insert('transactions', {
            'total_amount': totalAmount,
            'profit': totalProfit,
            'created_at': now,
          });

          // B. Loop through cart items
          for (var item in _items) {
            int newStock = item.product.stock - item.quantity;
            
            // Prevent negative stock
            if (newStock < 0) newStock = 0;

            // Update Stock
            await txn.update(
              'products',
              {'stock': newStock},
              where: 'id = ?',
              whereArgs: [item.product.id],
            );
            
            // C. Insert into 'transaction_items' for detailed history
            await txn.insert('transaction_items', {
              'transaction_id': txnId,
              'product_id': item.product.id,
              'quantity': item.quantity,
              'price': item.product.sellPrice,
            });
          }
        });
      });

      // 2. Clear UI after success
      clearCart();
      return true;

    } catch (e) {
      print("Checkout Error: $e");
      return false;
    }
  }
}