import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_bite/features/home/presentation/widgets/expiring_item_card.dart';
import 'package:safe_bite/features/scan/domain/entities/food_analysis.dart';

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
      itemBuilder: (context, index) => ExpiringItemCard(item: items[index]),
    );
  }
}

