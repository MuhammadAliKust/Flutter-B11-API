import 'package:flutter/material.dart';
import 'package:flutter_b11_api/models/user.dart';
import 'package:flutter_b11_api/provider/user_provider.dart';
import 'package:flutter_b11_api/services/auth.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: FutureProvider.value(
        value: AuthServices()
            .getProfile(userProvider.getToken()!.token.toString()),
        initialData: UserModel(),
        builder: (context, child) {
          UserModel userModel = context.watch<UserModel>();
          return userModel.user == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Text(userModel.user!.name.toString()),
                    Text(userModel.user!.email.toString()),
                  ],
                );
        },
      ),
    );
  }
}
