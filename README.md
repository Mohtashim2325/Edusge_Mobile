EduSage Mobile

EduSage Mobile is a Flutter-based educational application designed to help teachers create and manage assessments efficiently while giving students a modern, interactive quiz-taking experience. The app uses AI-assisted features and Firebase to streamline learning and evaluation.

🚀 How to Start

Install Flutter & Git

Configure Firebase

Run the app using flutter run

That’s it.

✅ Requirements

Before running the project, make sure you have:

Flutter SDK (latest stable)

Git

Android Studio / VS Code

Firebase Project (created in Firebase Console)

A connected Android emulator, physical device, or Chrome (for web)

Optional but recommended:

FlutterFire CLI

dart pub global activate flutterfire_cli

🛠️ Project Setup
1️⃣ Clone the Repository
git clone https://github.com/Mohtashim2325/Edusge_Mobile.git
cd edusage_mobile

2️⃣ Install Dependencies
flutter pub get

3️⃣ Configure Firebase
flutterfire configure --platforms android,ios,web


This will generate firebase_options.dart automatically.

4️⃣ Run the App
flutter run

✨ Core Features
👨‍🏫 Teachers

AI-based quiz generation from topics or documents

Automated grading for MCQs

Quiz sharing via unique codes

Student performance tracking

In-app slide & research note creation

👨‍🎓 Students

Join quizzes using a 6-digit code

Timed, distraction-free exams

Instant results and feedback

Built-in AI chatbot for academic help

🧱 Tech Stack

Framework: Flutter (Material 3)

Backend: Firebase (Auth, Firestore)

State Management: Provider

UI & UX:

animate_do (animations)

lucide_icons (icons)

google_fonts (Inter)

🗂️ Project Structure (Simplified)
lib/
 ├── main.dart
 ├── models/
 ├── providers/
 ├── services/
 ├── screens/
 │   ├── teacher/
 │   └── student/
 └── widgets/


Feature-first architecture separates teacher and student modules for scalability.

🤝 Contributing

Contributions are welcome.

git checkout -b feature/YourFeature
git commit -m "Add YourFeature"
git push origin feature/YourFeature


Then open a Pull Request.