import 'package:pjbooks/common/color_extenstion.dart';
import 'package:pjbooks/view/main_tab/main_tab_view.dart';
import 'package:pjbooks/view/onboarding/onboarding_view.dart';
import 'package:pjbooks/view/onboarding/spalsh_screen.dart';
import 'package:pjbooks/view/onboarding/welcome_view.dart';
import 'package:pjbooks/view/page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final prefs = await SharedPreferences.getInstance();
  // await prefs.remove('seen_onboarding');
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: TColor.primary,

        fontFamily: 'SF Pro Text',
      ),
      home: const SplashScreen(),
    );
  }
}
