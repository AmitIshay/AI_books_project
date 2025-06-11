import 'package:flutter/material.dart';
import 'book.dart';
// import 'bookpageviewer.dart';
import 'double_page_viewer.dart'; // <-- שימי לב: לא double_page_viewer.dart

class ReaderScreen extends StatelessWidget {
  final Book book;

  const ReaderScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      //body: BookPageViewer(pages: book.pages), //one screen per on page
      body: DoublePageBookViewer(pages: book.pages), //one screen two pages
    );
  }
}
