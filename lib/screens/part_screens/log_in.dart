import 'package:clipngo_web/providers/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogInScreen extends ConsumerStatefulWidget {
  const LogInScreen({super.key});

  @override
  createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var showCircularProgressIndicator = false;

  Future<void> validateUser() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      ref.read(isLoggedInProvider.notifier).state = 1;
      print("Logged in successfully");
    } catch (e) {
      print("email:${_emailController.text}");
      print("pass: ${_passwordController.text}");
      print("Invalid entries");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(150),
      child: Column(
        children: [
          const Text(
            "Log-In",
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 50,
          ),
          TextField(
            controller: _emailController,
            style: const TextStyle(fontSize: 22),
            decoration: const InputDecoration(
                hintText: "Enter your clipNgo ID",
                prefixIcon: Icon(Icons.person_outline)),
          ),
          const SizedBox(
            height: 50,
          ),
          TextField(
            controller: _passwordController,
            style: const TextStyle(fontSize: 22),
            decoration: const InputDecoration(
                hintText: "Enter your password", prefixIcon: Icon(Icons.lock)),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                  onPressed: () {}, child: const Text("Forgot password?"))
            ]),
          ),
          const SizedBox(
            height: 60,
          ),
          SizedBox(
            width: double.infinity * 0.9,
            height: 45,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary),
                onPressed: () {
                  setState(() {
                    showCircularProgressIndicator = true;
                  });
                  validateUser();
                },
                child: showCircularProgressIndicator
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        "Login",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      )),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Haven't registered?"),
                TextButton(
                    // inside LogInScreen page we can change the state to register
                    onPressed: () {
                      ref.read(loginOrRegisterProvider.notifier).state =
                          'register';
                    },
                    child: const Text("Register here"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
