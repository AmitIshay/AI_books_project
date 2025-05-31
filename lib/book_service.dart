import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pjbooks/backend/config.dart';
import 'package:pjbooks/backend/user_prefs.dart';
import 'package:flutter/foundation.dart';

class BookService extends ChangeNotifier {
  static const String baseUrl = Config.baseUrl;
  List<Map<String, dynamic>> _books = [];

  List<Map<String, dynamic>> get books => _books;

  static Future<Map<String, dynamic>> getUserBooks(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/books/get_user_books'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final body = jsonDecode(response.body);

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

  int get booksCount => _books.length;
}
