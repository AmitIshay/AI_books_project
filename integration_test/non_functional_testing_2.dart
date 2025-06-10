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


//test 2 The system should start text-to-speech narration within 1 second of clicking the speaker icon.
void main() {


  // 1. Given that the database is full of children's books that have been written in the past
  // 2. A loop that will go through five children's books that are definitely in the database
  // 3. Inside the loop, we click on the "Read" option for each book and start a timer from the moment we click the button until the moment we start reading
  // 4. Calculate the average time and make sure it says between a second and a second and a half
  //


  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('test text to speech books', (WidgetTester tester) async {

    app.main();

// Simulate 3 seconds passing for Future.delayed
    await tester.pump(const Duration(seconds: 3));


    const listBooks = ["The Fatal Tree","Day Four","Door to Door","cats and dogs","john big adventure"];

    const String email = "yam@smail.com";
    const String password ="yamking113";
    //key : elements on the widgits that help the tester to find the elements
    const skip_button_Key = Key('keySkip');
    const sign_in_key_first_screen = Key('sign in');
    const email_key = Key('email_key');
    const password_key = Key('password_key');
    const sign_in_key_login_screen = Key('sign_in_key_login_screen');
    const search_key = Key("search");
    const search_input_key = Key("search_text_input");
    const cancel_key = Key("cancel");

    //key to find the text to speach button
    const text_to_speech_key = Key("text_to_speech_key");

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
    await tester.tap(find.byKey(search_key));
    await tester.pump(const Duration(seconds: 5));
    int sum_time = 0;
    for (var book in listBooks)
    {

      //tap on search bar
      await tester.pump(const Duration(seconds: 5));

      await tester.tap(find.byKey(search_input_key));
      await tester.pump(const Duration(seconds: 5));
      //enetr book name
      await tester.enterText(find.byKey(search_input_key), book);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      //press on the result
      var key_book = Key("book_$book");

      expect(find.text(book), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));

      await tester.tap(find.byKey(key_book));

      await tester.pump(const Duration(seconds: 5));

      await tester.tap(find.byKey(key_book));
      //check if there is book
      expect(find.text(book), findsOneWidget);

      //start timer
      final start = DateTime.now();
      //press on text to speech
      await tester.tap(find.byKey(text_to_speech_key));

      //see the text to speech in on text
      expect(find.text("text to speech on"), findsOneWidget);
      await tester.tap(find.byKey(text_to_speech_key));

      await tester.pump(const Duration(seconds: 5));



      //stop timer
      final end = DateTime.now();
      final difference = end.difference(start); // This is a Duration object
      //print time diffrents
      print('Time difference is ${difference.inSeconds} seconds');

      int seconds = difference.inSeconds;

      sum_time +=seconds;
      await tester.pump(const Duration(seconds: 5));

      await tester.tap(find.byKey(cancel_key));

    }

    //caculate result
    int avg = (sum_time / listBooks.length).round(); // rounds to nearest int    //2:30 minuts  = 150 seconds

    if (avg > 150 ) {
      fail('avg is bigger then 2:30 minutes');
    }




  });
}
