# 📚 PJBooks - Create Your Own Story (Flutter)

PJBooks is a Flutter app that allows you to create, explore, and search for personalized books, combining AI to generate images and text based on your responses. The app includes three main features:
- Create a story page by page
- Answer guiding questions to build your idea
- Search and discover existing books by genre or author

---

## ✨ Key Features

### 📝 Create Your Own Story
- Write custom text for each page of the story.
- Features buttons: Add Page, Delete Page, Create Story.
- Send the story to the Flask server to generate content, including images.

### 🤖 Guiding Questions (`BookQuestionsScreen`)
- Questions grouped by categories: Idea, Characters, Conflict, Message, and more.
- Text fields for answering each question.
- Responses are stored in a map to build the story based on your answers.

### 🔍 Search and Discover (`SequelToStory`)
- Search dynamically for book titles or author names.
- Tags: *Your Books*, *Genre*, *News*.
- Filter results based on live text input.
- Grid view for book genres and list view for accurate search results.
- Navigation to detailed search screens (`SearchForceView`) and filter options (`SearchFilterView`).

---

## 🧱 Technologies

- Flutter + Dart
- REST API (to create the story on the server)
- Full support for Hebrew and English
- Local management with Shared Preferences
- UI built with `ExpansionTile`, `TextField`, `GridView`, and more.

---

## 📁 Main Files

| File | Description |
|------|------------|
| `create_own_story.dart` | Story creation screen with pages |
| `book_questions_screen.dart` | Guiding questions screen | 
| `sequel_to_story.dart` | Book search and filter screen |
| `search_force_view.dart` | Advanced search by keywords |
| `search_filter_view.dart` | Filter by categories or genre |

---
