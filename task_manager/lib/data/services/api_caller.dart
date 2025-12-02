import 'dart:convert';

import 'package:http/http.dart';
import 'package:logger/logger.dart';

class ApiCaller {
  static final Logger _logger = Logger();

  static Future<ApiResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);
      _logRequest(url);
      Response response = await get(uri);
      _logResponse(url, response);
      final int statusCode = response.statusCode;
      final decodedData = jsonDecode(response.body);
      if (statusCode == 200) {
        return ApiResponse(
            responseCode: statusCode,
            isSuccess: true,
            responseData: decodedData);
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

  static void _logRequest(String Url, {Map<String, dynamic>? body}) {
    _logger.i(
      'URL => $Url\n'
      'Request Body => $body\n',
    );
  }

  static void _logResponse(String Url, Response response) {
    _logger.i(
      'URL => $Url\n'
      'Status code => ${response.statusCode}\n'
      'Response Boy => ${response.body}\n',
    );
  }
}

// API response
//     -> body
//     -> code

class ApiResponse {
  final int responseCode;
  final dynamic responseData;
  final bool isSuccess;
  final String? errorMessage;

  ApiResponse(
      {required this.responseCode,
      required this.isSuccess,
      required this.responseData,
      this.errorMessage = 'Something wrong'});
}
