import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pjbooks/features/create_own_story.dart';

import '../common/color_extenstion.dart';

class HistoryRow extends StatelessWidget {
  final Map sObj;
  const HistoryRow({super.key, required this.sObj});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      key: Key("book_${sObj["title"].toString()}"),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              sObj["img"] ?? "",
              width: media.width * 0.25,
              height: media.width * 0.25 * 1.6,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                Text(
                  sObj["title"].toString(),
                  maxLines: 3,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: TColor.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  sObj["author"].toString(),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: TColor.subTitle, fontSize: 13),
                ),
                const SizedBox(height: 8),
                IgnorePointer(
                  ignoring: true,
                  child: RatingBar.builder(
                    initialRating:
                        double.tryParse(sObj["rating"].toString()) ?? 1,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 15,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder:
                        (context, _) => Icon(Icons.star, color: TColor.primary),
                    onRatingUpdate: (rating) {},
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  sObj["genre"].toString(),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: TColor.subTitle.withOpacity(0.3),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 30.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: TColor.button),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: TColor.primary,
                                blurRadius: 2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CreateOwnStory(
                                        bookData: Map<String, dynamic>.from(
                                          sObj,
                                        ),
                                      ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            child: const Text(
                              'Create sequel to this story',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),
                    // Expanded(
                    //   child: Container(
                    //     height: 30.0,
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(10),
                    //       boxShadow: const [
                    //         BoxShadow(
                    //           color: Colors.black12,
                    //           blurRadius: 2,
                    //           offset: Offset(0, 2),
                    //         ),
                    //       ],
                    //     ),
                    //     child: ElevatedButton(
                    //       onPressed: () {},
                    //       style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.transparent,
                    //         foregroundColor: TColor.text,
                    //         shadowColor: Colors.transparent,
                    //       ),
                    //       child: Text(
                    //         'Add to wishlist',
                    //         style: TextStyle(color: TColor.text, fontSize: 12),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
