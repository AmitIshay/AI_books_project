import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});
  @override
  State<StatefulWidget> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageFlipWidget(
        initialIndex: 0,
        lastPage: Center(
          child: Text(
            "The End",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        isRightSwipe: true,
        duration: const Duration(seconds: 1),
        children: [
          Pages(index: 1),
          Pages(index: 2),
        ],
      ),
    );
  }
}

class Pages extends StatelessWidget {
  final int index;

  const Pages({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/img/dog_$index.jpg'), fit: BoxFit.cover),
      ),
      // color: index.isEven ? Colors.lightBlueAccent : Colors.amberAccent,
      child: Center(
        child: Text(
          "Page $index",
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 5.0,
                  color: Colors.black,
                  offset: Offset(2.0, 2.0),
                ),
              ]),
        ),
      ),
    );
  }
}
