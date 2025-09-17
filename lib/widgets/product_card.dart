

import 'package:coinharbor/resources/colors.dart';
import 'package:coinharbor/utils/widget_extensions.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String category;
  final String price;
  final String imagePath;

  const ProductCard({
    Key? key,
    required this.name,
    required this.category,
    required this.price,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppColors.white,
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity, scale: 4,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(category, style: const TextStyle(fontSize: 12, color: Colors.orange)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              20.0.sbW,
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                  ),
                ),
                  ],
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}