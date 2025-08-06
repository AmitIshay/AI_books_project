// import 'package:pjbooks/view/search/search_fiter_view.dart';
import 'package:pjbooks/bookPages/book.dart';
import 'package:pjbooks/bookPages/home_screen.dart';
import 'package:pjbooks/backend/book_service.dart';
import 'package:pjbooks/home/view/home_view.dart';
import 'package:pjbooks/search/search_force_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../common/color_extenstion.dart';
import '../common_widget/AutherCell.dart';
import '../common_widget/genres_cell.dart';
import '../common_widget/history_row.dart';
import '../common_widget/search_grid_cell.dart';
import '../common/extenstion.dart';
import '../home/view/main_tab_view.dart';

class SequelToStory extends StatefulWidget {
  const SequelToStory({super.key});

  @override
  State<SequelToStory> createState() => _SequelToStoryState();
}

class _SequelToStoryState extends State<SequelToStory> {
  TextEditingController txtSearch = TextEditingController();
  BookService service = BookService();
  int selectTag = 0;
  List genres = [
    "Fantasy",
    "Adventure",
    "Fairy Tales",
    "Mystery",
    "Bedtime Stories",
    "Science Fiction",
    "Romance",
    "Horror",
    "Non-Fiction",
    "Biography",
    "History",
    "Thriller",
  ];
  List tagsArr = ["All Books", "Genre", "Book Authors"];
  List allBooks = [];
  List sResultArr = [];
  List authorsList = [];
  @override
  void initState() {
    super.initState();
    load_books();
    loadAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Stack(
      children: [
        Opacity(
          opacity: 0.8,
          child: Image.asset(
            "assets/img/blue-background-with-isometric-book.jpg",
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // חשוב - כדי לא לכסות את הרקע
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                    MaterialPageRoute(builder: (_) => MainTabView())
                );
              },
              icon: Icon(Icons.arrow_back_ios, color: TColor.primary),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: TColor.textbox,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      key: Key("search"),
                      controller: txtSearch,
                      onTap: () async {
                        final selectedBook = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => SearchForceView(
                                  allBooks:
                                      allBooks.cast<Map<String, dynamic>>(),
                                ),
                          ),
                        );
                        if (selectedBook != null &&
                            selectedBook is Map<String, dynamic>) {
                          setState(() {
                            txtSearch.text = selectedBook["title"] ?? '';
                            sResultArr = [
                              // <== עדכון פה
                              {
                                "_id": selectedBook["id"] ?? "",
                                "title": selectedBook["title"] ?? '',
                                "author": selectedBook["author"] ?? '',
                                "description":
                                    selectedBook["description"] ?? '',
                                "num_pages": selectedBook["num_pages"] ?? '',
                                "rating": selectedBook["rating"] ?? 0,
                                "genre": selectedBook["genre"] ?? '',
                                "pages": selectedBook["pages"] ?? [],
                                "img":
                                    selectedBook["pages"]?[0]?["img_url"] ?? '',
                                "comments": selectedBook["comments"] ?? [],
                                "sum_rating": selectedBook["sum_rating"] ?? 0,
                                "counter_rating":
                                    selectedBook["counter_rating"] ?? 0,
                              },
                            ];
                          });
                        }
                        endEditing();
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 8,
                        ),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        hintText: "Search Books or Authors",
                        labelStyle: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
                if (txtSearch.text.isNotEmpty) const SizedBox(width: 8),
                if (txtSearch.text.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      txtSearch.text = "";
                      setState(() {});
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: TColor.text, fontSize: 17),
                    ),
                  ),
              ],
            ),
          ),
          body: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 15,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:
                        tagsArr.map((tagName) {
                          var index = tagsArr.indexOf(tagName);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 15,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectTag = index;
                                });
                              },
                              child: Text(
                                tagName,
                                style: TextStyle(
                                  color:
                                      selectTag == index
                                          ? TColor.text
                                          : TColor.subTitle,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),

              if (txtSearch.text.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: sResultArr.length,
                    itemBuilder: (context, index) {
                      var sObj = sResultArr[index] as Map? ?? {};
                      return HistoryRow(sObj: sObj);
                    },
                  ),
                )
              else
                selectOptionView(selectTag),
            ],
          ),
        ),
      ],
    );
  }

  void load_books() async {
    await service.loadAllBooks();
    setState(() {
      if (service.allBooks.isNotEmpty) {
        allBooks = service.allBooks;
      }
    });
  }

  void openBookById(String bookId, BuildContext context) {
    var fullBook = allBooks.firstWhere(
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

  void loadAllUsers() async {
    BookService service = BookService();
    await service.loadAllUserFromDB();
    setState(() {
      authorsList = service.users;
    });
  }

  Expanded selectOptionView(int selectTag) {
    switch (selectTag) {
      case 0:
        return booksOptionView();
      case 1:
        return genresOptionView();
      case 2:
        return bookWritesOptionView();
    }
    return Expanded(child: SizedBox.shrink());
  }

  Expanded booksOptionView() {
    return allBooks.isNotEmpty? Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.9,
          crossAxisCount: 2,
          crossAxisSpacing: 35,
          mainAxisSpacing: 35,
        ),
        itemCount: allBooks.length,
        itemBuilder: (context, index) {
          var sObj = allBooks[index] as Map? ?? {};
          return GestureDetector(
            onTap: () {
              openBookById(sObj["id"], context);
            },
            child: SearchGridCell(sObj: sObj, index: index),
          );
        },
      ),
    )
        :
    Expanded(child: loadScreen());

  }

  Expanded genresOptionView() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.5,
          crossAxisCount: 3,
          crossAxisSpacing: 25,
          mainAxisSpacing: 35,
        ),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          String bObj = genres[index] ?? "";
          return GenresCell(bObj: bObj, bgcolor: TColor.searchBGColor[index]);
        },
      ),
    );
  }

  Expanded bookWritesOptionView() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.5,
          crossAxisCount: 3,
          crossAxisSpacing: 25,
          mainAxisSpacing: 35,
        ),
        itemCount: authorsList.length,
        itemBuilder: (context, index) {
          Map bObj = authorsList[index];
          return AuthorCell(user: bObj);
        },
      ),
    );
  }
  loadScreen() {
    return Scaffold(
      backgroundColor: TColor.primary,
      body: Center(
        child: SpinKitCircle(
          size: 140,
          itemBuilder: (context, index) {
            final colors = [Colors.white, Colors.blue, Colors.indigoAccent];
            final color = colors[index % colors.length];
            return DecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            );
          },
        ),
      ),
    );
  }
}
