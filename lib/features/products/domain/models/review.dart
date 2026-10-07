import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
class ProductReview with _$ProductReview {
  const factory ProductReview({
    required String id,
    required String userName,
    required double rating,
    @Default('') String comment,
    @Default('') String createdAt,
  }) = _ProductReview;

  factory ProductReview.fromJson(Map<String, dynamic> json) =>
      _$ProductReviewFromJson(json);
}
