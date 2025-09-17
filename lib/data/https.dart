//Due to time, this is faster for me to implement.
//I will refactor this to use the existing method in the future.

import 'dart:convert';
import 'dart:math';

import 'package:coinharbor/config/config.dart';
import 'package:coinharbor/services/locator.dart';
import 'package:coinharbor/services/user_services.dart';
import 'package:dio/dio.dart';


import 'network/error_handler.dart';

UserServices userServices = getIt<UserServices>();

Dio dio = Dio(BaseOptions(
    baseUrl: Config.BASEAPI, followRedirects: true, headers: getHeaders()));

getHeaders() {
  var headrs = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };
  if (userServices.isUserLoggedIn) {
    headrs["Authorization"] =
        "Bearer ${userServices.cache.getStringPreference("token")}";
  }

  return headrs;
}

Future<dynamic> httpGet(String path,
    {bool hasAuth = false,
    Map<String, dynamic>? queryParam,
    String token = ""}) async {
  if (hasAuth) {
    dio.options.headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    };
  } else {
    dio.options.headers = getHeaders();
  }
  print(dio.options.baseUrl + path);
  print('HOW FARRR:::::${dio.options.headers}');
  try {
    var response = await dio.get(path, queryParameters: queryParam);
    print(response);
    return response;
  } on DioException catch (err) {
    print("error happening @ ${dio.options.baseUrl}$path");
    handleError(err);
    rethrow;
  } on Exception catch (err) {
    print(err);
    rethrow;
  } catch (err) {
    print(err);
    rethrow;
  }
}

Future<dynamic> httpPost(String path, dynamic fData,
    {String token = "", bool hasAuth = false, List<MapEntry<String, MultipartFile>>? mapEntry}) async {
  if (hasAuth) {
    dio.options.headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    };
  } else {
    dio.options.headers = getHeaders();
  }

  print("${Config.BASEURL}$path");

  try {
    // Convert fData to JSON instead of using FormData
    var response = await dio.post(path, data: jsonEncode(fData));
    return response;
  } on DioException catch (err) {
    print("error happening @ ${dio.options.baseUrl}$path");
    handleError(err);
    print(err);
    rethrow;
  } on Exception catch (err) {
    print(err);
    rethrow;
  } catch (err) {
    print(err);
    rethrow;
  }
}
Future<dynamic> httpPost2(String path, dynamic fData,
    {String token = "", bool hasAuth = false}) async {
  dio.options.headers = {
    "Content-Type": "multipart/form-data", // ✅ Ensure correct content type
    if (hasAuth) "Authorization": "Bearer $token",
  };

  print("API URL: ${Config.BASEURL}$path");

  try {
    var response = await dio.post(path, data: fData); // ✅ Send FormData directly
    print("Response: ${response.data}");
    return response;
  } on DioException catch (err) {
    print("Dio Error: $err");
    handleError(err);
    rethrow;
  } catch (err) {
    print("General Error: $err");
    rethrow;
  }
}
// Future<dynamic> httpPost(String path, dynamic fData,
//     {List<MapEntry<String, MultipartFile>>? mapEntry,
//     String token = "",
//     bool hasAuth = false}) async {
//   if (hasAuth) {
//     dio.options.headers = {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//       "Authorization": "Bearer $token"
//     };
//   } else {
//     dio.options.headers = getHeaders();
//   }
//   print("${Config.BASEURL}$path");
//   try {
//     var formData = FormData.fromMap(fData);
//     if (mapEntry != null) {
//       formData.files.addAll(mapEntry);
//     }
//     var response = await dio.post(path, data: formData);
//     return response;
//   } on DioException catch (err) {
//     print("error happening @ ${dio.options.baseUrl}$path");
//     handleError(err);
//     print(err);
//     rethrow;
//   } on Exception catch (err) {
//     print(err);
//     rethrow;
//   } catch (err) {
//     print(err);
//     rethrow;
//   }
// }

Future<dynamic> httpPut(String path, dynamic fData,
    {List<MapEntry<String, MultipartFile>>? mapEntry,
    bool hasAuth = false}) async {
  dio.options.headers = getHeaders();
  //print(fData);
  try {
    var formData = FormData.fromMap(fData);
    if (mapEntry != null) {
      formData.files.addAll(mapEntry);
    }
    var response = await dio.put(path, data: fData);
    return response;
  } on DioException catch (err) {
    handleError(err);
    print(err);
    rethrow;
  } on Exception catch (err) {
    print(err);
    rethrow;
  } catch (err) {
    print(err);
    rethrow;
  }
}

// Future<dynamic> httpDelete(String path, dynamic fData,
//     {bool hasAuth = false}) async {
//   dio.options.headers = getHeaders();
//   print(path);
//   try {
//     FormData formData;
//     if (fData != null) {
//       formData = FormData.fromMap(fData);
//     }

//     var response = await dio.delete(path, data: formData);
//     return response;
//   } on DioException catch (err) {
//     handleError(err);
//     print(err);
//     rethrow;
//   } on Exception catch (err) {
//     print(err);
//     rethrow;
//   } catch (err) {
//     print(err);
//     rethrow;
//   }
//}
