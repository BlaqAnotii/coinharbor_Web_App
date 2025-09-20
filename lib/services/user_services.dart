// ignore_for_file: avoid_print

import 'package:coinharbor/config/urlPath.dart';
import 'package:coinharbor/data/https.dart';
import 'package:coinharbor/data/model/member_model.dart';
import 'package:coinharbor/data/model/store_model.dart';
import 'package:coinharbor/data/model/user_model.dart';
import 'package:flutter/material.dart';

import 'app_cache.dart';
import 'locator.dart';

class UserServices extends ChangeNotifier {
  AppData cache = getIt<AppData>();
  bool isUserLoggedIn = false;
  bool firstLogin = false;
  String authToken = "";
  // UserRepository userRepo = getIt<UserRepository>();
  Future initializer() async {
    //cache.init();
    isUserLoggedIn = false;
    firstLogin = true;
    authToken = "";
    String? userToken = cache.getStringPreference('token');
    // cache.lgas = await userRepo.getLGAs();
    // cache.states = await userRepo.getStates();s
    // int? userId = cache.getIntPreference('id');

    if (userToken != null) {
      authToken = userToken;
      // cache.user = await getUserDetail();
      if (cache.user != null) {
        isUserLoggedIn = true;
      }
    }
    firstLogin = false;
  }

  Future<bool> logout() async {
    isUserLoggedIn = false;
    return await cache.clearPreference();
  }

  // Future<User?> getUserDetail() async {
  //   String? token = cache.getStringPreference('token');
  //   // print('ECHO:::::::$token');

  //   try {
  //     // var response = await dio.get(UrlPath.profile);
  //     print('ECHO:::::::$token');
  //     var response = await httpGet(UrlPath.profile,
  //         hasAuth: true, token: token ?? "");

  //     print("Response status: ${response.statusCode}");
  //     print("Response data: ${response.data}");

  //     if (response.statusCode == 200 && response.data != null) {
  //       // Ensure that the data contains the 'success' key
  //       var successData = response.data['user'];
  //       if (successData != null) {
  //         notifyListeners();
  //         return User.fromJson(successData);
  //       } else {
  //         print("No 'success' key found in the response");
  //       }
  //     } else {
  //       print("Invalid response or status code not 200");
  //     }
  //   } catch (e, t) {
  //     print(e);
  //     print(t);
  //     //throw Exception('An unknown error occurred: ${e.toString()}');
  //   }
  //   return null;
  // }

}
