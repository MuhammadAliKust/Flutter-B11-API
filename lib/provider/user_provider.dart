import 'package:flutter/cupertino.dart';
import 'package:flutter_b11_api/models/user.dart';

import '../models/login.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _userModel;
  LoginUserModel? _loginUserModel;

  void setUser(UserModel model) {
    _userModel = model;
    notifyListeners();
  }

  void setToken(LoginUserModel model) {
    _loginUserModel = model;
    notifyListeners();
  }

  UserModel? getUser() => _userModel;

  LoginUserModel? getToken() => _loginUserModel;
}
