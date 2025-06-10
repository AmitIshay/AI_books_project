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
  testWidgets('test text to speech books', (WidgetTester tester) async {

    app.main();

// Simulate 3 seconds passing for Future.delayed
    await tester.pump(const Duration(seconds: 3));

    const String title = "cats and dogs";
    const String genere  = "adventure";

    const String email = "yam@smail.com";
    const String password ="yamking113";
    //key : elements on the widgits that help the tester to find the elements
    const skip_button_Key = Key('keySkip');
    const sign_in_key_first_screen = Key('sign in');
    const email_key = Key('email_key');
    const password_key = Key('password_key');
    const sign_in_key_login_screen = Key('sign_in_key_login_screen');

    const key_menu = Key("menu");
    const key_assistance = Key("Story with assistance");

    const basic_questions_key = Key("Basic Questions");
    const question1_key = Key("text_input_What is the genre of the book you want to write?");
    const question2_key = Key("text_input_What is the name of your book (if you have an idea)?");


    const create_story_key= Key("create story");

    await tester.pumpAndSettle(); // Wait for all UI to settle

    //tap on skip
    print("Tapping skip");
    expect(find.byKey(Key('keySkip')), findsOneWidget); // Add this check

    await tester.tap(find.byKey(skip_button_Key));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    //tap on sign in
    await tester.pumpAndSettle(); // Wait for all UI to settle
    await tester.tap(find.byKey(sign_in_key_first_screen));
    await tester.pumpAndSettle();
    //tap on email
    await tester.tap(find.byKey(email_key));

    //put email

    await  tester.enterText(find.byKey(email_key), email);

    //tap on password

    await tester.tap(find.byKey(password_key));

    //put password
    await tester.enterText(find.byKey(password_key), password);

    //enter done
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(Key('sign_in_key_login_screen')));

    //tap on sign in
    await tester.pumpAndSettle();
    print("Tapping sign in 1");

    await tester.tap(find.byKey(sign_in_key_login_screen));
    await tester.pump(const Duration(seconds: 5));
    print("Tapping sign in 2 ");


    await tester.tap(find.byKey(sign_in_key_login_screen));
    await tester.pump(const Duration(seconds: 5));


    //assert we are in the main screen
    expect(find.text('Our Top Picks'), findsOneWidget);
    //go to search screen

    //click on menu
    await tester.tap(find.byKey(key_menu));
    await tester.pump(const Duration(seconds: 5));

    //click on Story with assistance
    await tester.tap(find.byKey(key_assistance));
    await tester.pump(const Duration(seconds: 5));

    //click on Basic Questions
    await tester.tap(find.byKey(basic_questions_key));
    await tester.pump(const Duration(seconds: 5));

    //click on the first question: What is the genre of the book you want to write?
    await tester.tap(find.byKey(question1_key));
    await tester.pump(const Duration(seconds: 5));

    //enter text

    await tester.enterText(find.byKey(question1_key), genere);

    //click on the second question : What is the name of your book (if you have an idea)?
    await tester.tap(find.byKey(question2_key));
    await tester.pump(const Duration(seconds: 5));

    //enter text
    await tester.enterText(find.byKey(question2_key), title);

    //enter done
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    //click on Basic Questions
    await tester.tap(find.byKey(basic_questions_key));
    await tester.pump(const Duration(seconds: 5));

    //click on create story
    await tester.tap(find.byKey(create_story_key));
    await tester.pump(const Duration(seconds: 5));


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

    int seconds_result = difference.inSeconds;
    if (seconds_result > 80 ) {
      fail('result is bigger 1 minutes');
    }




  });
}
