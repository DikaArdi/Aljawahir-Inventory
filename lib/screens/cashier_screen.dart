import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Add intl to pubspec.yaml for currency formatting
import '../providers/cart_provider.dart';
import '../services/database_helper.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import 'add_edit_product_screen.dart';
import 'report_screen.dart';

class CashierScreen extends StatefulWidget {
  const CashierScreen({super.key});

  @override
  State<CashierScreen> createState() => _CashierScreenState();
}

class _CashierScreenState extends State<CashierScreen> {
  // Local state for the search bar (like a local variable in a Python function)
  String _searchQuery = "";
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  bool _showArchived = false; // Filter state

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Fetch data from SQLite (Async function)
  Future<void> _loadProducts() async {
    final data = await DatabaseHelper.instance.readAllProducts();
    // Convert List<Map> to List<Product> (List comprehension style)
    final products = data.map((json) => Product.fromMap(json)).toList();

    setState(() {
      _allProducts = products;
      _isLoading = false;
    });
    
    // Apply filters
    _applyFilters();
  }

  // Unified Filter Logic
  void _applyFilters() {
    List<Product> results = _allProducts;

    // 1. Filter by Archive Status
    if (!_showArchived) {
      results = results.where((p) => !p.isArchived).toList();
    } else {
       // Optional: If showing archived, maybe show ONLY archived? 
       // Or show all? Let's show ONLY archived for clarity, or All? 
       // User asked to "view archived", implies a separate view or mixed.
       // Let's stick to: "Show Retired" means "Show All including Retired" or "Show Only Retired".
       // Let's do: Show All (Active + Retired) but Retired visually distinct.
       // Actually, usually "Show Retired" toggles visibility. 
       // Let's make it simple: default is Active Only. If toggled, show Active + Retired.
    }

    // 2. Filter by Search Query
    if (_searchQuery.isNotEmpty) {
      results = results
          .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredProducts = results;
    });
  }

  void _runFilter(String keyword) {
    _searchQuery = keyword;
    _applyFilters();
  }

  // Helper to format Rp (Rupiah)
  String _formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    // Consumer is the "Listener". Whenever CartProvider calls notifyListeners(),
    // only the widgets inside this builder re-render.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stationery Shop"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'toggle_archived') {
                setState(() {
                  _showArchived = !_showArchived;
                  _applyFilters();
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'toggle_archived',
                  child: Row(
                    children: [
                      Icon(_showArchived ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(_showArchived ? "Hide Retired" : "Show Retired"),
                    ],
                  ),
                ),
              ];
            },
          ),
          // Inside CashierScreen AppBar
          IconButton(
            icon: const Icon(Icons.add_box), // Changed icon to "Add"
            onPressed: () async {
              // Navigate to Add Screen
              final bool? result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddEditProductScreen()),
              );

              // If result is true (saved successfully), refresh the list
              if (result == true) {
                _loadProducts();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ReportScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                labelText: 'Search Product',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // 2. Product Grid (The Shelf)
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredProducts.isEmpty
                    ? const Center(child: Text("No products found"))
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 items per row (Big buttons)
                          childAspectRatio: 0.7, // Adjusted from 0.8 to prevent overflow
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return _buildProductCard(product);
                        },
                      ),
          ),
        ],
      ),
      
      // 3. The "Sticky" Bottom Cart Bar
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, child) => _buildBottomCartBar(context, cart),
      ),
    );
  }

  // Widget: Individual Product Button
  Widget _buildProductCard(Product product) {
    return Stack(
      children: [
        Positioned.fill(
          child: InkWell(
            onLongPress: () => _editProduct(product), // 1. Long press trigger
            onTap: product.isArchived 
              ? () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Cannot sell retired product.")),
                  );
                }
              : () {
              // Access the provider locally to add item
              bool success = Provider.of<CartProvider>(context, listen: false).addToCart(product);
              
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${product.name} added!"),
                    duration: const Duration(milliseconds: 500),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Out of Stock! Cannot add ${product.name}."),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            child: Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias, // Clip image to card corners
              color: product.isArchived 
                  ? Colors.grey[400] // Darker grey for retired
                  : (product.stock > 0 ? Colors.white : Colors.grey[200]),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                       // Image Section
                      Expanded(
                        flex: 3,
                        child: product.imagePath != null
                            ? ColorFiltered(
                                colorFilter: product.isArchived 
                                  ? const ColorFilter.mode(Colors.grey, BlendMode.saturation) // Grayscale
                                  : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                                child: Image.file(
                                  File(product.imagePath!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                ),
                              )
                            : Container(
                                color: Colors.blue[50],
                                child: const Icon(Icons.image, size: 50, color: Colors.blueAccent),
                              ),
                      ),
                      
                      // Details Section
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 14,
                                  decoration: product.isArchived ? TextDecoration.lineThrough : null,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              if (product.isArchived)
                                const Text("RETIRED", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12))
                              else ...[
                                Text(
                                  _formatCurrency(product.sellPrice),
                                  style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                 Text(
                                  "Stock: ${product.stock}",
                                  style: TextStyle(
                                    color: product.stock < 5 ? Colors.red : Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // 2. Visible Edit Icon Button
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _editProduct(product),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, size: 16, color: Colors.blueAccent),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to navigate to edit screen
  Future<void> _editProduct(Product product) async {
    final bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditProductScreen(product: product),
      ),
    );

    // If result is true (saved/updated successfully), refresh the list
    if (result == true) {
      _loadProducts();
    }
  }

  // Widget: Bottom Bar with Totals and Checkout
  Widget _buildBottomCartBar(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Cart Summary (Clickable to open details)
            Expanded(
              child: GestureDetector(
                onTap: () => _showCartDetails(context, cart),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${cart.totalItemsCount} Items",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      _formatCurrency(cart.totalAmount),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            
            // Checkout Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: cart.items.isEmpty 
                ? null 
                : () async {
                  bool success = await cart.checkout();
                  if (success) {
                    _loadProducts(); // Refresh stock counts from DB
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Transaction Saved!")),
                      );
                    }
                  }
                },
              child: const Text("PAY", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // Modal: Slide-up sheet to edit cart
  void _showCartDetails(BuildContext context, CartProvider cart) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        // Re-wrap in Consumer so the modal updates if we delete items
        return Consumer<CartProvider>(
          builder: (context, cart, child) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text("Current Cart", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return ListTile(
                          title: Text(item.product.name),
                          subtitle: Text(_formatCurrency(item.subtotal)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => cart.decreaseQuantity(item),
                              ),
                              Text("${item.quantity}", style: const TextStyle(fontSize: 18)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => cart.addToCart(item.product),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}