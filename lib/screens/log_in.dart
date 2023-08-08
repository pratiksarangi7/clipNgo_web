import 'package:flutter/material.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

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
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(150),
                child: Column(
                  children: [
                    const Text(
                      "Log-In",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const TextField(
                      style: TextStyle(fontSize: 22),
                      decoration: InputDecoration(
                          hintText: "Enter your admin ID",
                          prefixIcon: Icon(Icons.person_outline)),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const TextField(
                      style: TextStyle(fontSize: 22),
                      decoration: InputDecoration(
                          hintText: "Enter your password",
                          prefixIcon: Icon(Icons.lock)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: const Text("Forgot password?"))
                          ]),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary),
                          onPressed: () {},
                          child: Text(
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
                              onPressed: () {},
                              child: const Text("Register here"))
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
