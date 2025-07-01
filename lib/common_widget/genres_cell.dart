import 'package:flutter/material.dart';
import 'package:pjbooks/home/view/genre_view.dart';

class GenresCell extends StatelessWidget {
  final String bObj;
  final Color bgcolor;
  const GenresCell({super.key, required this.bObj, required this.bgcolor});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenreView(genre: bObj), // pass genre
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: bgcolor,
          borderRadius: BorderRadius.circular(15),
        ),
        // color: Colors.red,
        width: media.width * 0.35,
        height: media.width * 0.35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.asset(
            //       bObj["img"].toString(),
            //       width: media.width * 0.7,
            //       height: media.width * 0.35,
            //       fit: BoxFit.fitWidth,
            //     ),
            const SizedBox(height: 15),
            Text(
              bObj.toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
