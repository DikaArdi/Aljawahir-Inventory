class Product {
  final int? id;
  final String name;
  final double costPrice;
  final double sellPrice;
  final int stock;
  final String? barcode;
  final String? imagePath;
  final bool isArchived; // New field for Soft Delete

  Product({
    this.id,
    required this.name,
    required this.costPrice,
    required this.sellPrice,
    required this.stock,
    this.barcode,
    this.imagePath,
    this.isArchived = false, // Default active
  });

  // Convert a Product into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cost_price': costPrice,
      'sell_price': sellPrice,
      'stock': stock,
      'barcode': barcode,
      'image_path': imagePath,
      'is_archived': isArchived ? 1 : 0, // Store as Int (0/1)
    };
  }

  // Convert a Map into a Product.
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      costPrice: map['cost_price'],
      sellPrice: map['sell_price'],
      stock: map['stock'],
      barcode: map['barcode'],
      imagePath: map['image_path'],
      isArchived: map['is_archived'] == 1, // Read from Int
    );
  }
}