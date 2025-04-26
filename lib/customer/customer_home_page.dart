import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:combined_view/database/review_repository.dart';
import '../main.dart';
import '../user_selection.dart';
import 'api_service.dart';
import 'product_card.dart';
import 'product_details.dart';
import 'product_model.dart';

class CHomePage extends StatefulWidget {
  const CHomePage({super.key});

  @override
  State<CHomePage> createState() => _CHomePageState();
}

    var userPhone = Get.arguments;
class _CHomePageState extends State<CHomePage> {
  final welcomeMessage = 'Welcome in Toxido';
  final apiService = ApiService();
  String userNameInput = ''; // متغير مؤقت لتخزين الاسم
  final box = GetStorage();

  @override
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          showLogoutDialog(); // ديالوج الخروج
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(welcomeMessage, style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.orange,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                showLogoutDialog();
              },
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
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        arguments: userPhone,
                        () => ProductDetailsScreen(product: products[index]),
                        transition: Transition.fadeIn,
                        duration: Duration(milliseconds: 300),
                      );
                    },
                    child: ProductCard(product: products[index]),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _logout() async {
    final box = GetStorage();
    await box.remove('userType'); // Remove userType from GetStorage
    var result = await Get.offAll(() => UserSelectionScreen()); // Navigate to UserSelectionScreen
    if (result.isNotEmpty) {
      Get.snackbar("Thank you", "All Reviews had been saved");
    }
    userPhone='';
  }

  void showLogoutDialog() {
    Get.defaultDialog(
      title: "Confirm Logout",
      content: Column(
        children: [
          Text("Would you like to save your name before logging out?"),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: "Enter your name (optional)",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              userNameInput = value;
            },
          ),
        ],
      ),
      textCancel: "No",
      textConfirm: "Yes",
      confirmTextColor: Colors.white,
      onCancel: () {},
      onConfirm: () async {
        if (userNameInput.isNotEmpty) {
          await ReviewRepository(database.reviewDao)
              .updateReview(userNameInput,userPhone);
          box.write('welcomeMessage', "Welcome $userNameInput");
        } else {
          box.write('welcomeMessage', "Welcome Sir");
        }
        _logout();
      },
    );
  }

}
