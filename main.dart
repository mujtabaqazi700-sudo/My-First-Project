import 'package:app/Login.dart';
import 'package:app/register.dart';
import 'package:app/splash.dart';
import 'package:app/Note.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('userBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        Login.routeName: (context) => const Login(
              username: '',
              email: '',
            ),
        Register.routeName: (context) => const Register(),
        Note.routeName: (context) => const Note(
              username: '',
              email: '',
            ),
      },
    );
  }
}
