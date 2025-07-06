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

// //test 3 functional testing
// making a sequel to a story

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('test make sequel book - original book is found ', (WidgetTester tester) async {

    app.main();

// Simulate 3 seconds passing for Future.delayed
    await tester.pump(const Duration(seconds: 3));

    const book  = "pinocio";
    const String email = "yam@smail.com";
    const String password ="yamking113";

    const skipButtonKey = Key('keySkip');
    const signInKeyFirstScreen = Key('sign in');
    const emailKey = Key('email_key');
    const passwordKey = Key('password_key');
    const signInKeyLoginScreen = Key('sign_in_key_login_screen');
    const searchKey = Key("search");
    const keyMenu = Key("menu");
    const keyAssistance = Key("Sequel to Story");
    const keyMakeSequel = Key("make sequel");
    const titleKey = Key("Book Title");
    const descriptionKey  = Key("Description");
    const subjectKey  = Key("subject");
    const addPageKey =Key("Add Page");
    const createStoryKey= Key("Create Story");
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
    //go to main
    await tester.tap(find.byKey(keyMenu));
    await tester.pump(const Duration(seconds: 5));

    //go to 3 option
    await tester.tap(find.byKey(keyAssistance));
    await tester.pump(const Duration(seconds: 2));

    //search for book
      await tester.tap(find.byKey(searchKey));
      await tester.pump(const Duration(seconds: 5));
      //enter book name
      await tester.enterText(find.byKey(searchKey), book);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      //press on the result
      var keyBook = Key("book_$book");

      await tester.pump(const Duration(seconds: 7));

      await tester.tap(find.byKey(keyBook));

      await tester.pump(const Duration(seconds: 5));

      //tap on make sequel
    await tester.tap(find.byKey(keyMakeSequel));
    await tester.pumpAndSettle();

    //making the sequel
    const String title = "Pinocchio: A New Adventure";
    const String subject = "Sequel to Pinocchio";
    const String description = "After becoming a real boy, Pinocchio sets out on a journey beyond his village. Along the way, he discovers friendship, forgotten toys, and what it truly means to be alive.";
    List<String> pages = [
      "After becoming a real boy, Pinocchio lived happily with Geppetto. But soon, he began to wonder what lay beyond their quiet village.",

      "One morning, he packed a small bag, kissed Geppetto goodbye, and set off to explore the world—promising to return before the first snowfall.",

      "In a nearby town, Pinocchio met a girl named Lila who had a mysterious music box. She said it once belonged to her grandfather, an inventor.",

      "That night, the music box glowed and opened a secret map hidden inside. It led to the 'Island of Forgotten Toys'—a place full of magic.",

      "Excited, Pinocchio and Lila followed the map. Along the way, they helped a broken wind-up soldier, who joined them on the journey.",

      "They finally reached the island, where toys lost or thrown away lived in silence. Pinocchio felt a deep connection—he was once one of them.",

      "Suddenly, a storm hit the island. Pinocchio bravely helped the toys take shelter, using quick thinking and kindness to lead them.",

      "After the storm, the island began to shine again. The toys elected Pinocchio as their hero and gave him a glowing wooden heart as thanks.",

      "Pinocchio and Lila said goodbye to their new friends and returned home. Geppetto hugged him tightly, proud of the boy Pinocchio had become.",

      "That night, as he lay in bed, Pinocchio held the glowing heart and smiled. He had once wanted to be real—and now, he truly felt alive."
    ];
    //subject
    await tester.tap(find.byKey(subjectKey));
    await tester.enterText(find.byKey(subjectKey), subject);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    //description
    await tester.tap(find.byKey(descriptionKey));
    await tester.enterText(find.byKey(descriptionKey), description);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    //title

    await tester.tap(find.byKey(titleKey));
    await tester.enterText(find.byKey(titleKey), title);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    int index = 0;
    for (var page in pages)
    {
      //enter text page
      var finder = find.byKey(Key( "Page Number ${index + 1}"));
      await tester.tap(finder);
      await tester.enterText(finder, page);
      //enter done
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(addPageKey));
      await tester.pumpAndSettle();
      index+=1;
      final scrollableFinder = find.byType(ListView); // Or find.byKey(Key('my_scrollable_list'))
      await tester.drag(scrollableFinder, const Offset(0.0, -400.0)); // Negative dy scrolls down
    }
    final scrollableFinder = find.byType(ListView); // Or find.byKey(Key('my_scrollable_list'))
    await tester.drag(scrollableFinder, const Offset(0.0, -520.0)); // Negative dy scrolls down
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

  });


  testWidgets('test make sequel book - original book is not found ', (WidgetTester tester) async {


    app.main();

// Simulate 3 seconds passing for Future.delayed
    await tester.pump(const Duration(seconds: 3));

    const book  = "harry poter and the secret stone";
    const String email = "yam@smail.com";
    const String password ="yamking113";

    const skipButtonKey = Key('keySkip');
    const signInKeyFirstScreen = Key('sign in');
    const emailKey = Key('email_key');
    const passwordKey = Key('password_key');
    const signInKeyLoginScreen = Key('sign_in_key_login_screen');
    const searchKey = Key("search");
    const keyMenu = Key("menu");
    const keyAssistance = Key("Sequel to Story");
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
    //go to main
    await tester.tap(find.byKey(keyMenu));
    await tester.pump(const Duration(seconds: 5));

    //go to 3 option
    await tester.tap(find.byKey(keyAssistance));
    await tester.pump(const Duration(seconds: 2));

    //search for book
    await tester.tap(find.byKey(searchKey));
    await tester.pump(const Duration(seconds: 5));
    //enter book name
    await tester.enterText(find.byKey(searchKey), book);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    //press on the result
    var keyBook = Key("book_$book");

    final errorTextFinder = find.byKey(keyBook);

    // Fail the test if any visible text contains the book name
    expect(errorTextFinder, findsNothing);
    print("test pass");
  });
}
