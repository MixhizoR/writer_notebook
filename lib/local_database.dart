import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:yazar/model/book.dart';

class LocalDatabase {
  LocalDatabase._privateConstructor();

  static final LocalDatabase _instance = LocalDatabase._privateConstructor();

  factory LocalDatabase() {
    return _instance;
  }

  Database? _database;

  String _booksTableName = "books";
  String _idBooks = "id";
  String _nameBooks = "name";
  String _createdDateBooks = "createdDate";

  Future<Database?> _returnDatabase() async {
    if (_database == null) {
      String filePath = await getDatabasesPath();
      String databasePath = join(filePath, "writer.db");
      _database = await openDatabase(
        databasePath,
        version: 1,
        onCreate: _createTables,
      );
    }
    return _database;
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute("""
        CREATE TABLE $_booksTableName (
          $_idBooks INTEGER NOT NULL UNIQUE PRIMARY KEY AUTOINCREMENT,
          $_nameBooks TEXT NOT NULL,
          $_createdDateBooks INTEGER
        );
        """);
  }

  Future<int> createBook(Book book) async {
    Database? db = await _returnDatabase();
    if (db != null) {
      return await db.insert(_booksTableName, book.toMap());
    } else {
      return -1;
    }
  }

  Future<List<Book>> readBook() async {
    Database? db = await _returnDatabase();
    List<Book> books = [];

    if (db != null) {
      print("databaseden kitaplar çekiliyor");
      List<Map<String, dynamic>> booksMap = await db.query(_booksTableName);
      print("databaseden kitaplar çekildi!");
      for (Map<String, dynamic> m in booksMap) {
        print("kitap listeye ekleniyor!");
        Book b = Book.fromMap(m);
        books.add(b);
        print("kitap listeye eklendi!");
      }
    }
    print("Kitaplar listesi döndürülüyor!");
    return books;
  }

  Future<int> updateBook(Book book) async {
    Database? db = await _returnDatabase();
    if (db != null) {
      return await db.update(
          _booksTableName, book.toMap(), where: "$_idBooks = ?", whereArgs:[book.id]);
    } else {
      return 0;
    }
  }

  Future<int> deleteBook(Book book) async {
    Database? db = await _returnDatabase();
    if (db != null) {
      return await db.delete(
          _booksTableName, where: "$_idBooks = ?", whereArgs:[book.id]);
    } else {
      return 0;
    }
  }

}
