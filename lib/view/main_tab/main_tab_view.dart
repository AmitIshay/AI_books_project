import 'package:pjbooks/common/color_extenstion.dart';
import 'package:pjbooks/features/create_own_story.dart';
import 'package:pjbooks/features/create_story_assistance.dart';
import 'package:pjbooks/features/sequel_to_story.dart';
import 'package:flutter/material.dart';
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
    // {"name": "Sell With Us", "icon": Icons.attach_money},
    // {"name": "Newsletter", "icon": Icons.newspaper},
    // {"name": "Pop-up Leasing", "icon": Icons.open_in_new},
    {"name": "Account", "icon": Icons.account_circle},
  ];

  @override
  void initState() {
    controller = TabController(length: 4, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      key: sideMenuScaffoldKey,
      endDrawer: Drawer(
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children:
                      menuArr.map((mObj) {
                        var index = menuArr.indexOf(mObj);
                        return Container(
                          // margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 15,
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
                              if (index == 2) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            const BookQuestionsScreen(),
                                  ),
                                );
                                sideMenuScaffoldKey.currentState
                                    ?.closeEndDrawer();
                              } else if (index == 4) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AccountView(),
                                  ),
                                );
                                sideMenuScaffoldKey.currentState
                                    ?.closeEndDrawer();
                              } else if (index == 3) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SequelToStory(),
                                  ),
                                );
                                sideMenuScaffoldKey.currentState
                                    ?.closeEndDrawer();
                              } else if (index == 1) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const CreateOwnStory(),
                                  ),
                                );
                                sideMenuScaffoldKey.currentState
                                    ?.closeEndDrawer();
                              }

                              //

                              setState(() {
                                selectMenu = index;
                              });
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Icon(
                                  mObj["icon"] as IconData? ?? Icons.home,
                                  color:
                                      selectMenu == index
                                          ? Colors.white
                                          : TColor.primary,
                                  size: 33,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
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
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 15),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Terns",
                          style: TextStyle(
                            color: TColor.subTitle,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Privacy",
                          style: TextStyle(
                            color: TColor.subTitle,
                            fontSize: 17,
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
      ),
      body: TabBarView(
        controller: controller,
        children: [
          const HomeView(),
          const SearchView(),
          Container(),
          Container(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: TColor.primary,
        child: TabBar(
          controller: controller,
          indicatorColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: "Home"),
            Tab(icon: Icon(Icons.search), text: "Search"),
            Tab(icon: Icon(Icons.menu), text: "Wishlist"),
            Tab(icon: Icon(Icons.shopping_bag), text: "Cart"),
          ],
        ),
      ),
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // מוחק את כל פרטי ההתחברות
    await prefs.remove('is_logged_in');
    await prefs.remove('token');
    await prefs.remove('user_id');
    // await prefs.remove('seen_onboarding',); // אם ברצונך גם לאפס את מסכי ה־Onboarding

    // מעבר למסך ההתחברות
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInView()),
    );
  }
}
