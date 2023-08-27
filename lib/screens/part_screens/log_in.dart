import 'package:clipngo_web/providers/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clipngo_web/screens/map_screen.dart';
import 'package:mapbox_search/mapbox_search.dart';

class LogInScreen extends ConsumerStatefulWidget {
  const LogInScreen({super.key});

  @override
  createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var showCircularProgressIndicator = false;
  final _registrationEmailController = TextEditingController();
  final _addressController = TextEditingController();
  var _addressEmpty = true;
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

  Future<void> _openMap(BuildContext context, {required String search}) async {
    var placesSearch = PlacesSearch(
      apiKey:
          'pk.eyJ1IjoiYnl0ZWJ1aWxkZXJzIiwiYSI6ImNsbGtwdDI4cTB5c2czZnBheWRvc21yczEifQ.fbPEIx1XlNGrznz-pC6wng',
      limit: 5,
    );
    final places = await placesSearch.getPlaces(search);

    final List<List<double>> mapBoxPlaces = places!.map((place) {
      final latitude = place.geometry!.coordinates![1];
      final longitude = place.geometry!.coordinates![0];
      return [latitude, longitude];
    }).toList();

    double longitude = mapBoxPlaces[0][1];
    double latitude = mapBoxPlaces[0][0];
    // print("The latitude is: $latitude");
    // print("The longitude is: $longitude");
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select precise salon location on the map'),
          content: Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Click on the screen to move the marker'),
                SizedBox(
                  height: 500,
                  width: 800,
                  child:
                      MapScreen(myLatitude: latitude, myLongitude: longitude),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginOrRegister = ref.watch(loginOrRegisterProvider);
    return Padding(
      padding: const EdgeInsets.all(150),
      child: Column(
        children: [
          Text(
            loginOrRegister == 'login' ? "Log-In" : "Register",
            style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 50,
          ),
          loginOrRegister == 'login'
              ? TextField(
                  controller: _emailController,
                  style: const TextStyle(fontSize: 22),
                  decoration: const InputDecoration(
                      hintText: "Enter your clipNgo ID",
                      prefixIcon: Icon(Icons.person_outline)),
                )
              : TextField(
                  controller: _registrationEmailController,
                  style: const TextStyle(fontSize: 22),
                  decoration: const InputDecoration(
                    hintText: "Enter your email address",
                    prefixIcon: Icon(Icons.mail_outline_rounded),
                  ),
                ),
          const SizedBox(
            height: 50,
          ),
          loginOrRegister == 'login'
              ? TextField(
                  controller: _passwordController,
                  style: const TextStyle(fontSize: 22),
                  decoration: const InputDecoration(
                      hintText: "Enter your password",
                      prefixIcon: Icon(Icons.lock)),
                )
              : TextField(
                  controller: _addressController,
                  onChanged: (_) {
                    setState(
                      () {
                        if (_addressController.text.isNotEmpty) {
                          _addressEmpty = false;
                        } else {
                          _addressEmpty = true;
                        }
                      },
                    );
                  },
                  style: const TextStyle(fontSize: 22),
                  decoration: const InputDecoration(
                    hintText: "Enter Salon Address to open map",
                    prefixIcon: Icon(Icons.location_on_rounded),
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: loginOrRegister == 'login'
                ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    TextButton(
                        onPressed: () {},
                        child: const Text("Forgot password?")),
                  ])
                : ElevatedButton(
                    onPressed: _addressEmpty
                        ? null
                        : () {
                            _openMap(context, search: _addressController.text);
                          },
                    child: const Text("Go to Map"),
                  ),
          ),
          const SizedBox(
            height: 60,
          ),
          SizedBox(
            width: double.infinity * 0.9,
            height: 45,
            child: loginOrRegister == 'login'
                ? ElevatedButton(
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
                          ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    onPressed: () {},
                    child: showCircularProgressIndicator
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Register",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                  ),
          ),
          // const SizedBox(
          //   height: 15,
          // ),
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(loginOrRegister == 'login'
                    ? "Haven't registered?"
                    : "Already registered?"),
                TextButton(
                  // inside LogInScreen page we can change the state to register
                  onPressed: () {
                    loginOrRegister == 'login'
                        ? ref.read(loginOrRegisterProvider.notifier).state =
                            'register'
                        : ref.read(loginOrRegisterProvider.notifier).state =
                            'login';
                  },
                  child: Text(loginOrRegister == 'login'
                      ? "Register here"
                      : "Login from here"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
