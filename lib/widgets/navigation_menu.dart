import 'package:flutter/material.dart';
import 'package:basic_app/screens/welcome_screen.dart';
import 'package:basic_app/screens/profile_screen.dart';
import 'package:basic_app/services/auth_service.dart';
import 'package:provider/provider.dart' as provider;

class NavigationMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = provider.Provider.of<AuthService>(context, listen: false);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Welcome'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen(user: authService.currentUserProfile!)),
              );
            },
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}