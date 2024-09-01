import 'package:flutter/material.dart';
import 'package:basic_app/models/user_profile.dart';
import 'package:basic_app/services/auth_service.dart';
import 'package:basic_app/screens/login_screen.dart';
import 'package:basic_app/widgets/custom_button.dart';
import 'package:basic_app/widgets/navigation_menu.dart';
import 'package:provider/provider.dart' as provider;

class WelcomeScreen extends StatelessWidget {
  final UserProfile user;

  WelcomeScreen({required this.user});

  void _logout(BuildContext context) async {
    final authService = provider.Provider.of<AuthService>(context, listen: false);
    await authService.signOut();  // Changed from logout to signOut
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      drawer: NavigationMenu(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, ${user.username}!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}