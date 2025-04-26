import 'package:floor/floor.dart';

@Entity(tableName: "reviews")
class Review {
  @PrimaryKey(autoGenerate: true)
  final int? reviewID;
  final String? customerName;
  final String? customerPhone;
  final String review;
  final String mealName;
  final double rating;

  Review({
    this.reviewID,
    this.customerName,
    required this.customerPhone,
    required this.review,
    required this.mealName,
    required this.rating,
  });
}
