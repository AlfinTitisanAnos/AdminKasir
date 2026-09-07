import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true; notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'admin@gmail.com' && password == 'admin123') {
      _user = UserModel(id: '1', name: 'Admin TEFA', email: email, role: 'admin', password: password);
      _isLoading = false; notifyListeners(); return true;
    } else if (email == 'kasir@gmail.com' && password == 'kasir123') {
      _user = UserModel(id: '2', name: 'Kasir 1', email: email, role: 'kasir', password: password);
      _isLoading = false; notifyListeners(); return true;
    }
    _isLoading = false; notifyListeners(); return false;
  }

  void updateProfile(String newName) {
    if (_user != null) { _user!.name = newName; notifyListeners(); }
  }

  void updatePassword(String newPass) {
    if (_user != null) { _user!.password = newPass; notifyListeners(); }
  }

  void logout() { _user = null; notifyListeners(); }
}