import 'package:combined_view/customer/product_model.dart';
import 'package:combined_view/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../database/review.dart';
import '../database/review_repository.dart';
import '../database/review_repository.dart'; // استيراد الريبو

class Reviews extends StatefulWidget {
  final Product product;

  const Reviews({super.key, required this.product});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  var reviews = <Review>[].obs;
  late ReviewRepository reviewRepository;

  @override
  void initState() {
    super.initState();
    reviewRepository = ReviewRepository(database.reviewDao); // إنشاء الريبو
    loadReview();
  }

  Future<void> loadReview() async {
    final result = await reviewRepository.getReviewsByMealName(widget.product.itemName);

    print("All reviews in DB:");
    for (var r in result) {
      print("${r.mealName} - ${r.review} - ${r.customerPhone}");
    }

    setState(() {
      reviews = result.obs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            'Reviews for ${widget.product.itemName}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(1.0),
              width: double.infinity,
              child: Image.network(
                widget.product.image,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.product.itemName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (ctx, index) {
                    final review = reviews[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.orange,
                        ),
                        title: ReadMoreText(
                          'Review: ${review.review}',
                          trimLines: 2,
                          colorClickableText: Colors.orange,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Read more',
                          trimExpandedText: 'Read less',
                          style: TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          'By: ${review.customerName ?? "Anonymous"}\nPhone: ${review.customerPhone}',
                        ),
                        isThreeLine: true,
                        trailing: Column(children: [
                          Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          Text(review.rating.toString()),
                        ],),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
