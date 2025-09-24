// ignore_for_file: avoid_print

import 'package:coinharbor/config/urlPath.dart';
import 'package:coinharbor/data/https.dart';
import 'package:coinharbor/data/model/copy_trade_model.dart';
import 'package:coinharbor/data/model/expert_model.dart';
import 'package:coinharbor/data/model/investment_options_model.dart';
import 'package:coinharbor/data/model/transaction_model.dart';
import 'package:coinharbor/data/model/wallet_model.dart';
import 'package:coinharbor/data/model/user_model.dart' hide Wallet;
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
      cache.user = await getUserDetail();
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

  Future<User?> getUserDetail() async {
    String? token = cache.getStringPreference('token');

    try {
      print('ECHO:::::::$token');
      var response = await httpGet(
        UrlPath.getUser,
        hasAuth: true,
        token: token ?? "",
      );

      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      final responseData = response.data;

      if (responseData != null &&
          responseData['status'] == true) {
        var userData =
            responseData['data']; // ✅ correct key is "data"
        if (userData != null) {
          notifyListeners();
          return User.fromJson(userData);
        } else {
          print("No 'data' key found in the response");
        }
      } else {
        print("Invalid response or status=false");
      }
    } catch (e, t) {
      print("Error in getUserDetail: $e");
      print(t);
    }
    return null;
  }


  Future<List<Wallet>> getWallet() async {
    String? token = cache.getStringPreference('token');

    try {
      // var response = await dio.get(UrlPath.profile);
      var response = await httpGet(UrlPath.getWallet,
          hasAuth: true, token: token ?? "");
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      final responseData = response.data;
     if (responseData['status']==true) {
        final data = responseData;

        // Ensure "events" exists and is a List
        if (data != null && data["data"] is List) {
          final List userJson = data["data"] ?? [];

          return userJson
              .where(
                  (e) => e != null && e is Map<String, dynamic>)
              .map<Wallet>((e) =>
                  Wallet.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }

      // Return empty list if response is bad or no events found
      return [];
   
    } catch (e, t) {
      print(e);
      print(t);
      //throw Exception('An unknown error occurred: ${e.toString()}');
    }
    return [];
  }



  Future<List<Transaction>> getTransaction() async {
    String? token = cache.getStringPreference('token');

    try {
      // var response = await dio.get(UrlPath.profile);
      var response = await httpGet(UrlPath.transactions,
          hasAuth: true, token: token ?? "");
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      final responseData = response.data;
     if (responseData['status']==true) {
        final data = responseData;

        // Ensure "events" exists and is a List
        if (data != null && data["data"] is List) {
          final List userJson = data["data"] ?? [];

          return userJson
              .where(
                  (e) => e != null && e is Map<String, dynamic>)
              .map<Transaction>((e) =>
                  Transaction.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }

      // Return empty list if response is bad or no events found
      return [];
   
    } catch (e, t) {
      print(e);
      print(t);
      //throw Exception('An unknown error occurred: ${e.toString()}');
    }
    return [];
  }



  Future<List<Expert>> getExperts() async {
    String? token = cache.getStringPreference('token');

    try {
      // var response = await dio.get(UrlPath.profile);
      var response = await httpGet(UrlPath.getExperts,
          hasAuth: true, token: token ?? "");
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      final responseData = response.data;
     if (responseData['status']==true) {
        final data = responseData;

        // Ensure "events" exists and is a List
        if (data != null && data["data"] is List) {
          final List userJson = data["data"] ?? [];

          return userJson
              .where(
                  (e) => e != null && e is Map<String, dynamic>)
              .map<Expert>((e) =>
                  Expert.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }

      // Return empty list if response is bad or no events found
      return [];
   
    } catch (e, t) {
      print(e);
      print(t);
      //throw Exception('An unknown error occurred: ${e.toString()}');
    }
    return [];
  }
  
 Future<List<CopyTrade>> getCopy() async {
    String? token = cache.getStringPreference('token');

    try {
      // var response = await dio.get(UrlPath.profile);
      var response = await httpGet(UrlPath.getcopytrade,
          hasAuth: true, token: token ?? "");
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      final responseData = response.data;
     if (responseData['status']==true) {
        final data = responseData;

        // Ensure "events" exists and is a List
        if (data != null && data["data"] is List) {
          final List userJson = data["data"] ?? [];

          return userJson
              .where(
                  (e) => e != null && e is Map<String, dynamic>)
              .map<CopyTrade>((e) =>
                  CopyTrade.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }

      // Return empty list if response is bad or no events found
      return [];
   
    } catch (e, t) {
      print(e);
      print(t);
      //throw Exception('An unknown error occurred: ${e.toString()}');
    }
    return [];
  }


  
 Future<List<InvestmentOption>> getInvOptions() async {
    String? token = cache.getStringPreference('token');

    try {
      // var response = await dio.get(UrlPath.profile);
      var response = await httpGet(UrlPath.getinvestmentOptions,
          hasAuth: true, token: token ?? "");
      print("Response status: ${response.statusCode}");
      print("Response data: ${response.data}");

      final responseData = response.data;
     if (responseData['status']==true) {
        final data = responseData;

        // Ensure "events" exists and is a List
        if (data != null && data["data"] is List) {
          final List userJson = data["data"] ?? [];

          return userJson
              .where(
                  (e) => e != null && e is Map<String, dynamic>)
              .map<InvestmentOption>((e) =>
                  InvestmentOption.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }

      // Return empty list if response is bad or no events found
      return [];
   
    } catch (e, t) {
      print(e);
      print(t);
      //throw Exception('An unknown error occurred: ${e.toString()}');
    }
    return [];
  }
  
}
