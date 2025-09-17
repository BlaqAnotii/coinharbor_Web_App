import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/widgets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppButton extends StatelessWidget {
  final String text;
  final double? height;
  final double? width;

  final VoidCallback? onPressed;
  final bool filled;
  final bool disabled;
  final Color? bg;
  final Color? textColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.filled = true,
    this.disabled = false,
    this.bg,
    this.textColor,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final bool useGradient = filled && bg == null;
    final Color fallbackBg = bg ?? const Color(0xFF8F07E7);
    final Color foregroundColor = textColor ??
        (filled ? Colors.white : const Color(0xFF8F07E7));

    final button = ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(65, 45),
        elevation: 0,
        backgroundColor:
            useGradient ? Colors.transparent : fallbackBg,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        shadowColor: Colors.transparent,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: foregroundColor,
        ),
      ),
    );

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: useGradient
          ? Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF182A88), // lighter shade 3

                    Color(0xFF3344A0), // lighter shade 1
                    Color(0xFF4D5EB8), // lighter shade 2
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: button,
            )
          : button,
    );
  }
}

class AppButton2 extends StatelessWidget {
  final String text;
  final double? height;
  final VoidCallback? onPressed;
  final bool filled;
  final bool disabled;
  final Color? bg;
  final Color? textColor;
  final bool isLoading;

  const AppButton2({
    super.key,
    required this.text,
    this.onPressed,
    this.filled = true,
    this.disabled = false,
    this.isLoading = false,
    this.bg,
    this.textColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        bg ?? (filled ? const Color(0xFF8F07E7) : Colors.white);
    final Color foregroundColor = textColor ??
        (filled ? Colors.white : const Color(0xFF8F07E7));

    return SizedBox(
      width: double.infinity,
      height: height ?? 50,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? CircularProgressIndicator(
                color: foregroundColor,
                strokeWidth: 2.0,
              )
            : Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: foregroundColor, // Important!
                ),
              ),
      ),
    );
  }
}

class AppOutlineButton extends StatelessWidget {
  final String text;
  final double? height;
  final double? width;

  final VoidCallback? onPressed;
  final bool filled;
  final bool disabled;
  final Color? textColor;
  final bool isLoading;
  final String? iconPath;

  const AppOutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.filled =
        false, // Outline button will not be filled by default
    this.disabled = false,
    this.isLoading = false,
    this.textColor,
    this.iconPath,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50,
      child: OutlinedButton(
        onPressed: disabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color(0xFFFFFFFF), // Primary color border
            width: 1.5, // Border width
          ),
          backgroundColor: Colors
              .transparent, // No background color for outline button
          foregroundColor: textColor ??
              const Color(0xFF8F07E7), // Primary color for text
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(100), // Rounded corners
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  if (iconPath != null) ...[
                    const SizedBox(width: 10),
                    SvgIcon(path: iconPath!),
                  ],
                ],
              ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String label;
  final String assetPath;
  final VoidCallback? onTap;

  const SocialButton({
    super.key,
    required this.label,
    required this.assetPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 56,
        width: 162.5,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xff8F7BFF),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(100),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetPath,
              width: 25,
              height: 25,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialButton2 extends StatelessWidget {
  final String label;
  final String assetPath;
  final VoidCallback? onTap;

  const SocialButton2({
    super.key,
    required this.label,
    required this.assetPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 56,
        width: 162.5,
        decoration: BoxDecoration(
          // border: Border.all(
          //   color: AppColors.foundationPurpleLight,
          //   width: 1.0,
          // ),
          borderRadius: BorderRadius.circular(100),
          color: AppColors.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetPath,
              width: 25,
              height: 25,
              color: const Color(0xffffffff),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
