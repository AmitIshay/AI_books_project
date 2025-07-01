import 'dart:math';

import 'package:pjbooks/common/color_extenstion.dart';
import 'package:flutter/material.dart';

import '../search/booksByAutherView.dart';

class AuthorCell extends StatefulWidget {
  final Map user;
  const AuthorCell({super.key, required this.user});

  @override
  State<AuthorCell> createState() => _AutherViewState();
}

class _AutherViewState extends State<AuthorCell> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      index = Random().nextInt(10);
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthorView(user: widget.user), // pass genre
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: TColor.searchBGColor[index % TColor.searchBGColor.length],
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 10),
        width: media.width * 0.32,
        height: media.width * 0.10,
        child: Column(
          children: [
            Icon(Icons.account_circle, color: TColor.primary),
            const SizedBox(height: 15),

            Text(
              widget.user["full_name"].toString(),
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 35,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.user["bio"].toString(),
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "${widget.user["numBooks"].toString()} book",
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
