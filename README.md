# Academic Advising & Student Follow-up System

A comprehensive Flutter application designed to facilitate communication and management between students, academic advisors, and guidance managers within an educational institution.

## Project Overview

The Academic Advising & Student Follow-up System is a mobile application that aims to streamline the academic advising process by providing a platform for:

* **Students** to communicate with their academic advisors, access academic forms, and manage their profiles
* **Academic Advisors** to manage their assigned students, communicate with guidance managers, and track student progress
* **Guidance Managers** to oversee the advising system, manage student and advisor accounts, and generate reports

## Features

### Student Features
- Academic chat with advisors
- Access and submit academic forms
- Profile and account settings
- Secure authentication

### Academic Advisor Features
- View and manage assigned students
- Chat with guidance managers
- Profile and account settings
- Student progress tracking

### Guidance Manager Features
- Upload student and advisor files
- Create dean accounts
- View all students and advisors
- Generate various reports (including reports for struggling students)
- Account management

## Technology Stack

- **Frontend:** Flutter
- **State Management:** BLoC Pattern (flutter_bloc)
- **Authentication:** Firebase Authentication
- **Database:** Firebase Firestore (assumed)
- **Storage:** Firebase Storage (assumed)
- **Caching:** Local storage solution
- **Fonts:** Google Fonts (Tajawal)

## Project Structure

### Repositories
- **auth_repository** - Handles authentication logic
- **user_repository** - Manages user data and profiles
- **student_repository** - Student-specific data and operations
- **advisor_repository** - Advisor-specific data and operations
- **manager_repository** - Manager-specific data and operations
- **chat_repository** - Manages chat functionality
- **form_repository** - Handles academic forms
- **reports_repository** - Manages report generation and access

### Main Directories
- `/lib` - Application source code
  - `/models` - Data models
  - `/repositories` - Data access layer
  - `/screens` - UI screens for different user types
  - `/shared` - Shared utilities and components
  - `/tools` - Helper functions and widgets
  - `/cubit` - BLoC implementation

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/academic-advising-system.git
```

2. Navigate to the project directory:
```bash
cd academic-advising-system
```

3. Install dependencies:
```bash
flutter pub get
```

4. Configure Firebase:
   - Create a Firebase project
   - Add your Android and iOS apps to the Firebase project
   - Download and add the configuration files (`google-services.json` and `GoogleService-Info.plist`)
   - Enable Authentication, Firestore, and Storage in Firebase console

5. Run the app:
```bash
flutter run
```

## Configuration

Ensure you have the following environment variables set in a `.env` file (not included in version control):

```
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_APP_ID=your_firebase_app_id
FIREBASE_PROJECT_ID=your_firebase_project_id
```

## Development Guidelines

- Use BLoC pattern for state management
- Follow Flutter's style guide and best practices
- Write unit tests for repositories and business logic
- Document all public APIs and complex functions
- Use Arabic for user-facing text (RTL layout)


## Contributors

- Ibrahim Nasser Darwish Mostafa

## Acknowledgments

- Special thanks to [Your Institution/University] for supporting this project
