import 'package:fingram/games/game.dart';
import 'package:fingram/helper.dart';
import 'package:fingram/shop/shop.dart';
import 'package:fingram/users/user_profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'main_routes/welcome_screen.dart';
import 'lessons/lessons_page.dart';
import 'main_routes/signup_screen.dart';
import 'main_routes/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseDatabase.instance.setLoggingEnabled(true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'welcome_screen',
      routes: {
        'welcome_screen': (context) => const WelcomeScreen(),
        'registration_screen': (context) => const RegistrationScreen(),
        'login_screen': (context) => const LoginScreen(),
        'user_profile': (context) => const UserProfilePage(),
        'game': (context) => const MainMenu(),
        'shop': (context) => const ShopPage(),
        'helper': (context) => const Helper(),
        'Уроки': (context) => const LessonsPage()
      },
    );
  }
}
