import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pjbooks/backend/config.dart';
import 'package:pjbooks/backend/user_prefs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pjbooks/book_service.dart';

import '../../common/color_extenstion.dart';
import '../../common_widget/your_review_row.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  List purArr = ["assets/img/p1.jpg", "assets/img/p2.jpg", "assets/img/p3.jpg"];

  List sResultArr = [
    {
      "img": "assets/img/p1.jpg",
      "description":
          "A must read for everybody. This book taught me so many things about...",
      "rate": 5.0,
    },
    {
      "img": "assets/img/p2.jpg",
      "description":
          "#1 international bestseller and award winning history book.",
      "rate": 4.0,
    },
  ];
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

  @override
  void initState() {
    super.initState();
    loadFullName();
    loadBio();
    loadlocation();
    loadimage_base64();
    //loadBooksCount();
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
      });
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

  Future<void> loadBooksCount() async {
    final booksCount = context.watch<BookService>().booksCount;
    print("Books count: $booksCount");
    bookCount = booksCount;
    // final booksProvider = Provider.of<BookService>(context, listen: false);
    // await booksProvider.loadBooks();
    // setState(() {
    //   bookCount = booksProvider.booksCount;
    // });
    // final token = await UserPrefs.getToken();
    // if (token != null) {
    //   final booksRes = await BookService.getUserBooks(token);
    //   if (booksRes['statusCode'] == 200) {
    //     final books = booksRes['body']['books'] as List;
    //     setState(() {
    //       bookCount = books.length;
    //     });
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text("Failed to load books: ${booksRes['message']}"),
    //       ),
    //     );
    //   }
    // final books = await UserPrefs.getBooks();
    // setState(() {
    //   bookCount = books.length;
    // });
    //}
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
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName.isNotEmpty ? fullName : "Loading...",
                          style: TextStyle(
                            color: TColor.text,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
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
                                          fontSize: 16,
                                        ),
                                      ),
                            ),
                            const SizedBox(height: 10),
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
                        Row(
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
                                          fontSize: 16,
                                        ),
                                      ),
                            ),
                            const SizedBox(height: 10),
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
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _pickImage, // פותח את המצלמה
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child:
                          _imageFile != null
                              ? Image.file(
                                _imageFile!,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                              : (image_base64.isNotEmpty &&
                                  image_base64 != "image_base64")
                              ? Image.memory(
                                base64Decode(image_base64),
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                              : Image.asset(
                                "assets/img/u1.png",
                                width: 70,
                                height: 70,
                              ),
                    ),
                  ),

                  const SizedBox(width: 15),
                ],
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 25),
            //   child: Row(
            //     children: [
            //       Icon(Icons.near_me_sharp, color: TColor.subTitle, size: 15),
            //       const SizedBox(width: 8),
            //       Expanded(
            //         child: Text(
            //           "Newcastle - Australia",
            //           style: TextStyle(color: TColor.subTitle, fontSize: 13),
            //         ),
            //       ),
            //       const SizedBox(width: 8),
            //       Container(
            //         height: 30.0,
            //         decoration: BoxDecoration(
            //           gradient: LinearGradient(colors: TColor.button),
            //           borderRadius: BorderRadius.circular(10),
            //           boxShadow: [
            //             BoxShadow(
            //               color: TColor.primary,
            //               blurRadius: 2,
            //               offset: const Offset(0, 2),
            //             ),
            //           ],
            //         ),
            // child: ElevatedButton(
            //   onPressed: () {},
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.transparent,
            //     shadowColor: Colors.transparent,
            //   ),
            //   child: const Text(
            //     'Edit Profile',
            //     style: TextStyle(fontSize: 12),
            //   ),
            // ),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "$booksCount",
                        style: TextStyle(
                          color: TColor.subTitle,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Books",
                        style: TextStyle(color: TColor.subTitle, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "5",
                        style: TextStyle(
                          color: TColor.subTitle,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Reviews",
                        style: TextStyle(color: TColor.subTitle, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Text(
                "Your Books (21)",
                style: TextStyle(
                  color: TColor.subTitle,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: media.width * 0.4,
                  width: media.width * 0.45,
                  decoration: const BoxDecoration(
                    color: Color(0xffFF5957),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        purArr.map((iName) {
                          var isFirst = purArr.first == iName;
                          var isLast = purArr.last == iName;
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 12,
                            ),
                            padding:
                                isFirst
                                    ? const EdgeInsets.only(left: 25)
                                    : (isLast
                                        ? const EdgeInsets.only(right: 25)
                                        : null),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  iName,
                                  height: media.width * 0.5,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Text(
                "Books you like (7)",
                style: TextStyle(
                  color: TColor.subTitle,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              itemCount: sResultArr.length,
              itemBuilder: (context, index) {
                var rObj = sResultArr[index] as Map? ?? {};
                return YourReviewRow(sObj: rObj);
              },
            ),
          ],
        ),
      ),
    );
  }
}
