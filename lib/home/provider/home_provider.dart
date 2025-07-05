import 'package:flutter/material.dart';
import 'package:pjbooks/backend/user_prefs.dart';
import 'package:pjbooks/bookPages/book.dart';
import 'package:pjbooks/bookPages/home_screen.dart';
import 'package:pjbooks/backend/book_service.dart';

class HomeViewProvider {
  final BookService service;
  final void Function(VoidCallback fn) setState;
  final BuildContext context;

  List topPicksArr = [];
  List bestArr = [];
  List genresArr = [];
  List recentArr = [];
  List allBooks = [];

  HomeViewProvider({
    required this.service,
    required this.setState,
    required this.context,
  });

  void loadTopPick() async {
    await service.loadBooksTopPick();
    setState(() {
      topPicksArr = service.books_top_pick;
    });
  }

  void loadMostRated() async {
    await service.loadBooksRated();
    setState(() {
      bestArr = service.books_most_rated;
    });
  }

  void loadGenresUser() async {
    final genres = await UserPrefs.getGenres();
    setState(() {
      genresArr = genres ?? []; // ברירת מחדל אם לא קיים
    });
  }

  void loadRecentAdded() async {
    await service.loadBooksRecentAdded();
    setState(() {
      recentArr = service.books_recent_added;
    });
  }

  void loadBooks() async {
    await service.loadAllBooks();
    setState(() {
      allBooks = service.allBooks;
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
}
