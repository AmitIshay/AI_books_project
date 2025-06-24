import 'package:pjbooks/common/color_extenstion.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;

class SearchGridCell extends StatelessWidget {
  final Map sObj;
  final int index;
  const SearchGridCell({super.key, required this.sObj, required this.index});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: TColor.searchBGColor[index % TColor.searchBGColor.length],
        borderRadius: BorderRadius.circular(20),

      ),
      padding: const EdgeInsets.symmetric(vertical: 21, horizontal: 10),
      width: media.width * 0.32,
      height: media.width * 0.10,
      child: Column(
        children: [
          Text(
            sObj["title"].toString(),
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
                imageUrl: sObj["pages"]?[0]?["img_url"],
                placeholder: (context, url) => CircularProgressIndicator(), // or Shimmer
                errorWidget: (context, url, error) => Icon(Icons.error),
                fadeInDuration: Duration(milliseconds: 200),
                width: media.width * 0.30,
                height: media.width * 0.23 * 1.6,
                fit: BoxFit.cover,
                ),
            ),
        ],
      ),
    );
  }
}
