import 'package:pjbooks/book_service.dart';
import 'package:pjbooks/common/color_extenstion.dart';
import 'package:pjbooks/view/main_tab/main_tab_view.dart';
import 'package:pjbooks/view/onboarding/onboarding_view.dart';
import 'package:pjbooks/view/onboarding/spalsh_screen.dart';
import 'package:pjbooks/view/onboarding/welcome_view.dart';
import 'package:pjbooks/view/page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('seen_onboarding');
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => BookService())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: TColor.primary, fontFamily: 'SF Pro Text'),
      home: const SplashScreen(),
    );
  }
}
