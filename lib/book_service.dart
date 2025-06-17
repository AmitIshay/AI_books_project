import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:pjbooks/backend/config.dart';
import 'package:pjbooks/backend/user_prefs.dart';
import 'package:flutter/foundation.dart';

class BookService extends ChangeNotifier {
  static const String baseUrl = Config.baseUrl;
  static const str_img_defult = 'https://timvandevall.com/wp-content/uploads/2014/01/Book-Cover-Template.jpg';

  List<Map<String, dynamic>> _books = [];
  List<Map<String, dynamic>> _books_top_pick  = [];
  List<Map<String, dynamic>> _books_most_rated = [];
  List<Map<String, dynamic>> _books_recent_added = [];

  List<Map<String, dynamic>> _books_genre = [];
  List<Map<String, dynamic>> get books => _books;
  List<Map<String, dynamic>> get books_top_pick => _books_top_pick;
  List<Map<String, dynamic>> get books_most_rated => _books_most_rated;
  List<Map<String, dynamic>> get books_recent_added => _books_recent_added;



  static Future<Map<String, dynamic>> getRecentAddedBooks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/books/recent_added'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final body = jsonDecode(response.body);
    print(body);
    return {'statusCode': response.statusCode, 'body': body};
  }


  static Future<Map<String, dynamic>> getUserBooks(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/books/get_user_books'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final body = jsonDecode(response.body);
    print(body);
    return {'statusCode': response.statusCode, 'body': body};
  }

  static Future<Map<String, dynamic>> getMostRatedBooks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/books/get_top_rated'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final body = jsonDecode(response.body);
    print(body);
    return {'statusCode': response.statusCode, 'body': body};
  }

  static Future<Map<String, dynamic>> getTopPicksBooks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/books/get_top_pick'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final body = jsonDecode(response.body);
    print(body);
    return {'statusCode': response.statusCode, 'body': body};
  }

  Future<void> loadBooks() async {
    final token = await UserPrefs.getToken();
    if (token == null) return;

    final response = await BookService.getUserBooks(token);
    if (response['statusCode'] == 200) {
      final booksList = response['body']['books'] as List;
      _books = List<Map<String, dynamic>>.from(booksList);
      notifyListeners();
    } else {
      // טפל בשגיאות כאן
      print('Error loading books: ${response['body']['message']}');
    }
  }

  Future<void> loadBooksTopPick() async {

    final response = await BookService.getTopPicksBooks();
    if (response['statusCode'] == 200) {
      final booksList = response['body']['books'] as List;
      _books_top_pick = List<Map<String, dynamic>>.from(booksList);
      notifyListeners();
    } else {
      // טפל בשגיאות כאן
      print('Error loading books: ${response['body']['message']}');
    }
  }
  Future<void> loadBooksRated() async {

    final response = await BookService.getMostRatedBooks();
    if (response['statusCode'] == 200) {
      final booksList = response['body']['books'] as List;
      _books_most_rated = List<Map<String, dynamic>>.from(booksList);
      notifyListeners();
    } else {
      // טפל בשגיאות כאן
      print('Error loading books: ${response['body']['message']}');
    }
  }

  int get booksCount => _books.length;

  List get books_genre => _books_genre;

  Future<void> loadBooksBaseOnGenre(String genre) async {
    final response = await BookService.getBookGenre(genre);
    if (response['statusCode'] == 200) {
      final booksList = response['body']['books'] as List;
      _books_genre = List<Map<String, dynamic>>.from(booksList);
      notifyListeners();
    } else {
      // טפל בשגיאות כאן
      print('Error loading books: ${response['body']['message']}');
    }
  }


  Future<void> loadBooksRecentAdded() async {
    final response = await BookService.getRecentAddedBooks();
    if (response['statusCode'] == 200) {
      final booksList = response['body']['books'] as List;
      _books_recent_added = List<Map<String, dynamic>>.from(booksList);
      notifyListeners();
    } else {
      // טפל בשגיאות כאן
      print('Error loading books: ${response['body']['message']}');
    }
  }

  static Future<Map<String, dynamic>> getBookGenre(String genre) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/books/genre/$genre'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final body = jsonDecode(response.body);
    print(body);
    return {'statusCode': response.statusCode, 'body': body};
  }

}
