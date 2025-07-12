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



// //test 2 functional testing
// reading a story
void main() {
  //
  // 1. We will enter a non-new user into the system
  //
  // 2. We will click on the option "read book"
  //
  // 3. We will choose one of the two reading options aloud
  //
  // 4. We will check the reading of the book (that the screen is clear to read, the transitions between pages are smooth, there is no lack of text / image)
  //

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('test text to speech books: book that has text to speech ', (WidgetTester tester) async {

    app.main();

// Simulate 3 seconds passing for Future.delayed
    await tester.pump(const Duration(seconds: 3));
    List pages  = [

      "Once upon a time, in a land filled with bouncy castles and endless ice cream, lived a little boy named Timmy. Timmy loved playing with his toys and giggling with his friends. But one day, he asked his grandpa, \"Grandpa, what does it mean to become a man?\" Grandpa chuckled, a warm, rumbling sound. \"It's not about growing taller or louder, Timmy,\" he said. \"It's about growing bigger on the inside.\" He winked. \"It's about having a good heart.\"",

      "\"A good heart?\" Timmy tilted his head. \"How do I get one of those?\" Grandpa smiled. \"Well,\" he said, \"it starts with kindness. See that little bird with the broken wing?\" He pointed to a tiny sparrow. \"A man would try to help that bird, even if it's scared. Being a man is about taking care of others, both big and small.\" Timmy looked at the bird, then back at his grandpa, a thoughtful expression on his face.",

      "The next day, Timmy saw his friend, Lily, crying because she couldn't reach her kite stuck in a tree. Instead of laughing, Timmy thought hard. He found a long stick and, with careful effort, gently nudged the kite until it floated down. Lily's face lit up. \"Thank you, Timmy!\" she cried. That day, Timmy felt a warmth in his chest. Grandpa was right. Helping felt good.",

      "Being a man isn't just about helping others, though. It's also about being brave. One night, Timmy heard a strange noise outside his window. He felt a little scared, but instead of hiding under the covers, he peeked through the curtains. It was just the wind rustling the leaves! He took a deep breath and felt a little taller. Facing his fear, even a small one, made him feel stronger.",

      "Grandpa also taught Timmy about responsibility. \"A man,\" Grandpa said, \"takes care of his things and keeps his promises.\" So, Timmy started making his bed every morning and remembering to water his plant. He even remembered to return the library book he borrowed. It wasn't always easy, but he knew it was the right thing to do.",

      "Finally, Grandpa told Timmy, \"Being a man is about being yourself. Don't try to be someone you're not. Be kind, be brave, be responsible, and always, always be true to who you are.\" Timmy smiled. He understood now. It wasn't about muscles or a deep voice. It was about a kind heart, a brave spirit, and a promise to be the best Timmy he could be. And that, he knew, he could do."
    ];

    const book  = "pinocio";
    const String email = "yam@smail.com";
    const String password ="yamking113";
    const Key keySearchMainTap = Key("search  Main Tap");
    const skipButtonKey = Key('keySkip');
    const signInKeyFirstScreen = Key('sign in');
    const emailKey = Key('email_key');
    const passwordKey = Key('password_key');
    const signInKeyLoginScreen = Key('sign_in_key_login_screen');
    const searchKey = Key("search");

    const keyReadBook= Key("Read Book");
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
    //search for book
    await tester.tap(find.byKey(keySearchMainTap));
    await tester.pump(const Duration(seconds: 2));

    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 10));
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

    //tap on read
    await tester.tap(find.byKey(keyReadBook));
    await tester.pumpAndSettle();
    Key playStory = Key("Open Book");
    await tester.tap(find.byKey(playStory));
    await tester.pump(const Duration(seconds: 5));

    Key nextPageKey = Key("Next Page");

    for (var i=0 ; i<pages.length ; i+=1)
    {
      Key textToSpeechKey = Key("Play Sound${i}");

      //press on text to speech
      if (i%2==0 && i>0) {
        await tester.tap(find.byKey(nextPageKey));
      }
      await tester.pump(const Duration(seconds: 1));

      print("tap key sound ");

      await tester.tap(find.byKey(textToSpeechKey));

      await tester.pump(const Duration(seconds: 5));

      await tester.tap(find.byKey(textToSpeechKey));
      print("untap key sound ");

      print("find  key page text ");

      expect(find.text(pages[i]), findsOneWidget);

    }

  });


  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('test text to speech books: book does not have text to speech option', (WidgetTester tester) async {

    app.main();

// Simulate 3 seconds passing for Future.delayed
    await tester.pump(const Duration(seconds: 3));
    List pages =  [

      "Once upon a time, in a cozy little town nestled between rolling green hills, lived a fluffy white cat named Snowball. Snowball loved napping in sunbeams, batting at dust bunnies, and generally being a very important cat. He ruled his house with a gentle paw. Across the street, lived a bouncy, brown dog named Rusty. Rusty loved chasing squirrels, barking at mail trucks (who were clearly up to no good!), and wagging his tail with enough enthusiasm to knock over small children (accidentally, of course!). Snowball and Rusty were, well, not friends. They were, in fact, the opposite.",


      "Whenever Snowball saw Rusty in the yard, he'd puff up his fur and hiss! \"Hssss! Go away, you noisy mutt!\" he'd meow with disdain. Rusty, in return, would bark with playful energy, \"Woof! Come play, Snowball! Chasing squirrels is much more fun than napping!\" But Snowball would just flick his tail dismissively and retreat back inside to his comfy cushion. He didn't understand Rusty's energetic games. Rusty didn't understand Snowball's love for peace and quiet. They seemed destined to be rivals forever, separated by a fence and a whole lot of misunderstanding.",


      "One sunny afternoon, disaster struck! A big, gusty wind blew open the gate separating Snowball's yard from the street. Before he knew it, Snowball was outside, lost and scared, amidst the busy cars. He froze, his fur on end. Rusty, who had been happily chewing on a bone, saw Snowball's distress. He knew Snowball was afraid, even if Snowball wouldn't admit it. Without hesitation, Rusty sprang into action. He barked loudly, not angrily, but to get people's attention.",



      "Rusty then gently nudged Snowball with his nose, guiding him away from the cars and towards his own yard. Slowly, cautiously, Snowball followed. Soon, they were both safely inside Rusty's yard, the gate securely closed. Snowball, for the first time, looked at Rusty with something other than annoyance. He rubbed against Rusty's leg, a soft purr rumbling in his chest. Rusty wagged his tail, a happy grin on his face. Maybe, just maybe, being friends wasn't so bad after all. From that day on, Snowball and Rusty learned that even the biggest differences can be overcome with a little kindness and a whole lot of understanding.",


    ];

    const book  = "The Little Bear Who Lost His Roar";
    const String email = "yam@smail.com";
    const String password ="yamking113";
    const Key keySearchMainTap = Key("search  Main Tap");
    const skipButtonKey = Key('keySkip');
    const signInKeyFirstScreen = Key('sign in');
    const emailKey = Key('email_key');
    const passwordKey = Key('password_key');
    const signInKeyLoginScreen = Key('sign_in_key_login_screen');
    const searchKey = Key("search");

    const keyReadBook= Key("Read Book");
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
    //search for book
    await tester.tap(find.byKey(keySearchMainTap));
    await tester.pump(const Duration(seconds: 2));

    await tester.pumpAndSettle();

    await tester.pump(const Duration(seconds: 10));
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

    //tap on read
    await tester.tap(find.byKey(keyReadBook));
    await tester.pumpAndSettle();
    Key playStory = Key("Open Book");
    await tester.tap(find.byKey(playStory));
    await tester.pump(const Duration(seconds: 5));

    Key nextPageKey = Key("Next Page");

    for (var i=0 ; i<pages.length ; i+=1)
    {
      //press on text to speech
      if (i%2==0 && i>0) {
        await tester.tap(find.byKey(nextPageKey));
      }
      await tester.pump(const Duration(seconds: 1));


      print("find  key page text ");

      expect(find.text(pages[i]), findsOneWidget);

    }

  });




}
