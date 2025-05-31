import 'package:flutter/material.dart';
import 'package:pjbooks/common/color_extenstion.dart';
import 'package:pjbooks/features/create_own_story.dart';
import 'package:pjbooks/features/create_story_assistance.dart';
import 'package:pjbooks/features/sequel_to_story.dart';
import 'package:pjbooks/view/login/sign_in_view.dart';
import 'package:pjbooks/view/onboarding/spalsh_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../account/account_view.dart';
import '../home/home_view.dart';
import '../our_book/out_books_view.dart';
import '../search/search_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

GlobalKey<ScaffoldState> sideMenuScaffoldKey = GlobalKey<ScaffoldState>();

class _MainTabViewState extends State<MainTabView>
    with TickerProviderStateMixin {
  TabController? controller;
  int selectMenu = 0;

  List menuArr = [
    {"name": "Home", "icon": Icons.home},
    {"name": "Story from scratch", "icon": Icons.book},
    {"name": "Stroy with assistance", "icon": Icons.storefront},
    {"name": "Sequel to Story", "icon": Icons.business_center},
    {"name": "Account", "icon": Icons.account_circle},
  ];

  @override
  void initState() {
    controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    var isPortrait = media.height > media.width;

    // התאמה לגובה ורוחב
    var textScale = isPortrait ? 0.85 : 1.0;
    var iconScale = isPortrait ? 0.8 : 1.0;
    var paddingScale = isPortrait ? 0.8 : 1.0;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
      child: Scaffold(
        key: sideMenuScaffoldKey,
        endDrawer: buildDrawer(media, iconScale, textScale, paddingScale),
        body: TabBarView(
          controller: controller,
          children: const [HomeView(), SearchView(), AccountView()],
        ),
        bottomNavigationBar: BottomAppBar(
          color: TColor.primary,
          child: TabBar(
            controller: controller,
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(icon: Icon(Icons.home, size: 24 * iconScale), text: "Home"),
              Tab(
                icon: Icon(Icons.search, size: 24 * iconScale),
                text: "Search",
              ),
              Tab(
                icon: Icon(Icons.account_circle, size: 24 * iconScale),
                text: "Profile",
              ),
              // Tab(
              //   icon: Icon(Icons.shopping_bag, size: 24 * iconScale),
              //   text: "Cart",
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawer(
    Size media,
    double iconScale,
    double textScale,
    double paddingScale,
  ) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      width: media.width * 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: TColor.dColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(media.width * 0.7),
          ),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 15)],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80 * paddingScale),
              ...menuArr.map((mObj) {
                var index = menuArr.indexOf(mObj);
                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12 * paddingScale,
                    horizontal: 15 * paddingScale,
                  ),
                  decoration:
                      selectMenu == index
                          ? BoxDecoration(
                            color: TColor.primary,
                            boxShadow: [
                              BoxShadow(
                                color: TColor.primary,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          )
                          : null,
                  child: GestureDetector(
                    onTap: () {
                      handleDrawerTap(index);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          mObj["name"].toString(),
                          style: TextStyle(
                            color:
                                selectMenu == index
                                    ? Colors.white
                                    : TColor.text,
                            fontSize: 18 * textScale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 15 * paddingScale),
                        Icon(
                          mObj["icon"] as IconData? ?? Icons.home,
                          color:
                              selectMenu == index
                                  ? Colors.white
                                  : TColor.primary,
                          size: 33 * iconScale,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: 20 * paddingScale),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 15 * paddingScale,
                  horizontal: 20 * paddingScale,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await logout();
                      },
                      icon: Icon(
                        Icons.login_outlined,
                        color: TColor.subTitle,
                        size: 25 * iconScale,
                      ),
                    ),
                    SizedBox(width: 15 * paddingScale),
                    TextButton(
                      onPressed: () {
                        showInfoDialog(
                          context,
                          "Terms of Service",
                          "By using this application, you agree to the following terms:\n - Do not use the app for any illegal or harmful purposes.\n - Content created within the app is for personal use only unless otherwise stated. \n - Features and services may change without prior notice. \n - We reserve the right to suspend or terminate accounts that violate these terms. \n Using the app implies your agreement to these terms. Please check back periodically for updates.",
                        );
                      },
                      child: Text(
                        "Terms",
                        style: TextStyle(
                          color: TColor.subTitle,
                          fontSize: 17 * textScale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(width: 15 * paddingScale),
                    TextButton(
                      onPressed: () {
                        showInfoDialog(
                          context,
                          "Privacy Policy",
                          "Your privacy is important to us. \n - We collect basic information such as your username and email to ensure the app functions properly. \n - Your information will never be shared with third parties without your consent, unless required by law. \n - We implement security measures to protect your data. \n - You may request to delete your data at any time through the app settings or by contacting us. \n By using the app, you consent to this privacy policy.",
                        );
                      },
                      child: Text(
                        "Privacy",
                        style: TextStyle(
                          color: TColor.subTitle,
                          fontSize: 17 * textScale,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: TColor.textbox, // תוכל להחליף לפי הצורך
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Text(content, style: const TextStyle(fontSize: 16)),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void handleDrawerTap(int index) {
    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateOwnStory()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BookQuestionsScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SequelToStory()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AccountView()),
        );
        break;
    }
    sideMenuScaffoldKey.currentState?.closeEndDrawer();
    setState(() {
      selectMenu = index;
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    await prefs.remove('token');
    await prefs.remove('user_id');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInView()),
    );
  }
}
