import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'cashier_screen.dart';
import 'report_screen.dart';
import 'backup_screen.dart';
import 'add_edit_product_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isOwner = userProvider.isOwner;

    return Scaffold(
      appBar: AppBar(
        title: Text(isOwner ? 'Owner Mode 🔓' : 'Employee Mode 🔒'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isOwner ? Icons.lock_open : Icons.lock),
            onPressed: () => _showLoginDialog(context, userProvider),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             const Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    title: "Cashier (POS)",
                    icon: Icons.point_of_sale,
                    color: Colors.blue,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CashierScreen())),
                  ),
                  _buildMenuCard(
                    context,
                    title: "Reports",
                    icon: Icons.bar_chart,
                    color: Colors.purple,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportScreen())),
                  ),
                  
                  // --- CONDITIONAL ADD PRODUCT BUTTON ---
                  // Only Owner can ADD new products.
                  if (isOwner) 
                    _buildMenuCard(
                      context,
                      title: "Add Product",
                      icon: Icons.add_box,
                      color: Colors.orange,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditProductScreen())),
                    ),
                  
                  // --- CONDITIONAL SETTINGS BUTTON ---
                  // Only Owner can Backup/Restore
                  if (isOwner)
                     _buildMenuCard(
                      context,
                      title: "Settings",
                      icon: Icons.settings,
                      color: Colors.grey,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BackupScreen())),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIN DIALOG LOGIC ---
  void _showLoginDialog(BuildContext context, UserProvider user) {
    if (user.isOwner) {
      // If already Owner, just logout (Lock)
      user.logout();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Switched to Employee Mode")));
      return;
    }

    // If Employee, show PIN Input
    final TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Owner Login"),
        content: TextField(
          controller: pinController,
          keyboardType: TextInputType.number,
          obscureText: true, // Hide PIN
          decoration: const InputDecoration(labelText: "Enter PIN"),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: const Text("Unlock"),
            onPressed: () {
              bool success = user.login(pinController.text);
              Navigator.pop(ctx);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Welcome Back, Owner!")));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong PIN!"), backgroundColor: Colors.red));
              }
            },
          )
        ],
      ),
    );
  }
  
  Widget _buildMenuCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.7),
                  color,
                ],
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
