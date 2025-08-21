// main.dart

import 'package:flutter/material.dart';
import 'package:app/src/modules/auth/login/login_screen.dart';
import 'package:app/src/modules/onboarding/onboarding_screen.dart'; // Corrigido o caminho do onboarding

// Variável para forçar o onboarding a ser sempre falso
bool onboardingCompleted = false;

void main() async {
  // Apenas para fins de teste, o SharedPreferences não será lido
  // WidgetsFlutterBinding.ensureInitialized();
  // final prefs = await SharedPreferences.getInstance();
  // onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloom',
      theme: ThemeData(primarySwatch: Colors.blue),
      // A tela inicial agora será sempre o OnboardingScreen
      home: onboardingCompleted ? const LoginScreen() : OnboardingScreen(),
    );
  }
}
