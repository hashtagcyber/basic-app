import 'package:uuid/uuid.dart';

class UserProfile {
  String id;
  String username;
  String email;
  String name;
  String pronouns;
  String phone;
  String website;
  String bio;
  Map<String, bool> privacySettings;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    this.name = '',
    this.pronouns = '',
    this.phone = '',
    this.website = '',
    this.bio = '',
    Map<String, bool>? privacySettings,
  }) : this.privacySettings = privacySettings ?? {
          'email': false,
          'name': false,
          'pronouns': false,
          'phone': false,
          'website': false,
          'bio': false,
        };

  factory UserProfile.create(String id, String email) {
    final defaultUsername = 'User${Uuid().v4().substring(0, 12)}';
    return UserProfile(
      id: id,
      username: defaultUsername,
      email: email,
    );
  }

  UserProfile clone() {
    return UserProfile(
      id: id,
      username: username,
      email: email,
      name: name,
      pronouns: pronouns,
      phone: phone,
      website: website,
      bio: bio,
      privacySettings: Map.from(privacySettings),
    );
  }

  bool equals(UserProfile? other) {
    if (other == null) return false;
    return id == other.id &&
        username == other.username &&
        email == other.email &&
        name == other.name &&
        pronouns == other.pronouns &&
        phone == other.phone &&
        website == other.website &&
        bio == other.bio &&
        Map.from(privacySettings).toString() == Map.from(other.privacySettings).toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'pronouns': pronouns,
      'phone': phone,
      'website': website,
      'bio': bio,
      'privacy_settings': privacySettings,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      name: json['name'] ?? '',
      pronouns: json['pronouns'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      bio: json['bio'] ?? '',
      privacySettings: Map<String, bool>.from(json['privacy_settings'] ?? {}),
    );
  }
}