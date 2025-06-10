import 'package:flutter/material.dart';
import 'book.dart';
import 'reader_screen.dart';
import 'book_cover.dart';

class HomeScreen extends StatelessWidget {
  final Book book;

  const HomeScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          BookCover(imagePath: book.coverImage, title: book.title),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReaderScreen(book: book)),
                  );
                },
                child: const Text(
                  'Open Book',
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
