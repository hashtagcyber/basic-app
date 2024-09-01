# basic-app
Basic multi-platform mobile app with authentication, user profiles, and offline support

## Core requirements
- Written in Flutter/Dart for deployment to both iOS and Android
- Authentication and data storage using Supabase
- User profile management with privacy settings
- Offline support with local caching

## User stories
- As a user, I want to sign up and log in to access the app's features
- As a user, I want to verify my email address after signing up
- As a user, I want to see a welcome page with my username and a logout button after logging in
- As a user, I want to navigate between different screens using a menu
- As a user, I want to view and edit my profile information
- As a user, I want to set privacy settings for my profile information

## Project Structure
basic_app/
├── lib/
│ ├── main.dart
│ ├── config/
│ │ └── app_config.dart
│ ├── models/
│ │ └── user_profile.dart
│ ├── screens/
│ │ ├── login_screen.dart
│ │ ├── signup_screen.dart
│ │ ├── email_verification_screen.dart
│ │ ├── welcome_screen.dart
│ │ └── profile_screen.dart
│ ├── services/
│ │ └── auth_service.dart
│ └── widgets/
│   ├── custom_button.dart
│   └── navigation_menu.dart
├── scripts/
│ ├── update_supabase_schema.dart
│ └── schema.sql
├── test/
│ └── widget_test.dart
├── pubspec.yaml
└── README.md

## Setup Instructions
1. Clone the repository
2. Run `flutter pub get` to fetch the project dependencies
3. Create a `lib/config/app_config.dart` file with your Supabase URL and anonymous key:
   ```dart
   class AppConfig {
     static const String supabaseUrl = 'YOUR_SUPABASE_URL';
     static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   }
   ```
4. Run the SQL script in `scripts/schema.sql` in your Supabase SQL editor to set up the database schema

⚠️ **Important Note**: When using the `provider` package, always import it with an alias to avoid naming conflicts:

## Running the App
- iOS simulator: `flutter run -d ios`
- Android emulator: `flutter run -d android`
- Connected device: `flutter run`

## Screens
1. Login Screen: User authentication
2. Signup Screen: New user registration
3. Email Verification Screen: Prompts user to verify their email
4. Welcome Screen: Displays welcome message and logout button
5. Profile Screen: View and edit user profile information with privacy settings

## Navigation
The app includes a drawer-based navigation menu for easy screen transitions between the Welcome Screen and Profile Screen.

## Authentication Flow
1. Users can sign up with email and password
2. Email verification is required after signup
3. Users can log in with their verified email and password
4. Authentication state is managed by the AuthService

## Data Management
- User profiles are created upon signup and stored in Supabase
- Profile information includes username, email, name, pronouns, phone, website, and bio
- Profile information can be updated and is synced with Supabase when online
- Privacy settings for each profile field can be configured by the user
- User data is cached locally for offline access

## Offline Support
- The app can function without an internet connection
- User profiles are cached locally after login or signup
- Users can view and edit their profiles while offline
- Changes made offline are synced when the app regains internet connectivity

## Error Handling
- The app provides user-friendly error messages for authentication and profile update failures

## Future Improvements
- Implement password reset functionality
- Add social media authentication options
- Create a CI/CD pipeline for automated testing and deployment
- Add profile picture upload functionality