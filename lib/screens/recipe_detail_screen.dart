import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String recipeName;
  final String recipeImage;

  const RecipeDetailScreen({
    Key? key,
    required this.recipeName,
    required this.recipeImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              recipeImage,
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 20),
            Text(
              'Detail untuk $recipeName',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            const Text('Ini adalah halaman detail resep.'),
            // Anda bisa menambahkan detail resep lainnya di sini
          ],
        ),
      ),
    );
  }
}
