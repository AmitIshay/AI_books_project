import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pjbooks/backend/config.dart';
import 'package:pjbooks/backend/user_prefs.dart';
import 'package:pjbooks/bookPages/book.dart';
import 'package:pjbooks/bookPages/home_screen.dart';
import 'package:pjbooks/backend/book_service.dart';
import 'package:pjbooks/common/color_extenstion.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BookQuestionsScreen extends StatefulWidget {
  const BookQuestionsScreen({super.key});

  @override
  State<BookQuestionsScreen> createState() => _BookQuestionsScreenState();
}

class _BookQuestionsScreenState extends State<BookQuestionsScreen> {
  // Questions grouped by category
  bool isLoading = false;
  final Map<String, List<String>> questions = {
    "Basic Questions": [
      "What is the name of your book (if you have an idea)?",
      "What is the main idea or the subject of your book?",
    ],
    "Plot Questions": [
      "What is the starting point of the plot?",
      "What is the central conflict in the story?",
      "How do you envision the ending?",
    ],
    "Character Questions": [
      "Who is your main character?",
      "What is the goal of your main character?",
      "Are there secondary characters?",
      "Is there an antagonist in your story?",
    ],
    "World and Atmosphere Questions": [
      "Where does your story take place?",
      "What kind of atmosphere would you like to create in your book?",
      "Are there any special rules in your story's world?",
    ],
    "Message and Audience Questions": [
      "What message would you like to convey to your readers?",
      "Who is the target audience for your book?",
    ],
    "Additional Inspiration Questions": [
      "What is your inspiration for writing this book?",
      "If your book became a movie, who would you want to direct it?",
      "What is the title of the first chapter?",
      "What is a central scene you imagine in your head?",
      "If you could write only one sentence about your book, what would it be?",
    ],
    "Additional ideas": [
      "Tell us about any other ideas you'd like to include in the book that we haven't asked about yet.",
    ],
  };

  final Map<String, String> userAnswers = {}; // Store user answers
  void submitStory() async {
    setState(() {
      isLoading = true;
    });
    final token = await UserPrefs.getToken();
    final author = await UserPrefs.getFullName() ?? "Unknown";
    final random = Random();
    final numPages = (random.nextInt(8) + 3).toString();
    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("You must be logged in")));
      return;
    }
    if (userAnswers["What is the main idea or the subject of your book?"] ==
            null ||
        userAnswers["What is the name of your book (if you have an idea)?"] ==
            null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must answer the main idea and name of the book."),
        ),
      );
      return;
    }
    try {
      // המרת התשובות למחרוזת תיאור
      final descriptionBuffer = StringBuffer();
      userAnswers.forEach((question, answer) {
        descriptionBuffer.writeln("$question\n- $answer\n");
      });

      final aiStoryData = {
        "subject":
            userAnswers["What is the main idea or the subject of your book?"] ??
            "", // אפשר לעדכן בהמשך
        "numPages": numPages.toString(),
        "auther": author,
        "description": descriptionBuffer.toString(), // הכנסת התשובות כאן
        "title":
            userAnswers["What is the name of your book (if you have an idea)?"] ??
            "",
        "text_to_voice": true,
        "resolution": "1024x898",
      };

      final aiResponse = await http.post(
        Uri.parse("${Config.baseUrl}/api/story-ai/MagicOfStory/Story"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(aiStoryData),
      );

      final Map<String, dynamic> responseData = jsonDecode(aiResponse.body);

      if (aiResponse.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Book & AI story created successfully!"),
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("AI story error: ${aiResponse.body}")),
        );
      }

      await context.read<BookService>().loadBooks();

      final Book newBook = Book(
        title: responseData["title"],
        coverImage: responseData["pages"]?[0]?["img_url"] ?? "",
        pages:
            (responseData["pages"] as List<dynamic>)
                .map(
                  (page) => BookPage(
                    imagePath: page["img_url"] ?? "",
                    text: page["text_page"] ?? "",
                    voiceUrl: page["voice_file_url"] ?? "",
                  ),
                )
                .toList()
              ..add(
                BookPage(
                  imagePath: "",
                  text: "",
                  voiceUrl: "",
                  isEndPage: true,
                ),
              ),
      );

      for (var page in newBook.pages) {
        if (page.imagePath.isNotEmpty) {
          await precacheImage(NetworkImage(page.imagePath), context);
        }
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(book: newBook)),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    if (isLoading) {
      return loadScreen();
    } else {
      return Scaffold(
        body: Stack(
          children: [
            Opacity(
              opacity: 0.8,
              child: Image.asset(
                "assets/img/blue-background-with-isometric-book.jpg",
                width: media.width,
                height: media.height,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 70),

                      Text(
                        "Create your own story with assistance",
                        style: TextStyle(
                          color: TColor.text,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Answer the guiding questions to create a book tailored to your idea.",
                        style: TextStyle(color: TColor.subTitle, fontSize: 15),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Based on the answers you provide, we will be able to create a complete book that includes text and images based on your responses. Please note that it's not required to answer all the questions.",
                        style: TextStyle(color: TColor.subTitle, fontSize: 15),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: questions.keys.length,
                    itemBuilder: (context, categoryIndex) {
                      String category = questions.keys.elementAt(categoryIndex);
                      return Padding(
                        key: Key("${questions[category]}"),
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ExpansionTile(
                          title: Text(
                            category,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children:
                              questions[category]!.map((question) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        key: Key(question),
                                        question,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 8.0),
                                      TextField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Write your answer here...",
                                        ),
                                        maxLines: null,
                                        onChanged: (value) {
                                          setState(() {
                                            userAnswers[question] = value;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 16.0),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: submitStory,
                    icon: const Icon(Icons.book),
                    label: const Text("Create Story"),
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios, color: TColor.primary),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

loadScreen() {
  return Scaffold(
    backgroundColor: TColor.primary,
    body: Center(
      child: SpinKitCircle(
        size: 140,
        itemBuilder: (context, index) {
          final colors = [Colors.white, Colors.blue, Colors.indigoAccent];
          final color = colors[index % colors.length];
          return DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          );
        },
      ),
    ),
  );
}
