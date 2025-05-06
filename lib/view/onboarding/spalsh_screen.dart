import 'package:flutter/material.dart';
import 'package:pjbooks/view/main_tab/main_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pjbooks/view/onboarding/onboarding_view.dart';
import 'package:pjbooks/view/login/sign_in_view.dart';
import 'package:pjbooks/backend/user_prefs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkFirstTime();
  }

  Future<void> checkFirstTime() async {
    // final prefs = await SharedPreferences.getInstance();
    // bool hasSeenOnboarding = prefs.getBool('seen_onboarding') ?? false;
    // bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    bool hasSeenOnboarding = await UserPrefs.getSeenOnboarding();
    bool isLoggedIn = await UserPrefs.getIsLoggedIn();
    if (!hasSeenOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingView()),
      );
    } else if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainTabView()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInView()),
      );
    }
  }

  Future<void> logout() async {
    await UserPrefs.clearAll();
    // final prefs = await SharedPreferences.getInstance();

    // // מוחק את כל פרטי ההתחברות
    // await prefs.remove('is_logged_in');
    // await prefs.remove('token');
    // await prefs.remove('user_id');
    // await prefs.remove(
    //   'seen_onboarding',
    // ); // אם ברצונך גם לאפס את מסכי ה־Onboarding

    // מעבר למסך ההתחברות
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
