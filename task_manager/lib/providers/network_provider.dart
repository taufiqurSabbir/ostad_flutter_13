import 'package:flutter/material.dart';
import 'package:task_manager/core/enums/api_state.dart';
import 'package:task_manager/data/models/user_model.dart';

import '../data/services/api_caller.dart';
import '../data/utils/urls.dart';

class NetworkProvider extends ChangeNotifier{
  ApiState _loginState = ApiState.initial;
  ApiState _registrationState = ApiState.initial;
  ApiState _profileUpdateState = ApiState.initial;

  String? _errorMessage;
  
  ApiState get loginState => _loginState;
  ApiState get registrationState => _registrationState;
  ApiState get profileUpdateState => _profileUpdateState;
  String ? get errorMessage => _errorMessage;
  
  
  Future <Map<String,dynamic>?> login({
    required String email,
    required String password,
}) async {

    Map<String,dynamic>requestBody = {
      "email":email,
      "password":password,
    };

    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
    );
    
    if(response.isSuccess){
      _loginState = ApiState.success;
      notifyListeners();
      return {
        'user': UserModel.fromJson(response.responseData['data']),
        'token' : response.responseData['token']
      };
    }else{
      _loginState = ApiState.error;
      _errorMessage = response.errorMessage ?? 'Login failed';
      notifyListeners();
      return null;
    }
    
  }


  Future <Map<String,dynamic>?> register({
    required String email,
    required String firstName,
    required String lastName,
    required String mobile,
    required String password,
  }) async {
    _registrationState= ApiState.loading;
    _errorMessage = null;
    notifyListeners();


    Map<String,dynamic>requestBody = {
      "email":email,
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
      "password":password,
    };

    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.registrationUrl,
      body: requestBody,
    );


    if(response.isSuccess){
      _registrationState = ApiState.success;
      notifyListeners();
      return response.responseData;
    }else{
      _registrationState = ApiState.error;
      _errorMessage = response.errorMessage ?? 'Registration failed';
      notifyListeners();
      return null;
    }

  }

}