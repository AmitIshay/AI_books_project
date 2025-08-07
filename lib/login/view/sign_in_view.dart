import 'package:pjbooks/common/color_extenstion.dart';
import 'package:pjbooks/login/view/forgot_password_view.dart';
import 'package:flutter/material.dart';
import 'package:pjbooks/login/provider/auth_provider.dart';
import 'package:pjbooks/login/widgets/auth_widgets.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isStay = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.8,
            child: Image.asset(
              "assets/img/blue-background-with-isometric-book.jpg",
              width: media.width,
              height: media.height,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),

                      Text(
                        "Sign In",
                        style: TextStyle(
                          color: TColor.text,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 25),
                      RoundTextField(
                        key: Key('email_key'),
                        controller: txtEmail,
                        hintText: "Email Address",
                      ),
                      const SizedBox(height: 30),
                      RoundTextField(
                        key: Key('password_key'),
                        controller: txtPassword,
                        hintText: "Password",
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isStay = !isStay;
                                  });
                                },
                                icon: Icon(
                                  isStay
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color:
                                      isStay
                                          ? TColor.primary
                                          : TColor.subTitle.withOpacity(0.3),
                                ),
                              ),
                              Text(
                                "Stay Logged In",
                                style: TextStyle(
                                  color: TColor.showMessage2,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const ForgotPasswordView(),
                                  ),
                                );
                              },
                              child: Text(
                                "Forgot Your Password?",
                                style: TextStyle(
                                  color: TColor.showMessage2,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            // child: Row(
                            //   children: [
                            //     socialIcon("assets/img/google.png"),
                            //     SizedBox(width: 12), // Space between children,
                            //     socialIcon("assets/img/facebook.png"),
                            //     SizedBox(width: 12), // Space between children
                            //     socialIcon("assets/img/apple.png"),
                            //   ],
                            // ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                      const SizedBox(height: 30),
                      RoundLineButton(
                        key: Key('sign_in_key_login_screen'),
                        title: "Sign In",
                        onPressed:
                            () => handleSignIn(
                              context,
                              txtEmail.text.trim(),
                              txtPassword.text,
                              isStay,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          buildBackButton(context),
        ],
      ),
    );
  }
}
