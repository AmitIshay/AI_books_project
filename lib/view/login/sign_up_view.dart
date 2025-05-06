import 'package:pjbooks/auth_service.dart';
import 'package:pjbooks/view/login/help_us_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: TColor.primary),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                controller: txtFirstName,
                hintText: "First & Last Name",
              ),
              const SizedBox(height: 15),
              RoundTextField(
                controller: txtEmail,
                hintText: "Email Address",
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              const SizedBox(height: 15),
              RoundTextField(
                controller: txtMobile,
                hintText: "Mobile Phone",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),
              RoundTextField(
                controller: txtPassword,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  socialButton("assets/img/google.png", () async {
                    final user = await AuthService.signInWithGoogle();
                    if (user != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Google Sign-In Successful"),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Google Sign-In Failed")),
                      );
                    }
                  }),
                  const SizedBox(width: 15),
                ],
              ),
              RoundLineButton(
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
                    final full_name = res['body']['full_name'];
                    // final prefs = await SharedPreferences.getInstance();
                    // await prefs.setString('token', token);
                    // await prefs.setString('user_id', userId);
                    await UserPrefs.saveTokenAndUserIdAndfull_name(
                      token,
                      userId,
                      full_name,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Signup successful")),
                    );

                    // מעבר ישיר למסך הבית
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                HelpUsView(userId: res['body']['userId']),
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
