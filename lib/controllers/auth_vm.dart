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
        //   final status = responseData['data']['status'];
        //   final isBusinessCreated = responseData['data']['is_business_created'];
        //   final hasJoinedBusiness = responseData['data']['has_joined_business'];
        // final businesses = responseData['data']['businesses'] ?? [];

        // // Extract user role safely
        // dynamic userRole;
        // if (businesses.isNotEmpty) {
        //   userRole = businesses.first['role'];
        // }

        // // Debugging: Print the actual role type and value
        // print("User Role: $userRole (Type: ${userRole.runtimeType})");

        // if (status != "active") {
        //   stopLoader();
        //   showCustomToast("Email not verified", toastType: ToastType.warning);
        //   String emailValue = emailLogin.text;
        //   context.replace('/verification/$emailValue');
        // } else if (isBusinessCreated == false && hasJoinedBusiness == false) {
        //   stopLoader();
        //   showCustomToast("Login successful", toastType: ToastType.success);
        //   context.replace('/create-business');
        // } else if (isBusinessCreated == false && hasJoinedBusiness == true) {
        //   stopLoader();
        //   showCustomToast("Join a business to proceed", toastType: ToastType.success);
        //   context.replace('/home');
        // } else {
        //   stopLoader();
        showCustomToast("Login successful",
            toastType: ToastType.success);
        context.replace('/home');
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

//   final TextEditingController busName = TextEditingController();
//   final TextEditingController busAddr = TextEditingController();
//   final TextEditingController busCity = TextEditingController();
//   final TextEditingController busState = TextEditingController();
//   final TextEditingController busEmail = TextEditingController();
//   final TextEditingController busRegNo = TextEditingController();

//   int? selectedCategoryId;
//   String? selectedRole;

//   List<Map<String, dynamic>> businessCategories = [
//     {
//       "id": 1,
//       "name": "Healthcare",
//       "created_at": "2024-11-08T09:43:36.000000Z",
//       "updated_at": "2024-11-08T09:43:36.000000Z"
//     },
//     {
//       "id": 2,
//       "name": "Fashion",
//       "created_at": "2024-11-08T09:43:43.000000Z",
//       "updated_at": "2024-11-08T09:43:43.000000Z"
//     },
//     {
//       "id": 3,
//       "name": "Finance",
//       "created_at": "2024-11-08T09:43:49.000000Z",
//       "updated_at": "2024-11-08T09:43:49.000000Z"
//     },
//     {
//       "id": 4,
//       "name": "Entertainment",
//       "created_at": "2024-11-08T09:43:56.000000Z",
//       "updated_at": "2024-11-08T09:43:56.000000Z"
//     },
//     {
//       "id": 5,
//       "name": "Commerce",
//       "created_at": "2024-11-08T09:44:03.000000Z",
//       "updated_at": "2024-11-08T09:44:03.000000Z"
//     }
//   ];

//   List<Map<String, dynamic>> roles = [
//     {
//       "id": "admin",
//       "name": "Admin",
//       "created_at": "2024-11-08T09:43:36.000000Z",
//       "updated_at": "2024-11-08T09:43:36.000000Z"
//     },
//     {
//       "id": "manager",
//       "name": "Manager",
//       "created_at": "2024-11-08T09:43:43.000000Z",
//       "updated_at": "2024-11-08T09:43:43.000000Z"
//     },
//     {
//       "id": "storekeeper",
//       "name": "Storekeeper",
//       "created_at": "2024-11-08T09:43:49.000000Z",
//       "updated_at": "2024-11-08T09:43:49.000000Z"
//     },
//     {
//       "id": "salesperson",
//       "name": "Salesperson",
//       "created_at": "2024-11-08T09:43:49.000000Z",
//       "updated_at": "2024-11-08T09:43:49.000000Z"
//     },
//   ];

//   Future createBusiness(BuildContext context) async {
//     try {
//       startLoader();
//       var data = {
//         "name": busName.text,
//         "address": busAddr.text,
//         "city": busCity.text,
//         "state": busState.text,
//         "email": busEmail.text,
//         "registration_number": busRegNo.text,
//         "category_id": selectedCategoryId,
//         "create_default_store": true // optional
//       };
//       var response = await authRepo.createBusiness(data);
//       if (response != null) {
//         // await userService.initializer();
//         if (response.statusCode == 200) {
//           if (response.data['email_verified'] == false) {
//             stopLoader();
//             showCustomToast("Email not Verified", toastType: ToastType.success);
//             String emailValue = emailLogin.text;
//             context.replace('/verification/$emailValue');
//           }
//         } else {
//           showCustomToast("Login Successful", toastType: ToastType.success);
//           stopLoader();
//           context.replace('/home');
//         }
//       } else {
//         showCustomToast("Login Successful", toastType: ToastType.success);
//         stopLoader();
//         context.replace('/home');
//       }
//     } catch (e, l) {
//       stopLoader();
//       print(e);
//       print(l);
//     }
//   }

//   final TextEditingController storeName = TextEditingController();
//   final TextEditingController storeAddr = TextEditingController();
//   Future createStore(BuildContext context) async {
//     try {
//       startLoader();
//       var data = {"store_name": storeName.text, "address": storeAddr.text};
//       var response = await authRepo.createStore(data);
//       if (response != null) {
//         // await userService.initializer();
//         showCustomToast("Store Created successfully",
//             toastType: ToastType.success);
//         stopLoader();
//         context.pop();
//       } else {
//         showCustomToast("Store creation failed", toastType: ToastType.error);
//         stopLoader();
//         context.pop();
//       }
//     } catch (e, l) {
//       stopLoader();
//       print(e);
//       print(l);
//     }
//   }

