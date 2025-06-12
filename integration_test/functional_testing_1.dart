// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:pjbooks/main.dart' as app;


// //test 1 functional testing
// making a new Story from Scratch
  void main() {


  // Balance sliders:
  // Manual
  // With the help of artificial intelligence
  //

    // Script:
    // 1. We will enter a new user into the system
    //
    // 2. We will click on the option "Create a new story manually"
    //
    // 3. We will choose one of the two options
    //
    // 4. We will enter text into the system according to the selection
    //
    // 5. We will enter new images into the system from the server with a descriptive text accordingly
    //
    // 6. We will wait for a new children's book to be received
    //
    //
    //

    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('test book with assistance', (WidgetTester tester) async {

    app.main();

// Simulate 3 seconds passing for Future.delayed
    await tester.pump(const Duration(seconds: 3));

    const String title = "cats and dogs";
    const String genere  = "adventure";
    const String email = "yam_new@smail.com";
    const String password ="yamking113";
    const String name = "tony dan";
    const String phone = "052123456";
    List valuesSignUp = [
      {"value" :email , "key": Key("text_input_email")},
      {"value" :name , "key": Key("text_input_name")},
      {"value" : phone, "key": Key("text_input_phone")},
      {"value" : password, "key": Key("text_input_password")}
    ];
    List genres = ["Fantasy"
      ,"Adventure"
      ,"Romance"
      ,"Horror"];

    //key : elements on the widgits that help the tester to find the elements
    const skipButtonKey = Key('keySkip');
    const signUpKey = Key('sign up');
    const keyMenu = Key("menu");
    const keyAssistance = Key("Story with assistance");
    const saveButtonKey = Key("save");
    const basicQuestionsKey = Key("Basic Questions");
    const question1Key = Key("text_input_What is the genre of the book you want to write?");
    const question2Key = Key("text_input_What is the name of your book (if you have an idea)?");


    const createStoryKey= Key("create story");

    await tester.pumpAndSettle(); // Wait for all UI to settle

    //tap on skip
    print("Tapping skip");
    expect(find.byKey(Key('keySkip')), findsOneWidget); // Add this check

    await tester.tap(find.byKey(skipButtonKey));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    //tap on sign up
    await tester.pumpAndSettle(); // Wait for all UI to settle
    await tester.tap(find.byKey(signUpKey));
    await tester.pumpAndSettle();
   //enetr values
    for (var value in valuesSignUp)
    {
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

    for (var genre in genres)
    {
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
    await tester.pump(const Duration(seconds: 5));

    //click on Story with assistance
    await tester.tap(find.byKey(keyAssistance));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));

    //click on Basic Questions
    await tester.tap(find.byKey(basicQuestionsKey));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));

    //click on the first question: What is the genre of the book you want to write?
    await tester.tap(find.byKey(question1Key));
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 5));

    //enter text

    await tester.enterText(find.byKey(question1Key), genere);

    //click on the second question : What is the name of your book (if you have an idea)?
    await tester.tap(find.byKey(question2Key));
    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 5));

    //enter text
    await tester.enterText(find.byKey(question2Key), title);

    //enter done
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    //click on Basic Questions
    await tester.tap(find.byKey(basicQuestionsKey));
    await tester.pumpAndSettle();


    //click on create story
    await tester.tap(find.byKey(createStoryKey));
    await tester.pumpAndSettle();

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
    SystemNavigator.pop();



  });

    testWidgets('test book from user', (WidgetTester tester) async {

      app.main();

// Simulate 3 seconds passing for Future.delayed
      await tester.pump(const Duration(seconds: 3));

      const String title = "cats and dogs";
      //pages to story
      List pages = [
        "In a quiet town, cats and dogs lived on opposite sides of the park. They rarely spoke, but they watched each other with curiosity.One day, a mischievous puppy named Max saw a cat named Luna chasing butterflies. He barked playfully and joined in, startling her!",
        "Instead of getting angry, Luna laughed. 'You're fast for a dog,' she said. Max wagged his tail. From that day, they met every morning.",
        "When rain kept them inside, Luna came up with an idea. 'Let’s build a shelter for all animals!' Max barked in agreement.",
        "Cats and dogs worked together, bringing sticks, blankets, and treats. Soon, they had a cozy spot where everyone played, no matter the weather.From then on, the park was full of wagging tails and happy purrs. Max and Luna showed everyone that even the oldest rivalries can become the best friendships."
      ];


      const String email = "yam_new2@smail.com";
      const String password ="yamking113";
      const String name = "tony dan2";
      const String phone = "0521234256";
      List valuesSignUp = [
        {"value" :email , "key": Key("text_input_email")},
        {"value" :name , "key": Key("text_input_name")},
        {"value" : phone, "key": Key("text_input_phone")},
        {"value" : password, "key": Key("text_input_password")}
      ];
      List genres = ["Fantasy"
        ,"Adventure"
        ,"Romance"
        ,"Horror"];

      //key : elements on the widgits that help the tester to find the elements
      const skipButtonKey = Key('keySkip');
      const signUpKey = Key('sign up');
      const saveButtonKey = Key("save");

      const keyMenu = Key("menu");
      const keyOption = Key("Story from scratch");
      const titleKey = Key("title");
      const addPageKey =Key("add page");
      const createStoryKey= Key("create story");

      await tester.pumpAndSettle(); // Wait for all UI to settle

      //tap on skip
      print("Tapping skip");
      expect(find.byKey(Key('keySkip')), findsOneWidget); // Add this check

      await tester.tap(find.byKey(skipButtonKey));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      //tap on sign up
      await tester.pumpAndSettle(); // Wait for all UI to settle
      await tester.tap(find.byKey(signUpKey));
      await tester.pumpAndSettle();
      //enetr values
      for (var value in valuesSignUp)
      {
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

      for (var genre in genres)
      {
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
      await tester.pump(const Duration(seconds: 5));

      //click on Story with assistance
      await tester.tap(find.byKey(keyOption));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      //title

      await tester.tap(find.byKey(titleKey));
      await tester.enterText(find.byKey(titleKey), title);
      //enter done
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
      }

      //click on create story
      await tester.tap(find.byKey(createStoryKey));
      await tester.pumpAndSettle();

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




    });
}
