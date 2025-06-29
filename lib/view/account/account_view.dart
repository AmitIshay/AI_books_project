import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pjbooks/backend/config.dart';
import 'package:pjbooks/backend/user_prefs.dart';
import 'package:pjbooks/view/login/help_us_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pjbooks/book_service.dart';

import '../../bookPages/book.dart';
import '../../bookPages/home_screen.dart';
import '../../common/color_extenstion.dart';
// import '../../common_widget/your_review_row.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../common_widget/history_row.dart';
import '../../common_widget/top_picks_cell.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  String uid ="";
  List userBooks = [];
  List genresUser = [];
  String fullName = '';
  TextEditingController bioController = TextEditingController();
  String bio = '';
  bool isEditingBio = false;
  TextEditingController locationController = TextEditingController();
  String location = '';
  bool isEditingLocation = false;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String image_base64 = '';
  int bookCount = 0;
  double fontSize = 17;

  TextEditingController imageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadFullName();
    loadUid();
    loadBio();
    loadlocation();
    loadBooks();
    loadimage_base64();
    loadGenres();
  }
  void loadUid() async{
    final uidOut = await UserPrefs.getUserId();
    setState(() {
      uid = uidOut ?? "";
    });
  }
  void loadGenres() async{
    final genres = await UserPrefs.getGenres(); // צור מתודה מתאימה ב־UserPrefs
    setState(() {
      genresUser = genres ??[];
    });
  }
  void loadBooks() async {
    var bookService = BookService();
    await bookService.loadBooks();
    setState(() {
      userBooks = bookService.books;
      bookCount  = userBooks.length;
    });
  }

  void loadFullName() async {
    final name = await UserPrefs.getFullName();
    setState(() {
      fullName = name ?? "User"; // ברירת מחדל אם לא קיים
    });
  }

  void loadBio() async {
    final userBio = await UserPrefs.getBio(); // צור מתודה מתאימה ב־UserPrefs
    setState(() {
      bio = userBio ?? "bio";
    });
  }

  void loadlocation() async {
    final userlocation =
        await UserPrefs.getlocation(); // צור מתודה מתאימה ב־UserPrefs
    setState(() {
      location = userlocation ?? "location";
    });
  }

  void loadimage_base64() async {
    final userImageBase64 = await UserPrefs.getImageBase64();

    setState(() {
      image_base64 = userImageBase64 ?? "image_base64";
      imageController.text = image_base64;
    });
  }

  Future<void> _pickImage() async {
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


  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final booksCount = context.watch<BookService>().booksCount;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: TColor.primary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          fullName.isNotEmpty ? fullName : "Loading...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TColor.showMessage,
                            fontSize: fontSize+20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),

                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: _pickImage, // פותח את המצלמה
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                      _imageFile != null
                          ? Image.file(
                        _imageFile!,
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      )
                          : (image_base64.isNotEmpty &&
                          image_base64 != "image_base64")
                          ? Image.memory(
                        base64Decode(image_base64),
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        "assets/img/u1.png",
                        width: 160,
                        height: 160,
                      ),
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: 10,),
            containerBio(media),
            SizedBox(height: 30,),
            containerLocation(media),
            SizedBox(height: 30,),
            containerGenres(media),
            SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child:
        //continer genres
        Column(

              children:[

                Text(
                  "Your Books ($booksCount):",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: TColor.showMessage,
                    fontSize: fontSize+5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ]
        )
        ),
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: media.width * 0.4,
                  width: media.width * 0.45,
                  decoration: const BoxDecoration(
                    // color: Color(0xffFF5957),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
                SizedBox(
                  width: media.width,
                  height: media.width * 0.5,
                  child: CarouselSlider.builder(
                    itemCount: userBooks.length,
                    itemBuilder: (
                        BuildContext context,
                        int itemIndex,
                        int pageViewIndex,
                        ) {
                      var iObj = userBooks[itemIndex] as Map? ?? {};
                      return
                        GestureDetector(
                          //TODO:  fix in the server get books from user func
                          // onTap: () {
                           //      Navigator.push(
                           //        context,
                           //        MaterialPageRoute(
                           //          builder: (context) => HistoryRow(sObj: iObj),
                           //        ),
                           //      );
                           //    },
                           //
                          onTap:(){
                            openBookById(iObj["id"] , context);
                          },

                        child:
                        TopPicksCell(iObj: iObj)
                        );
                    },
                    options: CarouselOptions(
                      autoPlay: false,
                      aspectRatio: 1,
                      enlargeCenterPage: true,
                      viewportFraction: 0.45,
                      enlargeFactor: 0.4,
                      enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                    ),
                  ),
                ),
              ],
            ),


          ],

        ),

      ) );
  }




