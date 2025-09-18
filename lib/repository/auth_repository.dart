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

      // Extracting business details
      // final businesses = responseData['data']['businesses'];
      // if (businesses != null &&
      //     businesses is List &&
      //     businesses.isNotEmpty) {
      //   final business =
      //       businesses[0]; // Assuming the first business

      //   final businessID = business['id'].toString();
      //   final businessName = business['name'] ?? '';
      //   final businessAddress = business['address'] ?? '';
      //   final businessCity = business['city'] ?? '';
      //   final businessState = business['state'] ?? '';
      //   final businessEmail = business['email'] ?? '';
      //   final registrationNumber =
      //       business['registration_number'] ?? '';
      //   final businessCategory = business['category'] ?? '';
      //   final businessRole = business['role'] ?? '';

      //   // Save business details
      //   userServices.cache
      //       .setStringPreference('business_id', businessID);
      //   userServices.cache
      //       .setStringPreference('business_name', businessName);
      //   userServices.cache.setStringPreference(
      //       'business_address', businessAddress);
      //   userServices.cache
      //       .setStringPreference('business_city', businessCity);
      //   userServices.cache.setStringPreference(
      //       'business_state', businessState);
      //   userServices.cache.setStringPreference(
      //       'business_email', businessEmail);
      //   userServices.cache.setStringPreference(
      //       'registration_number', registrationNumber);
      //   userServices.cache.setStringPreference(
      //       'business_category', businessCategory);
      //   userServices.cache
      //       .setStringPreference('business_role', businessRole);

      //   // Extract and save store details
      //   if (business['stores'] != null &&
      //       (business['stores'] as List).isNotEmpty) {
      //     final store = business['stores'][0]; // First store

      //     final storeID = store['id'].toString();
      //     final storeName = store['store_name'] ?? '';
      //     final storeAddress = store['address'] ?? '';

      //     userServices.cache
      //         .setStringPreference('store_id', storeID);
      //     userServices.cache
      //         .setStringPreference('store_name', storeName);
      //     userServices.cache.setStringPreference(
      //         'store_address', storeAddress);
      //   }
      // }
      // Re-initialize userServices after saving data
      userServices.initializer();

      // Print saved values for debugging
      // print(
      //     'Business ID:::: ${userServices.cache.getStringPreference('business_id')}');
      // print(
      //     'Business Name:::: ${userServices.cache.getStringPreference('business_name')}');
      // print(
      //     'Store Name:::: ${userServices.cache.getStringPreference('store_name')}');

      print('Token:::: $token');
      print('ID:::: $iD');
      print('FNAME:::: $firstname');
    } else {
      print('LOGIN GONE WRONG:::');
    }

    // trying to get the token from the response and storing using sharedPreferences

    return response;
  }

  Future createBusiness(Map<String, dynamic> data) async {
    var response = await httpPost(
      UrlPath.createBusiness,
      data,
    );
    final responseData = response.data;

    print('TIMINI BUZZ::$responseData');

    // Extracting business details
    final business = responseData['business'];
    final businessID = business['id'].toString();
    final businessName = business['name'].toString();
    final businessAddress = business['address'].toString();
    final businessCity = business['city'].toString();
    final businessState = business['state'].toString();
    final businessEmail = business['email'].toString();
    final registrationNumber =
        business['registration_number'].toString();
    final businessCategory = business['category'].toString();
    final businessLogo = business['logo'] ?? '';

    // Save business details to shared preferences
    userServices.cache
        .setStringPreference('business_id', businessID);
    userServices.cache
        .setStringPreference('business_name', businessName);
    userServices.cache.setStringPreference(
        'business_address', businessAddress);
    userServices.cache
        .setStringPreference('business_city', businessCity);
    userServices.cache
        .setStringPreference('business_state', businessState);
    userServices.cache
        .setStringPreference('business_email', businessEmail);
    userServices.cache.setStringPreference(
        'registration_number', registrationNumber);
    userServices.cache.setStringPreference(
        'business_category', businessCategory);
    userServices.cache
        .setStringPreference('business_logo', businessLogo);

    // Extract and save store details
    if (business['stores'] != null &&
        (business['stores'] as List).isNotEmpty) {
      final store = business['stores']
          [0]; // Assuming saving the first store
      final storeID = store['id'].toString();
      final storeName = store['store_name'].toString();
      final storeAddress = store['address'].toString();

      userServices.cache
          .setStringPreference('store_id', storeID);
      userServices.cache
          .setStringPreference('store_name', storeName);
      userServices.cache
          .setStringPreference('store_address', storeAddress);
    }

    // Re-initialize userServices after saving data
    userServices.initializer();

    // Print saved values for debugging
    print(
        'Business ID:::: ${userServices.cache.getStringPreference('business_id')}');
    print(
        'Business Name:::: ${userServices.cache.getStringPreference('business_name')}');
    print(
        'Store Name:::: ${userServices.cache.getStringPreference('store_name')}');

    return response;
  }

  AppData cache = getIt<AppData>();

  Future createStore(Map<String, dynamic> data) async {
    String? businessID =
        cache.getStringPreference('business_id');

    var response = await httpPost(
      "${UrlPath.getstores}$businessID/stores",
      data,
    );
    final responseData = response.data;

    print('TIMINI BUZZ::$responseData');

    return response;
  }

  Future inviteUser(Map<String, dynamic> data) async {
    String? businessID =
        cache.getStringPreference('business_id');

    var response = await httpPost(
      "${UrlPath.inviteUser}$businessID/invite",
      data,
    );
    final responseData = response.data;

    print('TIMINI BUZZ::$responseData');

    return response;
  }

  Future joinBusiness(Map<String, dynamic> data) async {
    //  String? businessID = cache.getStringPreference('business_id');

    var response = await httpPost(
      UrlPath.joinBusiness,
      data,
    );
    final responseData = response.data;

    print('TIMINI BUZZ::$responseData');

    return response;
  }

  Future addProduct(
    FormData data,
  ) async {
    String? businessID =
        cache.getStringPreference('business_id');
    String? token =
        userServices.cache.getStringPreference('token');

    var response = await httpPost2(
      "${UrlPath.createProduct}$businessID/products",
      data,
      token: token ?? "", // Pass the token explicitly
      hasAuth: true, // Ensure auth headers are set
    );
    print("Response status: ${response.statusCode}");
    print("Response data: ${response.data}");
    final responseData = response.data;

    return responseData;
  }
}
