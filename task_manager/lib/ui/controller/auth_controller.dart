
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_model.dart';

class AuthController {
  static String _accessTokenKey = 'token';
  static String _userModelKey = 'user-data';
  
  static String ? accessToken;
  static UserModel ? userModel;

 static Future saveUserData(UserModel model,String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    await sharedPreferences.setString(_userModelKey, jsonEncode(model.toJson()));
    accessToken = token;
    userModel = model;
    
  }

  static Future getUserData()async {
   SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
   String ? token = sharedPreferences.getString(_accessTokenKey);
   
   if(token != null){
     String ? userData = sharedPreferences.getString(_userModelKey);
     userModel = UserModel.fromJson(jsonDecode(userData!));
   }
  }


  static Future<bool> isUserLoggeIn() async {
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   String ?  token = sharedPreferences.getString(_accessTokenKey);
   return token != null ;
  }


static Future<void>clearUserData() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   await sharedPreferences.clear();
}



}