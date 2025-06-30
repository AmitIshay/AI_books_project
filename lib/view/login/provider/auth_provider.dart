import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pjbooks/view/login/provider/auth_service.dart';
import 'package:pjbooks/backend/config.dart';
import 'package:pjbooks/backend/user_prefs.dart';
import 'package:pjbooks/book_service.dart';
import 'package:pjbooks/view/login/view/help_us_view.dart';
import 'package:pjbooks/view/main_tab/main_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> coventDynamicListIntoString(genres) {
  List<String> genresList = []; // Default to an empty list

  if (genres != null && genres is List) {
    // Ensure every item in the list is a String before casting
    genresList = genres.map((item) => item.toString()).toList();
  } else if (genres == null) {
    // Handle the case where 'genres' might be missing from the response entirely
    // You might want to default to an empty list or handle it as an error
    print("Genres field is null or not a list in the response.");
  }
  return genresList;
}

Future<void> handleSignIn(
  BuildContext context,
  String email,
  String password,
  bool isStay,
) async {
  final res = await AuthService.signIn(email: email, password: password);

  if (res['statusCode'] == 200) {
    final token = res['body']['token'];
    final userId = res['body']['userId'];
    final fullName = res['body']['full_name'];
    final bio = res['body']['bio'];
    final location = res['body']['location'] ?? "";
    final imageBase64 = res['body']['image_base64'] ?? "";
    final genresDynamic = res['body']['genres'];

    final genres = coventDynamicListIntoString(genresDynamic);

    await UserPrefs.saveTokenAndUserIdAndfull_name_bio_location_image_base64(
      token,
      userId,
      fullName,
      bio,
      location,
      imageBase64,
      genres,
    );
    await UserPrefs.setIsLoggedIn(isStay);

    await context.read<BookService>().loadBooks();
    await context.read<BookService>().loadBooksTopPick();

    showSnackBar(context, "Login successful");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainTabView()),
    );
  } else {
    showSnackBar(context, res['body']['message'] ?? "Login failed");
  }
}

Future<void> handleSignUp({
  required BuildContext context,
  required String fullName,
  required String email,
  required String mobile,
  required String password,
}) async {
  final res = await AuthService.signUp(
    fullName: fullName,
    email: email,
    mobile: mobile,
    password: password,
  );

  if (res['statusCode'] == 201) {
    final body = res['body'];
    final token = body['token'];
    final userId = body['userId'];
    final bio = body['bio'] ?? "";
    final location = body['location'] ?? "";
    final imageBase64 = body['image_base64'] ?? "";
    final List<dynamic>? rawGenres = body['genres'];
    final List<String> genres = rawGenres?.cast<String>() ?? <String>[];

    await UserPrefs.saveTokenAndUserIdAndfull_name_bio_location_image_base64(
      token,
      userId,
      fullName,
      bio,
      location,
      imageBase64,
      genres,
    );
    showSnackBar(context, "Signup successful");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HelpUsView(userId: userId)),
    );
  } else {
    showSnackBar(context, res['body']['message'] ?? "Signup failed");
  }
}

Future<void> handleResetPassword({
  required BuildContext context,
  required String email,
}) async {
  final res = await AuthService.resetPassword(email: email.trim());

  if (res['statusCode'] == 200) {
    showSnackBar(context, "Password reset link sent to your email.");
    Navigator.pop(context);
  } else {
    showSnackBar(context, "Failed to send reset link. Please try again.");
  }
}

Future<void> handleSaveGenres({
  required BuildContext context,
  required String userId,
  required Map<String, bool> topGenres,
  required Map<String, bool> otherGenres,
}) async {
  final selectedGenres = [
    ...topGenres.entries.where((e) => e.value).map((e) => e.key),
    ...otherGenres.entries.where((e) => e.value).map((e) => e.key),
  ];

  final response = await http.put(
    Uri.parse('${Config.baseUrl}/api/auth/update_genres'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': userId, 'genres': selectedGenres}),
  );

  if (response.statusCode == 200) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('generes', selectedGenres);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainTabView()),
    );
  } else {
    showSnackBar(context, "Failed to save genres");
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
