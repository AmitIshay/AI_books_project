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
// making a new Story
  void main() {



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

    const String title = "the sleeping princess";
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
    const questions =
    [
      {
       "question" :"What is the name of your book (if you have an idea)?",
        "answer" :"the magic dragon friends"
      },
      {
        "question":"What is the main idea or the subject of your book?",
        "answer" : "the main idea is to show how to make friends and work together"
      }
    ];



    const createStoryKey= Key("create story");

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

    //click on Story with assistance
    await tester.tap(find.byKey(keyAssistance));
    await tester.pumpAndSettle();

    //click on Basic Questions
    await tester.tap(find.byKey(basicQuestionsKey));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    for (var section in questions)
    {
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

    await tester.pump(const Duration(seconds:10));


    expect(find.text('the magic dragon friends'), findsOneWidget);

    SystemNavigator.pop();



  });

    testWidgets('test book from user', (WidgetTester tester) async {

      app.main();

// Simulate 3 seconds passing for Future.delayed
      await tester.pump(const Duration(seconds: 3));
      const String title = "The Magical Paintbrush";
      const String subject = "Creativity and Kindness";
      const String description = "A shy boy discovers a magical paintbrush that brings his drawings to life, teaching him the power of imagination and helping others.";

// Pages to story
      List pages = [
        "In the village of Willowbrook, a shy boy named Leo found an old paintbrush in his grandmother’s attic. It glowed with a soft blue light. Curious, he painted a tree—and to his amazement, it grew right out of the page!",
        "Leo painted birds, butterflies, and even a tiny pond. All of them came to life! Soon, the once-quiet village was full of magical creations, and everyone came to see Leo’s gift.",
        "But one day, he painted a thundercloud by mistake. It rumbled and poured rain for hours! 'What should I do?' he worried.",
        "Then he had an idea—he painted a giant sun with a big smile. The sun rose into the sky and dried all the rain. From that day on, Leo used his paintbrush to bring joy, color, and a little magic to everyone he met."
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

      await tester.tap(find.byKey(saveButtonKey));
      await tester.pump(const Duration(seconds: 5));



      //assert we are in the main screen
      expect(find.text('Our Top Picks'), findsOneWidget);
      //go to search screen

      //click on menu
      await tester.tap(find.byKey(keyMenu));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5));

      //click on Story from scratch
      await tester.tap(find.byKey(keyOption));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
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
      }
      final scrollableFinder = find.byType(ListView); // Or find.byKey(Key('my_scrollable_list'))
      await tester.drag(scrollableFinder, const Offset(0.0, -400.0)); // Negative dy scrolls down
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
}
