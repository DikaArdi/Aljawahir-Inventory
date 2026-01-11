import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../services/database_helper.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  bool _isProcessing = false;

  // --- EXPORT LOGIC ---
  Future<void> _createBackup() async {
    setState(() => _isProcessing = true);
    try {
      final dbPath = await DatabaseHelper.instance.dbPath;
      final File dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        if (mounted) _showSnack("No database found to backup!", Colors.red);
        return;
      }

      // Generate a nice filename: "backup_2026-01-10.db"
      final String dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      // Share the file directly. Android's Share Sheet handles the rest.
      // She can tap "Save to Drive" or "WhatsApp".
      await Share.shareXFiles(
        [XFile(dbPath, name: 'inventory_backup_$dateStr.db')],
        text: 'Aljawahir Inventory Backup ($dateStr)',
      );

    } catch (e) {
      if (mounted) _showSnack("Backup failed: $e", Colors.red);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  // --- IMPORT LOGIC ---
  Future<void> _restoreBackup() async {
    // 1. Pick the file
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return; // User canceled

    final File selectedFile = File(result.files.single.path!);

    // 2. Confirm Alert (Crucial!)
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("⚠️ Overwrite Data?"),
        content: const Text(
          "This will DELETE your current inventory and replace it with the backup file.\n\nAre you sure?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("RESTORE", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isProcessing = true);
    try {
      // 3. Close current DB connection
      await DatabaseHelper.instance.close();

      // 4. Overwrite the file
      final dbPath = await DatabaseHelper.instance.dbPath;
      await selectedFile.copy(dbPath);

      // 5. Success!
      if (mounted) {
        _showSnack("Restore Successful! Please restart the app.", Colors.green);
        // Optional: Force navigation back home to reload data
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) _showSnack("Restore failed: $e", Colors.red);
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Backup & Restore")),
      body: Center(
        child: _isProcessing
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_sync, size: 100, color: Colors.blueAccent),
                  const SizedBox(height: 40),
                  
                  // EXPORT BUTTON
                  SizedBox(
                    width: 250,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.upload),
                      label: const Text("Backup Data"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _createBackup,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Save your data to Google Drive or WhatsApp",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  
                  const SizedBox(height: 40),

                  // IMPORT BUTTON
                  SizedBox(
                    width: 250,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.download),
                      label: const Text("Restore Data"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                      onPressed: _restoreBackup,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Overwrite current data with a backup file",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }
}