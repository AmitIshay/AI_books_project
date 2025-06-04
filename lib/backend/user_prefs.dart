import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static const String _tokenKey = 'token';
  static const String _userIdKey = 'user_id';
  static const String _full_nameKey = 'full_name';
  static const String _bio = 'bio';
  static const String _location = 'location';
  static const String _image_base64 = 'image_base64';

  /// שומר טוקן ו-id של המשתמש
  static Future<void> saveTokenAndUserIdAndfull_name(
    String token,
    String userId,
    String full_name,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_full_nameKey, full_name);
  }

  static Future<void> saveTokenAndUserIdAndfull_name_bio_location_image_base64(
    String token,
    String userId,
    String full_name,
    String bio,
    String location,
    String image_base64,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_full_nameKey, full_name);
    await prefs.setString(_bio, bio);
    await prefs.setString(_location, location);
    await prefs.setString(_image_base64, image_base64);
  }

  /// מחזיר את הטוקן
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// מחזיר את userId
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  /// מוחק את כל המידע (לוגאאוט)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> setIsLoggedIn(bool isStay) async {
    final prefs = await SharedPreferences.getInstance();
    if (isStay) {
      await prefs.setBool('is_logged_in', true);
    } else {
      await prefs.setBool('is_logged_in', false);
    }
  }

  static Future<bool> getSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seen_onboarding') ?? false;
  }

  static Future<bool> getIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('full_name');
  }

  static Future<String?> getBio() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('bio');
  }

  static Future<String?> getlocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('location');
  }

  static Future<String?> getImageBase64() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('image_base64');
  }

  static Future<void> setImageBase64(String imageBase64) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_image_base64, imageBase64);
  }

  static Future<void> saveBooks(List<Map<String, dynamic>> books) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> booksJsonList =
        books.map((book) => jsonEncode(book)).toList();
    await prefs.setStringList('user_books', booksJsonList);
  }

  static Future<List<Map<String, dynamic>>> getBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? booksJsonList = prefs.getStringList('user_books');
    if (booksJsonList == null) return [];

    return booksJsonList
        .map((bookJson) => Map<String, dynamic>.from(jsonDecode(bookJson)))
        .toList();
  }
}
