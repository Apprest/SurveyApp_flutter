import 'package:combined_view/customer/product_model.dart';
import 'package:combined_view/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import '../database/review.dart';
import '../database/review_repository.dart';

class Reviews extends StatefulWidget {
  final Product product;

  const Reviews({super.key, required this.product});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  var reviews = <Review>[].obs;
  var averageRate = 0.0.obs;
  var reviewsCount = 0.obs;
  late ReviewRepository reviewRepository;

  @override
  void initState() {
    super.initState();
    reviewRepository = ReviewRepository(database.reviewDao);
    loadReview();
  }

  Future<void> loadReview() async {
    final result = await reviewRepository.getReviewsByMealName(
      widget.product.itemName,
    );
    reviews.value = result;
    reviewsCount.value = result.length;
    averageRate.value =
        result.isEmpty
            ? 0.0
            : result.map((e) => e.rating).reduce((a, b) => a + b) /
                result.length;
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
              padding: const EdgeInsets.all(10.0),
              width: double.infinity,
              child: Image.network(
                widget.product.image,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.product.itemName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Obx(() => Text(
              "Total Rates\t\t (${reviewsCount.value})",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )),
            const SizedBox(height: 10),
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RatingBarIndicator(
                  rating: averageRate.value,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: 40,
                  itemBuilder: (context, index) => const Icon(Icons.star, color: Colors.amber),
                ),
                const SizedBox(width: 8),
                Text(
                  "(${averageRate.value.toStringAsFixed(1)}/5)",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            )),
            Expanded(
              child: Obx(() {
                return reviews.isEmpty
                    ? const Center(child: Text('No reviews yet.',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black,),))
                    : ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (ctx, index) {
                    final review = reviews[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.orange,
                              size: 40,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ReadMoreText(
                                    'Review: ${review.review}',
                                    trimLines: 2,
                                    colorClickableText: Colors.orange,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Read more',
                                    trimExpandedText: 'Read less',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'By: ${review.customerName ?? "Anonymous"}\nPhone: ${review.customerPhone}',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    if (review.customerPhone != null) {
                                      await deleteReview(review.customerPhone!, review.review);
                                    }
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  iconSize: 24,
                                ),
                                Text(
                                  review.rating.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  Future<void> deleteReview(String phone, String reviewText) async {
    await reviewRepository.deleteReview(phone, reviewText);
    await loadReview();
    Get.snackbar(
      "Deleted",
      "Review has been deleted",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration:Duration(seconds: 1),
    );
  }
  Future<void> deleteReviewsWithNullPhone() async {
    await reviewRepository.deleteReviewsWithNullPhone();
    await loadReview();
  }
}
