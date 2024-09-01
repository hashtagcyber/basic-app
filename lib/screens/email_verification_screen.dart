import 'package:flutter/material.dart';
import 'package:basic_app/services/auth_service.dart';
import 'package:provider/provider.dart' as provider;

class EmailVerificationScreen extends StatelessWidget {
  final String email;

  EmailVerificationScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify Your Email')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Please check your email to verify your account.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final authService = provider.Provider.of<AuthService>(context, listen: false);
                  await authService.resendVerificationEmail(email);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Verification email resent')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to resend verification email: $e')),
                  );
                }
              },
              child: Text('Resend Verification Email'),
            ),
          ],
        ),
      ),
    );
  }
}