// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:coinharbor/controllers/base.vm.dart';
import 'package:coinharbor/resources/events.dart';
import 'package:coinharbor/utils/snack_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class AuthViewModel extends BaseViewModel {
  final TextEditingController phonenumber =
      TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController fname = TextEditingController();
  final TextEditingController lname = TextEditingController();

  final TextEditingController otp = TextEditingController();
  final TextEditingController emailLogin =
      TextEditingController();
  final TextEditingController passwordLogin =
      TextEditingController();

//   final emailReg =
//       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//   bool isHidden = false;
//   bool isChecked = true;
  final formKey = GlobalKey<FormState>();

  Future processSignUp(BuildContext context) async {
    try {
      startLoader();
      var data = {
        "first_name": fname.text.trim(),
        "last_name": lname.text.trim(),
        "email": email.text.trim(),
        "password": password.text.trim()
      };

      var response = await authRepo.register(data);
      if (response != null) {
        //  await userService.initializer();
        print('REG OK::::$response');
        showCustomToast("Registration Successful",
            toastType: ToastType.success);
        stopLoader();
        String emailValue = email.text;
        context.replace('/verification/$emailValue');
      } else {
        stopLoader();
      }
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }

  Future processEmailVerify(
      String emailVal, BuildContext context) async {
    try {
      startLoader();
      var data = {
        "email": emailVal,
        "code": otp.text.trim(),
      };

      print(
          "Request Payload: $data"); // 👈 Added print statement

      var response = await authRepo.emailVerify(data);
      userService.cache.eventBus!.fire(const ApplicationEvent(
          "", "stop_otp_timer",
          data: {}));
      if (response != null) {
        //await userService.initializer();
        showCustomToast("Email Verified Successfully",
            toastType: ToastType.success);
        stopLoader();
        context.replace('/login');
      } else {
        stopLoader();
      }
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }

  Future processForgotPassword(BuildContext context) async {
    try {
      startLoader();
      var data = {
        "user_email": emailLogin.text,
      };

      print(
          "Request Payload: $data"); // 👈 Added print statement

      var response = await authRepo.forgotpassword(data);

      if (response != null) {
        //await userService.initializer();
        showCustomToast("Verification Code Sent",
            toastType: ToastType.success);
        stopLoader();
        context.go('/reset-password');
      } else {
        stopLoader();
      }
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }

  Future processResetPassword(BuildContext context) async {
    try {
      startLoader();
      var data = {
        "otp": otp.text,
        "new_password": passwordLogin.text,
      };

      print(
          "Request Payload: $data"); // 👈 Added print statement

      var response = await authRepo.resetpassword(data);

      if (response != null) {
        //await userService.initializer();
        showCustomToast("Password Reset is Successful",
            toastType: ToastType.success);
        stopLoader();
        context.go('/login');
      } else {
        stopLoader();
      }
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }

  Future processResendVerifyEmail(String emailVal) async {
    try {
      startLoader();
      var data = {"email": emailVal};
      var response = await authRepo.resendVerifyEmail(data);

      if (response != null) {
        //await userService.initializer();
        userService.cache.eventBus!.fire(const ApplicationEvent(
            "", "start_otp_timer",
            data: {}));
        showCustomToast("Verification Email Sent Successfully",
            toastType: ToastType.success);
        stopLoader();
      } else {
        stopLoader();
      }
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }

  Future processLogin(BuildContext context) async {
    try {
      startLoader();
      var data = {
        "email": emailLogin.text.trim(),
        "password": passwordLogin.text.trim(),
      };
      var response = await authRepo.login(data);

      if (response != null && response.data != null) {
        // Extract necessary data from the response
        final responseData = response.data;

        print('CONTROLLER::::$responseData');

        showCustomToast(
            responseData['message'] ?? "Login successful",
            toastType: ToastType.success);
        context.replace('/homepage');
        // }
      } else {
        // Handle invalid or null response
        stopLoader();
        showCustomToast(
            "Something went wrong. Please try again.",
            toastType: ToastType.error);
      }
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }

// GENERATED FILE - Country data with ISO codes and currencies
// Parsed from the provided dataset. Import this file into your Flutter project.

  int? selectedCountryCode;
  String? selectedgender;

  final List<Map<String, dynamic>> gender = [
    {
      "id": "Male",
      "name": "Male",
    
    },
    {
      "id": "Female",
      "name": "Female",
      
    },
  ];

  final List<Map<String, dynamic>> countries = [
    {
      "id": 1,
      "name": "Afghanistan",
      "iso2": "AF",
      "iso3": "AFG",
      "currency_name": "Afghani",
      "currency_code": "AFN",
      "currency_symbol": "؋",
    },
    {
      "id": 2,
      "name": "Albania",
      "iso2": "AL",
      "iso3": "ALB",
      "currency_name": "Lek",
      "currency_code": "ALL",
      "currency_symbol": "L",
    },
    {
      "id": 3,
      "name": "Algeria",
      "iso2": "DZ",
      "iso3": "DZA",
      "currency_name": "Algerian Dinar",
      "currency_code": "DZD",
      "currency_symbol": "دج",
    },
    {
      "id": 4,
      "name": "Andorra",
      "iso2": "AD",
      "iso3": "AND",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 5,
      "name": "Angola",
      "iso2": "AO",
      "iso3": "AGO",
      "currency_name": "Kwanza",
      "currency_code": "AOA",
      "currency_symbol": "Kz",
    },
    {
      "id": 6,
      "name": "Argentina",
      "iso2": "AR",
      "iso3": "ARG",
      "currency_name": "Argentine Peso",
      "currency_code": "ARS",
      "currency_symbol": "\$",
    },
    {
      "id": 7,
      "name": "Armenia",
      "iso2": "AM",
      "iso3": "ARM",
      "currency_name": "Armenian Dram",
      "currency_code": "AMD",
      "currency_symbol": "֏",
    },
    {
      "id": 8,
      "name": "Australia",
      "iso2": "AU",
      "iso3": "AUS",
      "currency_name": "Australian Dollar",
      "currency_code": "AUD",
      "currency_symbol": "\$",
    },
    {
      "id": 9,
      "name": "Austria",
      "iso2": "AT",
      "iso3": "AUT",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 10,
      "name": "Azerbaijan",
      "iso2": "AZ",
      "iso3": "AZE",
      "currency_name": "Azerbaijani Manat",
      "currency_code": "AZN",
      "currency_symbol": "₼",
    },
    {
      "id": 11,
      "name": "Bahamas",
      "iso2": "BS",
      "iso3": "BHS",
      "currency_name": "Bahamian Dollar",
      "currency_code": "BSD",
      "currency_symbol": "\$",
    },
    {
      "id": 12,
      "name": "Bahrain",
      "iso2": "BH",
      "iso3": "BHR",
      "currency_name": "Bahraini Dinar",
      "currency_code": "BHD",
      "currency_symbol": ".د.ب",
    },
    {
      "id": 13,
      "name": "Bangladesh",
      "iso2": "BD",
      "iso3": "BGD",
      "currency_name": "Taka",
      "currency_code": "BDT",
      "currency_symbol": "৳",
    },
    {
      "id": 14,
      "name": "Barbados",
      "iso2": "BB",
      "iso3": "BRB",
      "currency_name": "Barbadian Dollar",
      "currency_code": "BBD",
      "currency_symbol": "\$",
    },
    {
      "id": 15,
      "name": "Belarus",
      "iso2": "BY",
      "iso3": "BLR",
      "currency_name": "Belarusian Ruble",
      "currency_code": "BYN",
      "currency_symbol": "Br",
    },
    {
      "id": 16,
      "name": "Belgium",
      "iso2": "BE",
      "iso3": "BEL",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 17,
      "name": "Belize",
      "iso2": "BZ",
      "iso3": "BLZ",
      "currency_name": "Belize Dollar",
      "currency_code": "BZD",
      "currency_symbol": "\$",
    },
    {
      "id": 18,
      "name": "Benin",
      "iso2": "BJ",
      "iso3": "BEN",
      "currency_name": "West African CFA franc",
      "currency_code": "XOF",
      "currency_symbol": "CFA",
    },
    {
      "id": 19,
      "name": "Bhutan",
      "iso2": "BT",
      "iso3": "BTN",
      "currency_name": "Ngultrum",
      "currency_code": "BTN",
      "currency_symbol": "Nu.",
    },
    {
      "id": 20,
      "name": "Bolivia",
      "iso2": "BO",
      "iso3": "BOL",
      "currency_name": "Boliviano",
      "currency_code": "BOB",
      "currency_symbol": "Bs.",
    },
    {
      "id": 21,
      "name": "Bosnia and Herzegovina",
      "iso2": "BA",
      "iso3": "BIH",
      "currency_name": "Convertible Mark",
      "currency_code": "BAM",
      "currency_symbol": "KM",
    },
    {
      "id": 22,
      "name": "Botswana",
      "iso2": "BW",
      "iso3": "BWA",
      "currency_name": "Pula",
      "currency_code": "BWP",
      "currency_symbol": "P",
    },
    {
      "id": 23,
      "name": "Brazil",
      "iso2": "BR",
      "iso3": "BRA",
      "currency_name": "Brazilian Real",
      "currency_code": "BRL",
      "currency_symbol": "R\$",
    },
    {
      "id": 24,
      "name": "Brunei",
      "iso2": "BN",
      "iso3": "BRN",
      "currency_name": "Brunei Dollar",
      "currency_code": "BND",
      "currency_symbol": "\$",
    },
    {
      "id": 25,
      "name": "Bulgaria",
      "iso2": "BG",
      "iso3": "BGR",
      "currency_name": "Bulgarian Lev",
      "currency_code": "BGN",
      "currency_symbol": "лв",
    },
    {
      "id": 26,
      "name": "Burkina Faso",
      "iso2": "BF",
      "iso3": "BFA",
      "currency_name": "West African CFA franc",
      "currency_code": "XOF",
      "currency_symbol": "CFA",
    },
    {
      "id": 27,
      "name": "Burundi",
      "iso2": "BI",
      "iso3": "BDI",
      "currency_name": "Burundian Franc",
      "currency_code": "BIF",
      "currency_symbol": "FBu",
    },
    {
      "id": 28,
      "name": "Cambodia",
      "iso2": "KH",
      "iso3": "KHM",
      "currency_name": "Riel",
      "currency_code": "KHR",
      "currency_symbol": "៛",
    },
    {
      "id": 29,
      "name": "Cameroon",
      "iso2": "CM",
      "iso3": "CMR",
      "currency_name": "Central African CFA franc",
      "currency_code": "XAF",
      "currency_symbol": "FCFA",
    },
    {
      "id": 30,
      "name": "Canada",
      "iso2": "CA",
      "iso3": "CAN",
      "currency_name": "Canadian Dollar",
      "currency_code": "CAD",
      "currency_symbol": "\$",
    },
    {
      "id": 31,
      "name": "Cape Verde",
      "iso2": "CV",
      "iso3": "CPV",
      "currency_name": "Escudo",
      "currency_code": "CVE",
      "currency_symbol": "\$",
    },
    {
      "id": 32,
      "name": "Central African Republic",
      "iso2": "CF",
      "iso3": "CAF",
      "currency_name": "Central African CFA franc",
      "currency_code": "XAF",
      "currency_symbol": "FCFA",
    },
    {
      "id": 33,
      "name": "Chad",
      "iso2": "TD",
      "iso3": "TCD",
      "currency_name": "Central African CFA franc",
      "currency_code": "XAF",
      "currency_symbol": "FCFA",
    },
    {
      "id": 34,
      "name": "Chile",
      "iso2": "CL",
      "iso3": "CHL",
      "currency_name": "Chilean Peso",
      "currency_code": "CLP",
      "currency_symbol": "\$",
    },
    {
      "id": 35,
      "name": "China",
      "iso2": "CN",
      "iso3": "CHN",
      "currency_name": "Yuan Renminbi",
      "currency_code": "CNY",
      "currency_symbol": "¥",
    },
    {
      "id": 36,
      "name": "Colombia",
      "iso2": "CO",
      "iso3": "COL",
      "currency_name": "Colombian Peso",
      "currency_code": "COP",
      "currency_symbol": "\$",
    },
    {
      "id": 37,
      "name": "Comoros",
      "iso2": "KM",
      "iso3": "COM",
      "currency_name": "Comorian Franc",
      "currency_code": "KMF",
      "currency_symbol": "CF",
    },
    {
      "id": 38,
      "name": "Congo (Brazzaville)",
      "iso2": "CG",
      "iso3": "COG",
      "currency_name": "Central African CFA franc",
      "currency_code": "XAF",
      "currency_symbol": "FCFA",
    },
    {
      "id": 39,
      "name": "Congo (Kinshasa)",
      "iso2": "CD",
      "iso3": "COD",
      "currency_name": "Congolese Franc",
      "currency_code": "CDF",
      "currency_symbol": "FC",
    },
    {
      "id": 40,
      "name": "Costa Rica",
      "iso2": "CR",
      "iso3": "CRI",
      "currency_name": "Costa Rican Colón",
      "currency_code": "CRC",
      "currency_symbol": "₡",
    },
    {
      "id": 41,
      "name": "Croatia",
      "iso2": "HR",
      "iso3": "HRV",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 42,
      "name": "Cuba",
      "iso2": "CU",
      "iso3": "CUB",
      "currency_name": "Cuban Peso",
      "currency_code": "CUP",
      "currency_symbol": "\$",
    },
    {
      "id": 43,
      "name": "Cyprus",
      "iso2": "CY",
      "iso3": "CYP",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 44,
      "name": "Czechia",
      "iso2": "CZ",
      "iso3": "CZE",
      "currency_name": "Czech Koruna",
      "currency_code": "CZK",
      "currency_symbol": "Kč",
    },
    {
      "id": 45,
      "name": "Denmark",
      "iso2": "DK",
      "iso3": "DNK",
      "currency_name": "Danish Krone",
      "currency_code": "DKK",
      "currency_symbol": "kr",
    },
    {
      "id": 46,
      "name": "Djibouti",
      "iso2": "DJ",
      "iso3": "DJI",
      "currency_name": "Djiboutian Franc",
      "currency_code": "DJF",
      "currency_symbol": "Fdj",
    },
    {
      "id": 47,
      "name": "Dominica",
      "iso2": "DM",
      "iso3": "DMA",
      "currency_name": "East Caribbean Dollar",
      "currency_code": "XCD",
      "currency_symbol": "\$",
    },
    {
      "id": 48,
      "name": "Dominican Republic",
      "iso2": "DO",
      "iso3": "DOM",
      "currency_name": "Dominican Peso",
      "currency_code": "DOP",
      "currency_symbol": "RD\$",
    },
    {
      "id": 49,
      "name": "Ecuador",
      "iso2": "EC",
      "iso3": "ECU",
      "currency_name": "US Dollar",
      "currency_code": "USD",
      "currency_symbol": "\$",
    },
    {
      "id": 50,
      "name": "Egypt",
      "iso2": "EG",
      "iso3": "EGY",
      "currency_name": "Egyptian Pound",
      "currency_code": "EGP",
      "currency_symbol": "£",
    },
    {
      "id": 51,
      "name": "El Salvador",
      "iso2": "SV",
      "iso3": "SLV",
      "currency_name": "US Dollar",
      "currency_code": "USD",
      "currency_symbol": "\$",
    },
    {
      "id": 52,
      "name": "Equatorial Guinea",
      "iso2": "GQ",
      "iso3": "GNQ",
      "currency_name": "Central African CFA franc",
      "currency_code": "XAF",
      "currency_symbol": "FCFA",
    },
    {
      "id": 53,
      "name": "Eritrea",
      "iso2": "ER",
      "iso3": "ERI",
      "currency_name": "Nakfa",
      "currency_code": "ERN",
      "currency_symbol": "Nfk",
    },
    {
      "id": 54,
      "name": "Estonia",
      "iso2": "EE",
      "iso3": "EST",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 55,
      "name": "Eswatini",
      "iso2": "SZ",
      "iso3": "SWZ",
      "currency_name": "Lilangeni",
      "currency_code": "SZL",
      "currency_symbol": "E",
    },
    {
      "id": 56,
      "name": "Ethiopia",
      "iso2": "ET",
      "iso3": "ETH",
      "currency_name": "Birr",
      "currency_code": "ETB",
      "currency_symbol": "Br",
    },
    {
      "id": 57,
      "name": "Fiji",
      "iso2": "FJ",
      "iso3": "FJI",
      "currency_name": "Fijian Dollar",
      "currency_code": "FJD",
      "currency_symbol": "\$",
    },
    {
      "id": 58,
      "name": "Finland",
      "iso2": "FI",
      "iso3": "FIN",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 59,
      "name": "France",
      "iso2": "FR",
      "iso3": "FRA",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 60,
      "name": "Gabon",
      "iso2": "GA",
      "iso3": "GAB",
      "currency_name": "Central African CFA franc",
      "currency_code": "XAF",
      "currency_symbol": "FCFA",
    },
    {
      "id": 61,
      "name": "Gambia",
      "iso2": "GM",
      "iso3": "GMB",
      "currency_name": "Dalasi",
      "currency_code": "GMD",
      "currency_symbol": "D",
    },
    {
      "id": 62,
      "name": "Georgia",
      "iso2": "GE",
      "iso3": "GEO",
      "currency_name": "Georgian Lari",
      "currency_code": "GEL",
      "currency_symbol": "₾",
    },
    {
      "id": 63,
      "name": "Germany",
      "iso2": "DE",
      "iso3": "DEU",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 64,
      "name": "Ghana",
      "iso2": "GH",
      "iso3": "GHA",
      "currency_name": "Ghanaian Cedi",
      "currency_code": "GHS",
      "currency_symbol": "₵",
    },
    {
      "id": 65,
      "name": "Greece",
      "iso2": "GR",
      "iso3": "GRC",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 66,
      "name": "Grenada",
      "iso2": "GD",
      "iso3": "GRD",
      "currency_name": "East Caribbean Dollar",
      "currency_code": "XCD",
      "currency_symbol": "\$",
    },
    {
      "id": 67,
      "name": "Guatemala",
      "iso2": "GT",
      "iso3": "GTM",
      "currency_name": "Quetzal",
      "currency_code": "GTQ",
      "currency_symbol": "Q",
    },
    {
      "id": 68,
      "name": "Guinea",
      "iso2": "GN",
      "iso3": "GIN",
      "currency_name": "Guinean Franc",
      "currency_code": "GNF",
      "currency_symbol": "FG",
    },
    {
      "id": 69,
      "name": "Guinea-Bissau",
      "iso2": "GW",
      "iso3": "GNB",
      "currency_name": "West African CFA franc",
      "currency_code": "XOF",
      "currency_symbol": "CFA",
    },
    {
      "id": 70,
      "name": "Guyana",
      "iso2": "GY",
      "iso3": "GUY",
      "currency_name": "Guyana Dollar",
      "currency_code": "GYD",
      "currency_symbol": "\$",
    },
    {
      "id": 71,
      "name": "Haiti",
      "iso2": "HT",
      "iso3": "HTI",
      "currency_name": "Gourde",
      "currency_code": "HTG",
      "currency_symbol": "G",
    },
    {
      "id": 72,
      "name": "Honduras",
      "iso2": "HN",
      "iso3": "HND",
      "currency_name": "Lempira",
      "currency_code": "HNL",
      "currency_symbol": "L",
    },
    {
      "id": 73,
      "name": "Hungary",
      "iso2": "HU",
      "iso3": "HUN",
      "currency_name": "Forint",
      "currency_code": "HUF",
      "currency_symbol": "Ft",
    },
    {
      "id": 74,
      "name": "Iceland",
      "iso2": "IS",
      "iso3": "ISL",
      "currency_name": "Iceland Krona",
      "currency_code": "ISK",
      "currency_symbol": "kr",
    },
    {
      "id": 75,
      "name": "India",
      "iso2": "IN",
      "iso3": "IND",
      "currency_name": "Indian Rupee",
      "currency_code": "INR",
      "currency_symbol": "₹",
    },
    {
      "id": 76,
      "name": "Indonesia",
      "iso2": "Rupiah",
      "iso3": "Rp",
      "currency_name": "77",
      "currency_code": "Iran",
      "currency_symbol": "IR",
    },
    {
      "id": 78,
      "name": "Iraq",
      "iso2": "IQ",
      "iso3": "IRQ",
      "currency_name": "Iraqi Dinar",
      "currency_code": "IQD",
      "currency_symbol": "د.ع",
    },
    {
      "id": 79,
      "name": "Ireland",
      "iso2": "IE",
      "iso3": "IRL",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 80,
      "name": "Israel",
      "iso2": "IL",
      "iso3": "ISR",
      "currency_name": "Shekel",
      "currency_code": "ILS",
      "currency_symbol": "₪",
    },
    {
      "id": 81,
      "name": "Italy",
      "iso2": "IT",
      "iso3": "ITA",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 82,
      "name": "Jamaica",
      "iso2": "JM",
      "iso3": "JAM",
      "currency_name": "Jamaican Dollar",
      "currency_code": "JMD",
      "currency_symbol": "J\$",
    },
    {
      "id": 83,
      "name": "Japan",
      "iso2": "JP",
      "iso3": "JPN",
      "currency_name": "Yen",
      "currency_code": "JPY",
      "currency_symbol": "¥",
    },
    {
      "id": 84,
      "name": "Jordan",
      "iso2": "JO",
      "iso3": "JOR",
      "currency_name": "Jordanian Dinar",
      "currency_code": "JOD",
      "currency_symbol": "JD",
    },
    {
      "id": 85,
      "name": "Kazakhstan",
      "iso2": "KZ",
      "iso3": "KAZ",
      "currency_name": "Tenge",
      "currency_code": "KZT",
      "currency_symbol": "₸",
    },
    {
      "id": 86,
      "name": "Kenya",
      "iso2": "KE",
      "iso3": "KEN",
      "currency_name": "Kenyan Shilling",
      "currency_code": "KES",
      "currency_symbol": "KSh",
    },
    {
      "id": 87,
      "name": "Kiribati",
      "iso2": "KI",
      "iso3": "KIR",
      "currency_name": "Australian Dollar",
      "currency_code": "AUD",
      "currency_symbol": "\$",
    },
    {
      "id": 88,
      "name": "Kuwait",
      "iso2": "KW",
      "iso3": "KWT",
      "currency_name": "Kuwaiti Dinar",
      "currency_code": "KWD",
      "currency_symbol": "KD",
    },
    {
      "id": 89,
      "name": "Kyrgyzstan",
      "iso2": "KG",
      "iso3": "KGZ",
      "currency_name": "Som",
      "currency_code": "KGS",
      "currency_symbol": "с",
    },
    {
      "id": 90,
      "name": "Laos",
      "iso2": "LA",
      "iso3": "LAO",
      "currency_name": "Kip",
      "currency_code": "LAK",
      "currency_symbol": "₭",
    },
    {
      "id": 91,
      "name": "Latvia",
      "iso2": "LV",
      "iso3": "LVA",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 92,
      "name": "Lebanon",
      "iso2": "LB",
      "iso3": "LBN",
      "currency_name": "Lebanese Pound",
      "currency_code": "LBP",
      "currency_symbol": "ل.ل",
    },
    {
      "id": 93,
      "name": "Lesotho",
      "iso2": "LS",
      "iso3": "LSO",
      "currency_name": "Loti",
      "currency_code": "LSL",
      "currency_symbol": "L",
    },
    {
      "id": 94,
      "name": "Liberia",
      "iso2": "LR",
      "iso3": "LBR",
      "currency_name": "Liberian Dollar",
      "currency_code": "LRD",
      "currency_symbol": "\$",
    },
    {
      "id": 95,
      "name": "Libya",
      "iso2": "LY",
      "iso3": "LBY",
      "currency_name": "Libyan Dinar",
      "currency_code": "LYD",
      "currency_symbol": "ل.د",
    },
    {
      "id": 96,
      "name": "Liechtenstein",
      "iso2": "LI",
      "iso3": "LIE",
      "currency_name": "Swiss Franc",
      "currency_code": "CHF",
      "currency_symbol": "CHF",
    },
    {
      "id": 97,
      "name": "Lithuania",
      "iso2": "LT",
      "iso3": "LTU",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 98,
      "name": "Luxembourg",
      "iso2": "LU",
      "iso3": "LUX",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 99,
      "name": "Madagascar",
      "iso2": "MG",
      "iso3": "MDG",
      "currency_name": "Ariary",
      "currency_code": "MGA",
      "currency_symbol": "Ar",
    },
    {
      "id": 100,
      "name": "Malawi",
      "iso2": "MW",
      "iso3": "MWI",
      "currency_name": "Malawi Kwacha",
      "currency_code": "MWK",
      "currency_symbol": "MK",
    },
    {
      "id": 101,
      "name": "Malaysia",
      "iso2": "MY",
      "iso3": "MYS",
      "currency_name": "Malaysian Ringgit",
      "currency_code": "MYR",
      "currency_symbol": "RM",
    },
    {
      "id": 102,
      "name": "Maldives",
      "iso2": "MV",
      "iso3": "MDV",
      "currency_name": "Rufiyaa",
      "currency_code": "MVR",
      "currency_symbol": "Rf",
    },
    {
      "id": 103,
      "name": "Mali",
      "iso2": "ML",
      "iso3": "MLI",
      "currency_name": "West African CFA franc",
      "currency_code": "XOF",
      "currency_symbol": "CFA",
    },
    {
      "id": 104,
      "name": "Malta",
      "iso2": "MT",
      "iso3": "MLT",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 105,
      "name": "Marshall Islands",
      "iso2": "MH",
      "iso3": "MHL",
      "currency_name": "US Dollar",
      "currency_code": "USD",
      "currency_symbol": "\$",
    },
    {
      "id": 106,
      "name": "Mauritania",
      "iso2": "MR",
      "iso3": "MRT",
      "currency_name": "Ouguiya",
      "currency_code": "MRU",
      "currency_symbol": "UM",
    },
    {
      "id": 107,
      "name": "Mauritius",
      "iso2": "MU",
      "iso3": "MUS",
      "currency_name": "Mauritian Rupee",
      "currency_code": "MUR",
      "currency_symbol": "₨",
    },
    {
      "id": 108,
      "name": "Mexico",
      "iso2": "MX",
      "iso3": "MEX",
      "currency_name": "Peso",
      "currency_code": "MXN",
      "currency_symbol": "\$",
    },
    {
      "id": 109,
      "name": "Micronesia",
      "iso2": "FM",
      "iso3": "FSM",
      "currency_name": "US Dollar",
      "currency_code": "USD",
      "currency_symbol": "\$",
    },
    {
      "id": 110,
      "name": "Moldova",
      "iso2": "MD",
      "iso3": "MDA",
      "currency_name": "Leu",
      "currency_code": "MDL",
      "currency_symbol": "L",
    },
    {
      "id": 111,
      "name": "Monaco",
      "iso2": "MC",
      "iso3": "MCO",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 112,
      "name": "Mongolia",
      "iso2": "MN",
      "iso3": "MNG",
      "currency_name": "Tugrik",
      "currency_code": "MNT",
      "currency_symbol": "₮",
    },
    {
      "id": 113,
      "name": "Montenegro",
      "iso2": "ME",
      "iso3": "MNE",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 114,
      "name": "Morocco",
      "iso2": "MA",
      "iso3": "MAR",
      "currency_name": "Dirham",
      "currency_code": "MAD",
      "currency_symbol": "د.م.",
    },
    {
      "id": 115,
      "name": "Mozambique",
      "iso2": "MZ",
      "iso3": "MOZ",
      "currency_name": "Metical",
      "currency_code": "MZN",
      "currency_symbol": "MT",
    },
    {
      "id": 116,
      "name": "Myanmar",
      "iso2": "MM",
      "iso3": "MMR",
      "currency_name": "Kyat",
      "currency_code": "MMK",
      "currency_symbol": "Ks",
    },
    {
      "id": 117,
      "name": "Namibia",
      "iso2": "NA",
      "iso3": "NAM",
      "currency_name": "Namibia Dollar",
      "currency_code": "NAD",
      "currency_symbol": "\$",
    },
    {
      "id": 118,
      "name": "Nauru",
      "iso2": "NR",
      "iso3": "NRU",
      "currency_name": "Australian Dollar",
      "currency_code": "AUD",
      "currency_symbol": "\$",
    },
    {
      "id": 119,
      "name": "Nepal",
      "iso2": "NP",
      "iso3": "NPL",
      "currency_name": "Nepalese Rupee",
      "currency_code": "NPR",
      "currency_symbol": "₨",
    },
    {
      "id": 120,
      "name": "Netherlands",
      "iso2": "NL",
      "iso3": "NLD",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 121,
      "name": "New Zealand",
      "iso2": "NZ",
      "iso3": "NZL",
      "currency_name": "New Zealand Dollar",
      "currency_code": "NZD",
      "currency_symbol": "\$",
    },
    {
      "id": 122,
      "name": "Nicaragua",
      "iso2": "NI",
      "iso3": "NIC",
      "currency_name": "Cordoba Oro",
      "currency_code": "NIO",
      "currency_symbol": "C\$",
    },
    {
      "id": 123,
      "name": "Niger",
      "iso2": "NE",
      "iso3": "NER",
      "currency_name": "West African CFA franc",
      "currency_code": "XOF",
      "currency_symbol": "CFA",
    },
    {
      "id": 124,
      "name": "Nigeria",
      "iso2": "NG",
      "iso3": "NGA",
      "currency_name": "Naira",
      "currency_code": "NGN",
      "currency_symbol": "₦",
    },
    {
      "id": 125,
      "name": "North Korea",
      "iso2": "KP",
      "iso3": "PRK",
      "currency_name": "North Korean Won",
      "currency_code": "KPW",
      "currency_symbol": "₩",
    },
    {
      "id": 126,
      "name": "North Macedonia",
      "iso2": "MK",
      "iso3": "MKD",
      "currency_name": "Denar",
      "currency_code": "MKD",
      "currency_symbol": "ден",
    },
    {
      "id": 127,
      "name": "Norway",
      "iso2": "NO",
      "iso3": "NOR",
      "currency_name": "Norwegian Krone",
      "currency_code": "NOK",
      "currency_symbol": "kr",
    },
    {
      "id": 128,
      "name": "Oman",
      "iso2": "OM",
      "iso3": "OMN",
      "currency_name": "Rial Omani",
      "currency_code": "OMR",
      "currency_symbol": "﷼",
    },
    {
      "id": 129,
      "name": "Pakistan",
      "iso2": "PK",
      "iso3": "PAK",
      "currency_name": "Rupee",
      "currency_code": "PKR",
      "currency_symbol": "₨",
    },
    {
      "id": 130,
      "name": "Palau",
      "iso2": "PW",
      "iso3": "PLW",
      "currency_name": "US Dollar",
      "currency_code": "USD",
      "currency_symbol": "\$",
    },
    {
      "id": 131,
      "name": "Palestine",
      "iso2": "PS",
      "iso3": "PSE",
      "currency_name": "Israeli Shekel",
      "currency_code": "ILS",
      "currency_symbol": "₪",
    },
    {
      "id": 132,
      "name": "Panama",
      "iso2": "PA",
      "iso3": "PAN",
      "currency_name": "Balboa",
      "currency_code": "PAB",
      "currency_symbol": "B/.",
    },
    {
      "id": 133,
      "name": "Papua New Guinea",
      "iso2": "PG",
      "iso3": "PNG",
      "currency_name": "Kina",
      "currency_code": "PGK",
      "currency_symbol": "K",
    },
    {
      "id": 134,
      "name": "Paraguay",
      "iso2": "PY",
      "iso3": "PRY",
      "currency_name": "Guarani",
      "currency_code": "PYG",
      "currency_symbol": "₲",
    },
    {
      "id": 135,
      "name": "Peru",
      "iso2": "PE",
      "iso3": "PER",
      "currency_name": "Sol",
      "currency_code": "PEN",
      "currency_symbol": "S/.",
    },
    {
      "id": 136,
      "name": "Philippines",
      "iso2": "PH",
      "iso3": "PHL",
      "currency_name": "Peso",
      "currency_code": "PHP",
      "currency_symbol": "₱",
    },
    {
      "id": 137,
      "name": "Poland",
      "iso2": "PL",
      "iso3": "POL",
      "currency_name": "Zloty",
      "currency_code": "PLN",
      "currency_symbol": "zł",
    },
    {
      "id": 138,
      "name": "Portugal",
      "iso2": "PT",
      "iso3": "PRT",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 139,
      "name": "Qatar",
      "iso2": "QA",
      "iso3": "QAT",
      "currency_name": "Qatari Rial",
      "currency_code": "QAR",
      "currency_symbol": "﷼",
    },
    {
      "id": 140,
      "name": "Romania",
      "iso2": "RO",
      "iso3": "ROU",
      "currency_name": "Leu",
      "currency_code": "RON",
      "currency_symbol": "lei",
    },
    {
      "id": 141,
      "name": "Russia",
      "iso2": "RU",
      "iso3": "RUS",
      "currency_name": "Russian Ruble",
      "currency_code": "RUB",
      "currency_symbol": "₽",
    },
    {
      "id": 142,
      "name": "Rwanda",
      "iso2": "RW",
      "iso3": "RWA",
      "currency_name": "Rwandan Franc",
      "currency_code": "RWF",
      "currency_symbol": "FRw",
    },
    {
      "id": 143,
      "name": "Saint Kitts and Nevis",
      "iso2": "KN",
      "iso3": "KNA",
      "currency_name": "East Caribbean Dollar",
      "currency_code": "XCD",
      "currency_symbol": "\$",
    },
    {
      "id": 144,
      "name": "Saint Lucia",
      "iso2": "LC",
      "iso3": "LCA",
      "currency_name": "East Caribbean Dollar",
      "currency_code": "XCD",
      "currency_symbol": "\$",
    },
    {
      "id": 145,
      "name": "Saint Vincent and the Grenadines",
      "iso2": "VC",
      "iso3": "VCT",
      "currency_name": "East Caribbean Dollar",
      "currency_code": "XCD",
      "currency_symbol": "\$",
    },
    {
      "id": 146,
      "name": "Samoa",
      "iso2": "WS",
      "iso3": "WSM",
      "currency_name": "Tala",
      "currency_code": "WST",
      "currency_symbol": "T",
    },
    {
      "id": 147,
      "name": "San Marino",
      "iso2": "SM",
      "iso3": "SMR",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 148,
      "name": "Sao Tome and Principe",
      "iso2": "ST",
      "iso3": "STP",
      "currency_name": "Dobra",
      "currency_code": "STN",
      "currency_symbol": "Db",
    },
    {
      "id": 149,
      "name": "Saudi Arabia",
      "iso2": "SA",
      "iso3": "SAU",
      "currency_name": "Saudi Riyal",
      "currency_code": "SAR",
      "currency_symbol": "﷼",
    },
    {
      "id": 150,
      "name": "Senegal",
      "iso2": "SN",
      "iso3": "SEN",
      "currency_name": "West African CFA franc",
      "currency_code": "XOF",
      "currency_symbol": "CFA",
    },
    {
      "id": 151,
      "name": "Serbia",
      "iso2": "RS",
      "iso3": "SRB",
      "currency_name": "Serbian Dinar",
      "currency_code": "RSD",
      "currency_symbol": "din",
    },
    {
      "id": 152,
      "name": "Seychelles",
      "iso2": "SC",
      "iso3": "SYC",
      "currency_name": "Seychellois Rupee",
      "currency_code": "SCR",
      "currency_symbol": "₨",
    },
    {
      "id": 153,
      "name": "Sierra Leone",
      "iso2": "SL",
      "iso3": "SLE",
      "currency_name": "Leone",
      "currency_code": "SLL",
      "currency_symbol": "Le",
    },
    {
      "id": 154,
      "name": "Singapore",
      "iso2": "SG",
      "iso3": "SGP",
      "currency_name": "Singapore Dollar",
      "currency_code": "SGD",
      "currency_symbol": "\$",
    },
    {
      "id": 155,
      "name": "Slovakia",
      "iso2": "SK",
      "iso3": "SVK",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 156,
      "name": "Slovenia",
      "iso2": "SI",
      "iso3": "SVN",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 157,
      "name": "Solomon Islands",
      "iso2": "SB",
      "iso3": "SLB",
      "currency_name": "Solomon Islands Dollar",
      "currency_code": "SBD",
      "currency_symbol": "\$",
    },
    {
      "id": 158,
      "name": "Somalia",
      "iso2": "SO",
      "iso3": "SOM",
      "currency_name": "Somali Shilling",
      "currency_code": "SOS",
      "currency_symbol": "Sh",
    },
    {
      "id": 159,
      "name": "South Africa",
      "iso2": "ZA",
      "iso3": "ZAF",
      "currency_name": "Rand",
      "currency_code": "ZAR",
      "currency_symbol": "R",
    },
    {
      "id": 160,
      "name": "South Korea",
      "iso2": "KR",
      "iso3": "KOR",
      "currency_name": "Won",
      "currency_code": "KRW",
      "currency_symbol": "₩",
    },
    {
      "id": 161,
      "name": "South Sudan",
      "iso2": "SS",
      "iso3": "SSD",
      "currency_name": "South Sudanese Pound",
      "currency_code": "SSP",
      "currency_symbol": "£",
    },
    {
      "id": 162,
      "name": "Spain",
      "iso2": "ES",
      "iso3": "ESP",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 163,
      "name": "Sri Lanka",
      "iso2": "LK",
      "iso3": "LKA",
      "currency_name": "Sri Lankan Rupee",
      "currency_code": "LKR",
      "currency_symbol": "₨",
    },
    {
      "id": 164,
      "name": "Sudan",
      "iso2": "SD",
      "iso3": "SDN",
      "currency_name": "Sudanese Pound",
      "currency_code": "SDG",
      "currency_symbol": "ج.س.",
    },
    {
      "id": 165,
      "name": "Suriname",
      "iso2": "SR",
      "iso3": "SUR",
      "currency_name": "Surinamese Dollar",
      "currency_code": "SRD",
      "currency_symbol": "\$",
    },
    {
      "id": 166,
      "name": "Sweden",
      "iso2": "SE",
      "iso3": "SWE",
      "currency_name": "Swedish Krona",
      "currency_code": "SEK",
      "currency_symbol": "kr",
    },
    {
      "id": 167,
      "name": "Switzerland",
      "iso2": "CH",
      "iso3": "CHE",
      "currency_name": "Swiss Franc",
      "currency_code": "CHF",
      "currency_symbol": "CHF",
    },
    {
      "id": 168,
      "name": "Syria",
      "iso2": "SY",
      "iso3": "SYR",
      "currency_name": "Syrian Pound",
      "currency_code": "SYP",
      "currency_symbol": "£S",
    },
    {
      "id": 169,
      "name": "Taiwan",
      "iso2": "TW",
      "iso3": "TWN",
      "currency_name": "New Taiwan Dollar",
      "currency_code": "TWD",
      "currency_symbol": "NT\$",
    },
    {
      "id": 170,
      "name": "Tajikistan",
      "iso2": "TJ",
      "iso3": "TJK",
      "currency_name": "Somoni",
      "currency_code": "TJS",
      "currency_symbol": "SM",
    },
    {
      "id": 171,
      "name": "Tanzania",
      "iso2": "TZ",
      "iso3": "TZA",
      "currency_name": "Tanzanian Shilling",
      "currency_code": "TZS",
      "currency_symbol": "TSh",
    },
    {
      "id": 172,
      "name": "Thailand",
      "iso2": "TH",
      "iso3": "THA",
      "currency_name": "Baht",
      "currency_code": "THB",
      "currency_symbol": "฿",
    },
    {
      "id": 173,
      "name": "Timor-Leste",
      "iso2": "TL",
      "iso3": "TLS",
      "currency_name": "US Dollar",
      "currency_code": "USD",
      "currency_symbol": "\$",
    },
    {
      "id": 174,
      "name": "Togo",
      "iso2": "TG",
      "iso3": "TGO",
      "currency_name": "West African CFA franc",
      "currency_code": "XOF",
      "currency_symbol": "CFA",
    },
    {
      "id": 175,
      "name": "Tonga",
      "iso2": "TO",
      "iso3": "TON",
      "currency_name": "Pa’anga",
      "currency_code": "TOP",
      "currency_symbol": "T\$",
    },
    {
      "id": 176,
      "name": "Trinidad and Tobago",
      "iso2": "TT",
      "iso3": "TTO",
      "currency_name": "Trinidad and Tobago Dollar",
      "currency_code": "TTD",
      "currency_symbol": "TT\$",
    },
    {
      "id": 177,
      "name": "Tunisia",
      "iso2": "TN",
      "iso3": "TUN",
      "currency_name": "Tunisian Dinar",
      "currency_code": "TND",
      "currency_symbol": "د.ت",
    },
    {
      "id": 178,
      "name": "Turkey",
      "iso2": "TR",
      "iso3": "TUR",
      "currency_name": "Turkish Lira",
      "currency_code": "TRY",
      "currency_symbol": "₺",
    },
    {
      "id": 179,
      "name": "Turkmenistan",
      "iso2": "TM",
      "iso3": "TKM",
      "currency_name": "Turkmenistan Manat",
      "currency_code": "TMT",
      "currency_symbol": "m",
    },
    {
      "id": 180,
      "name": "Tuvalu",
      "iso2": "TV",
      "iso3": "TUV",
      "currency_name": "Australian Dollar",
      "currency_code": "AUD",
      "currency_symbol": "\$",
    },
    {
      "id": 181,
      "name": "Uganda",
      "iso2": "UG",
      "iso3": "UGA",
      "currency_name": "Ugandan Shilling",
      "currency_code": "UGX",
      "currency_symbol": "USh",
    },
    {
      "id": 182,
      "name": "Ukraine",
      "iso2": "UA",
      "iso3": "UKR",
      "currency_name": "Hryvnia",
      "currency_code": "UAH",
      "currency_symbol": "₴",
    },
    {
      "id": 183,
      "name": "United Arab Emirates",
      "iso2": "AE",
      "iso3": "ARE",
      "currency_name": "UAE Dirham",
      "currency_code": "AED",
      "currency_symbol": "د.إ",
    },
    {
      "id": 184,
      "name": "United Kingdom",
      "iso2": "GB",
      "iso3": "GBR",
      "currency_name": "Pound Sterling",
      "currency_code": "GBP",
      "currency_symbol": "£",
    },
    {
      "id": 185,
      "name": "United States",
      "iso2": "US",
      "iso3": "USA",
      "currency_name": "US Dollar",
      "currency_code": "USD",
      "currency_symbol": "\$",
    },
    {
      "id": 186,
      "name": "Uruguay",
      "iso2": "UY",
      "iso3": "URY",
      "currency_name": "Peso Uruguayo",
      "currency_code": "UYU",
      "currency_symbol": "\$U",
    },
    {
      "id": 187,
      "name": "Uzbekistan",
      "iso2": "UZ",
      "iso3": "UZB",
      "currency_name": "Uzbekistani Som",
      "currency_code": "UZS",
      "currency_symbol": "лв",
    },
    {
      "id": 188,
      "name": "Vanuatu",
      "iso2": "VU",
      "iso3": "VUT",
      "currency_name": "Vatu",
      "currency_code": "VUV",
      "currency_symbol": "VT",
    },
    {
      "id": 189,
      "name": "Vatican City",
      "iso2": "VA",
      "iso3": "VAT",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
    {
      "id": 190,
      "name": "Venezuela",
      "iso2": "VE",
      "iso3": "VEN",
      "currency_name": "Bolívar Soberano",
      "currency_code": "VES",
      "currency_symbol": "Bs.",
    },
    {
      "id": 191,
      "name": "Vietnam",
      "iso2": "VN",
      "iso3": "VNM",
      "currency_name": "Dong",
      "currency_code": "VND",
      "currency_symbol": "₫",
    },
    {
      "id": 192,
      "name": "Yemen",
      "iso2": "YE",
      "iso3": "YEM",
      "currency_name": "Yemeni Rial",
      "currency_code": "YER",
      "currency_symbol": "﷼",
    },
    {
      "id": 193,
      "name": "Zambia",
      "iso2": "ZM",
      "iso3": "ZMB",
      "currency_name": "Kwacha",
      "currency_code": "ZMW",
      "currency_symbol": "ZK",
    },
    {
      "id": 194,
      "name": "Zimbabwe",
      "iso2": "ZW",
      "iso3": "ZWE",
      "currency_name": "Zimbabwe Dollar (new)",
      "currency_code": "ZWL",
      "currency_symbol": "Z\$",
    },
    {
      "id": 195,
      "name": "Kosovo",
      "iso2": "XK",
      "iso3": "XKX",
      "currency_name": "Euro",
      "currency_code": "EUR",
      "currency_symbol": "€",
    },
  ];

  Future processCompleteProfile(
    BuildContext context,
    String dob,
    String address,
    String phone,
  ) async {
    try {
      startLoader();
      var data = {
        "dob": dob,
        "gender": selectedgender,
        "address": address,
        "phone": phone,
        "country_id": selectedCountryCode
      };

      print("Payload: $data");

      var responseData = await authRepo.completeprofile(data);

      if (responseData['status'] == true) {
        print('CONTROLLER:::: $responseData');

        showCustomToast(
          responseData['message'] ?? "Profile Updated",
          toastType: ToastType.success,
        );
        context.pop();
      } else {
        // Handle invalid or null response
        stopLoader();
        showCustomToast(
          responseData['message'] ??
              "Something went wrong. Please try again.",
          toastType: ToastType.error,
        );
        context.pop();
      }
      stopLoader();
    } catch (e, l) {
      stopLoader();
      print(e);
      print(l);
    }
  }
}
