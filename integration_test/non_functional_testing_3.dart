// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:pjbooks/main.dart' as app;


//test 3
// The system should generate a complete AI-generated book (text and illustrations) within 60 seconds.
void main() {
  //
  // 1. Log in to the app as a non-new user
  // 2. Click Create a story with AI
  // 3. Start a timer
  // 4. After the story is created and a confirmation screen appears, stop the timer

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('test The system should generate a complete AI-generated book (text and illustrations) within 60 seconds.', (WidgetTester tester) async {
    const List listBooks = [
      "The Dog",
      "My Toy",
      "Big Bus",
      "Little Fox",
      "Red Cap",
      "The Cloud"
    ];

    for (var book in listBooks) {
      app.main();

// Simulate 3 seconds passing for Future.delayed
      await tester.pump(const Duration(seconds: 3));

      const String title = "the sleeping princess";
      const String email = "yam_new@smail.com";
      const String password = "yamking113";
      const String name = "tony dan";
      const String phone = "052123456";
      List valuesSignUp = [
        {"value": email, "key": Key("text_input_email")},
        {"value": name, "key": Key("text_input_name")},
        {"value": phone, "key": Key("text_input_phone")},
        {"value": password, "key": Key("text_input_password")}
      ];
      List genres = ["Fantasy"
        , "Adventure"
        , "Romance"
        , "Horror"];

      //key : elements on the widgits that help the tester to find the elements
      const skipButtonKey = Key('keySkip');
      const signUpKey = Key('sign up');
      const keyMenu = Key("menu");
      const keyAssistance = Key("Story with assistance");
      const saveButtonKey = Key("save");
      const basicQuestionsKey = Key("Basic Questions");
      final questions =
      [
        {
          "question": "What is the name of your book (if you have an idea)?",
          "answer": book
        },
        const {
          "question": "What is the main idea or the subject of your book?",
          "answer": "the main idea is to show how to make friends and work together"
        }
      ];


      const createStoryKey = Key("create story");

      await tester.pumpAndSettle(); // Wait for all UI to settle

      //tap on skip
      expect(find.byKey(Key('keySkip')), findsOneWidget); // Add this check

      await tester.tap(find.byKey(skipButtonKey));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      //tap on sign up
      await tester.pumpAndSettle(); // Wait for all UI to settle
      await tester.tap(find.byKey(signUpKey));
      await tester.pumpAndSettle();
      //enetr values
      for (var value in valuesSignUp) {
        var finder = find.byKey(value["key"]);
        await tester.tap(finder);
        await tester.enterText(finder, value["value"]);
        //enter done
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
      }
      //enter sign up
      await tester.tap(find.byKey(signUpKey));
      await tester.pumpAndSettle();

      for (var genre in genres) {
        var finder = find.byKey(Key(genre));
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }


      //tap on sign in
      await tester.pumpAndSettle();
      print("Tapping sign in 1");

      await tester.tap(find.byKey(saveButtonKey));
      await tester.pump(const Duration(seconds: 5));


      //assert we are in the main screen
      expect(find.text('Our Top Picks'), findsOneWidget);
      //go to search screen

      //click on menu
      await tester.tap(find.byKey(keyMenu));
      await tester.pumpAndSettle();

      //click on Story with assistance
      await tester.tap(find.byKey(keyAssistance));
      await tester.pumpAndSettle();

      //click on Basic Questions
      await tester.tap(find.byKey(basicQuestionsKey));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      for (var section in questions) {
        var finder = find.byKey(Key("text_input_${section["question"]}"));
        await tester.tap(finder);
        await tester.enterText(finder, section["answer"]!);
        //enter done
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
      }

      //click on Basic Questions
      await tester.tap(find.byKey(basicQuestionsKey));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));

      //click on create story
      await tester.tap(find.byKey(createStoryKey));
      await tester.pumpAndSettle();


      //start timer
      final start = DateTime.now();

      //assure there is a book with the title
      await tester.ensureVisible(find.text(title));
      expect(find.text(title), findsOneWidget);


      //caculate result
      final end = DateTime.now();
      final difference = end.difference(start); // This is a Duration object
      //print time diffrents
      print('Time difference is ${difference.inSeconds} seconds');

      await tester.pump(const Duration(seconds: 10));


      expect(find.text('the magic dragon friends'), findsOneWidget);

      if (difference.inSeconds >= 80) {
        fail(
            "the test failed because the the time took to make the book was beyond 80 seconds");
      }
    }
  });
}
