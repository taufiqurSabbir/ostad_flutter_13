import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/core/enums/api_state.dart';

import '../data/models/user_model.dart';

class AuthProvider extends ChangeNotifier{
  String? _accessToken;
  String? _errorMessage;
  UserModel? _userModel;
  static String _accessTokenKey = 'token';
  static String _userModelKey = 'user-data';


  ApiState _authState = ApiState.initial;

  String ? get accessToken => _accessToken;
  UserModel ? get userModel => _userModel;
  ApiState ? get authState => _authState;
  String ? get errorMessage => _errorMessage;
  bool get isLoggedIn => _accessToken != null ;

   Future saveUserData(UserModel model,String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
    _accessToken = token;
    _userModel = model;

    notifyListeners();

  }

   Future loadUserData()async {
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    String ? token = sharedPreferences.getString(_accessTokenKey);

    if(token != null){
      _accessToken = token;
      String ? userData = sharedPreferences.getString(_userModelKey);
      _userModel = UserModel.fromJson(jsonDecode(userData!));
    }

    notifyListeners();
  }

   Future<void> updateUserData(UserModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
    notifyListeners();
  }


  static Future<bool> checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String ?  token = sharedPreferences.getString(_accessTokenKey);
    return token != null ;
  }


   Future<void>logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    _accessToken = null;
    _userModel = null;
    _authState = ApiState.initial;
    notifyListeners();
  }

  void setLoading(){
    _authState = ApiState.loading;
    notifyListeners();
  }

  void setSuccess(){
    _authState = ApiState.success;
    notifyListeners();
  }

  void setError(){
    _authState = ApiState.error;
    notifyListeners();
  }

  void resetState(){
    _authState = ApiState.initial;
    _errorMessage = null;
    notifyListeners();
  }
}