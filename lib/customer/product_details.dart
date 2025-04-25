import 'package:combined_view/database/review.dart';
import 'package:combined_view/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final userPhone = Get.arguments;
  double rating = 5.0;
  final TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.itemName, style: TextStyle(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                child: Image.network(widget.product.image,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image,
                          size: 100, color: Colors.grey),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                widget.product.itemName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text("Rate this product:", style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40,
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (newRating) {
                  setState(() {
                    rating = newRating;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller,
                keyboardType: TextInputType.text,
                cursorColor: Colors.orange,
                cursorErrorColor: Colors.red,
                decoration: InputDecoration(
                  labelText: "Enter your Comment",
                  labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.orange,
                          width: 2.5) // Border when focused
                      ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.orangeAccent, // Set the background color
                ),
                onPressed: () async {

                  final review = Review(customerPhone: userPhone, review: controller.text, mealName: widget.product.itemName, rating: rating);
                  await database.reviewDao.insertReview(review);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Thank You For Your Rating \n You rated ${widget.product.itemName} with $rating stars!")));
                  Future.delayed(Duration(seconds: 1), () {
                    Get.back(result: review);
                  });
                },
                child: Text("Submit Rating",
                    style: TextStyle(color: Colors.black, fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
