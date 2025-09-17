import 'package:auto_size_text/auto_size_text.dart';
import 'package:coinharbor/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ButtonType { fill, outline, text, gradient }

class AppSwitchButton extends StatelessWidget {
  const AppSwitchButton(
      {super.key, required this.value, required this.onChanged});

  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
        activeColor: AppColors.primary,
        inactiveThumbColor: AppColors.white,
        inactiveTrackColor: AppColors.grey,
        value: value,
        onChanged: onChanged);
  }
}

class AppGradientButton extends StatelessWidget {
  final double fontSize;
  final Function onPressed;
  final String title;
  final IconData? buttonIcon;
  final ButtonType? buttonType;
  final Color? textColor;
  late Color? buttonBgColor1 = AppColors.secondary;
  late Color? buttonBgColor2 = AppColors.primary;
  final bool? loading;
  AppGradientButton(
      {super.key,
      this.fontSize = 14.0,
      required this.onPressed,
      required this.title,
      this.buttonIcon,
      this.textColor = AppColors.white,
      this.buttonType = ButtonType.gradient,
      this.buttonBgColor1,
      this.buttonBgColor2,
      this.loading = false,
      s});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      // onTap: onPressed,
      onTap: (loading != null && loading!) ? null : () => onPressed(),
      child: Center(
        child: Container(
          height: 60.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.h),
            color: buttonType == ButtonType.gradient
                ? null
                : buttonType == ButtonType.outline
                    ? buttonBgColor2 ?? Colors.transparent
                    : (loading != null && loading!)
                        ? buttonBgColor1!.withOpacity(0.6)
                        : buttonBgColor1!,
            border: constructBorder(),
            gradient: buttonType == ButtonType.gradient
                ? LinearGradient(
                    colors: (loading != null && loading!)
                        ? [
                            buttonBgColor1!.withOpacity(0.5),
                            buttonBgColor2!.withOpacity(0.5)
                          ]
                        : [buttonBgColor1!, buttonBgColor2!],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
          ),
          child: Stack(
            children: [
              if (loading != null && loading!)
                Positioned(
                  left: 25.h,
                  top: 17.h,
                  child: SizedBox(
                    width: 16.h,
                    height: 16.h,
                    child: CircularProgressIndicator(
                      color: textColor!,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              Center(
                child: AutoSizeText(
                  title,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: 'Inter',
                    color: textColor,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              buttonIcon != null
                  ? Positioned(
                      right: 0.h,
                      top: 0.h,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.h),
                              color: buttonType == ButtonType.gradient
                                  ? AppColors.white
                                  : Colors.transparent,
                              border: constructBorder()),
                          width: 60.0.h,
                          height: 60.0.h,
                          child: Icon(buttonIcon,
                              color: Colors.black, size: 20.h)))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Border constructBorder() {
    if (buttonType == ButtonType.outline) {
      return Border.all(
        color: loading! ? AppColors.grey : buttonBgColor1!,
        width: 1.w,
      );
    } else {
      return Border.all(
        color: Colors.grey.withOpacity(0.5),
        width: 0.w,
      );
    }
  }
}

class AppButton extends StatelessWidget {
  final double borderRadius;
  final double fontSize;
  final String title;
  final bool busy;
  final Border? border;
  final Function onPressed;
  Color? buttonBgColor;
  final double? radius;
  final Color? loadingColor;
  late Color? buttonTextColor = AppColors.white;
  late Color? leadingIconColor = AppColors.white;
  late Color? trailingIconColor = AppColors.white;
  final bool? disabled;
  // final FontWeight fontWeight;
  final ButtonType? buttonType;
  final String? leadingIcon;
  final String? trailingIcon;
  final double trailingIconSpace;
  final EdgeInsets? padding;
  final bool? loading;
  AppButton({
    super.key,
    this.borderRadius = 8.0,
    this.border,
    this.fontSize = 15.0,
    this.trailingIconSpace = 4.0,
    required this.onPressed,
    this.buttonBgColor,
    this.buttonTextColor,
    required this.title,
    this.leadingIcon,
    this.trailingIcon,
    this.leadingIconColor,
    this.trailingIconColor,
    this.busy = false,
    this.loadingColor,
    this.disabled,
    this.padding,
    this.loading,
    this.buttonType = ButtonType.fill,
    this.radius,
  });

  Color getBackgroundColor() {
    if (buttonType == ButtonType.outline) {
      return Colors.transparent;
    } else if (buttonType == ButtonType.fill) {
      return buttonBgColor ?? AppColors.primary;
    } else {
      return Colors.transparent;
    }
  }

  Color getColor() {
    if (buttonType == ButtonType.fill) {
      return buttonTextColor != null ? buttonTextColor! : AppColors.white;
    } else if (buttonType == ButtonType.outline) {
      return buttonTextColor!;
    } else {
      return buttonTextColor != null ? buttonTextColor! : buttonBgColor!;
    }
  }

  Border constructBorder() {
    if (border != null) {
      return border!;
    }
    if (buttonType == ButtonType.outline) {
      return Border.all(
        color: getColor(),
        width: 0.2.w,
      );
    } else {
      return Border.all(
        color: Colors.transparent,
        width: 0.w,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getColor();
    final bgColor = getBackgroundColor();
    return GestureDetector(
      // onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      onTap: ((disabled != null && disabled!) || loading != null && loading!)
          ? null
          : () => onPressed(),
      child: Container(
        height: 60.h,
        padding: padding ??
            EdgeInsets.symmetric(
              vertical: 18.0.h,
            ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 10),
          color:
              (disabled != null && disabled!) || (loading != null && loading!)
                  ? bgColor.withOpacity(0.6)
                  : bgColor,
          border: constructBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leadingIcon != null)
              Container(
                margin: EdgeInsets.only(right: 20.w),
                child: Image.asset(
                  leadingIcon!,
                  height: 20.h,
                  width: 20.w,
                ),
              ),
            loading != null && loading!
                ? const AutoSizeText(
                    'PLEASE WAIT...',
                    textScaleFactor: 1.2,
                  )
                : AutoSizeText(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: color,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            if (trailingIcon != null) SizedBox(width: trailingIconSpace),
            if (trailingIcon != null)
              Image.asset(
                trailingIcon!,
                height: 20.h,
                width: 20.w,
              ),
            if (loading != null && loading!)
              SizedBox(
                width: 16.w,
                height: 16.h,
                child: CircularProgressIndicator(
                  color: loadingColor ?? color,
                  strokeWidth: 3,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class AppButton3 extends StatelessWidget {
  final double borderRadius;
  final double fontSize;
  final String title;
  final bool busy;
  final Border? border;
  final Function onPressed;
  late Color? buttonBgColor = AppColors.primary;
  final double? radius;
  final Color? loadingColor;
  final Color? buttonTextColor;
  final Color? leadingIconColor;
  final Color? trailingIconColor;
  final bool? disabled;
  // final FontWeight fontWeight;
  final ButtonType? buttonType;
  final String? leadingIcon;
  final String? trailingIcon;
  final double trailingIconSpace;
  final EdgeInsets? padding;
  final bool? loading;
  AppButton3({
    super.key,
    this.borderRadius = 8.0,
    this.border,
    this.fontSize = 14.0,
    this.trailingIconSpace = 4.0,
    required this.onPressed,
    this.buttonBgColor,
    this.buttonTextColor = AppColors.white,
    required this.title,
    this.leadingIcon,
    this.trailingIcon,
    this.leadingIconColor = AppColors.white,
    this.trailingIconColor = AppColors.white,
    this.busy = false,
    this.loadingColor,
    this.disabled,
    this.padding,
    this.loading,
    this.buttonType = ButtonType.fill,
    this.radius,
  });

  Color getBackgroundColor() {
    if (buttonType == ButtonType.outline) {
      return Colors.transparent;
    } else if (buttonType == ButtonType.fill) {
      return buttonBgColor!;
    } else {
      return Colors.transparent;
    }
  }

  Color getColor() {
    if (buttonType == ButtonType.fill) {
      return buttonTextColor != null ? buttonTextColor! : AppColors.white;
    } else if (buttonType == ButtonType.outline) {
      return buttonTextColor!;
    } else {
      return buttonTextColor != null ? buttonTextColor! : buttonBgColor!;
    }
  }

  Border constructBorder() {
    if (border != null) {
      return border!;
    }
    if (buttonType == ButtonType.outline) {
      return Border.all(
        color: getColor(),
        width: 1.w,
      );
    } else {
      return Border.all(
        color: Colors.transparent,
        width: 0.w,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getColor();
    final bgColor = getBackgroundColor();
    return InkWell(
      splashColor: AppColors.primary,
      // onTap: onPressed,
      onTap: ((disabled != null && disabled!) || loading != null && loading!)
          ? null
          : () => onPressed(),
      child: Container(
        height: 60.h,
        padding: padding ??
            EdgeInsets.symmetric(
              vertical: 13.0.h,
            ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 50.h),
          color:
              (disabled != null && disabled!) || (loading != null && loading!)
                  ? bgColor.withOpacity(0.6)
                  : bgColor,
          border: constructBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leadingIcon != null)
              Container(
                margin: EdgeInsets.only(right: 20.w),
                child: Image.asset(
                  leadingIcon!,
                  height: 20.h,
                  width: 20.w,
                ),
              ),
            loading != null && loading!
                ? const Text('')
                : AutoSizeText(
                    title.toUpperCase(),
                    // ignore: deprecated_member_use
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1.0,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: 'Montserrat',
                      color: color,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            if (trailingIcon != null) SizedBox(width: trailingIconSpace),
            if (trailingIcon != null)
              Image.asset(
                trailingIcon!,
                height: 20.h,
                width: 20.w,
              ),
            if (loading != null && loading!)
              SizedBox(
                width: 16.w,
                height: 16.h,
                child: CircularProgressIndicator(
                  color: loadingColor ?? color,
                  strokeWidth: 3,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class AppButton4 extends StatelessWidget {
  final double borderRadius;
  final double fontSize;
  final String? title;
  final bool busy;
  final Border? border;
  final Function onPressed;
  late Color? buttonBgColor = AppColors.primary;
  final double? radius;
  final Color? loadingColor;
  late Color? buttonTextColor = AppColors.white;
  late Color? leadingIconColor = AppColors.white;
  late Color? trailingIconColor = AppColors.white;
  final bool? disabled;
  // final FontWeight fontWeight;
  final ButtonType? buttonType;
  final IconData leadingIcon;
  final String? trailingIcon;
  final double trailingIconSpace;
  final EdgeInsets? padding;
  final bool? loading;
  AppButton4({
    super.key,
    this.borderRadius = 8.0,
    this.border,
    this.fontSize = 14.0,
    this.trailingIconSpace = 4.0,
    required this.onPressed,
    this.buttonBgColor,
    this.buttonTextColor,
    this.title,
    required this.leadingIcon,
    this.trailingIcon,
    this.leadingIconColor,
    this.trailingIconColor,
    this.busy = false,
    this.loadingColor,
    this.disabled,
    this.padding,
    this.loading,
    this.buttonType = ButtonType.fill,
    this.radius,
  });

  Color getBackgroundColor() {
    if (buttonType == ButtonType.outline) {
      return Colors.transparent;
    } else if (buttonType == ButtonType.fill) {
      return buttonBgColor!;
    } else {
      return Colors.transparent;
    }
  }

  Color getColor() {
    if (buttonType == ButtonType.fill) {
      return buttonTextColor != null ? buttonTextColor! : AppColors.white;
    } else if (buttonType == ButtonType.outline) {
      return buttonTextColor!;
    } else {
      return buttonTextColor != null ? buttonTextColor! : buttonBgColor!;
    }
  }

  Border constructBorder() {
    if (border != null) {
      return border!;
    }
    if (buttonType == ButtonType.outline) {
      return Border.all(
        color: AppColors.blue,
        width: 1.w,
      );
    } else {
      return Border.all(
        color: Colors.transparent,
        width: 0.w,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //final _color = getColor();
    final bgColor = getBackgroundColor();
    return InkWell(
      splashColor: AppColors.primary,
      // onTap: onPressed,
      onTap: ((disabled != null && disabled!) || loading != null && loading!)
          ? null
          : () => onPressed(),
      child: Container(
        height: 60.h,
        padding: padding ??
            EdgeInsets.symmetric(
              vertical: 13.0.h,
            ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 50.h),
          color:
              (disabled != null && disabled!) || (loading != null && loading!)
                  ? bgColor.withOpacity(0.6)
                  : bgColor,
          border: constructBorder(),
        ),
        child: loading != null && loading! ? Container() : Icon(leadingIcon),
      ),
    );
  }
}
