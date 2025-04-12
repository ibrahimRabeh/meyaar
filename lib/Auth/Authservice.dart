import 'AuthUser.dart';
import 'Auth_Provider.dart';

class Authservice implements AuthProvider {
  final AuthProvider provider;
  const Authservice(this.provider);

  @override
  // ignore: non_constant_identifier_names
  Future<AuthUser> CreateUser({
    required email,
    required password,
  }) =>
      provider.CreateUser(email: email, password: password);

  @override
  // ignore: non_constant_identifier_names
  Future<AuthUser> LogIn({
    required email,
    required password,
  }) =>
      provider.LogIn(email: email, password: password);

  @override
  // ignore: non_constant_identifier_names
  Future<void> SendEmailVerification() => provider.SendEmailVerification();

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> LogOut() => provider.LogOut();
  Future<void> reload() => provider.reload();

  @override
  Future<void> init() async => await provider.init();
}
