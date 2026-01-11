import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_helper.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;

  // Totals
  double _totalSales = 0.0;
  double _totalProfit = 0.0;

  @override
  void initState() {
    super.initState();
    _loadDailyReport();
  }

  Future<void> _loadDailyReport() async {
    setState(() => _isLoading = true);

    // Convert DateTime to "YYYY-MM-DD" string for SQLite
    String dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

    final data = await DatabaseHelper.instance.getTransactionsByDate(dateStr);

    // Calculate totals in Dart (easier than complex SQL for now)
    double sales = 0;
    double profit = 0;
    
    for (var row in data) {
      sales += row['total_amount'];
      profit += row['profit'];
    }

    setState(() {
      _transactions = data;
      _totalSales = sales;
      _totalProfit = profit;
      _isLoading = false;
    });
  }

  // Date Picker Logic
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadDailyReport();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get Role
    final isOwner = Provider.of<UserProvider>(context).isOwner;

    return Scaffold(
      appBar: AppBar(title: const Text("Daily Report")),
      body: Column(
        children: [
          // --- 1. Date Selector ---
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                    });
                    _loadDailyReport();
                  },
                ),
                GestureDetector(
                  onTap: _pickDate,
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('EEE, dd MMM yyyy').format(_selectedDate),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.add(const Duration(days: 1));
                    });
                    _loadDailyReport();
                  },
                ),
              ],
            ),
          ),

          // --- 2. Summary Cards ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildSummaryCard("Total Sales", _totalSales, Colors.blue),
                const SizedBox(width: 16),
                _buildSummaryCard("Profit", _totalProfit, Colors.green),
              ],
            ),
          ),

          const Divider(),

          // --- 3. Transaction List ---
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _transactions.isEmpty
                    ? const Center(child: Text("No sales on this date."))
                    : ListView.builder(
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          final txn = _transactions[index];
                          // Convert timestamp string back to time
                          final time = DateFormat('HH:mm').format(DateTime.parse(txn['created_at']));
                          
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue[100],
                              child: const Icon(Icons.receipt, color: Colors.blue),
                            ),
                            title: Text("Sale at $time"),
                            subtitle: Text(
                              "Profit: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(txn['profit'])}",
                              style: TextStyle(color: Colors.green[700]),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(txn['total_amount']),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                // 2. Wrap Delete Icon in Conditional
                                if (isOwner)
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _confirmDelete(txn['id']),
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
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Transaction?"),
        content: const Text("This will remove the sale record. If this transaction was made recently, stock will be restored."),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              Navigator.of(ctx).pop(); // Close dialog
              await DatabaseHelper.instance.deleteTransaction(id);
              _loadDailyReport(); // Refresh list
              
              if (mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Transaction deleted.")),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              NumberFormat.compactCurrency(locale: 'id_ID', symbol: 'Rp ').format(amount),
              style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}