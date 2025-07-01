import 'package:flutter/material.dart';

import '../common/color_extenstion.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchForceView extends StatefulWidget {
  final Function(String)? didSearch;
  final List<Map<String, dynamic>> allBooks;
  const SearchForceView({super.key, required this.allBooks, this.didSearch});

  @override
  State<SearchForceView> createState() => _SearchForceViewState();
}

class _SearchForceViewState extends State<SearchForceView> {
  TextEditingController txtSearch = TextEditingController();
  List<Map<String, dynamic>> filteredBooks = [];
  List<String> perviousArr = [];
  @override
  void initState() {
    super.initState();
    loadPreviousSearches();
  }

  Future<void> loadPreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    perviousArr = prefs.getStringList('previous_searches') ?? [];
    setState(() {});
  }

  Future<void> saveSearchTerm(String term) async {
    final prefs = await SharedPreferences.getInstance();

    // הוצא אם כבר קיים
    perviousArr.remove(term);

    // הכנס לראש הרשימה
    perviousArr.insert(0, term);

    // שמור רק את 5 האחרונים
    if (perviousArr.length > 5) {
      perviousArr = perviousArr.sublist(0, 5);
    }

    await prefs.setStringList('previous_searches', perviousArr);
    setState(() {});
  }

  // בתוך ה־onTap של GestureDetector:
  void handleSearchTap(String itemText) async {
    if (widget.didSearch != null) {
      widget.didSearch!(itemText);
    }

    await saveSearchTerm(itemText);

    Navigator.pop(context);
  }

  Future<void> _clearPreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('previous_searches');
    setState(() {
      perviousArr = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(),
        leadingWidth: 0,
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
                  onChanged: (value) {
                    setState(() {
                      filteredBooks =
                          widget.allBooks.where((book) {
                            final title = book["title"]?.toLowerCase() ?? '';
                            final author = book["author"]?.toLowerCase() ?? '';
                            return title.contains(value.toLowerCase()) ||
                                author.contains(value.toLowerCase());
                          }).toList();
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 8,
                    ),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: TColor.text),
                    hintText: "Search here",
                    labelStyle: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (txtSearch.text.isEmpty && perviousArr.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Previous Searches",
                    style: TextStyle(
                      color: TColor.subTitle,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: _clearPreviousSearches,
                    child: Text(
                      "Clear",
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
              itemCount:
                  txtSearch.text.isEmpty
                      ? perviousArr.length
                      : filteredBooks.length,
              itemBuilder: (context, index) {
                if (txtSearch.text.isEmpty) {
                  final itemText = perviousArr[index];
                  return GestureDetector(
                    onTap: () async {
                      if (widget.didSearch != null) {
                        widget.didSearch!(itemText);
                      }
                      await saveSearchTerm(itemText);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: TColor.subTitle),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Text(
                              itemText,
                              style: TextStyle(
                                color: TColor.text,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "times",
                            style: TextStyle(
                              color: TColor.primaryLight,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  final book = filteredBooks[index];
                  return GestureDetector(
                    onTap: () {
                      if (widget.didSearch != null) {
                        widget.didSearch!(book["title"] ?? '');
                      }
                      Navigator.pop(context, book);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 15,
                      ),
                      child: Row(
                        children: [
                          Image.network(
                            book["pages"]?[0]?["img_url"] ?? "",
                            width: 40,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book["title"] ?? '',
                                  style: TextStyle(
                                    color: TColor.text,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  book["author"] ?? '',
                                  style: TextStyle(
                                    color: TColor.subTitle,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
