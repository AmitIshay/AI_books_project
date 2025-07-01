import 'package:pjbooks/common/color_extenstion.dart';
import 'package:pjbooks/onboarding/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int page = 0;
  PageController? controller = PageController();

  List pageArr = [
    {
      "title": "Welcome\nTo story time",
      "sub_title": "Use AI to create your dream books.",
      "img": "assets/img/1img.png",
    },
    {
      "title": "Write us the plot\nThe rest is on us!",
      "sub_title":
          "Write us the storyline, and we will create a book with illustrations.",
      "img": "assets/img/2img.png",
    },
    {
      "title": "Share your stories\nWith our community",
      "sub_title":
          "You can enjoy stories written by other users and share your own as well.",
      "img": "assets/img/3img.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    controller?.addListener(() {
      setState(() {
        page = controller?.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final orientation = media.orientation;
    final bottomPadding = orientation == Orientation.portrait ? 60.0 : 40.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Opacity(
              opacity: 0.8,
              child: Image.asset(
                "assets/img/blue-background-with-isometric-book.jpg",
                width: media.size.width,
                height: media.size.height,
                fit: BoxFit.cover,
              ),
            ),
            PageView.builder(
              controller: controller,
              itemCount: pageArr.length,
              itemBuilder: (context, index) {
                var pObj = pageArr[index] as Map? ?? {};
                double imageSize =
                    orientation == Orientation.portrait
                        ? size.width * 0.8
                        : size.height * 0.6;

                return SingleChildScrollView(
                  child: Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          pObj["title"].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TColor.showMessage,
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          pObj["sub_title"].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TColor.showMessage2,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Image.asset(
                          pObj["img"].toString(),
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomPadding,
              child: SafeArea(
                bottom: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        key: Key('keySkip'),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('seen_onboarding', true);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WelcomeView(),
                            ),
                          );
                        },
                        child: Text(
                          "Skip",

                          style: TextStyle(
                            color: TColor.showMessage2,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            pageArr.map((pObj) {
                              var index = pageArr.indexOf(pObj);
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  color:
                                      page == index
                                          ? TColor.primary
                                          : TColor.primaryLight,
                                  borderRadius: BorderRadius.circular(7.5),
                                ),
                              );
                            }).toList(),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (page < pageArr.length - 1) {
                            controller?.jumpToPage(page + 1);
                          } else {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('seen_onboarding', true);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WelcomeView(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(
                            color: TColor.showMessage2,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
