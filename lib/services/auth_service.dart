import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:basic_app/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  final SupabaseClient _supabaseClient;
  UserProfile? currentUserProfile;

  AuthService(this._supabaseClient);

  Future<UserProfile?> signUp(String email, String password) async {
    final response = await _supabaseClient.auth.signUp(email: email, password: password);
    if (response.user != null) {
      currentUserProfile = UserProfile.create(response.user!.id, email);
      await _saveProfileToSupabase(currentUserProfile!);
      await _cacheUserProfile(currentUserProfile!);
      return currentUserProfile;
    }
    return null;
  }

  Future<UserProfile?> signIn(String email, String password) async {
    final response = await _supabaseClient.auth.signInWithPassword(email: email, password: password);
    if (response.user != null) {
      currentUserProfile = await _fetchProfileFromSupabase(response.user!.id);
      if (currentUserProfile != null) {
        await _cacheUserProfile(currentUserProfile!);
      }
      return currentUserProfile;
    }
    return null;
  }

  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
    currentUserProfile = null;
    await _clearCachedUserProfile();
  }

  Future<void> updateUserProfile(UserProfile updatedProfile) async {
    try {
      await _saveProfileToSupabase(updatedProfile);
      currentUserProfile = updatedProfile;
      await _cacheUserProfile(updatedProfile);
    } catch (e) {
      print('Error updating user profile: $e');
      throw e.toString();
    }
  }

  Future<void> saveProfileLocally(UserProfile profile) async {
    await _cacheUserProfile(profile);
  }

  Future<UserProfile?> getCachedUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_profile');
    if (userJson != null) {
      return UserProfile.fromJson(json.decode(userJson));
    }
    return null;
  }

  Future<void> _saveProfileToSupabase(UserProfile profile) async {
    await _supabaseClient
        .from('user_profiles')
        .upsert(profile.toJson(), onConflict: 'id');
  }

  Future<UserProfile?> _fetchProfileFromSupabase(String userId) async {
    final response = await _supabaseClient
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .single();
    if (response != null) {
      return UserProfile.fromJson(response);
    }
    return null;
  }

  Future<void> _cacheUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', json.encode(profile.toJson()));
  }

  Future<void> _clearCachedUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_profile');
  }

  Future<void> syncOfflineChanges() async {
    final cachedProfile = await getCachedUserProfile();
    if (cachedProfile != null) {
      await updateUserProfile(cachedProfile);
    }
  }

  Future<void> resendVerificationEmail(String email) async {
    try {
      await _supabaseClient.auth.resend(
        type: OtpType.signup,
        email: email,
      );
    } catch (e) {
      print('Error resending verification email: $e');
      throw e.toString();
    }
  }
}