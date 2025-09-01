// main.dart

import 'package:app/src/modules/dashboard-pregnant/homepage.dart';
import 'package:flutter/material.dart';

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
      home: HomePage(),
    );
  }
}
