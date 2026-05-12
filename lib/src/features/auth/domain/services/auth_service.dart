import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/utils/logger.dart';

class AuthService {
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';
  static const _onboardingKey = 'onboarding_completed';

  AuthService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    talker.info('Saving auth token');
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    talker.info('Deleting auth token');
    await _storage.delete(key: _tokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> setOnboardingCompleted() async {
    talker.info('Setting onboarding as completed');
    await _storage.write(key: _onboardingKey, value: 'true');
  }

  Future<bool> isOnboardingCompleted() async {
    final value = await _storage.read(key: _onboardingKey);
    return value == 'true';
  }
}
