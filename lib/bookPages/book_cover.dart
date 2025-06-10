import 'package:flutter/material.dart';

class BookCover extends StatelessWidget {
  final String imagePath;
  final String title;

  const BookCover({super.key, required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(imagePath, fit: BoxFit.cover),
        Container(color: Colors.black.withOpacity(0.3)),
        Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
