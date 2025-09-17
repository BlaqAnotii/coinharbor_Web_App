import 'package:coinharbor/resources/colors.dart';
import 'package:flutter/material.dart';

typedef String2VoidCallback = String? Function(String?);
typedef Void2VoidCallback = Function();

class Input extends StatelessWidget {
  final String? placeholder;
  final String? label;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Void2VoidCallback? onTap;
  final String2VoidCallback? onChanged;
  final TextEditingController? controller;
  final bool autofocus;
  late Color? borderColor = AppColors.border;
  late Color? activeBorderColor = AppColors.activeBorder;
  late bool isEnabled = true;
  final bool isPassword;
  late bool isMultiline = false;
  final TextInputType inputType;

  Input(
      {super.key,
      this.placeholder,
      this.suffixIcon,
      this.prefixIcon,
      this.onTap,
      this.onChanged,
      required this.label,
      this.autofocus = false,
      this.isPassword = false,
      this.inputType = TextInputType.text,
      this.borderColor,
      this.activeBorderColor,
      this.controller,
      this.isEnabled = true,
      this.isMultiline = false});

  @override
  Widget build(BuildContext context) {
    if (isMultiline) {
      return TextField(
          cursorColor: AppColors.label,
          maxLines: 3,
          onTap: onTap,
          onChanged: onChanged,
          controller: controller,
          enabled: isEnabled,
          autofocus: autofocus,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: AppColors.text),
          textAlignVertical: TextAlignVertical(y: 0.6),
          keyboardType: inputType,
          obscureText: isPassword,
          decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.background,
              hintStyle: TextStyle(
                color: AppColors.hint,
              ),
              label: Text(label ?? ""),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                      color: borderColor ?? AppColors.border,
                      width: 1.5,
                      style: BorderStyle.solid)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                      color: activeBorderColor ?? AppColors.activeBorder,
                      width: 2.5,
                      style: BorderStyle.solid)),
              hintText: placeholder));
    } else {
      return TextField(
          cursorColor: AppColors.label,
          onTap: onTap,
          onChanged: onChanged,
          controller: controller,
          enabled: isEnabled,
          autofocus: autofocus,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: AppColors.black),
          textAlignVertical: const TextAlignVertical(y: 0.6),
          keyboardType: inputType,
          obscureText: isPassword,
          decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.white,
              hintStyle: TextStyle(
                color: AppColors.hint,
              ),
              label: Text(label ?? ""),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              floatingLabelStyle: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: AppColors.activeBorder),
                  border: const OutlineInputBorder(
                     borderSide: BorderSide(
                      color: Color(0xfff58634),
                      width: 1.5,
                      style: BorderStyle.solid)
                  ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                      color: borderColor ?? AppColors.border,
                      width: 1.5,
                      style: BorderStyle.solid)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                      color: activeBorderColor ?? AppColors.activeBorder,
                      width: 2.5,
                      style: BorderStyle.solid)),
              hintText: placeholder));
    }
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => length > 0
      ? replaceAll(RegExp(' +'), ' ')
          .split(' ')
          .map((str) => str.toCapitalized())
          .join(' ')
      : this;
  String sanitizePhoneNumber() => replaceAll(" ", "").replaceAll("-", "");
  String lastChars(int n) => substring(length - n);
}
