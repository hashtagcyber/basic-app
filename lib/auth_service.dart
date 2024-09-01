import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_profile.dart';

class AuthService {
  final SupabaseClient _supabaseClient;
  UserProfile? currentUserProfile;

  AuthService(this._supabaseClient);

  Future<void> signUp(String email, String password) async {
    final response = await _supabaseClient.auth.signUp(email: email, password: password);
    if (response.user != null) {
      currentUserProfile = UserProfile.create(response.user!.id);
      // Save the user profile to your database here
    }
  }

  Future<void> signIn(String email, String password) async {
    final response = await _supabaseClient.auth.signInWithPassword(email: email, password: password);
    if (response.user != null) {
      // Fetch the user profile from your database here
      // For now, we'll create a new one
      currentUserProfile = UserProfile.create(response.user!.id);
    }
  }

  // Add methods to update and save the user profile
}