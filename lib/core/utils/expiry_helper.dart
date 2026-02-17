import 'package:flutter/material.dart';

/// Calculates the number of days until [expiryDate].
///
/// Returns a negative value if the date has already passed.
/// Returns `0` if [expiryDate] is null.
int calculateDaysUntilExpiry(DateTime? expiryDate) {
  if (expiryDate == null) return 0;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
  return expiry.difference(today).inDays;
}

/// Parses a human-readable shelf life string (e.g. "3 days", "2 minggu")
/// into the equivalent number of days. Returns `null` if parsing fails.
int? parseShelfLife(String shelfLife) {
  try {
    final lowerCase = shelfLife.toLowerCase();
    final regex = RegExp(
      r'(\d+)\s*(day|days|week|weeks|month|months|year|years|hari|minggu|bulan|tahun)',
    );
    final match = regex.firstMatch(lowerCase);

    if (match != null) {
      final value = int.parse(match.group(1)!);
      final unit = match.group(2)!;

      if (unit.contains('week') || unit.contains('minggu')) return value * 7;
      if (unit.contains('month') || unit.contains('bulan')) return value * 30;
      if (unit.contains('year') || unit.contains('tahun')) return value * 365;
      return value; // days
    }
  } catch (_) {
    // Ignore parsing errors
  }
  return null;
}

/// Returns a human-readable Indonesian expiry text.
String getExpiryText(int days) {
  if (days < 0) return 'Sudah kadaluwarsa';
  if (days == 0) return 'Kadaluwarsa hari ini';
  return '$days hari lagi';
}

/// Returns a short Indonesian status label based on days remaining.
String getExpiryStatus(int days) {
  if (days < 0) return 'Kadaluwarsa';
  if (days == 0) return 'Hari Ini!';
  if (days <= 3) return 'Segera Habiskan!';
  if (days <= 7) return 'Hampir Kadaluwarsa';
  return 'Aman';
}

/// Returns a colour representing urgency based on days remaining.
Color getExpiryStatusColor(int days) {
  if (days <= 3) return const Color(0xFFD32F2F);
  if (days <= 7) return const Color(0xFFFBC02D);
  return const Color(0xFF558B49);
}

/// Resolves the effective days-until-expiry for a food item,
/// preferring [shelfLife] parsing over [expiryDate] calculation.
int resolveDaysUntilExpiry(String shelfLife, DateTime? expiryDate) {
  if (shelfLife.isNotEmpty && shelfLife != 'Unknown') {
    final parsed = parseShelfLife(shelfLife);
    if (parsed != null) return parsed;
  }
  return calculateDaysUntilExpiry(expiryDate);
}
