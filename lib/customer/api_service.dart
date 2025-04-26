import 'package:dio/dio.dart';
import 'product_model.dart';

class ApiService {
  static const String apiUrl = "https://560057.youcanlearnit.net/services/json/itemsfeed.php";

  Future<List<Product>> fetchProducts() async {
    final dio = Dio();
    final response = await dio.get(apiUrl);

    if (response.statusCode == 200) {
      final List data = response.data;
      // for (var item in data) {
      //   await insertItemsToDb(Product.fromJson(item));
      // }
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  // Future<void> insertItemsToDb(Product product) async {
  //   final db = await DatabaseHelper.instance.database;
  //   await db.insert(
  //     'products',
  //     product.toJson(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }
}
