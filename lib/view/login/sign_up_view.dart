import 'package:pjbooks/auth_service.dart';
import 'package:pjbooks/view/login/help_us_view.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../../common/color_extenstion.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';
import 'package:pjbooks/backend/user_prefs.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
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
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 70),

                      Text(
                        "Sign up",
                        style: TextStyle(
                          color: TColor.text,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      RoundTextField(
                        key: Key("text_input_name"),
                        controller: txtFirstName,
                        hintText: "First & Last Name",
                      ),
                      const SizedBox(height: 15),
                      RoundTextField(
                        key: Key("text_input_email"),
                        controller: txtEmail,
                        hintText: "Email Address",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 15),
                      const SizedBox(height: 15),
                      RoundTextField(
                        key: Key("text_input_phone"),
                        controller: txtMobile,
                        hintText: "Mobile Phone",
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 15),
                      RoundTextField(
                        key: Key("text_input_password"),
                        controller: txtPassword,
                        hintText: "Password",
                        obscureText: true,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // socialButton("assets/img/google.png", () async {
                          //   final user = await AuthService.signInWithGoogle();
                          //   if (user != null) {
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(
                          //         content: Text("Google Sign-In Successful"),
                          //       ),
                          //     );
                          //   } else {
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       const SnackBar(
                          //         content: Text("Google Sign-In Failed"),
                          //       ),
                          //     );
                          //   }
                          // }),
                          const SizedBox(width: 15),
                        ],
                      ),
                      RoundLineButton(
                        key: Key("sign up"),
                        title: "Sign Up",
                        onPressed: () async {
                          final res = await AuthService.signUp(
                            fullName: txtFirstName.text.trim(),
                            email: txtEmail.text.trim(),
                            mobile: txtMobile.text.trim(),
                            password: txtPassword.text,
                          );

                          if (res['statusCode'] == 201) {
                            final token = res['body']['token'];
                            final userId = res['body']['userId'];
                            final fullName = res['body']['full_name'];
                            final bio = res['body']['bio'] ?? "";
                            final location = res['body']['location'] ?? "";
                            final imageBase64 =
                                res['body']['image_base64'] ?? "";
                            final genres = res['body']['genres'] ?? List<String>;

                            // final prefs = await SharedPreferences.getInstance();
                            // await prefs.setString('token', token);
                            // await prefs.setString('user_id', userId);
                            await UserPrefs.saveTokenAndUserIdAndfull_name_bio_location_image_base64(
                              token,
                              userId,
                              fullName,
                              bio,
                              location,
                              imageBase64,
                              genres
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Signup successful"),
                              ),
                            );

                            // מעבר ישיר למסך הבית
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => HelpUsView(
                                      userId: res['body']['userId'],
                                    ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  res['body']['message'] ?? "Signup failed",
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

  Widget socialButton(String imagePath, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Image.asset(imagePath, height: 30),
      ),
    );
  }
}
