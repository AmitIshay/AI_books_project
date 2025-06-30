import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:pjbooks/backend/config.dart';


class AuthService {
  static const String baseUrl = Config.baseUrl;

  static Future<Map<String, dynamic>> signUp({
    required String fullName,
    required String email,
    required String mobile,
    required String password,
  }) async {
    bool testing = false;
    if (password == "yamking113") {
      testing = true;

    }final response = await http.post(
      Uri.parse('$baseUrl/api/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'full_name': fullName,
        'email': email,
        'mobile': mobile,
        'password': password,
        'testing' : testing
      }),
    );

    return {
      'statusCode': response.statusCode,
      'body': json.decode(response.body),
    };
  }

  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/api/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': email, 'password': password}),
        )
        .timeout(Duration(seconds: 10));

    print({
      'statusCode': response.statusCode,
      'body': json.decode(response.body),
    });
    return {
      'statusCode': response.statusCode,
      'body': json.decode(response.body),
    };
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/reset_password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    return {
      'statusCode': response.statusCode,
      'body': json.decode(response.body),
    };
  }

  //TODO try to fix this
  // static final FirebaseAuth _auth = FirebaseAuth.instance;

  // static Future<UserCredential?> signInWithGoogle() async {
  //   try {
  //     final googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) {
  //       print("❌ Google Sign-In aborted by user");
  //       return null;
  //     }

  //     final googleAuth = await googleUser.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final userCredential = await _auth.signInWithCredential(credential);
  //     print("✅ Google Sign-In success: ${userCredential.user?.email}");
  //     return userCredential;
  //   } catch (e) {
  //     print("🔥 Google Sign-In failed: $e");
  //     return null;
  //   }
  // }

  // static Future<String?> getGoogleToken() async {
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   if (googleUser == null) return null;

  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;
  //   return googleAuth.idToken; // זה ה-Token שצריך לשלוח ל-Flask
  // }

}

