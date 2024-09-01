import 'package:flutter/material.dart';
import 'package:basic_app/services/auth_service.dart';
import 'package:basic_app/screens/email_verification_screen.dart';
import 'package:basic_app/widgets/custom_button.dart';
import 'package:provider/provider.dart' as provider;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authService = provider.Provider.of<AuthService>(context, listen: false);
        final user = await authService.signUp(
          _emailController.text,
          _passwordController.text,
        );
        if (user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => EmailVerificationScreen(
                email: _emailController.text,
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
              ),
              SizedBox(height: 16),
              CustomButton(
                onPressed: _signUp,
                text: 'Sign Up',
              ),
            ],
          ),
        ),
      ),
    );
  }
}