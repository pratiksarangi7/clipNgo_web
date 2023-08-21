import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginOrRegisterProvider = StateProvider((ref) => 'login');
final isLoggedInProvider = StateProvider((ref) => 0);
final showCircularProgressIndicator = StateProvider((ref) => 0);
