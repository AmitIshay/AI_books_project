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
      "Leo loved Saturdays. Saturdays meant adventures, and today's adventure began with a bright red wagon and a mission: to find the best-tasting berry pie in the neighborhood. \"Ready, Pip?\" he whispered to his little dog, Pip, who wagged his tail furiously, a tiny pink bow bouncing on his head. Their first stop was Mrs. Gable's house, known for her award-winning roses and, rumor had it, a secret blueberry crumble recipe. Leo straightened his explorer's hat and took a deep breath. This was serious pie-hunting business.",
      "Knock, knock! The sound echoed slightly in the quiet afternoon. Mrs. Gable, with her spectacles perched on her nose and flour dusting her apron, opened the door with a warm smile. \"Well, good afternoon, Leo! And Pip, too! What brings you to my humble abode?\" Leo, ever the polite adventurer, explained his quest. Mrs. Gable chuckled. \"A noble pursuit indeed! While I have no berry pie today, I do have some fresh-baked apple turnovers. Perhaps they'll fuel your journey?\" Leo's eyes lit up. Apple was good, too! He carefully placed two turnovers in his wagon.",
      "Their next stop was the spooky old house at the end of Elm Street, where Mr. Henderson lived. Local legend said he only ate toast, but Leo had heard a whisper about a forgotten cherry pie recipe from his grandmother. Pip whimpered a little as they approached the creaky porch. \"It's okay, boy,\" Leo reassured him, though his own heart beat a little faster. This door was dark wood, unlike Mrs. Gable's welcoming yellow. He knocked, a little louder this time.",
      "The door slowly creaked open, revealing Mr. Henderson. He was tall and thin, with kind, crinkled eyes that seemed to hide a smile. \"Leo,\" he rumbled, his voice like soft thunder. \"And Pip. To what do I owe this... pie-seeking visit?\" Leo explained his quest again, a bit more quickly this time. Mr. Henderson listened, then disappeared for a moment, returning with a slightly lopsided, but wonderfully fragrant, cherry pie. \"My grandmother's recipe,\" he said softly. \"It's been a while since I made one.\" Leo carefully added the pie to his wagon, next to the apple turnovers. This was turning into a grand feast!",
      "With the cherry pie and apple turnovers secured, Leo and Pip decided they had found enough deliciousness for one day. Their wagon, once empty, now held treasures. They headed home, the scent of fruit and cinnamon following them. Leo realized it wasn't just about the pie; it was about the stories, the smiles, and the doors that opened to unexpected kindness. As they stepped through their own front door, Leo knew he'd found something even sweeter than any berry pie: the joy of connecting with his neighbors, one door at a time."
    ];

    const String book  = "Door to Door";
    const String email = "yam@smail.com";
    const String password ="yamking113";
    //key : elements on the widgits that help the tester to find the elements
    const skipButtonKey = Key('keySkip');
    const signInKeyFirstScreen = Key('sign in');
    const emailKey = Key('email_key');
    const passwordKey = Key('password_key');
    const signInKeyLoginScreen = Key('sign_in_key_login_screen');
    const searchKey = Key("search");
    const searchInputKey = Key("search_text_input");
    const cancelKey = Key("cancel");

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
    //go to search screen
    await tester.tap(find.byKey(searchKey));
    await tester.pump(const Duration(seconds: 5));

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
      final textFinder = find.byKey(Key('pages counter'));

      final textWidget = tester.widget<Text>(textFinder);
      String value = textWidget.data ?? '';
      int len = value.length;
      int pagesNum = int.parse(value.substring(len-1 ,len));

      if (pagesNum != pages.length) {
        fail("there is not correct number of pages");
      }
    for (var i=0 ; i<pagesNum ; i+=2)
    {
      //press on text to speech
      await tester.tap(find.byKey(textToSpeechKey));

      //see the text to speech in on text
      expect(find.text("text to speech on"), findsOneWidget);
      await tester.tap(find.byKey(textToSpeechKey));

      await tester.pump(const Duration(seconds: 5));

      await tester.tap(find.byKey(cancelKey));
      expect(find.text(pages[i]), findsOneWidget);
      expect(find.text(pages[i+1]), findsOneWidget);

    }




  });


  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('test text to speech books: book that has not text to speech ', (WidgetTester tester) async {

    app.main();

// Simulate 3 seconds passing for Future.delayed
    await tester.pump(const Duration(seconds: 3));
    List pages  = [
      "Barnaby the bear had a rumbling in his tummy. It wasn't just any rumble; it was a \"I need something sweet and sticky\" rumble. Barnaby loved honey more than napping in a sunbeam or splashing in the cool waters of the Yarkon River (which he sometimes imagined flowed further inland). Today, his nose twitched with the faintest, most delicious scent. Honey! The adventure had begun.",
      "Following his nose, Barnaby ambled past prickly pear bushes (he knew to be careful of those!), and under the shade of tall eucalyptus trees that rustled in the gentle breeze. The scent grew stronger, leading him towards a rocky outcrop dotted with wildflowers. High above, nestled in a crevice, Barnaby could see it – a golden, dripping honeycomb!",
      "Now, Barnaby wasn't the best climber. He was a bit round and a little clumsy. He tried one way, his claws scrabbling on the smooth rock. He tried another, his furry legs wobbling. A little bluebird perched on a nearby branch chirped encouragingly. Barnaby huffed. \"Easy for you to say, little friend!\" he grumbled good-naturedly.",
      "Suddenly, Barnaby spotted a sturdy, fallen branch leaning against the rocks. It wasn't a perfect bridge, but it looked like it might just reach. Taking a deep breath, Barnaby carefully stepped onto the branch. It swayed a little, and Pip, a small field mouse watching from below, squeaked nervously. Slowly, steadily, Barnaby shuffled across, his eyes fixed on the prize – the glistening honeycomb.",
      "Finally, Barnaby reached the crevice. He dipped a large paw into the sticky sweetness and brought it to his mouth. Oh, the taste! Golden sunshine and wildflower nectar all in one. He enjoyed a good, long lick, the rumbling in his tummy finally subsiding. Content and happy, Barnaby carefully made his way back across the branch, a little bit of honey still clinging to his fur. It had been a sweet adventure indeed, all for the love of honey in the sunny forest."
    ];

    const String book  = "bear and honey ";
    const String email = "yam@smail.com";
    const String password ="yamking113";
    //key : elements on the widgits that help the tester to find the elements
    const skipButtonKey = Key('keySkip');
    const signInKeyFirstScreen = Key('sign in');
    const emailKey = Key('email_key');
    const passwordKey = Key('password_key');
    const signInKeyLoginScreen = Key('sign_in_key_login_screen');
    const searchKey = Key("search");
    const searchInputKey = Key("search_text_input");
    const cancelKey = Key("cancel");

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
    //go to search screen
    await tester.tap(find.byKey(searchKey));
    await tester.pump(const Duration(seconds: 5));

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
    final textFinder = find.byKey(Key('pages counter'));

    final textWidget = tester.widget<Text>(textFinder);
    String value = textWidget.data ?? '';
    int len = value.length;
    int pagesNum = int.parse(value.substring(len-1 ,len));

    if (pagesNum != pages.length) {
      fail("there is not correct number of pages");
    }
    for (var i=0 ; i<pagesNum ; i+=2)
    {
      //press on text to speech
      await tester.tap(find.byKey(textToSpeechKey));

      //see the text to speech in on text
      expect(find.text("error text to speech is not available"), findsOneWidget);
      await tester.tap(find.byKey(textToSpeechKey));

      await tester.pump(const Duration(seconds: 5));

      await tester.tap(find.byKey(cancelKey));
      expect(find.text(pages[i]), findsOneWidget);
      expect(find.text(pages[i+1]), findsOneWidget);

    }




  });


}
