import 'package:pjbooks/auth_service.dart';
import 'package:pjbooks/book_service.dart';
import 'package:pjbooks/common/color_extenstion.dart';
import 'package:pjbooks/view/login/forgot_password_view.dart';
import 'package:flutter/material.dart';
import 'package:pjbooks/view/main_tab/main_tab_view.dart';
import 'package:provider/provider.dart';

import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:pjbooks/backend/user_prefs.dart';

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
                        controller: txtEmail,
                        hintText: "Email Address",
                      ),
                      const SizedBox(height: 30),
                      RoundTextField(
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
                                  color: TColor.subTitle.withOpacity(0.3),
                                  fontSize: 15,
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
                                  color: TColor.subTitle.withOpacity(0.3),
                                  fontSize: 15,
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
                            child: Row(
                              children: [
                                socialIcon("assets/img/google.png"),
                                socialIcon("assets/img/facebook.png"),
                                socialIcon("assets/img/apple.png"),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                      const SizedBox(height: 30),
                      RoundLineButton(
                        title: "Sign In",
                        onPressed: () async {
                          final res = await AuthService.signIn(
                            email: txtEmail.text.trim(),
                            password: txtPassword.text,
                          );

                          if (res['statusCode'] == 200) {
                            final token = res['body']['token'];
                            final userId = res['body']['userId'];
                            final full_name = res['body']['full_name'];
                            final bio = res['body']['bio'];
                            final location = res['body']['location'] ?? "";
                            final image_base64 =
                                res['body']['image_base64'] ?? "";

                            await UserPrefs.saveTokenAndUserIdAndfull_name_bio_location_image_base64(
                              token,
                              userId,
                              full_name,
                              bio,
                              location,
                              image_base64,
                            );
                            await UserPrefs.setIsLoggedIn(isStay);
                            await context.read<BookService>().loadBooks();
                            await context
                                .read<BookService>()
                                .loadBooksTopPick();

                            // 🟨 שליפת הספרים מהשרת
                            // final booksRes = await BookService.getUserBooks(
                            //   token,
                            // );
                            // if (booksRes['statusCode'] == 200) {
                            // final books = booksRes['body']['books'];
                            // await UserPrefs.saveBooks(
                            //   List<Map<String, dynamic>>.from(books),
                            // );

                            // for (var book in books) {
                            //   print(
                            //     "Book: ${book['title']} by ${book['author']}",
                            //   );
                            // }

                            // אם אתה רוצה לשמור בזיכרון או לשתף דרך Provider / GetX / Riverpod וכו'
                            // או שאתה יכול להעביר ל־MainTabView ישירות

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Login successful")),
                            );

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainTabView(),
                              ),
                            );
                            // } else {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(
                            //       content: Text(
                            //         "Login succeeded, but failed to load books",
                            //       ),
                            //     ),
                            //   );
                            // }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  res['body']['message'] ?? "Login failed",
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: TColor.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container socialIcon(image) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Image.asset(image, height: 30),
    );
  }
}
