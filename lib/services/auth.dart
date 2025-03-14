import 'dart:convert';

import 'package:flutter_b11_api/models/login.dart';
import 'package:flutter_b11_api/models/register.dart';
import 'package:flutter_b11_api/models/user.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  ///Register
  Future<RegisterUserModel> registerUser(
      {required String name,
      required String email,
      required String password}) async {
    try {
      http.Response response = await http.post(
          Uri.parse('{{TODO_URL}}/users/register'),
          headers: {'Content-Type': 'application/json'},
          body:
              jsonEncode({"name": name, "email": email, "password": password}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterUserModel.fromJson(jsonDecode(response.body));
      } else {
        return RegisterUserModel();
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Login
  Future<LoginUserModel> loginUser(
      {required String email, required String password}) async {
    try {
      http.Response response = await http.post(
          Uri.parse('{{TODO_URL}}/users/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"email": email, "password": password}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginUserModel.fromJson(jsonDecode(response.body));
      } else {
        return LoginUserModel();
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Get Profile

  Future<UserModel> getProfile(String token) async {
    try {
      http.Response response = await http.get(
          Uri.parse('{{TODO_URL}}/users/login'),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        return UserModel();
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Update Profile
  Future<bool> updateProfile(
      {required String token, required String name}) async {
    try {
      http.Response response = await http.put(
          Uri.parse('{{TODO_URL}}/users/profile'),
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: jsonEncode({"name": name}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
