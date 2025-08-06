import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pjbooks/backend/config.dart';
import 'package:pjbooks/backend/user_prefs.dart';
import 'package:pjbooks/bookPages/book.dart';
import 'package:pjbooks/bookPages/home_screen.dart';
import 'package:pjbooks/login/view/help_us_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pjbooks/backend/book_service.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AccountProvider {
  final void Function(VoidCallback fn) setState;
  final BuildContext context;
  String uid = "";
  List userBooks = [];
  List genresUser = [];
  String fullName = '';
  String bio = '';
  String location = '';
  final ImagePicker _picker = ImagePicker();
  String image_base64 = '';
  final TextEditingController imageController;
  File? _imageFile;
  int bookCount = 0;

  AccountProvider({
    required this.setState,
    required this.context,
    required this.imageController,
  });

  void loadUid() async {
    final uidOut = await UserPrefs.getUserId();
    setState(() {
      uid = uidOut ?? "";
    });
  }

  void loadGenres() async {
    final genres = await UserPrefs.getGenres(); // צור מתודה מתאימה ב־UserPrefs
    setState(() {
      genresUser = genres ?? [];
    });
  }

  void loadBooks() async {
    var bookService = BookService();
    await bookService.loadBooks();
    setState(() {
      userBooks = bookService.books;
      bookCount = userBooks.length;
    });
  }

  void loadUserProfileData() async {
    final name = await UserPrefs.getFullName();
    final userBio = await UserPrefs.getBio();
    final userLocation = await UserPrefs.getlocation();
    final userImageBase64 = await UserPrefs.getImageBase64();

    setState(() {
      fullName = name ?? "User";
      bio = userBio ?? "bio";
      location = userLocation ?? "location";
      image_base64 = userImageBase64 ?? "image_base64";
      imageController.text = image_base64;
    });
  }

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    ); // אפשר גם gallery
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final imageBytes = await file.readAsBytes();
      final imageBase64 = base64Encode(imageBytes);
      setState(() {
        _imageFile = File(pickedFile.path);
        image_base64 = imageBase64;
        imageController.text = imageBase64;
      });
      await UserPrefs.setImageBase64(imageBase64);
      await _uploadProfileImage(imageBase64);
    }
  }

  Future<void> _uploadProfileImage(String base64Image) async {
    final userId = await UserPrefs.getUserId();

    final response = await http.post(
      Uri.parse('${Config.baseUrl}/api/auth/update_profile_image'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId, 'image_base64': base64Image}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Profile image updated")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to update image")));
    }
  }

  void openBookById(String bookId, BuildContext context) {
    var fullBook = userBooks.firstWhere(
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
