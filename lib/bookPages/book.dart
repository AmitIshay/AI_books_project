class BookPage {
  final String imagePath;
  final String text;
  final String voiceUrl;
  final bool isEndPage;

  BookPage({
    required this.imagePath,
    required this.text,
    required this.voiceUrl,
    this.isEndPage = false,
  });
}

class Book {
  final String title;
  final String coverImage;
  final List<BookPage> pages;

  Book({required this.title, required this.coverImage, required this.pages});
}
