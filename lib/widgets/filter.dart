import 'package:coinharbor/resources/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FilterDropDown extends StatelessWidget {
  String? selectedValue;
  final String hint;
  final Function(String?) onChanged;
  final List<String> items;

  FilterDropDown({
    super.key,
    required this.selectedValue,
    required this.hint,
    required this.onChanged,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 145,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey),
      ),
      padding: const EdgeInsets.only(
        left: 5,
      ),
      child: SizedBox(
        width: 80,
        child: DropdownButton<String>(
          isExpanded: true,
          underline: Container(),
          hint: Text(
            hint,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          value: selectedValue,
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(
                hint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            for (String item in items)
              DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
          borderRadius: BorderRadius.circular(5),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
