import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../core/enums/api_state.dart';
import '../data/models/user_model.dart';

/// AuthProvider manages all authentication-related state
/// This includes user login, logout, token management, and user data persistence
class AuthProvider extends ChangeNotifier {
  // Private fields
  String? _accessToken;
  UserModel? _userModel;
  ApiState _authState = ApiState.initial;
  String? _errorMessage;

  // Public getters
  String? get accessToken => _accessToken;
  UserModel? get userModel => _userModel;
  ApiState get authState => _authState;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _accessToken != null;

  /// Save user data after successful login/registration
  Future<void> saveUserData(UserModel model, String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save token and user data to SharedPreferences
      await prefs.setString(AppConstants.accessTokenKey, token);
      await prefs.setString(
        AppConstants.userDataKey, 
        jsonEncode(model.toJson()),
      );
      
      // Update state
      _accessToken = token;
      _userModel = model;
      
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to save user data: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Load user data from SharedPreferences on app start
  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final token = prefs.getString(AppConstants.accessTokenKey);
      if (token != null) {
        _accessToken = token;
        
        final userData = prefs.getString(AppConstants.userDataKey);
        if (userData != null) {
          _userModel = UserModel.fromJson(jsonDecode(userData));
        }
      }
      
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load user data: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Update user profile data
  Future<void> updateUserData(UserModel model) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.userDataKey,
        jsonEncode(model.toJson()),
      );
      
      _userModel = model;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update user data: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Check if user is logged in
  Future<bool> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.accessTokenKey);
      return token != null;
    } catch (e) {
      return false;
    }
  }

  /// Clear all user data and logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      _accessToken = null;
      _userModel = null;
      _authState = ApiState.initial;
      
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to logout: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Set loading state
  void setLoading() {
    _authState = ApiState.loading;
    notifyListeners();
  }

  /// Set success state
  void setSuccess() {
    _authState = ApiState.success;
    _errorMessage = null;
    notifyListeners();
  }

  /// Set error state
  void setError(String message) {
    _authState = ApiState.error;
    _errorMessage = message;
    notifyListeners();
  }

  /// Reset auth state
  void resetState() {
    _authState = ApiState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
