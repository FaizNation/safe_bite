import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';

/// Maps a raw category string to a normalised filter key.
///
/// This is shared between stats and home filtering to avoid
/// duplicate category-matching logic.
String normalizeCategory(String raw) {
  final lower = raw.toLowerCase();
  if (lower.contains('vegetable') || lower.contains('sayur')) {
    return 'vegetables';
  }
  if (lower.contains('fruit') || lower.contains('buah')) return 'fruits';
  if (lower.contains('meat') ||
      lower.contains('daging') ||
      lower.contains('chicken') ||
      lower.contains('ayam') ||
      lower.contains('fish') ||
      lower.contains('ikan')) {
    return 'meat';
  }
  if (lower.contains('milk') ||
      lower.contains('dairy') ||
      lower.contains('susu')) {
    return 'milk';
  }
  return 'other';
}

/// Filters [items] by [category]. Returns all items when category is `'all'`.
List<FoodItem> filterItemsByCategory(List<FoodItem> items, String category) {
  if (category == 'all') return items;
  return items
      .where((item) => normalizeCategory(item.category) == category)
      .toList();
}
