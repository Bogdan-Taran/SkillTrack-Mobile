import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_service.g.dart';

@Riverpod(keepAlive: true)
class DatabaseService extends _$DatabaseService {
  late Database _db;

  @override
  FutureOr<Database> build() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'skilltrack.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            avatar_url TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE projects (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT,
            deadline INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            project_id TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT,
            deadline INTEGER NOT NULL,
            priority TEXT NOT NULL,
            status TEXT NOT NULL,
            FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE
          )
        ''');
      },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
    return _db;
  }
}
