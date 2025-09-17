// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../utils/snack_message.dart';

// This function handles errors in the app using DioError
void handleError(dynamic error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.cancel:
        print("Request to API server was cancelled");
        break;
      case DioExceptionType.connectionTimeout:
        showCustomToast("Connection timeout with API server");
        print("Connection timeout with API server");
        break;
      case DioExceptionType.connectionError:
        showCustomToast(
            "Please enable internet connection to use Acute shelves");
        break;
      case DioExceptionType.receiveTimeout:
        print("Receive timeout in connection with API server");
        break;
      case DioExceptionType.badResponse:
        if (error.response?.data != null) {
          // Check if 'message' exists in the response
          final errorMessage = error.response?.data["message"];
          if (errorMessage != null) {
            showCustomToast(errorMessage);
            print(errorMessage);
          } else if (error.response?.data["error"] != null) {
            // If 'errors' exists, parse it to get the specific error message
            final errors = error.response?.data["error"];
            showCustomToast("$errors");
          } else {
            showCustomToast("An error occurred: Bad Response 400");
          }
        }
        break;
      case DioExceptionType.sendTimeout:
        print("Send timeout in connection with API server");
        break;
      default:
        showCustomToast("Something went wrong");
        break;
    }
  } else {
    try {
      var errorJson = jsonDecode(error.toString());
      var errorMessage = errorJson['message'];
      showCustomToast(errorMessage);
      print(errorMessage);
    } catch (e) {
      showCustomToast("An unexpected error occurred");
      print("An unexpected error occurred: $e");
    }
  }
}
