// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart'; // دي عشان join()
//
// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._internal();
//
//   DatabaseHelper._internal();
//
//   static Database? _database;
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, 'customer_review.db');
//
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }
//
//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE products (
//         itemID INTEGER PRIMARY KEY AUTOINCREMENT,
//         itemName TEXT,
//         image TEXT
//       )
//     ''');
//   }
//   Future<List<Map<String, dynamic>>> getReviewsByMealName(String mealName) async {
//     final db = await database;
//     final result = await db.rawQuery('''
//     SELECT customerName, customerPhone, review, mealName, rating
//     FROM reviews
//     WHERE mealName = ?
//   ''', [mealName]);
//
//     return result;
//   }
// }
