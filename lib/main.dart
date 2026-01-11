
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()), // Add this
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aljawahir Inventory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Dark mode is better for battery life on shop floor
        brightness: Brightness.light, 
      ),
      home: const HomeScreen(),
    );
  }
}