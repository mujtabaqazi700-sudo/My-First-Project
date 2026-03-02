import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Note.dart';
import 'Login.dart';

class Register extends StatefulWidget {
  static const String routeName = '/register';

  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> saveUser() async {
    final box = Hive.box('userBox');

    await box.put(
      emailController.text.trim(),
      {
        'username': usernameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      },
    );
  }

  Future<bool> userAlreadyExists() async {
    final box = Hive.box('userBox');
    return box.containsKey(emailController.text.trim());
  }

  @override
  void dispose() {
    usernameController.dispose();
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
          'Register',
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Create Account",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 20),

                  /// USERNAME
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// EMAIL
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// PASSWORD
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 25),

                  /// REGISTER BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (usernameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please fill all fields")),
                          );
                          return;
                        }

                        if (await userAlreadyExists()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("User already registered")),
                          );
                          return;
                        }

                        try {
                          await saveUser();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Registration Successful")),
                          );

                          Navigator.pushReplacementNamed(
                              context, Note.routeName);
                        } catch (e) {
                          print("Error saving user: $e");
                        }
                      },
                      child: const Text("Register"),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// LOGIN LINK
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Login.routeName);
                    },
                    child: const Text(
                      "Already have an account? Login",
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
