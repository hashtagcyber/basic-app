import 'package:uuid/uuid.dart';

class UserProfile {
  String id;
  String screenName;
  String username;

  UserProfile({
    required this.id,
    required this.screenName,
    required this.username,
  });

  factory UserProfile.create(String id) {
    final defaultUsername = 'User${Uuid().v4().substring(0, 12)}';
    return UserProfile(
      id: id,
      screenName: '',
      username: defaultUsername,
    );
  }

  void updateScreenName(String newScreenName) {
    screenName = newScreenName;
  }
}