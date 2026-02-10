import 'package:flutter/material.dart';

class RecipeSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  const RecipeSearchBar({
    super.key,
    required this.onChanged,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(
                0xFF4A7A3F,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TextField(
              onChanged: onChanged,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white70),
                hintText: 'Cari resep...',
                hintStyle: TextStyle(color: Colors.white60),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: onFilterTap,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF4A7A3F),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(Icons.tune, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
