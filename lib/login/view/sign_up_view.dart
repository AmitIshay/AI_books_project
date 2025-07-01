import 'package:flutter/material.dart';
import 'package:pjbooks/login/provider/auth_provider.dart';
import 'package:pjbooks/login/widgets/auth_widgets.dart';
import '../../common/color_extenstion.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';

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
                        key: const Key("sign up"),
                        title: "Sign Up",
                        onPressed:
                            () => handleSignUp(
                              context: context,
                              fullName: txtFirstName.text.trim(),
                              email: txtEmail.text.trim(),
                              mobile: txtMobile.text.trim(),
                              password: txtPassword.text,
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
