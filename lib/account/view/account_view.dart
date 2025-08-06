import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pjbooks/backend/config.dart';
import 'package:pjbooks/backend/user_prefs.dart';
import 'package:pjbooks/account/provider/account_provider.dart';
import 'package:pjbooks/login/view/help_us_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pjbooks/backend/book_service.dart';
import '../../common/color_extenstion.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../../common_widget/top_picks_cell.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  late AccountProvider provider;
  TextEditingController bioController = TextEditingController();
  bool isEditingBio = false;
  TextEditingController locationController = TextEditingController();
  bool isEditingLocation = false;
  int bookCount = 0;
  double fontSize = 17;
  File? _imageFile;

  TextEditingController imageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    provider = AccountProvider(
      setState: setState,
      context: context,
      imageController: imageController,
    );
    provider.loadUserProfileData();
    provider.loadUid();
    provider.loadBooks();
    provider.loadGenres();
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
                          provider.fullName.isNotEmpty
                              ? provider.fullName
                              : "Loading...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TColor.showMessage,
                            fontSize: fontSize + 20,
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
                    onTap: provider.pickImage, // פותח את המצלמה
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
                              : (provider.image_base64.isNotEmpty &&
                                  provider.image_base64 != "image_base64")
                              ? Image.memory(
                                base64Decode(provider.image_base64),
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

            SizedBox(height: 10),
            containerBio(media),
            SizedBox(height: 30),
            containerLocation(media),
            SizedBox(height: 30),
            containerGenres(media),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child:
              //continer genres
              Column(
                children: [
                  Text(
                    "Your Books ($booksCount):",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: TColor.showMessage,
                      fontSize: fontSize + 5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
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
                    itemCount: provider.userBooks.length,
                    itemBuilder: (
                      BuildContext context,
                      int itemIndex,
                      int pageViewIndex,
                    ) {
                      var iObj = provider.userBooks[itemIndex] as Map? ?? {};
                      return GestureDetector(
                        onTap: () {
                          provider.openBookById(iObj["id"], context);
                        },

                        child: TopPicksCell(iObj: iObj),
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
      ),
    );
  }

  Container containerBio(dynamic media) {
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
          Icon(Icons.edit_note, color: TColor.primary),
          const SizedBox(width: 8),
          Expanded(
            child:
                isEditingBio
                    ? TextField(
                      controller: bioController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Write something about yourself...",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )
                    : Text(
                      provider.bio.isNotEmpty
                          ? provider.bio
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
                  Uri.parse('${Config.baseUrl}/api/auth/update_bio'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({'user_id': userId, 'bio': newBio}),
                );

                if (response.statusCode == 200) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('bio', newBio);
                  setState(() {
                    provider.bio = newBio;
                    isEditingBio = false;
                  });

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text("Bio updated")));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to update bio")),
                  );
                }
              } else {
                setState(() {
                  bioController.text = provider.bio;
                  isEditingBio = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Container containerLocation(dynamic media) {
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )
                    : Text(
                      provider.location.isNotEmpty
                          ? provider.location
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
                  Uri.parse('${Config.baseUrl}/api/auth/update_location'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'user_id': userId,
                    'location': newlocation,
                  }),
                );

                if (response.statusCode == 200) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('location', newlocation);
                  setState(() {
                    provider.location = newlocation;
                    isEditingLocation = false;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("location updated")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to update location")),
                  );
                }
              } else {
                setState(() {
                  bioController.text = provider.bio;
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
              provider.genresUser.isNotEmpty
                  ? provider.genresUser.join(", ")
                  : "No genres yet. Tap edit to add some.",
              style: TextStyle(color: TColor.subTitle, fontSize: fontSize),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.edit, color: TColor.primary),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpUsView(userId: provider.uid),
                ),
              );
              provider.loadGenres(); // reload after change
            },
          ),
        ],
      ),
    );
  }
}
