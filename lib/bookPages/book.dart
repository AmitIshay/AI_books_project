class BookPage {
  final String imagePath;
  final String text;
  final bool isEndPage;

  BookPage({
    required this.imagePath,
    required this.text,
    this.isEndPage = false,
  });
}

class Book {
  final String title;
  final String coverImage;
  final List<BookPage> pages;

  Book({required this.title, required this.coverImage, required this.pages});
}
