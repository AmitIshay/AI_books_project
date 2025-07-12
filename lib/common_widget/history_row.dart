import 'dart:convert' show jsonEncode;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:pjbooks/backend/user_prefs.dart';
import 'package:pjbooks/features/create_own_story.dart';
import 'package:pjbooks/backend/config.dart' show Config;
import '../backend/book_service.dart';
import '../bookPages/book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bookPages/home_screen.dart';
import '../common/color_extenstion.dart';
import 'comment_card.dart';

class HistoryRow extends StatefulWidget {
  final Map sObj;

  const HistoryRow({super.key, required this.sObj});

  @override
  State<HistoryRow> createState() => _HistoryRowState();
}

class _HistoryRowState extends State<HistoryRow> {
  double rating = 0.0;

  bool canDelete = false;
  double heightButton = 60;
  late List comments;
  late double totalCounterRanking;
  late double sumRanking;
  late double rankStory;
  late BookService service;
  late TextEditingController commentTextController;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    TextEditingController commentTextController = TextEditingController();
    Map<String, dynamic> mapComment;

    return Container(
      key: Key("book_${widget.sObj["title"].toString()}"),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      GestureDetector(
          key: Key("Read Book"),
          onTap:() {
          openBookById(widget.sObj["_id"] , context);
          },
          child:
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl:widget.sObj["img"] ?? "",
              placeholder:
                  (context, url) => CircularProgressIndicator(), // or Shimmer
              errorWidget: (context, url, error) => Icon(Icons.error),
              fadeInDuration: Duration(milliseconds: 200),
              width: media.width * 0.20,
              height: media.width * 0.30,
              fit: BoxFit.cover,
            ),
          )

      ),

          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                Text(
                  widget.sObj["title"].toString(),
                  maxLines: 3,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: TColor.text,
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.sObj["author"].toString(),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  style: TextStyle(color: TColor.subTitle, fontSize: 25),
                ),
                const SizedBox(height: 10),
                IgnorePointer(
                  ignoring: true,
                  child: RatingBar.builder(
                    initialRating: rankStory,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 20,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder:
                        (context, _) => Icon(Icons.star, color: TColor.primary),
                    onRatingUpdate: (rating) {},
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.sObj["genre"].toString(),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: TColor.subTitle.withOpacity(0.3),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: heightButton,
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
                                          widget.sObj,
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
                              key: Key("make sequel"),
                              'Create sequel to this story',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),
                    canDelete == true
                        ? Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: heightButton,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: TColor.button2,
                                ),
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
                                onPressed: () async {
                                  final token = await UserPrefs.getToken();
                                  if (token == null) return;
                                  String idBook = widget.sObj["_id"];
                                  final respond = await http.delete(
                                    Uri.parse(
                                      '${Config.baseUrl}/api/books/delete/id=$idBook',
                                    ),
                                    headers: {
                                      'Content-Type': 'application/json',
                                      'Authorization': 'Bearer $token',
                                    },
                                  );
                                  if (respond.statusCode == 200) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("book has been deleted"),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "ERROR could not delete book",
                                        ),
                                      ),
                                    );
                                    // טפל בשגיאות כאן
                                    print(
                                      'Error loading books: ${respond.body}',
                                    );
                                    return;
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                child: const Text(
                                  'Delete Story',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
                    const SizedBox(width: 12),
                  ],
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: heightButton,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.button3),
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
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text(
                                  "new comment for book ${widget.sObj["title"].toString()}",
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      TextField(
                                        controller: commentTextController,
                                        decoration: const InputDecoration(
                                          labelText: "comment",
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        minLines: 3,
                                      ),

                                      SizedBox(height: 10),
                                      RatingBar.builder(
                                        initialRating: 3,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                        ),
                                        itemBuilder:
                                            (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                        onRatingUpdate: (ratingInput) {
                                          rating = ratingInput;
                                        },
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      String comment =
                                          commentTextController.text.trim();
                                      mapComment = {
                                        "comment": comment,
                                        "rating": rating,
                                      };
                                      String id = widget.sObj["_id"].toString();
                                      final token = await UserPrefs.getToken();
                                      if (token == null) Navigator.pop(context);
                                      final response = await http.put(
                                        Uri.parse(
                                          '${Config.baseUrl}/api/books/newCommentAndRanking/id=$id',
                                        ),
                                        headers: {
                                          'Content-Type': 'application/json',
                                          'Authorization': 'Bearer $token',
                                        },
                                        body: jsonEncode(mapComment),
                                      );

                                      if (response.statusCode == 200) {
                                        String userName =
                                            await UserPrefs.getFullName() ??
                                            "unknown user";
                                        setState(() {
                                          comments.add({
                                            "user": userName,
                                            "comment": comment,
                                          });
                                          rankStory =
                                              (sumRanking += rating) /
                                              (totalCounterRanking += 1);
                                        });
                                      }
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("comment added"),
                                        ),
                                      );
                                    },
                                    child: Text("Submit"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Error Could Not Add Comment",
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text("Cancel"),
                                  ),
                                ],
                              ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        'New Comment',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 23,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: comments.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return CommentCard(objComments: comments[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> createListForTest() {
    return [
      {
        "user": "LiamTheReader",
        "comment":
            "My little brother loved the page with the talking animals! He laughed so much at the lion wearing glasses.",
      },
      {
        "user": "MomOfTwins",
        "comment":
            "Such a cute story! My kids asked me to read it three times before bed. The colorful pictures are magical!",
      },
      {
        "user": "Ella8",
        "comment":
            "I liked the part where the bear danced in the forest! Can you make more pages with singing animals?",
      },
      {
        "user": "StoryTimeDad",
        "comment":
            "The characters are super fun, and the lesson about kindness really stood out. Great job!",
      },
      {
        "user": "ZoeLovesBooks",
        "comment":
            "I think the bunny is my favorite character ever! She’s so brave and kind. Can’t wait to read more!",
      },

      {
        "user": "LiamTheReader",
        "comment":
            "My little brother loved the page with the talking animals! He laughed so much at the lion wearing glasses.",
      },
      {
        "user": "MomOfTwins",
        "comment":
            "Such a cute story! My kids asked me to read it three times before bed. The colorful pictures are magical!",
      },
      {
        "user": "Ella8",
        "comment":
            "I liked the part where the bear danced in the forest! Can you make more pages with singing animals?",
      },
      {
        "user": "StoryTimeDad",
        "comment":
            "The characters are super fun, and the lesson about kindness really stood out. Great job!",
      },
      {
        "user": "ZoeLovesBooks",
        "comment":
            "I think the bunny is my favorite character ever! She’s so brave and kind. Can’t wait to read more!",
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    final rawComments = widget.sObj["comments"];
    comments =
        (rawComments is List && rawComments.isNotEmpty)
            ? rawComments
            : createListForTest();
    commentTextController = TextEditingController();
    totalCounterRanking = widget.sObj["sum_rating"].toDouble() ?? 0.0;
    sumRanking = widget.sObj["counter_rating"].toDouble() ?? 0.0;
    rankStory =
        widget.sObj["rating"].toDouble() == 0.0
            ? 2.5
            : widget.sObj["rating"].toDouble();
    service = BookService();
    checkDeleteOption();
  }

  Future<void> checkDeleteOption() async {
    String idBook = widget.sObj["_id"];
    final token = await UserPrefs.getToken();
    if (token == null) {
      setState(() {
        canDelete = false;
      });
      return;
    }
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/books/checkDeleteOption/id=$idBook'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        canDelete = true;
      });
    } else {
      setState(() {
        canDelete = false;
      });
    }
  }



  void openBookById(String bookId, BuildContext context) {

    final Book newBook = Book(
      title: widget.sObj["title"] ?? "",
      coverImage: widget.sObj["pages"]?[0]?["img_url"] ?? "",
      pages:
      (widget.sObj["pages"] as List<dynamic>? ?? []).map((page) {
        return BookPage(
          imagePath: page["img_url"] ?? "",
          text: page["text_page"] ?? "",
          voiceUrl: page["voice_file_url"] ?? "",
        );
      }).toList()
        ..add(
          BookPage(imagePath: "", text: "", voiceUrl: "", isEndPage: true),
        ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(book: newBook)),
    );
  }
}
