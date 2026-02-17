import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_bite/core/utils/expiry_helper.dart';
import 'package:safe_bite/features/home/presentation/cubit/home_cubit.dart';
import 'package:safe_bite/features/home/presentation/pages/food_item_detail_page.dart';
import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';

class ExpiringItemCard extends StatelessWidget {
  final FoodItem item;

  const ExpiringItemCard({super.key, required this.item});

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Hapus Bahan Makanan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah kamu yakin ingin menghapus "${item.foodName}"?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Batal', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final daysUntilExpiry = resolveDaysUntilExpiry(
      item.shelfLife,
      item.expiryDate,
    );
    final status = getExpiryStatus(daysUntilExpiry);
    final statusColor = getExpiryStatusColor(daysUntilExpiry);

    return Dismissible(
      key: Key(item.documentId ?? item.foodName),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => _confirmDelete(context),
      onDismissed: (direction) {
        if (item.documentId != null) {
          context.read<HomeCubit>().deleteFoodItem(item.documentId!);
        }
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodItemDetailPage(item: item),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildImage(),
            const SizedBox(width: 16),
            _buildDetails(status, statusColor, daysUntilExpiry),
            _buildQuantityBadge(),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
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
    );
  }

  Widget _buildDetails(String status, Color statusColor, int daysUntilExpiry) {
    return Expanded(
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
            item.shelfLife.isNotEmpty && item.shelfLife != 'Unknown'
                ? item.shelfLife
                : getExpiryText(daysUntilExpiry),
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, color: statusColor, size: 16),
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
    );
  }

  Widget _buildQuantityBadge() {
    return Container(
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
    );
  }
}
