import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/product.dart';
import '../services/database_helper.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'scanner_screen.dart';
import '../l10n/app_localizations.dart';

class AddEditProductScreen extends StatefulWidget {
  // If this is null, we are adding a new product.
  // If this allows a value, we are editing that product.
  final Product? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers act like "Variables bound to Input Fields"
  late TextEditingController _nameController;
  late TextEditingController _costController;
  late TextEditingController _sellController;
  late TextEditingController _stockController;
  late TextEditingController _barcodeController;

  File? _selectedImage;
  bool _isArchived = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill data if editing, or empty string if new
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _costController = TextEditingController(text: widget.product?.costPrice.toString() ?? '');
    _sellController = TextEditingController(text: widget.product?.sellPrice.toString() ?? '');
    _stockController = TextEditingController(text: widget.product?.stock.toString() ?? '');
    _barcodeController = TextEditingController(text: widget.product?.barcode ?? '');
    
    if (widget.product?.imagePath != null) {
      _selectedImage = File(widget.product!.imagePath!);
    }
    
    _isArchived = widget.product?.isArchived ?? false;
  }

  @override
  void dispose() {
    // Clean up memory (like closing a file in Python)
    _nameController.dispose();
    _costController.dispose();
    _sellController.dispose();
    _stockController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Save image to local directory so it persists
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = path.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        _selectedImage = savedImage;
      });
    }
  }

  Future<void> _deleteProduct() async {
    if (widget.product == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteProductTitle),
        content: Text(AppLocalizations.of(context)!.deleteProductConfirm(widget.product!.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
       await DatabaseHelper.instance.deleteProduct(widget.product!.id!);
       if (mounted) {
         Navigator.pop(context, true); // Return true to refresh list
       }
    }
  }

  Future<void> _saveProduct() async {
    // 1. Validate Form (Check for empty fields)
    if (!_formKey.currentState!.validate()) return;

    // 2. Collect Data
    final name = _nameController.text;
    final cost = double.parse(_costController.text);
    final sell = double.parse(_sellController.text);
    final stock = int.parse(_stockController.text);
    final barcode = _barcodeController.text;

    // 3. Create Map (Dictionary) for SQLite
    // Note: We don't include ID here if creating, SQLite adds it auto-incrementally
    final Map<String, dynamic> productMap = {
      'name': name,
      'cost_price': cost,
      'sell_price': sell,
      'stock': stock,
      'barcode': barcode,
      'image_path': _selectedImage?.path,
      'is_archived': _isArchived ? 1 : 0,
    };

    if (widget.product == null) {
      // Create New
      await DatabaseHelper.instance.createProduct(productMap);
    } else {
      // Update Existing (Need ID to know which row to update)
      productMap['id'] = widget.product!.id;
      await DatabaseHelper.instance.updateProduct(productMap);
    }

    // 4. Close screen and return "true" to indicate refresh needed
    if (mounted) {
      Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get Role
    final isOwner = Provider.of<UserProvider>(context).isOwner;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? AppLocalizations.of(context)!.addNewItem : AppLocalizations.of(context)!.editItem),
        actions: [
          // 2. Hide Delete Button for Employees
          if (widget.product != null && isOwner)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteProduct,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // --- Image Picker ---
              // Wrap GestureDetector in AbsorbPointer if !isOwner
              AbsorbPointer(
                absorbing: !isOwner,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_selectedImage!, fit: BoxFit.cover),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                              const SizedBox(height: 5),
                              Text(AppLocalizations.of(context)!.tapToAddImage, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // --- Name (Read Only for Employee) ---
              TextFormField(
                controller: _nameController,
                readOnly: !isOwner, // <--- LOCK
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.productNameLabel, 
                  border: const OutlineInputBorder(),
                  fillColor: !isOwner ? Colors.grey[200] : null, // Visual cue
                  filled: !isOwner,
                ),
                validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.productNameError : null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // --- Barcode (Row with Icon) ---
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _barcodeController,
                      // Barcode editing might also be restricted? User didn't specify, but I'll assume they want to lock "Product Details".
                      // I will lock it for consistency with Name.
                      readOnly: !isOwner,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.barcodeLabel, 
                        border: const OutlineInputBorder(),
                        fillColor: !isOwner ? Colors.grey[200] : null,
                        filled: !isOwner,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Hide scanner button if not owner? Or allow scanning to verify?
                  // I'll keep it enabled or maybe disable. Usually employees scan at POS. Here it's editing.
                  // Restricting it seems safer if the field is read-only.
                  if (isOwner)
                  IconButton(
                    style: IconButton.styleFrom(backgroundColor: Colors.blue[50], iconSize: 30),
                    icon: const Icon(Icons.qr_code_scanner, color: Colors.blue),
                    onPressed: () async {
                      // 1. Navigate to the Scanner Screen
                      final String? scannedCode = await Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const ScannerScreen()),
                      );
    
                      // 2. If a code was returned, update the text field
                      if (scannedCode != null) {
                        setState(() {
                          _barcodeController.text = scannedCode;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(AppLocalizations.of(context)!.scannedCodeMessage(scannedCode))),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Prices (Read Only for Employee) ---
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _costController,
                      readOnly: !isOwner, // <--- LOCK
                      obscureText: !isOwner, // Hide Cost Price from Employee? (Optional - User suggested)
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.costPriceLabel, 
                        prefixText: 'Rp ',
                        fillColor: !isOwner ? Colors.grey[200] : null,
                        filled: !isOwner,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.requiredError : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _sellController,
                      readOnly: !isOwner, // <--- LOCK
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.sellPriceLabel, 
                        prefixText: 'Rp ',
                        fillColor: !isOwner ? Colors.grey[200] : null,
                        filled: !isOwner,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.requiredError : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Stock (EDITABLE for Everyone) ---
              // This stays enabled!
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.currentStockLabel, border: const OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? AppLocalizations.of(context)!.requiredError : null,
              ),
              const SizedBox(height: 16),

              // --- Archived / Retired Switch (Owner Only) ---
              if (isOwner)
                SwitchListTile(
                  title: Text(AppLocalizations.of(context)!.retiredProductTitle),
                  subtitle: Text(AppLocalizations.of(context)!.retiredProductSubtitle),
                  value: _isArchived, // State variable
                  onChanged: (val) {
                    setState(() {
                      _isArchived = val;
                    });
                  },
                ),
              const SizedBox(height: 30),

              // --- Save Button ---
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: _saveProduct,
                child: Text(AppLocalizations.of(context)!.saveProductButton, style: const TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}