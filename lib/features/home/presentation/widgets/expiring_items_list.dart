import 'package:flutter/material.dart';
import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpiringItemsList extends StatelessWidget {
  final List<FoodItem> items;

  const ExpiringItemsList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Belum ada data bahan makanan.',
            style: GoogleFonts.poppins(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        final daysUntilExpiry = _calculateDaysUntilExpiry(item.expiryDate);
        final status = _getStatus(daysUntilExpiry);
        final statusColor = _getStatusColor(daysUntilExpiry);

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                  image: item.imageBlob != null
                      ? DecorationImage(
                          image: MemoryImage(item.imageBlob!),
                          fit: BoxFit.cover,
                        )
                      : (item.imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(item.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null),
                ),
                child: (item.imageBlob == null && item.imageUrl == null)
                    ? const Icon(Icons.fastfood, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.foodName,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      // Use shelfLife if available, otherwise calculate
                      item.shelfLife.isNotEmpty && item.shelfLife != 'Unknown'
                          ? item.shelfLife
                          : _getExpiryText(daysUntilExpiry),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: statusColor,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            status,
                            style: GoogleFonts.poppins(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Quantity Badge
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${item.quantity}x',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _calculateDaysUntilExpiry(DateTime? expiryDate) {
    if (expiryDate == null) return 0;
    final now = DateTime.now();
    // Reset time components to compare dates only
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return expiry.difference(today).inDays;
  }

  String _getExpiryText(int days) {
    if (days < 0) return 'Sudah kadaluwarsa';
    if (days == 0) return 'Kadaluwarsa hari ini';
    return '$days hari lagi';
  }

  String _getStatus(int days) {
    if (days < 0) return 'Kadaluwarsa';
    if (days == 0) return 'Hari Ini!';
    if (days <= 3) return 'Segera Habiskan!';
    if (days <= 7) return 'Hampir Kadaluwarsa';
    return 'Aman';
  }

  Color _getStatusColor(int days) {
    if (days <= 3) return const Color(0xFFD32F2F); // Red
    if (days <= 7) return const Color(0xFFFBC02D); // Yellow
    return const Color(0xFF558B49); // Green
  }
}
