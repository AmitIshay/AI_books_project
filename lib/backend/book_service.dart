import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
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
  List<Map<String, dynamic>> _Allbooks = [];
  List<Map<String, dynamic>> _books_top_pick  = [];
  List<Map<String, dynamic>> _books_most_rated = [];
  List<Map<String, dynamic>> _books_recent_added = [];
  List<Map<String, dynamic>> _books_diffrent_user =[];
  List<Map<String, dynamic>> _books_genre = [];
  List<Map<String , dynamic>> _users = [];

  List<Map<String, dynamic>> get users => _users;
  List<Map<String, dynamic>> get books => _books;
  List<Map<String, dynamic>> get allBooks => _Allbooks;
  List<Map<String, dynamic>> get books_top_pick => _books_top_pick;
  List<Map<String, dynamic>> get books_most_rated => _books_most_rated;
  List<Map<String, dynamic>> get books_recent_added => _books_recent_added;


  static Future<Map<String, dynamic>> getBooksByUserRequest(String token, String id_user) async
  {
    final response = await http.get(
      Uri.parse('$baseUrl/api/books/byUser/id=$id_user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final body = jsonDecode(response.body);
    print(body);
    return {'statusCode': response.statusCode, 'body': body};
  }

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
static Future<Map<String , dynamic>> getAllBooks(String token) async{
  final response = await http.get(
    Uri.parse('$baseUrl/api/books/all_books'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  ).timeout(
    const Duration(seconds: 10), // Wait for 10 seconds for the entire request
    onTimeout: () {
      // This callback is executed if the timeout occurs
      throw TimeoutException('The connection timed out after 10 seconds. Check server or network.');
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

  static Future<Map<String, dynamic>> putNewCommentInBook(String token , String idBook, Map commentObj) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/books/newCommentAndRanking/id=$idBook'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(commentObj),
    );

    final body = jsonDecode(response.body);
    print(body);
    return {'statusCode': response.statusCode, 'body': body};
  }

  static Future<Map<String, dynamic>> deleteBook(String token , String idBook) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/books/delete/id=$idBook'),
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

Future<void> loadAllBooks()async{
  final token = await UserPrefs.getToken();
  if (token == null) return;

  final response = await BookService.getAllBooks(token);
  if (response['statusCode'] == 200) {
    final booksList = response['body']['books'] as List;
    if (booksList.isNotEmpty) {
      _Allbooks = List<Map<String, dynamic>>.from(booksList);
    }
    notifyListeners();
  } else {
    // טפל בשגיאות כאן
    print('Error loading books: ${response['body']['message']}');
  }
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
  Future<bool> putNewComment(String idBook,Map commentMap) async{
    final token = await UserPrefs.getToken();
    if (token == null) return false;
    final response = await BookService.putNewCommentInBook(token,idBook, commentMap);
    if (response['statusCode'] == 200) {
      notifyListeners();
      return true;
    } else {
      // טפל בשגיאות כאן
      print('Error loading books: ${response['body']['message']}');
      return false;
    }
  }


  Future<bool> deleteBookFromDB(String idBook) async{
    final token = await UserPrefs.getToken();
    if (token == null) return false;
    final response = await BookService.deleteBook(token,idBook);
    if (response['statusCode'] == 200) {
      notifyListeners();
      return true;
    } else {
      // טפל בשגיאות כאן
      print('Error loading books: ${response['body']['message']}');
      return false;
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
  List get bookDiffrentUser => _books_diffrent_user;
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

  Future<void> loadBooksByUser(String id_user)async
  {
    final token = await UserPrefs.getToken();
    if (token == null) return ;

    final response  = await BookService.getBooksByUserRequest(token, id_user);
    if (response["statusCode"]==200)
      {
        final booksList = response['body']['books'] as List;
        _books_diffrent_user = List<Map<String, dynamic>>.from(booksList);
        notifyListeners();
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


  static Future<Map<String, dynamic>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/getAllUsers'),

    );

    return {
      'statusCode': response.statusCode,
      'body': json.decode(response.body),
    };
  }
  Future<void> loadAllUserFromDB() async {

    final response = await BookService.getAllUsers();
    if (response['statusCode'] == 200) {
      final booksList = response['body']['users'] as List;
      _users= List<Map<String, dynamic>>.from(booksList);
      notifyListeners();
    } else {
      // טפל בשגיאות כאן
      print('Error loading books: ${response['body']['message']}');
    }
  }

}
