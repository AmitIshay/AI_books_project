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
    const List listBooks = [
      "The Dog",
      "My Toy",
      "Big Bus",
      "Little Fox",
      "Red Cap",
      "The Cloud"
    ];
    app.main();

// Simulate 3 seconds passing for Future.delayed
    await tester.pump(const Duration(seconds: 3));

    const Key keySearchMainTap = Key("search  Main Tap");

    const keyReadBook= Key("Read Book");

    const String email = "yam@smail.com";
    const String password ="yamking113";
    //key : elements on the widgits that help the tester to find the elements
    const skipButtonKey = Key('keySkip');
    const signInKeyFirstScreen = Key('sign in');
    const emailKey = Key('email_key');
    const passwordKey = Key('password_key');
    const signInKeyLoginScreen = Key('sign_in_key_login_screen');
    const searchKey = Key("search");

    //key to find the text to speach button
    const textToSpeechKey = Key("text_to_speech_key");

    await tester.pumpAndSettle(); // Wait for all UI to settle

    //tap on skip
    print("Tapping skip");
    expect(find.byKey(Key('keySkip')), findsOneWidget); // Add this check

    await tester.tap(find.byKey(skipButtonKey));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    //tap on sign in
    await tester.pumpAndSettle(); // Wait for all UI to settle
    await tester.tap(find.byKey(signInKeyFirstScreen));
    await tester.pumpAndSettle();
    //tap on email
    await tester.tap(find.byKey(emailKey));

    //put email

    await  tester.enterText(find.byKey(emailKey), email);

    //tap on password

    await tester.tap(find.byKey(passwordKey));

    //put password
    await tester.enterText(find.byKey(passwordKey), password);

    //enter done
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(Key('sign_in_key_login_screen')));

    //tap on sign in
    await tester.pumpAndSettle();
    print("Tapping sign in 1");

    await tester.tap(find.byKey(signInKeyLoginScreen));
    await tester.pump(const Duration(seconds: 5));
    print("Tapping sign in 2 ");


    await tester.tap(find.byKey(signInKeyLoginScreen));
    await tester.pump(const Duration(seconds: 5));


    //assert we are in the main screen
    expect(find.text('Our Top Picks'), findsOneWidget);
    //go to search
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.byKey(keySearchMainTap));
    await tester.pump(const Duration(seconds: 2));

    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 10));

    int sumTime = 0;
    for (var book in listBooks)
    {
      //enter book name
      await tester.enterText(find.byKey(searchKey), book);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      //press on the result
      var keyBook = Key("book_$book");

      await tester.pump(const Duration(seconds: 7));

      await tester.tap(find.byKey(keyBook));

      await tester.pump(const Duration(seconds: 5));

      //tap on read
      await tester.tap(find.byKey(keyReadBook));
      await tester.pumpAndSettle();
      Key playStory = Key("Open Book");
      await tester.tap(find.byKey(playStory));
      await tester.pump(const Duration(seconds: 5));


      //start timer
      final start = DateTime.now();
      //press on text to speech
      await tester.tap(find.byKey(textToSpeechKey));

      //see the text to speech in on text
      expect(find.text("text to speech on"), findsOneWidget);
      await tester.tap(find.byKey(textToSpeechKey));

      await tester.pump(const Duration(seconds: 1));



      //stop timer
      final end = DateTime.now();
      final difference = end.difference(start); // This is a Duration object
      //print time diffrents
      print('Time difference is ${difference.inSeconds} seconds');

      int seconds = difference.inSeconds;

      sumTime +=seconds;
      final backButton = find.byType(BackButton);
      // Tap it
      await tester.tap(backButton);
      await tester.pumpAndSettle();
    }

    //caculate result
    int avg = (sumTime / listBooks.length).round(); // rounds to nearest int    //2:30 minuts  = 150 seconds

    if (avg > 150 ) {
      fail('avg is bigger then 2:30 minutes');
    }




  });
}
