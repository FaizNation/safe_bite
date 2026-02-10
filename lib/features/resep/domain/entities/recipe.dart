import 'package:equatable/equatable.dart';

class Recipe extends Equatable {
  final String id;
  final String name;
  final String thumbUrl;
  final String category;

  final int timeMinutes;
  final double rating;

  const Recipe({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.category,
    this.timeMinutes = 15,
    this.rating = 4.5,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    thumbUrl,
    category,
    timeMinutes,
    rating,
  ];
}
