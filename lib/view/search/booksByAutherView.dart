
import 'package:pjbooks/common/color_extenstion.dart';
import 'package:flutter/material.dart';

import '../../bookPages/book.dart';
import '../../bookPages/home_screen.dart';
import '../../book_service.dart';
import '../../common_widget/top_picks_cell.dart';

import '../book_reading/book_reading_view.dart';
import '../main_tab/main_tab_view.dart';

class AuthorView extends StatefulWidget {
  final Map user;

  const AuthorView({super.key,required this.user});

  @override
  State<AuthorView> createState() => _AuthorViewState();
}

class _AuthorViewState extends State<AuthorView> {

  List booksUser = [];


  @override
  void initState() {
    super.initState();
    loadBookBaseOnId();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Align(
                      child: Transform.scale(
                        scale: 1.5,
                        origin: Offset(0, media.width * 0.8),
                        child: Container(
                          width: media.width,
                          height: media.width,
                          decoration: BoxDecoration(
                            color: TColor.primary,
                            borderRadius: BorderRadius.circular(media.width * 0.5),
                          ),
                        ),
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          leading: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios, color: TColor.showMessage),
                          ),
                          actions: [
                            IconButton(
                              key: const Key("menu"),
                              onPressed: () {
                                sideMenuScaffoldKey.currentState?.openEndDrawer();
                              },
                              icon: const Icon(Icons.menu, size: 30),
                            ),
                          ],
                        )

                        ,Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // SizedBox(height: media.width * 0.1),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  //TODO change this text to the account  view one
                                  Text(
                                    widget.user["full_name"].toString(),
                                    style: TextStyle(
                                      color: TColor.text,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15,),
                            containerBio(media, widget.user["bio"]),
                            const SizedBox(height: 15,),
                            containerLocation(media, widget.user["location"]),
                            const SizedBox(height: 10,),

                          ],
                        ),
                        const SizedBox(height: 25,),
                        booksUser.isEmpty ? Text(
                          textAlign: TextAlign.center,
                          "${widget.user["full_name"].toString()} did not wrote any books so far...",
                          style: TextStyle(
                            color: TColor.showMessage,
                            fontSize: 42,
                            fontWeight: FontWeight.w700,
                          ),
                        ):
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: booksUser.map<Widget>((item) {
                              final bObj = item as Map? ?? {};

                              return GestureDetector(
                                onTap: () {
                                  openBookById(bObj["id"], context);
                                },
                                child: TopPicksCell(iObj: bObj),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),

                  ],
                ),]
          ),
        )
    );
  }

  void loadBookBaseOnId()
  async{
    BookService service = BookService();
    await service.loadBooksByUser(widget.user["id"]);
    setState(() {
      booksUser = service.bookDiffrentUser;
    });
  }

  Container containerBio(dynamic media , String bio)
  {
    return Container(
      width: media.width*0.6,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(8),
      child:
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.edit_note, color: TColor.primary),
          const SizedBox(width: 8),
          Expanded(
            child:
             Text(
              bio.isNotEmpty
                  ? bio
                  : "No bio ",
              style: TextStyle(
                color: TColor.showMessage,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(height: 12),

        ],
      ),

    );
  }
  Container containerLocation(dynamic media , String location)
  {
    return Container(
      width: media.width*0.6,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(8),
      child:
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_city, color: TColor.primary),
          const SizedBox(width: 8),
          Expanded(
            child:
            Text(
              location.isNotEmpty
                  ? location
                  : "No Location Found ",
              style: TextStyle(
                color: TColor.showMessage,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(height: 12),

        ],
      ),

    );
  }
//TODO: this func is found in more places , best to move it into one file
  void openBookById(String bookId, BuildContext context) {
    var fullBook = booksUser.firstWhere(
          (book) => book['id'] == bookId,
      orElse: () => <String, dynamic>{},
    );

    if (fullBook.isEmpty) {
      // אפשר להציג הודעת שגיאה
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Book not found.")));
      return;
    }

    final Book newBook = Book(
      title: fullBook["title"] ?? "",
      coverImage: fullBook["pages"]?[0]?["img_url"] ?? "",
      pages:
      (fullBook["pages"] as List<dynamic>? ?? []).map((page) {
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
