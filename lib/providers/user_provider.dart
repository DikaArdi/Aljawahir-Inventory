import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  // false = Employee (Default), true = Owner
  bool _isOwner = false;

  bool get isOwner => _isOwner;

  // Simple PIN protection (Hardcoded for MVP, can be saved to DB later)
  // For now, let's say the PIN is "1234"
  bool login(String pin) {
    if (pin == "1234") { 
      _isOwner = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isOwner = false;
    notifyListeners();
  }
}