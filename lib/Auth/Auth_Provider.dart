import 'package:firebase_auth/firebase_auth.dart';
import '/Auth/auth_exceptions.dart';

import 'AuthUser.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  // ignore: non_constant_identifier_names
  Future<AuthUser> LogIn({
    required email,
    required password,
  });

  // ignore: non_constant_identifier_names
  Future<AuthUser> CreateUser({
    required email,
    required password,
  });
  // ignore: non_constant_identifier_names
  Future<void> SendEmailVerification() async {
    final user = await FirebaseAuth.instance.currentUser;
    if (user != null)
      user.sendEmailVerification();
    else
      throw UserNotLoggedInAuthException();
  }

  // ignore: non_constant_identifier_names
  Future<void> LogOut() async {}
  Future<void> reload() async {}
  Future<void> init() async {}
}
