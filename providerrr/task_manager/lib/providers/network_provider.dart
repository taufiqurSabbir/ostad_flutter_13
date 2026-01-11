import 'package:flutter/foundation.dart';
import '../core/enums/api_state.dart';
import '../data/models/user_model.dart';
import '../data/services/api_caller.dart';
import '../data/utils/urls.dart';

/// NetworkProvider handles all network/API operations
/// This includes login, registration, and profile updates
class NetworkProvider extends ChangeNotifier {
  ApiState _loginState = ApiState.initial;
  ApiState _registrationState = ApiState.initial;
  ApiState _profileUpdateState = ApiState.initial;
  
  String? _errorMessage;

  // Public getters
  ApiState get loginState => _loginState;
  ApiState get registrationState => _registrationState;
  ApiState get profileUpdateState => _profileUpdateState;
  String? get errorMessage => _errorMessage;

  /// Login user
  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    _loginState = ApiState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await ApiCaller.postRequest(
        url: Urls.loginUrl,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.isSuccess) {
        _loginState = ApiState.success;
        notifyListeners();
        
        // Return user data and token
        return {
          'user': UserModel.fromJson(response.responseData['data']),
          'token': response.responseData['token'],
        };
      } else {
        _loginState = ApiState.error;
        _errorMessage = response.errorMessage ?? 'Login failed';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _loginState = ApiState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Register new user
  Future<Map<String, dynamic>?> register({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    required String password,
  }) async {
    _registrationState = ApiState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final ApiResponse response = await ApiCaller.postRequest(
        url: Urls.registrationUrl,
        body: {
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'mobile': mobile,
          'password': password,
        },
      );

      if (response.isSuccess) {
        _registrationState = ApiState.success;
        notifyListeners();
        return response.responseData;
      } else {
        _registrationState = ApiState.error;
        _errorMessage = response.errorMessage ?? 'Registration failed';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _registrationState = ApiState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Update user profile
  Future<UserModel?> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    String? password,
    String? photo,
  }) async {
    _profileUpdateState = ApiState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      Map<String, dynamic> body = {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'mobile': mobile,
      };

      if (password != null && password.isNotEmpty) {
        body['password'] = password;
      }
      
      if (photo != null && photo.isNotEmpty) {
        body['photo'] = photo;
      }

      final ApiResponse response = await ApiCaller.postRequest(
        url: Urls.updateProfileUrl,
        body: body,
      );

      if (response.isSuccess) {
        _profileUpdateState = ApiState.success;
        notifyListeners();
        return UserModel.fromJson(response.responseData['data']);
      } else {
        _profileUpdateState = ApiState.error;
        _errorMessage = response.errorMessage ?? 'Profile update failed';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _profileUpdateState = ApiState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Reset login state
  void resetLoginState() {
    _loginState = ApiState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset registration state
  void resetRegistrationState() {
    _registrationState = ApiState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset profile update state
  void resetProfileUpdateState() {
    _profileUpdateState = ApiState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
