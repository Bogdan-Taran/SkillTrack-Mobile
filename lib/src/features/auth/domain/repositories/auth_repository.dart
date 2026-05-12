abstract class AuthRepository {
  Future<String> login(String email, String password);
  Future<String> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });
  Future<void> logout();
}
