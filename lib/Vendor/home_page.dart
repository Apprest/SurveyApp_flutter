import 'package:combined_view/Vendor/reviews.dart';
import 'package:combined_view/database/review.dart';
import 'package:combined_view/database/review_repository.dart';
import 'package:combined_view/user_selection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../customer/product_model.dart';
import '../customer/api_service.dart';
import '../customer/product_card.dart';
import '../main.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();

}


class _HomePageState extends State<HomePage> {
  final box = GetStorage();
  final welcomeMessage = "Dashboard";
  final apiService = ApiService();


  void _logout() async {
    box.remove('userType');
    box.write('isLoggedIn', false);
    // box.write('welcomeMessage', welcomeMessage);
    Get.offAll(() => UserSelectionScreen(), transition: Transition.fadeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          welcomeMessage,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: (){
              Get.defaultDialog(
                title: "Confirm",
                middleText: "Are you sure you want to log out?",
                textCancel: "No",
                textConfirm: "Yes",
                confirmTextColor: Colors.white,
                onCancel: () {},
                onConfirm:_logout
              );
            }, // Logout function
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: apiService.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No products available"));
          }

          List<Product> products = snapshot.data!;
          box.write("products", products);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Row with 3 buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle button 1 action
                      },
                      child: Text('Button 1'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle button 2 action
                      },
                      child: Text('Button 2'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Handle button 3 action
                      },
                      child: Text('Button 3'),
                    ),
                  ],
                ),
                SizedBox(height: 10), // Space between Row and GridView
                // The GridView.builder
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // عدد الأعمدة
                      crossAxisSpacing: 10, // المسافة بين الأعمدة
                      mainAxisSpacing: 10, // المسافة بين الصفوف
                      childAspectRatio: 0.75, // نسبة العرض إلى الارتفاع
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to((context) => Reviews(product: products[index]));
                        },
                        child: ProductCard(product: products[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
