import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../../app.dart';

/// ApiCaller handles all HTTP requests to the backend API
/// This is a professional wrapper around the http package
class ApiCaller {
  static final Logger _logger = Logger();
  static String? accessToken;

  /// GET request
  static Future<ApiResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url);
      Response response = await get(uri, headers: {
        'token': accessToken ?? '',
      });
      _logResponse(url, response);
      final int statusCode = response.statusCode;
      final decodedData = jsonDecode(response.body);
      if (statusCode == 200) {
        return ApiResponse(
            responseCode: statusCode,
            isSuccess: true,
            responseData: decodedData);
      } else if (statusCode == 401) {
        await _moveToLogin();
        return ApiResponse(
            responseCode: -1, isSuccess: false, responseData: null);
      } else {
        return ApiResponse(
            responseCode: statusCode,
            isSuccess: false,
            responseData: decodedData);
      }
    } catch (e) {
      return ApiResponse(
          responseCode: -1,
          isSuccess: false,
          responseData: null,
          errorMessage: e.toString());
    }
  }

  /// POST request
  static Future<ApiResponse> postRequest(
      {required String url, Map<String, dynamic>? body}) async {
    try {
      _logRequest(url, body: body);
      Uri uri = Uri.parse(url);
      Response response = await post(
        uri,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          'token': accessToken ?? '',
        },
        body: body != null ? jsonEncode(body) : null,
      );
      _logResponse(url, response);

      final int statusCode = response.statusCode;
      final decodedData = jsonDecode(response.body);
      if (statusCode == 200 || statusCode == 201) {
        return ApiResponse(
            responseCode: statusCode,
            isSuccess: true,
            responseData: decodedData);
      } else if (statusCode == 401) {
        await _moveToLogin();
        return ApiResponse(
            responseCode: -1, isSuccess: false, responseData: null);
      } else {
        return ApiResponse(
            responseCode: statusCode,
            isSuccess: false,
            responseData: decodedData);
      }
    } catch (e) {
      return ApiResponse(
          responseCode: -1,
          isSuccess: false,
          responseData: null,
          errorMessage: e.toString());
    }
  }

  /// Log request details
  static void _logRequest(String url, {Map<String, dynamic>? body}) {
    _logger.i(
      'URL => $url\n'
      'Request Body => $body\n',
    );
  }

  /// Log response details
  static void _logResponse(String url, Response response) {
    _logger.i(
      'URL => $url\n'
      'Status code => ${response.statusCode}\n'
      'Response Body => ${response.body}\n',
    );
  }

  /// Handle unauthorized access - move to login
  static Future<void> _moveToLogin() async {
    Navigator.pushNamedAndRemoveUntil(
      TaskManagerApp.navigator.currentContext!,
      '/Login',
      (predicate) => false,
    );
  }
}

/// API Response Model
/// Standardized response format for all API calls
class ApiResponse {
  final int responseCode;
  final dynamic responseData;
  final bool isSuccess;
  final String? errorMessage;

  ApiResponse({
    required this.responseCode,
    required this.isSuccess,
    required this.responseData,
    this.errorMessage = 'Something went wrong',
  });
}
