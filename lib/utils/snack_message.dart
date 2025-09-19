import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/utils/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:oktoast/oktoast.dart';

Widget toast(String message, {ToastType? toastType}) {
  List<Color> listColor = [];
  IconData iconData = Icons.warning;
  if (toastType! == ToastType.error) {
    iconData = Icons.error;
    listColor = [Colors.red, Colors.red];
  } else if (toastType == ToastType.success) {
    iconData = Icons.check_circle;
    listColor = [AppColors.darkGreen, AppColors.darkGreen];
  } else if (toastType == ToastType.info) {
    iconData = Icons.info;
    listColor = [
      AppColors.primary,
      AppColors.primary,
    ];
  } else {
    listColor = [
      AppColors.primary,
      AppColors.primary,
    ];
  }
  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 200,
    ),
    child: Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 50.h),
        padding: EdgeInsets.all(15.0.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: listColor,
          ),
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: Colors.white,
              size: 30,
            ),
            10.0.sbW,
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

showCustomToast(String message,
    {ToastType toastType = ToastType.error, int time = 3}) {
  // dialogLocation(message: message, success: success, time: time);
  showToastWidget(
    toast(message, toastType: toastType),
    duration: Duration(seconds: time),
    onDismiss: () {},
  );
}

enum ToastType { info, error, warning, success }
