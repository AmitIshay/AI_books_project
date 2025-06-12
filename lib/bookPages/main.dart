import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'book.dart';

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sampleBook = Book(
      title: 'sample book',
      coverImage: 'assets/images/cover.jpg',
      pages: [
        // BookPage(
        //   imagePath: 'assets/images/image1.jpg',
        //   text: 'the begin of our story',
        // ),
        // BookPage(
        //   imagePath: 'assets/images/image2.jpg',
        //   text: ' the animals go to the trip',
        // ),
        // BookPage(
        //   imagePath: 'assets/images/image3.jpg',
        //   text: 'the trip keep contusion with many obstetrical',
        // ),
        // BookPage(imagePath: '', text: '', isEndPage: true),
      ],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true, // << Modern Material Design
      ),
      home: HomeScreen(book: sampleBook),
    );
  }
}
