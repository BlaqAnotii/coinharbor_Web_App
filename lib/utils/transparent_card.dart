
import 'package:coinharbor/data/https.dart';
import 'package:coinharbor/resources/colors.dart';
import 'package:flutter/material.dart';

class AcesysTransparentCard extends StatelessWidget {
  final Widget child;

  const AcesysTransparentCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        color: AppColors.background
            .withOpacity(userServices.cache.isDarkMode ? 0.5 : 0.7),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: child);
  }
}
