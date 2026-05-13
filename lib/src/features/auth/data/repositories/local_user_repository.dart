import 'package:sqflite/sqflite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/database_service.dart';
import '../../domain/models/user_model.dart';

part 'local_user_repository.g.dart';

class LocalUserRepository {
  final Database _db;

  LocalUserRepository(this._db);

  Future<UserModel?> getUser() async {
    final List<Map<String, dynamic>> maps = await _db.query('users', limit: 1);
    if (maps.isEmpty) return null;
    
    return UserModel(
      id: maps.first['id'],
      name: maps.first['name'],
      email: maps.first['email'],
      avatarUrl: maps.first['avatar_url'],
    );
  }

  Future<void> saveUser(UserModel user) async {
    await _db.insert(
      'users',
      {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'avatar_url': user.avatarUrl,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteUser() async {
    await _db.delete('users');
  }
}

@riverpod
LocalUserRepository localUserRepository(Ref ref) {
  final db = ref.watch(databaseServiceProvider).requireValue;
  return LocalUserRepository(db);
}