//   int? selectedShop;

//   final TextEditingController userEmail = TextEditingController();
//   Future invite(BuildContext context) async {
//     try {
//       startLoader();
//       var data = {
//         "email": userEmail.text,
//         "role": selectedRole, // manager or storekeeper
//         "store_id": selectedShop
//       };
//       var response = await authRepo.inviteUser(data);
//       if (response != null) {
//         // await userService.initializer();
//         showCustomToast("User Invited successfully",
//             toastType: ToastType.success);
//         stopLoader();
//         context.pop();
//       } else {
//         showCustomToast("User Invitation failed", toastType: ToastType.error);
//         stopLoader();
//         context.pop();
//       }
//     } catch (e, l) {
//       stopLoader();
//       print(e);
//       print(l);
//     }
//   }

//   final TextEditingController ivCode = TextEditingController();
//   Future joinBusiness(BuildContext context) async {
//     try {
//       startLoader();
//       var data = {"invite_code": ivCode.text};
//       var response = await authRepo.joinBusiness(data);
//       if (response != null) {
//         // await userService.initializer();
//         showCustomToast("Welcome", toastType: ToastType.success);
//         stopLoader();
//         context.replace('/home');
//       } else {
//         showCustomToast("Joining failed", toastType: ToastType.error);
//         stopLoader();
//       }
//     } catch (e, l) {
//       stopLoader();
//       print(e);
//       print(l);
//     }
//   }

//        // List of selected images

//   final TextEditingController productName = TextEditingController();
//   final TextEditingController alias = TextEditingController();
//   final TextEditingController productDesc = TextEditingController();
//   final TextEditingController color = TextEditingController();
//   final TextEditingController size = TextEditingController();
//   final TextEditingController weight = TextEditingController();
//   final TextEditingController cprice = TextEditingController();
//   final TextEditingController sprice = TextEditingController();
//   final TextEditingController threshold = TextEditingController();

// Future<void> processAddProduct({required List<PlatformFile> images}) async {
//   startLoader();

//   if (images.length != 4) {
//     stopLoader();
//     showCustomToast("Please select exactly 4 images.", toastType: ToastType.error);
//     return;
//   }

//   List<MultipartFile> imageFiles = [];

//   for (var image in images) {
//     if (image.bytes != null) {
//       // Determine file extension
//       String extension = image.extension?.toLowerCase() ?? 'jpeg';

//       // Map extension to MIME type
//       String mimeType = 'image/jpeg'; // Default
//       if (extension == 'png') {
//         mimeType = 'image/png';
//       } else if (extension == 'webp') {
//         mimeType = 'image/webp';
//       }

//       imageFiles.add(
//         MultipartFile.fromBytes(
//           image.bytes!,
//           filename: image.name,
//           contentType: MediaType('image', mimeType.split('/')[1]),
//         ),
//       );
//     }
//   }

//   // ✅ Convert attributes to JSON (ensure it's a proper JSON string)
//   Map<String, dynamic> productAttributes = {
//     "color": color.text,
//     "size": size.text,
//     "weight": weight.text,
//   };

//   // ✅ Correct FormData
//   FormData formData = FormData.fromMap({
//     "category_id": selectedCategoryId,
//     "store_id": selectedShop,
//     "product_name": productName.text,
//     "alias": alias.text,
//     "description": productDesc.text,
//     "cost_price": cprice.text,
//     "selling_price": sprice.text,
//     "low_stock_threshold": threshold.text,
//     "status": "active",
//     "variation_attributes": jsonEncode(productAttributes), // ✅ Fix JSON format
//   });

//   // ✅ Append images properly as list
//   for (var file in imageFiles) {
//     formData.files.add(MapEntry("images[]", file)); // ✅ Ensure correct array format
//   }

//   print('FINAL FORM DATA: ${formData.fields}');

//   try {
//     var response = await authRepo.addProduct(formData);

//     if (response != null) {
//       await userService.initializer();
//       stopLoader();
//       showCustomToast("Product Added Successfully!", toastType: ToastType.success);
//     } else {
//       stopLoader();
//       showCustomToast("Product Upload Failed", toastType: ToastType.error);
//     }
//   } catch (e, l) {
//     stopLoader();
//     print("Error: $e");
//     print("Stacktrace: $l");
//     showCustomToast("Upload Failed", toastType: ToastType.error);
//   }
// }

//    Future<List<PlatformFile>> pickImages(BuildContext context) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: true,
//       withData: true,

//     );

//   if (result != null  && result.files.length == 4) {
//     for (var file in result.files) {
//         if (file.bytes == null && file.path != null) {
//         // Read the file manually
//         File f = File(file.path!);
//         file = PlatformFile(
//           name: file.name,
//           size: file.size,
//           bytes: await f.readAsBytes(),
//           path: file.path,
//         );
//       }
//       print("Picked file: ${file.name}, Size: ${file.size}, Bytes null? ${file.bytes == null}");
//     }
//     return result.files;
//   } else {
//    showCustomToast("Please select exactly 4 images!",
//             toastType: ToastType.info);
//     return [];
//   }
//   }
}
