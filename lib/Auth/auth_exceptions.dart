class AuthExceptions implements Exception {}

class EmailAlreadyInUseAuthException implements AuthExceptions {
  @override
  String toString() {
    return "Email Already exists";
  }
}

class WeakPasswordAuthException implements AuthExceptions {
  @override
  String toString() {
    return "Weak password, it needs to have capital and small letters and numbers";
  }
}

class InvalidEmailAuthException implements AuthExceptions {
  @override
  String toString() {
    return "Invalid Email format";
  }
}

class ChannelNotFoundAuthException implements AuthExceptions {
  @override
  String toString() {
    return "Please fill in Password and Email";
  }
}

class GenericAuthException implements AuthExceptions {
  @override
  String toString() {
    return "Something went wrong";
  }
}

class UserNotLoggedInAuthException implements AuthExceptions {
  @override
  String toString() {
    return "User not logged in";
  }
}

class InternetConnectionAuthException implements AuthExceptions {
  @override
  String toString() {
    return "Please check internet connection";
  }
}

class AppNotInitialized implements AuthExceptions {
  @override
  String toString() {
    return " you need to initialze the app first";
  }

  const AppNotInitialized();
}

class UserNotFoundAuthException implements AuthExceptions {
  @override
  String toString() {
    return "User not found";
  }
}

class TimeOut implements AuthExceptions {
  @override
  String toString() {
    return "Proccess took too long";
  }
}
