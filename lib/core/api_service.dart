import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

const uri = 'http://192.168.1.34:8001';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      headers: {'Content-Type': 'application/json', "Charset": "UTF-8"},
    ),
  );
  Future signUp({required data}) async {
    Response result = await _dio.post('$uri/api/signup',
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
        data: data);
    return result.data;
  }

  Future signIn({required data}) async {
    Response result = await _dio.post('$uri/api/signIn',
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
        data: data);
    return result.data;
  }

  Future isValid({required token}) async {
    log("token : $token");
    var tokenRes = await _dio.post('$uri/tokenIsValid',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token ?? ""
          },
        ));
    var response = jsonDecode(tokenRes.data);
    return response;
  }

  Future getUserData({required token}) async {
    log("called :  $token");
    var tokenRes = await _dio.get('$uri/',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token ?? ""
          },
        ));
    var response = jsonDecode(tokenRes.data);
    return response;
  }
}
