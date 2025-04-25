import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'product_details.dart';
import 'product_model.dart';

class ProductListScreen extends StatefulWidget {
  final String welcomeMessage;

  const ProductListScreen({Key? key, required this.welcomeMessage}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  bool isLoading = true;
  // final String apiUrl = "https://your-api.com/products";
  final String apiUrl = "https://560057.youcanlearnit.net/services/json/itemsfeed.php";

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;

        // التحقق من أن البيانات هي قائمة
        if (data is! List) {
          throw FormatException('Expected list but got ${data.runtimeType}');
        }

        setState(() {
          products = data.map((item) {
            try {
              return Product.fromJson(item as Map<String, dynamic>);
            } catch (e) {
              print('Error parsing product: $e');
              // يمكنك إرجاع منتج افتراضي أو تجاهل هذا العنصر
              return Product(itemName: 'Unknown', image: 'default.jpg');
            }
          }).toList();

          isLoading = false;
        });
      } else {
        throw Exception("Failed to load products: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching products: $e");
      setState(() {
        isLoading = false;
      });

      // عرض رسالة خطأ للمستخدم
      Get.snackbar(
        'Error',
        'Failed to load products',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.welcomeMessage)),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.black,)) // مؤشر تحميل
          : GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ProductDetailsScreen(product: product),
              //   ),
              // );
              Get.to(ProductDetailsScreen(product: product));
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                      child: Image.network(
                        "https://560057.youcanlearnit.net/services/images/${product.image}",
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, size: 50, color: Colors.grey);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      product.itemName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
