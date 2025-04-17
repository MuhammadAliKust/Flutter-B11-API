import 'dart:convert';

import 'package:flutter_b11_api/models/login.dart';
import 'package:flutter_b11_api/models/register.dart';
import 'package:flutter_b11_api/models/user.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  ///Register
  Future<RegisterUserModel> registerUser(
      {required String email,
      required String name,
      required String password}) async {
    try {
      http.Response response = await http.post(Uri.parse('uri'),
          headers: {'Content-Type': 'application/json'},
          body: {"name": name, "email": email, "password": password});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterUserModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Login
  Future<LoginUserModel> loginUser(
      {required String email, required String password}) async {
    try {
      http.Response response = await http.post(Uri.parse('uri'),
          headers: {'Content-Type': 'application/json'},
          body: {"email": email, "password": password});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginUserModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Get Profile
  Future<UserModel> getProfile(String token) async {
    try {
      http.Response response = await http.get(
        Uri.parse('uri'),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Update Profile
  Future<bool> updateProfile(String token, String name) async {
    try {
      http.Response response = await http.put(Uri.parse('uri'),
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: {"name": name});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
