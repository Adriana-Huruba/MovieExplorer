import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('movies.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            imdbID TEXT PRIMARY KEY,
            title TEXT,
            year TEXT,
            poster TEXT,
            plot TEXT,
            genre TEXT,
            director TEXT,
            actors TEXT,
            runtime TEXT,
            imdbRating TEXT,
            released TEXT
          )
        ''');
      },
    );
  }

  Future<void> addFavorite(Movie movie) async {
    final db = await database;
    await db.insert(
      'favorites',
      {
        'imdbID': movie.imdbID,
        'title': movie.title,
        'year': movie.year,
        'poster': movie.poster,
        'plot': movie.plot,
        'genre': movie.genre,
        'director': movie.director,
        'actors': movie.actors,
        'runtime': movie.runtime,
        'imdbRating': movie.imdbRating,
        'released': movie.released,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete('favorites', where: 'imdbID = ?', whereArgs: [id]);
  }

  Future<List<Movie>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) => Movie.fromJson(maps[i]));
  }
}