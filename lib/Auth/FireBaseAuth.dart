import 'package:firebase_core/firebase_core.dart';
import '/Auth/AuthUser.dart';
import '/Auth/Auth_Provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '/Auth/auth_exceptions.dart';
import '/Components/HandleSigninUpErrors.dart';
import '/firebase_options.dart';

class FirebBaseAuth implements AuthProvider {
  @override
  // ignore: non_constant_identifier_names
  Future<AuthUser> CreateUser({required email, required password}) async {
    try {
      await firebase.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;

      if (user != null)
        return user;
      else
        throw UserNotLoggedInAuthException();
    } on firebase.FirebaseAuthException catch (e) {
      handleFirebaseError(e);
      throw GenericAuthException(); // Ensure an exception is thrown
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<AuthUser> LogIn({required email, required password}) async {
    try {
      await firebase.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;

      if (user != null)
        return user;
      else
        throw AppNotInitialized();
    } on firebase.FirebaseAuthException catch (e) {
      handleFirebaseError(e);
      throw GenericAuthException(); // Ensure an exception is thrown
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<void> LogOut() async {
    try {
      await firebase.FirebaseAuth.instance.signOut();
    } on firebase.FirebaseAuthException catch (e) {
      handleFirebaseError(e);
      throw GenericAuthException(); // Ensure an exception is thrown
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<void> SendEmailVerification() async {
    try {
      final user = await firebase.FirebaseAuth.instance.currentUser;
      if (user != null) {
        user.sendEmailVerification();
      } else
        throw AppNotInitialized();
    } on firebase.FirebaseAuthException catch (e) {
      handleFirebaseError(e);
      throw GenericAuthException(); // Ensure an exception is thrown
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = firebase.FirebaseAuth.instance.currentUser;
    if (user != null)
      return AuthUser.fromFireBase(user);
    else
      return null;
  }

  Future<void> reload() async {
    try {
      final user = await firebase.FirebaseAuth.instance.currentUser;
      user!.reload();
    } on firebase.FirebaseAuthException catch (e) {
      handleFirebaseError(e);
    } catch (e) {
      GenericAuthException();
    }
  }

  Future<void> init() async {
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
