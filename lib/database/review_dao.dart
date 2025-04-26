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

  @Query('UPDATE reviews SET customerName = :customerName WHERE customerPhone = :customerPhone')
  Future<void> updateReview(String customerName, String customerPhone);

  @Query('DELETE FROM reviews WHERE customerPhone = :phoneNumber AND review = :review')
  Future<void> deleteReview(String phoneNumber, String review);

  @Query('DELETE FROM reviews WHERE customerPhone IS NULL')
  Future<void> deleteReviewsWithNullPhone();
}
