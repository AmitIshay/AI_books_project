import 'package:flutter/material.dart';

void main() {
  runApp(BookApp());
}

class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: BookScreen(), debugShowCheckedModeBanner: false);
  }
}

class BookScreen extends StatelessWidget {
  final List<String> pages = List.generate(
    10,
    (index) =>
        "This is the content of page ${index + 1}. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
  );

  BookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int numDoublePages = (pages.length / 2).ceil();

    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(title: Text('My Book'), backgroundColor: Colors.brown),
      body: PageView.builder(
        controller: PageController(viewportFraction: 0.95),
        itemCount: numDoublePages + 2, // +2 for front & back cover
        itemBuilder: (context, index) {
          if (index == 0) {
            return BookCover(isFront: true);
          } else if (index == numDoublePages + 1) {
            return BookCover(isFront: false);
          }

          final realIndex = index - 1;
          final leftPage =
              pages.length > realIndex * 2 ? pages[realIndex * 2] : null;
          final rightPage =
              pages.length > realIndex * 2 + 1
                  ? pages[realIndex * 2 + 1]
                  : null;

          return Row(
            children: [
              Expanded(child: BookPage(content: leftPage)),
              Expanded(child: BookPage(content: rightPage)),
            ],
          );
        },
      ),
    );
  }
}

class BookPage extends StatelessWidget {
  final String? content;

  const BookPage({super.key, this.content});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.brown),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            content ?? '',
            style: TextStyle(fontSize: 18, height: 1.5),
          ),
        ),
      ),
    );
  }
}

class BookCover extends StatelessWidget {
  final bool isFront;

  const BookCover({super.key, required this.isFront});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: isFront ? Colors.brown[300] : Colors.brown[700],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.brown[800]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 6,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            isFront
                ? 'Front Cover\nMy Book Title'
                : 'Back Cover\nThank you for reading!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