Container containerBio(dynamic media)
{
  return Container(
    width: media.width*0.6,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    padding: EdgeInsets.all(8),
    child:
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.edit_note, color: TColor.primary),
        const SizedBox(width: 8),
        Expanded(
          child:
          isEditingBio
              ? TextField(
            controller: bioController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText:
              "Write something about yourself...",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
            ),
          )
              : Text(
            bio.isNotEmpty
                ? bio
                : "No bio yet. Tap edit to add one.",
            style: TextStyle(
              color: TColor.subTitle,
              fontSize: fontSize,
            ),
          ),
        ),
        const SizedBox(height: 12),
        IconButton(
          icon: Icon(
            isEditingBio ? Icons.check : Icons.edit,
            color: TColor.primary,
          ),
          onPressed: () async {
            if (isEditingBio) {
              final userId = await UserPrefs.getUserId();
              final newBio = bioController.text;

              final response = await http.post(
                Uri.parse(
                  '${Config.baseUrl}/api/auth/update_bio',
                ),
                headers: {
                  'Content-Type': 'application/json',
                },
                body: jsonEncode({
                  'user_id': userId,
                  'bio': newBio,
                }),
              );

              if (response.statusCode == 200) {
                final prefs =
                await SharedPreferences.getInstance();
                await prefs.setString('bio', newBio);
                setState(() {
                  bio = newBio;
                  isEditingBio = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Bio updated"),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Failed to update bio"),
                  ),
                );
              }
            } else {
              setState(() {
                bioController.text = bio;
                isEditingBio = true;
              });
            }
          },
        ),
      ],
    ),

  );
}
Container containerLocation(dynamic media)
{
  return Container(
    width: media.width*0.6,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    padding: EdgeInsets.all(8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.near_me_sharp, color: TColor.primary),
        const SizedBox(width: 8),
        Expanded(
          child:
          isEditingLocation
              ? TextField(
            controller: locationController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Where are you from...",
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
            ),
          )
              : Text(
            location.isNotEmpty
                ? location
                : "No location yet. Tap edit to add one.",
            style: TextStyle(
              color: TColor.subTitle,
              fontSize: fontSize,
            ),
          ),
        ),
        const SizedBox(height: 12),
        IconButton(
          icon: Icon(
            isEditingLocation ? Icons.check : Icons.edit,
            color: TColor.primary,
          ),
          onPressed: () async {
            if (isEditingLocation) {
              final userId = await UserPrefs.getUserId();
              final newlocation = locationController.text;

              final response = await http.post(
                Uri.parse(
                  '${Config.baseUrl}/api/auth/update_location',
                ),
                headers: {
                  'Content-Type': 'application/json',
                },
                body: jsonEncode({
                  'user_id': userId,
                  'location': newlocation,
                }),
              );

              if (response.statusCode == 200) {
                final prefs =
                await SharedPreferences.getInstance();
                await prefs.setString(
                  'location',
                  newlocation,
                );
                setState(() {
                  location = newlocation;
                  isEditingLocation = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("location updated"),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Failed to update location",
                    ),
                  ),
                );
              }
            } else {
              setState(() {
                bioController.text = bio;
                isEditingLocation = true;
              });
            }
          },
        ),
      ],
    ),
  );
}

  Container containerGenres(dynamic media) {
    return Container(
      width: media.width * 0.6,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.book, color: TColor.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              genresUser.isNotEmpty
                  ? genresUser.join(", ")
                  : "No genres yet. Tap edit to add some.",
              style: TextStyle(
                color: TColor.subTitle,
                fontSize: fontSize,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.edit, color: TColor.primary),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpUsView(userId: uid),
                ),
              );
              loadGenres(); // reload after change
            },
          ),
        ],
      ),
    );
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