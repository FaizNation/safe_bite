import 'dart:ui';

Color getStatsColorForCategory(String category) {
  switch (category) {
    case 'Sayur':
      return const Color(0xFF2E7D32);
    case 'Buah':
      return const Color(0xFF8BC34A);
    case 'Daging':
      return const Color(0xFFD32F2F);
    case 'Susu':
      return const Color(0xFFFFC107);
    default:
      return const Color(0xFF9E9E9E);
  }
}
