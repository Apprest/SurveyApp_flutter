import 'package:combined_view/database/review_dao.dart';

import '../database/review.dart';
import '../database/database.dart';
import '../main.dart'; // Floor Database

class ReviewRepository {
  final reviewDao = database.reviewDao;
  late final ReviewDAO reviewDAO;

  ReviewRepository(ReviewDAO reviewDao);

  Future<void> insertReview(Review review) async {
    await reviewDao.insertReview(review);
  }

  Future<List<Review>> getReviewsByMealName(String mealName) async {
    return await reviewDao.selectReviewsByMealName(mealName);
  }

  Future<List<Review>> getAllReviews() async {
    return await reviewDao.getAllReviews();
  }
}
