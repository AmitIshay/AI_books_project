// import 'package:pjbooks/view/search/search_fiter_view.dart';
import 'package:pjbooks/book_service.dart';
import 'package:pjbooks/view/search/search_force_view.dart';
import 'package:flutter/material.dart';

import '../common/color_extenstion.dart';
import '../common_widget/history_row.dart';
import '../common_widget/search_grid_cell.dart';
import '../common/extenstion.dart';

class SequelToStory extends StatefulWidget {
  const SequelToStory({super.key});

  @override
  State<SequelToStory> createState() => _SequelToStoryState();
}

class _SequelToStoryState extends State<SequelToStory> {
  TextEditingController txtSearch = TextEditingController();
  BookService service = BookService();
  int selectTag = 0;
  List tagsArr = ["Your Books", "Genre", "News"];
  List searchArrNew = [];
  // List searchArr = [
  //   {"name": "Biography", "img": "assets/img/b1.jpg"},
  //   {"name": "Business", "img": "assets/img/b2.jpg"},
  //   {"name": "Children", "img": "assets/img/b3.jpg"},
  //   {"name": "Cookery", "img": "assets/img/b4.jpg"},
  //   {"name": "Fiction", "img": "assets/img/b5.jpg"},
  //   {"name": "Graphic Novels", "img": "assets/img/b6.jpg"},
  //   {"name": "Biography", "img": "assets/img/b1.jpg"},
  //   {"name": "Business", "img": "assets/img/b2.jpg"},
  //   {"name": "Children", "img": "assets/img/b3.jpg"},
  //   {"name": "Cookery", "img": "assets/img/b4.jpg"},
  //   {"name": "Fiction", "img": "assets/img/b5.jpg"},
  //   {"name": "Graphic Novels", "img": "assets/img/b6.jpg"},
  // ];

  List sResultArr = [
    // {
    //   "name": "The Heart of Hell",
    //   "img": "assets/img/h1.jpg",
    //   "author": "Mitch Weiss",
    //   "description":
    //       "The untold story of courage and sacrifice in the shadow of Iwo Jima.",
    //   "rate": 5.0,
    // },
    // {
    //   "name": "Adrennes 1944",
    //   "img": "assets/img/h2.jpg",
    //   "author": "Antony Beevor",
    //   "description":
    //       "#1 international bestseller and award winning history book.",
    //   "rate": 4.0,
    // },
    // {
    //   "name": "War on the Gothic Line",
    //   "img": "assets/img/h3.jpg",
    //   "author": "Christian Jennings",
    //   "description":
    //       "Through the eyes of thirteen men and women from seven different nations",
    //   "rate": 3.0,
    // },
  ];
  @override
  void initState() {
    super.initState();
    load_books();
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
                Navigator.pop(context);
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
                      controller: txtSearch,
                      onTap: () async {
                        final selectedBook = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => SearchForceView(
                                  allBooks:
                                      searchArrNew.cast<Map<String, dynamic>>(),
                                  // didSearch: (sText) {
                                  //   txtSearch.text = sText;
                                  //   if (mounted) {
                                  //     setState(() {});
                                  //   }
                                  // },
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
                                "title": selectedBook["title"] ?? '',
                                "img":
                                    selectedBook["pages"]?[0]?["img_url"] ?? '',
                                "author": selectedBook["author"] ?? '',
                                "genre": selectedBook["genre"] ?? '',
                                "rating": selectedBook["rating"] ?? 5.0,
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
              if (txtSearch.text.isEmpty)
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 15,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.75,
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                    itemCount: searchArrNew.length,
                    itemBuilder: (context, index) {
                      var sObj = searchArrNew[index] as Map? ?? {};
                      return SearchGridCell(sObj: sObj, index: index);
                    },
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
                ),
            ],
          ),
        ),
      ],
    );
  }

  void load_books() async {
    await service.loadBooks();
    setState(() {
      searchArrNew = service.books;
    });
  }
}
