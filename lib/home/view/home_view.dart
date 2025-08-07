import 'package:pjbooks/backend/book_service.dart';
import 'package:pjbooks/common/color_extenstion.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pjbooks/home/provider/home_provider.dart';
import '../../common_widget/genres_cell.dart';
import '../../common_widget/top_picks_cell.dart';
import 'main_tab_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  late HomeViewProvider provider;
  final BookService service = BookService();

  @override
  void initState() {
    super.initState();
    provider = HomeViewProvider(
      service: service,
      setState: setState,
      context: context,
    );
    provider.loadTopPick();
    provider.loadMostRated();
    provider.loadGenresUser();
    provider.loadRecentAdded();
    provider.loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Align(
                  child: Transform.scale(
                    scale: 1.5,
                    origin: Offset(0, media.width * 0.8),
                    child: Container(
                      width: media.width,
                      height: media.width,
                      decoration: BoxDecoration(
                        color: TColor.primary,
                        borderRadius: BorderRadius.circular(media.width * 0.5),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SizedBox(height: media.width * 0.1),
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Row(
                        children: const [
                          Text(
                            "Our Recommended Books:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      leading: Container(),
                      leadingWidth: 1,
                      actions: [
                        IconButton(
                          key: Key("menu"),
                          onPressed: () {
                            sideMenuScaffoldKey.currentState?.openEndDrawer();
                          },
                          icon: const Icon(Icons.menu, size: 50),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: media.width,
                      height: media.width * 0.5,
                      child: CarouselSlider.builder(
                        itemCount: provider.topPicksArr.length,
                        itemBuilder: (
                          BuildContext context,
                          int itemIndex,
                          int pageViewIndex,
                        ) {
                          var iObj =
                              provider.topPicksArr[itemIndex] as Map? ?? {};
                          return GestureDetector(
                            onTap: () {
                              provider.openBookById(iObj['id'], context);
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Bestsellers",
                            style: TextStyle(
                              color: TColor.text,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.6,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 8,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.bestArr.length,
                        itemBuilder: ((context, index) {
                          var bObj = provider.bestArr[index] as Map? ?? {};

                          return GestureDetector(
                            onTap: () {
                              provider.openBookById(bObj['id'], context);
                            },

                            child: TopPicksCell(iObj: bObj),
                          );
                        }),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Genres",
                            style: TextStyle(
                              color: TColor.text,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.3,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 8,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.genresArr.length,
                        itemBuilder: ((context, index) {
                          String bObj = provider.genresArr[index] ?? "";

                          return GenresCell(
                            bObj: bObj,
                            bgcolor:
                                index % 2 == 0 ? TColor.color1 : TColor.color2,
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: media.width * 0.1),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Recently Added",
                            style: TextStyle(
                              color: TColor.text,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.5,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 8,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.recentArr.length,
                        itemBuilder: ((context, index) {
                          var bObj = provider.recentArr[index] as Map? ?? {};

                          return GestureDetector(
                            onTap: () {
                              provider.openBookById(bObj['id'], context);
                            },

                            child: TopPicksCell(iObj: bObj),
                          );
                        }),
                      ),
                    ),
                    // SizedBox(
                    //   height: media.width * 0.1,
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: Row(children: [
                    //     Text(
                    //       "Monthly Newsletter",
                    //       style: TextStyle(
                    //           color: TColor.text,
                    //           fontSize: 22,
                    //           fontWeight: FontWeight.w700),
                    //     )
                    //   ]),
                    // ),
                    // Container(
                    //   width: double.maxFinite,
                    //   margin: const EdgeInsets.symmetric(
                    //       vertical: 20, horizontal: 20),
                    //   padding: const EdgeInsets.symmetric(
                    //       vertical: 15, horizontal: 15),
                    //   decoration: BoxDecoration(
                    //       color: TColor.textbox.withOpacity(0.4),
                    //       borderRadius: BorderRadius.circular(15)),
                    //   child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           "Receive our monthly newsletter and receive updates on new stock, books and the occasional promotion.",
                    //           style: TextStyle(
                    //             color: TColor.subTitle,
                    //             fontSize: 12,
                    //           ),
                    //         ),
                    //         const SizedBox(
                    //           height: 15,
                    //         ),
                    //         RoundTextField(
                    //           controller: txtName,
                    //           hintText: "Name",
                    //         ),
                    //         const SizedBox(
                    //           height: 15,
                    //         ),
                    //         RoundTextField(
                    //           controller: txtEmail,
                    //           hintText: "Email Address",
                    //         ),
                    //         const SizedBox(
                    //           height: 15,
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.end,
                    //           children: [
                    //             MiniRoundButton(
                    //               title: "Sign Up",
                    //               onPressed: () {
                    //                 Navigator.push(
                    //                     context,
                    //                     MaterialPageRoute(
                    //                         builder: (context) =>
                    //                             const SignUpView()));
                    //               },
                    //             )
                    //           ],
                    //         )
                    //       ]),
                    // ),
                    // SizedBox(
                    //   height: media.width * 0.1,
                    // ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
