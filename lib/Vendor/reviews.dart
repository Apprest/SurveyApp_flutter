import 'package:combined_view/customer/customer_home_page.dart';
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
  late ReviewRepository reviewRepository;
  double averageRate = 0.0;
  int reviewsCount=0;

  @override
  void initState() {
    super.initState();
    reviewRepository = ReviewRepository(database.reviewDao);
    loadReview();
  }

  Future<void> loadReview() async {
    final result = await reviewRepository.getReviewsByMealName(widget.product.itemName);
    double averageRate = 0;
    reviewsCount = result.length;

    for (var r in result) {
        averageRate += r.rating;
    }
    averageRate = averageRate / reviewsCount;

    reviews.value = result;
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
              padding: EdgeInsets.all(10.0),
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
            const SizedBox(height: 10),
            Text(
              widget.product.itemName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text("Average Rate\t\t ($reviewsCount)",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:CrossAxisAlignment.center,
              children: [
                RatingBarIndicator (
                  rating: averageRate,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: 40,
                  itemBuilder: (context, index) =>
                      Icon(Icons.star, color: Colors.amber),
                ),
                SizedBox(width: 8),
                Text(
                  "(${averageRate.toStringAsFixed(1)}/5)", // عرض الرقم كـ Double
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Expanded(
              child: Obx(() {
                return reviews.isEmpty
                    ? Center(child: Text('No reviews yet.'))
                    : ListView.builder(
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
                        // isThreeLine: true,
                        trailing: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // TextButton(
                            //   onPressed: () async {
                            //     await deleteReview(userPhone, review.review);
                            //     await loadReview();
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(content: Text('Review deleted')),
                            //     );
                            //   },
                            //   child: Text(
                            //     "Delete",
                            //     style: TextStyle(color: Colors.red, fontSize: 16),
                            //   ),
                            // ),
                            Icon(Icons.star, color: Colors.orange),
                            Text(review.rating.toString()),
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

  Future<void> deleteReview(String phone ,String review) async {
    await ReviewRepository(database.reviewDao)
        .deleteReview(userPhone,review);
  }
}
