import 'package:floor/floor.dart';
import 'review.dart';

@dao
abstract class ReviewDAO {
  @Query('SELECT * FROM reviews WHERE mealName = :mealName')
  Future<List<Review>> selectReviewsByMealName(String mealName);

  @Query('SELECT * FROM reviews')
  Future<List<Review>> getAllReviews();

  @insert
  Future<void> insertReview(Review review);

  @insert
  Future<void> insertReviews(List<Review> reviews);
}
