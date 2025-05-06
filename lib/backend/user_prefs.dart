import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  static const String _tokenKey = 'token';
  static const String _userIdKey = 'user_id';
  static const String _full_nameKey = 'full_name';

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
}
