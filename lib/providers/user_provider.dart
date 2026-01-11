import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  // false = Employee (Default), true = Owner
  bool _isOwner = false;
  String _pin = "1234"; // Default PIN
  
  UserProvider() {
    _loadPin();
  }
  
  // Default to English, but allows switching
  Locale _locale = const Locale('en');

  bool get isOwner => _isOwner;
  Locale get locale => _locale;

  // Simple PIN protection (Hardcoded for MVP, can be saved to DB later)
  bool login(String pin) {
    if (pin == _pin) { 
      _isOwner = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> _loadPin() async {
    final prefs = await SharedPreferences.getInstance();
    _pin = prefs.getString('owner_pin') ?? "1234";
    notifyListeners();
  }

  Future<bool> changePin(String oldPin, String newPin) async {
    if (oldPin != _pin) return false;
    
    _pin = newPin;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('owner_pin', _pin);
    notifyListeners();
    return true;
  }

  void logout() {
    _isOwner = false;
    notifyListeners();
  }
  
  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }
}
