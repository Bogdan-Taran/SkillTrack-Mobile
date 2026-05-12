import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<String> login(String email, String password) async {
    // TODO: Implement real API call
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'test@test.com' && password == 'password') {
      return 'fake-jwt-token';
    }
    throw Exception('Неверный email или пароль');
  }

  @override
  Future<String> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    // TODO: Implement real API call
    await Future.delayed(const Duration(seconds: 2));
    return 'fake-jwt-token';
  }

  @override
  Future<void> logout() async {
    // TODO: Implement real API call if needed (e.g. invalidate token on server)
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
