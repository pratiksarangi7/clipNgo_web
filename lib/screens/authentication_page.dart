import 'package:clipngo_web/screens/part_screens/log_in.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset('lib/assets/images/salon.jpeg',
                      fit: BoxFit.cover),
                ),
              )),
          const Expanded(flex: 1, child: LogInScreen()),
        ],
      ),
    );
  }
}
