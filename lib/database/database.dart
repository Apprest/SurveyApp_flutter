import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'review.dart';
import 'review_dao.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Review])
abstract class AppDatabase extends FloorDatabase {
  ReviewDAO get reviewDao;
}
