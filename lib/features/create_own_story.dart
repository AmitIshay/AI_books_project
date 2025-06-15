import 'package:flutter/material.dart';
import 'package:pjbooks/backend/config.dart';
import 'package:pjbooks/backend/user_prefs.dart';
import 'package:pjbooks/bookPages/book.dart';
import 'package:pjbooks/bookPages/home_screen.dart';
import 'package:pjbooks/book_service.dart';
import 'package:pjbooks/common/color_extenstion.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

class CreateOwnStory extends StatefulWidget {
  const CreateOwnStory({super.key});
  @override
  State<StatefulWidget> createState() => _CreateOwnStoryState();
}

class _CreateOwnStoryState extends State<CreateOwnStory> {
  List<TextEditingController> controllers = [TextEditingController()];
  TextEditingController titleController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    subjectController.dispose();
    descriptionController.dispose();
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void submitStory() async {
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('token');
    final token = await UserPrefs.getToken();
    final author = await UserPrefs.getFullName() ?? "Unknown";

    if (token == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("You must be logged in")));
      return;
    }

    if (titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a book title")),
      );
      return;
    }
    if (subjectController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a subject")));
      return;
    }
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a description")),
      );
      return;
    }

    Map<String, dynamic> pages = {};
    List<String> pagesTexts = [];

    for (int i = 0; i < controllers.length; i++) {
      String text = controllers[i].text.trim();
      if (text.isNotEmpty) {
        pages[(i + 1).toString()] = {
          "text": text,
          "image_url": "", // נוכל למלא בהמשך כשה-AI ייצור תמונות
        };
        pagesTexts.add(text);
      }
    }

    // final bookData = {
    //   "title": titleController.text.trim(),
    //   "author": author, // בהמשך תביא מהיוזר
    //   "pages": pages,
    // };

    try {
      // final response = await http.post(
      //   Uri.parse(
      //     "${Config.baseUrl}/api/books/createbook",
      //   ), // שים את הכתובת הנכונה
      //   headers: {
      //     "Content-Type": "application/json",
      //     "Authorization": "Bearer $token",
      //   },
      //   body: jsonEncode(bookData),
      // );
      // קריאה שנייה: יצירת סיפור עם AI
      final aiStoryData = {
        "subject": subjectController.text.trim(), // אתה יכול לשפר את זה מהמשתמש
        "numPages": pagesTexts.length,
        "auther": author,
        "description": descriptionController.text.trim(), // אפשר לבקש מהמשתמש
        "title": titleController.text.trim(),
        "text_to_voice": true,
        "resolution": "1024x898",
        "story_pages": pagesTexts,
      };
      final aiResponse = await http.post(
        Uri.parse("${Config.baseUrl}/api/story-ai/MagicOfStory/Story"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(aiStoryData),
      );
      print(aiStoryData);
      final Map<String, dynamic> responseData = jsonDecode(aiResponse.body);
      // if (aiResponse.statusCode == 201) {
      if (aiResponse.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Book & AI story created successfully!"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("AI story error: ${aiResponse.body}")),
        );
      }
      await context.read<BookService>().loadBooks();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book created successfully!")),
      );
      final Book newBook = Book(
        title: responseData["title"],
        coverImage: responseData["cover_image"] ?? "",
        pages:
            (responseData["pages"] as List<dynamic>).map((page) {
                return BookPage(
                  imagePath: page["img_url"] ?? "",
                  text: page["text_page"] ?? "",
                  voiceUrl: page["voice_file_url"] ?? "",
                );
              }).toList()
              ..add(
                BookPage(
                  imagePath: "",
                  text: "",
                  voiceUrl: "",
                  isEndPage: true,
                ),
              ), // עמוד סיום
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

      // final sampleBook = Book(
      //   title: 'sample book',
      //   coverImage: 'assets/images/cover.jpg',
      //   pages: [
      //     BookPage(
      //       imagePath: 'assets/images/image1.jpg',
      //       text: 'the begin of our story',
      //     ),
      //     BookPage(
      //       imagePath: 'assets/images/image2.jpg',
      //       text: ' the animals go to the trip',
      //     ),
      //     BookPage(
      //       imagePath: 'assets/images/image3.jpg',
      //       text: 'the trip keep contusion with many obstetrical',
      //     ),
      //     BookPage(imagePath: '', text: '', isEndPage: true),
      //   ],
      // );
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreen(book: sampleBook)),
      //   (route) => false,
      // );
      // Navigator.pop(context); // חזרה למסך הקודם או מעבר לספר
      // } else {
      //   ScaffoldMessenger.of(
      //     context,
      //   ).showSnackBar(SnackBar(content: Text("Error: ${aiResponse.body}")));
      // }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void addTextField() {
    if (controllers.last.text.trim().isNotEmpty) {
      setState(() {
        controllers.add(TextEditingController());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("The previous page is empty!")),
      );
    }
  }

  void deleteTextField(int index) {
    if (controllers.length > 1) {
      setState(() {
        controllers[index].dispose();
        controllers.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("you can't delete the last text")),
      );
    }
  }

  void showDeleteWarningDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteTextField(index);
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

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
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  top: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70),

                    Text(
                      "Create your own story",
                      style: TextStyle(
                        color: TColor.text,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Write the story and we will create a book for you with the text you've written and with images.",
                      style: TextStyle(color: TColor.subTitle, fontSize: 15),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Each text box represents a page in the book. Write the text you want to appear on the page, and we will combine all the pages into a complete book.",
                      style: TextStyle(color: TColor.subTitle, fontSize: 15),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: subjectController,
                      decoration: const InputDecoration(
                        labelText: "Subject",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Book Title",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // 🔽 שדות הטקסט
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controllers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controllers[index],
                                  minLines: 1,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                    labelText: "Page Number ${index + 1}",
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 244, 80, 68),
                                ),
                                onPressed: () => showDeleteWarningDialog(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // 🔽 הכפתורים
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: addTextField,
                            icon: const Icon(Icons.add),
                            label: const Text("Add Page"),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: submitStory,
                            icon: const Icon(Icons.book),
                            label: const Text("Create Story"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
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
