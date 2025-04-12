import 'package:firebase_auth/firebase_auth.dart';
import '/Auth/auth_exceptions.dart';

FirebaseAuthException handleFirebaseError(FirebaseAuthException e) {
  switch (e.code) {
    case "email-already-in-use":
      throw EmailAlreadyInUseAuthException();
    case "invalid-email":
      throw InvalidEmailAuthException();
    case "weak-password":
      throw WeakPasswordAuthException();
    case "channel-error":
      throw ChannelNotFoundAuthException();
    case "network-request-failed":
      throw InternetConnectionAuthException();
    case "invalid-credential":
      throw UserNotFoundAuthException();
    default:
      throw GenericAuthException();
  }
}
