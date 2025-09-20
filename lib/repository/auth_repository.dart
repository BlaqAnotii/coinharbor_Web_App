import 'package:coinharbor/config/urlPath.dart';
import 'package:coinharbor/data/https.dart';
import 'package:coinharbor/services/app_cache.dart';
import 'package:coinharbor/services/locator.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  Future register(Map<String, dynamic> data) async {
    var response = await httpPost(
      UrlPath.register,
      data,
    );
    final responseData = (response.data);
    if (responseData['status'] == true) {
      print('REGISTER IS OK');
    } else {
      print('REGISTER FAILED');
    }
    // trying to get the token from the response and storing using sharedPreferences
    return responseData;
  }

  Future emailVerify(Map<String, dynamic> data) async {
    var response = await httpPost(
      UrlPath.emailVerify,
      data,
    );
    final responseData = (response.data);

    if (responseData['status'] == true) {
      print('VERIFY IS OK');
      print(responseData);
    } else {
      print('VERIFY FAILED');
    }
    // trying to get the token from the response and storing using sharedPreferences

    return responseData;
  }

  Future resendVerifyEmail(Map<String, dynamic> data) async {
    var response = await httpPost(
      UrlPath.resendVerifyEmail,
      data,
    );
    final responseData = (response.data);
    if (responseData['status'] == true) {
      print('REVERIFY IS OK');
      print(responseData);
    } else {
      print('REVERIFY FAILED');
    }
    // trying to get the token from the response and storing using sharedPreferences

    return responseData;
  }

  Future forgotpassword(Map<String, dynamic> data) async {
    var response = await httpPost(
      UrlPath.forgotPassword,
      data,
    );
    final responseData = (response.data);
    if (responseData['status'] == true) {
      print('OTP SENT IS OK');
      print(responseData);
    } else {
      print('OTP SENT FAILED');
    }
    // trying to get the token from the response and storing using sharedPreferences

    return responseData;
  }

  Future resetpassword(Map<String, dynamic> data) async {
    var response = await httpPost(
      UrlPath.resetPassword,
      data,
    );
    final responseData = (response.data);
    if (responseData['status'] == true) {
      print('recovery IS OK');
      print(responseData);
    } else {
      print('recovery FAILED');
    }
    // trying to get the token from the response and storing using sharedPreferences

    return responseData;
  }

  Future login(Map<String, dynamic> data) async {
    var response = await httpPost(
      UrlPath.login,
      data,
    );
    final responseData = response.data;
    if (responseData['status'] == true) {
      print('TIMINI::$responseData');

      final userToken = responseData['data']['token'].toString();
      final userID = responseData['data']['id'].toString();
      final fname = responseData['data']['name'].toString();

      final email = responseData['data']['email'].toString();
      userServices.cache.setStringPreference('token', userToken);
      userServices.cache.setStringPreference('id', userID);
      userServices.cache.setStringPreference('name', fname);

      userServices.cache.setStringPreference('email', email);

      String? token =
          userServices.cache.getStringPreference('token');
      String? iD = userServices.cache.getStringPreference('id');

      String? firstname =
          userServices.cache.getStringPreference('name');

      // Re-initialize userServices after saving data
      userServices.initializer();

      print('Token:::: $token');
      print('ID:::: $iD');
      print('FNAME:::: $firstname');
    } else {
      print('LOGIN GONE WRONG:::');
    }

    // trying to get the token from the response and storing using sharedPreferences

    return response;
  }

  AppData cache = getIt<AppData>();
}
