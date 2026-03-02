import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Note.dart';
import 'register.dart';

class Login extends StatefulWidget {
  static const String routeName = '/login';

  const Login({super.key, required String username, required String email});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// LOGIN FUNCTION
  Future<Map<String, dynamic>?> loginUser() async {
    final box = Hive.box('userBox');

    final user = box.get(emailController.text.trim());

    if (user == null) {
      return null;
    }

    if (passwordController.text.trim() == user['password']) {
      return Map<String, dynamic>.from(user);
    }

    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// EMAIL FIELD
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// PASSWORD FIELD
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  /// LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all fields"),
                            ),
                          );
                          return;
                        }

                        final user = await loginUser();

                        if (user != null) {
                          final email = user['email'];

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Login Successful")),
                          );

                          /// ✅ open hive box safely
                          if (!Hive.isBoxOpen('notesBox_$email')) {
                            await Hive.openBox('notesBox_$email');
                          }

                          /// ✅ navigate AFTER box ready
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Note(
                                username: user['username'],
                                email: email,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text("Login"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// REGISTER NAVIGATION
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        Register.routeName,
                      );
                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
