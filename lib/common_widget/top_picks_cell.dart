
import 'dart:math';

import 'package:flutter/material.dart';

import '../common/color_extenstion.dart';

class TopPicksCell extends StatelessWidget {
  final Map iObj;
  const TopPicksCell({super.key, required this.iObj});

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;
    return SizedBox(
        // color: Colors.red,
        width: media.width * 0.32,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 2),
                        blurRadius: 5)
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  chooseImage(),
                  width: media.width * 0.20,
                  height: media.width * 0.30,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              iObj["name"].toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: TColor.showMessage,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              iObj["author"].toString(),
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: TColor.showMessage2,
                fontSize: 18,
              ),
            )
          ],
        ));
  }

  String chooseImage() {
    List pages = List<Map<String, dynamic>>.from(iObj["pages"]);
    var intValue = Random().nextInt(pages.length-1); // Value is >= 0 and < pages.length-1
    return pages[intValue]["img_ur"].toString();
  }
}