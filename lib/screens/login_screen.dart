import 'package:flutter/material.dart';
import 'package:basic_app/services/auth_service.dart';
import 'package:basic_app/screens/welcome_screen.dart';
import 'package:basic_app/screens/signup_screen.dart';
import 'package:basic_app/widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as provider;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authService = provider.Provider.of<AuthService>(context, listen: false);
        final userProfile = await authService.signIn(
          _emailController.text,
          _passwordController.text,
        );
        if (userProfile != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => WelcomeScreen(user: userProfile)),
          );
        } else {
          _showErrorSnackBar('Login failed. Please try again.');
        }
      } on AuthException catch (e) {
        _showErrorSnackBar(e.message);
      } catch (e) {
        _showErrorSnackBar('An unexpected error occurred');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
                ),
                SizedBox(height: 24),
                CustomButton(
                  onPressed: _login,
                  text: 'Login',
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SignupScreen(),
                    ));
                  },
                  child: Text('Don\'t have an account? Sign up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}