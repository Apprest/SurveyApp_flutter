import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'Vendor/home_page.dart';
import 'customer/login_screen.dart';
import 'database/database.dart';
import 'user_selection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  await GetStorage.init();
  // final Product product;
  final box = GetStorage();
  final storedUserType = box.read<String>('userType');

  runApp(MyApp(userType: storedUserType));
}

late AppDatabase database;

Future<void> initializeDatabase() async {
  await _copyPrebuiltDatabase();

  final dir = await getApplicationDocumentsDirectory();
  final dbPath = join(dir.path, 'customer_review.db');

  database = await $FloorAppDatabase.databaseBuilder(dbPath).build();
}

Future<void> _copyPrebuiltDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final path = join(dir.path, 'customer_review.db');

  if (File(path).existsSync()) return;

  final data = await rootBundle.load('assets/database/customer_review.db');
  final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await File(path).writeAsBytes(bytes);
}

String? userType;

class MyApp extends StatelessWidget {
  const MyApp({super.key, userType});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: _getInitialScreen(),
    );
  }

  Widget _getInitialScreen() {
    if (userType?.isNotEmpty ?? false) {
      return userType == "vendor"
          ? const HomePage()
          : const CustomerLoginScreen();
    } else {
      return const UserSelectionScreen();
    }
  }
}
