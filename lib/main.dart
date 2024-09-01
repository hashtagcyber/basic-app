import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:basic_app/config/app_config.dart';
import 'package:basic_app/services/auth_service.dart';
import 'package:basic_app/services/connectivity_service.dart';
import 'package:basic_app/screens/login_screen.dart';
import 'package:provider/provider.dart' as provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  final authService = AuthService(Supabase.instance.client);
  final connectivityService = ConnectivityService(authService);

  runApp(
    provider.MultiProvider(
      providers: [
        provider.Provider<AuthService>(create: (_) => authService),
        provider.ChangeNotifierProvider<ConnectivityService>(create: (_) => connectivityService),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}