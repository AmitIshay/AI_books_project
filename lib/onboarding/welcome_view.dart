import 'package:pjbooks/login/view/sign_in_view.dart';
import 'package:pjbooks/login/view/sign_up_view.dart';
import 'package:flutter/material.dart';

import '../common/color_extenstion.dart';
import '../common_widget/round_button.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // רקע שקוף
          Opacity(
            opacity: 0.8,
            child: Image.asset(
              "assets/img/blue-background-with-isometric-book.jpg",
              width: media.width,
              height: media.height,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SizedBox(
              width: media.width,
              height: media.height,
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400, // או כל ערך שנראה לך מתאים
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: media.height * 0.15),
                        Text(
                          //"Books For\nEvery Taste.",
                          "Explore The Power Of Your Imagination!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: TColor.showMessage,
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: media.height * 0.05),
                        Image.asset(
                          "assets/img/4img.png",
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: media.height * 0.05),
                        RoundButton(
                          key: Key('sign in'),
                          title: "Sign in",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInView(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        RoundButton(
                          key: Key("sign up"),
                          title: "Sign up",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpView(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
