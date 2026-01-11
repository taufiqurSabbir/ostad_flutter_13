/// Application-wide constants
/// This file contains all the constant values used throughout the app
class AppConstants {
  // SharedPreferences Keys
  static const String accessTokenKey = 'access_token';
  static const String userDataKey = 'user_data';
  
  // Route Names
  static const String splashRoute = '/splash';
  static const String loginRoute = '/login';
  static const String signUpRoute = '/signUp';
  static const String mainNavRoute = '/mainNav';
  static const String updateProfileRoute = '/updateProfile';
  static const String addTaskRoute = '/addTask';
  
  // Error Messages
  static const String networkErrorMessage = 'Network error occurred. Please try again.';
  static const String unauthorizedErrorMessage = 'Unauthorized. Please login again.';
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  
  // Success Messages
  static const String loginSuccessMessage = 'Login successful!';
  static const String registrationSuccessMessage = 'Registration successful!';
  static const String taskCreatedMessage = 'Task created successfully!';
  static const String taskUpdatedMessage = 'Task updated successfully!';
  static const String taskDeletedMessage = 'Task deleted successfully!';
  static const String profileUpdatedMessage = 'Profile updated successfully!';
}
