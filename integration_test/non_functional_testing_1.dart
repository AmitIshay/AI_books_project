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

//test 1 The system should start text-to-speech narration within 1 second of clicking the speaker icon.
void main() {
  //
  // 1. Given that the database is full of children's books written in the past
  // 2. A loop that will go through five names of children's books that are definitely in the database
  // 3. Inside the loop, we will run a timer from the beginning of entering the book name in the search input until the book is displayed
  // 4. At the end of the loop, we will check that the average search time for a book was 2 minutes

    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('test search books', (WidgetTester tester) async {

  app.main();

// Simulate 3 seconds passing for Future.delayed
    await tester.pump(const Duration(seconds: 3));


    const listBooks = [
      "Cat and Dog",
      "My Ball",
      "Big Car",
      "Little Bear",
      "Red Hat"
    ];
    const String email = "yam@smail.com";
    const String password ="yamking113";

    const skipButtonKey = Key('keySkip');
    const signInKeyFirstScreen = Key('sign in');
    const emailKey = Key('email_key');
    const passwordKey = Key('password_key');
    const signInKeyLoginScreen = Key('sign_in_key_login_screen');
    const searchKey = Key("search");
    const searchInputKey = Key("search_text_input");
    const cancelKey = Key("cancel");


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
    //go to search screen
    await tester.tap(find.byKey(searchKey));
    await tester.pump(const Duration(seconds: 5));
    int sumTime = 0;
    for (var book in listBooks)
    {
      //start timer
      final start = DateTime.now();
      //tap on search bar
      await tester.pump(const Duration(seconds: 5));

      await tester.tap(find.byKey(searchInputKey));
      await tester.pump(const Duration(seconds: 5));
      //enetr book name
      await tester.enterText(find.byKey(searchInputKey), book);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      //press on the result
      var keyBook = Key("book_$book");

      expect(find.text(book), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));

      await tester.tap(find.byKey(keyBook));

      await tester.pump(const Duration(seconds: 5));

      await tester.tap(find.byKey(keyBook));
      //check if there is book
      expect(find.text(book), findsOneWidget);

      //stop timer

      final end = DateTime.now();
      final difference = end.difference(start); // This is a Duration object
      //print time diffrents
      print('Time difference is ${difference.inSeconds} seconds');

      int seconds = difference.inSeconds;

      sumTime +=seconds;
      await tester.pump(const Duration(seconds: 5));

      await tester.tap(find.byKey(cancelKey));

    }

    //caculate result
    int avg = (sumTime / listBooks.length).round(); // rounds to nearest int    //2:30 minuts  = 150 seconds

    if (avg > 150 ) {
      fail('avg is bigger then 2:30 minutes');
    }




  });
}
