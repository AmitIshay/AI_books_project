import 'package:flutter/material.dart';
import 'package:pjbooks/common/color_extenstion.dart';

Container socialIcon(image) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white, width: 2),
    ),
    child: Image.asset(image, height: 30),
  );
}

Widget buildBackButton(BuildContext context) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios, color: TColor.primary),
      ),
    ),
  );
}

Widget socialButton(String imagePath, VoidCallback onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Image.asset(imagePath, height: 30),
    ),
  );
}
