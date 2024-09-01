import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

void main() async {
  final supabaseUrl = Platform.environment['SUPABASE_URL'];
  final supabaseKey = Platform.environment['SUPABASE_KEY'];

  if (supabaseUrl == null || supabaseKey == null) {
    print('Error: SUPABASE_URL and SUPABASE_KEY environment variables must be set.');
    exit(1);
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  final client = Supabase.instance.client;

  try {
    // Check if the table exists
    final tableExists = await client
        .rpc('check_table_exists', params: {'table_name': 'user_profiles'})
        .execute();

    if (tableExists.data == false) {
      // Create the table if it doesn't exist
      await client.rpc('create_user_profiles_table').execute();
      print('Created user_profiles table.');
    } else {
      // Update the existing table
      await client.rpc('update_user_profiles_table').execute();
      print('Updated user_profiles table.');
    }

    print('Database schema update completed successfully.');
  } catch (e) {
    print('Error updating database schema: $e');
  } finally {
    client.dispose();
  }
}