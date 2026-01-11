import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../services/database_helper.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  bool _isProcessing = false;

  void _showChangePinDialog() {
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();
    final confirmPinController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.changePinTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPinController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.oldPinLabel),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: newPinController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.newPinLabel),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: confirmPinController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.confirmPinLabel),
              obscureText: true,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            child: Text(AppLocalizations.of(context)!.changePinButton),
            onPressed: () async {
              if (newPinController.text != confirmPinController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.pinMismatchError), backgroundColor: Colors.red),
                );
                return;
              }

              final success = await Provider.of<UserProvider>(context, listen: false)
                  .changePin(oldPinController.text, newPinController.text);
              
              if (success) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.pinChangedSuccess), backgroundColor: Colors.green),
                );
              } else {
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.wrongOldPinError), backgroundColor: Colors.red),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // --- EXPORT LOGIC ---
  Future<void> _createBackup() async {
    setState(() => _isProcessing = true);
    try {
      final dbPath = await DatabaseHelper.instance.dbPath;
      final File dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        if (mounted) _showSnack(AppLocalizations.of(context)!.noDatabaseFound, Colors.red);
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
      if (mounted) _showSnack(AppLocalizations.of(context)!.backupFailed(e.toString()), Colors.red);
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
        title: Text(AppLocalizations.of(context)!.overwriteConfirmTitle),
        content: Text(
          AppLocalizations.of(context)!.overwriteConfirmMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppLocalizations.of(context)!.restoreButton, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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
        _showSnack(AppLocalizations.of(context)!.restoreSuccess, Colors.green);
        // Optional: Force navigation back home to reload data
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) _showSnack(AppLocalizations.of(context)!.restoreFailed(e.toString()), Colors.red);
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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.backupRestoreTitle)),
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
                      label: Text(AppLocalizations.of(context)!.backupDataButton),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _createBackup,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.backupDataSubtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  
                  const SizedBox(height: 40),

                  // IMPORT BUTTON
                  SizedBox(
                    width: 250,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.download),
                      label: Text(AppLocalizations.of(context)!.restoreDataButton),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                      onPressed: _restoreBackup,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppLocalizations.of(context)!.restoreDataSubtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                  const SizedBox(height: 40),

                  // CHANGE PIN BUTTON
                  SizedBox(
                    width: 250,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.lock_reset),
                      label: Text(AppLocalizations.of(context)!.changePinTitle),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        foregroundColor: Colors.orange,
                        side: const BorderSide(color: Colors.orange),
                      ),
                      onPressed: _showChangePinDialog,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}