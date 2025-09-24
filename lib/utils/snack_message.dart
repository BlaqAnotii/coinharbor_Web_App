import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/utils/widget_extensions.dart';
import 'package:coinharbor/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:oktoast/oktoast.dart';

Widget toast(String message, {ToastType? toastType}) {
  Color listColor = AppColors.darkBlue;
  IconData iconData = Icons.warning;
  if (toastType! == ToastType.error) {
    iconData = Icons.error;
    listColor = AppColors.red;
  } else if (toastType == ToastType.success) {
    iconData = Icons.check_circle;
    listColor = AppColors.darkGreen;
  } else if (toastType == ToastType.info) {
    iconData = Icons.info;
    listColor = AppColors.darkBlue;
  } else {
    listColor = AppColors.primary;
  }



  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
    ),
    child: Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 50.h),
        padding: EdgeInsets.all(15.0.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.white,
            border: Border.all(color: listColor)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: listColor,
                size: 30,
              ),
            ),
            10.0.sbW,
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.blacks,
                  fontWeight: FontWeight.w600,
                  fontSize: 17.0,
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
    {ToastType toastType = ToastType.error, int time = 10}) {
  // dialogLocation(message: message, success: success, time: time);
  showToastWidget(
    toast(message, toastType: toastType),
    duration: Duration(seconds: time),
    onDismiss: () {},
  );
}

enum ToastType { info, error, warning, success }
