import 'package:flutter/material.dart';
import 'recipe_detail_screen.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Cari resep...';

  final List<Map<String, dynamic>> recipes = [
    {
      'name': 'Salad Tomat Segar',
      'category': 'Tomat',
      'time': 'Lebih Lama',
      'difficulty': 'Mudah',
      'image': '🥗',
    },
    {
      'name': 'Nasi Goreng Tomat',
      'category': 'Tomat',
      'time': 'Lama',
      'difficulty': 'Mudah',
      'image': '🍛',
    },
    {
      'name': 'Sup Tomat',
      'category': 'Tomat',
      'time': 'Sedang',
      'difficulty': 'Mudah',
      'image': '🍲',
    },
  ];

  final List<Map<String, dynamic>> recommendedRecipes = [
    {
      'name': 'Tumis Brokoli',
      'image': '🥦',
    },
    {
      'name': 'Capcay',
      'image': '🥘',
    },
    {
      'name': 'Sup Ayam',
      'image': '🍜',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4E7C5),
        elevation: 0,
        title: const Text(
          'Resep',
          style: TextStyle(
            color: Color(0xFF2D5016),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFD4E7C5),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: _selectedFilter,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.filter_list),
                      onSelected: (value) {
                        setState(() {
                          _selectedFilter = value;
                        });
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'Tomat',
                          child: Text('Tomat'),
                        ),
                        const PopupMenuItem(
                          value: 'Sayuran',
                          child: Text('Sayuran'),
                        ),
                        const PopupMenuItem(
                          value: 'Buah',
                          child: Text('Buah'),
                        ),
                      ],
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8BC34A).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Color(0xFF2D5016)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Jangan membuang basi!\nBiarkan menjadi makanan baru!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF2D5016),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ...recipes.map((recipe) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RecipeCard(
                        name: recipe['name'],
                        category: recipe['category'],
                        time: recipe['time'],
                        difficulty: recipe['difficulty'],
                        image: recipe['image'],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(
                                recipeName: recipe['name'],
                                recipeImage: recipe['image'],
                              ),
                            ),
                          );
                        },
                      ),
                    )),
                const SizedBox(height: 20),
                const Text(
                  'Rekomendasi Resep Lainnya',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D5016),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: recommendedRecipes
                        .map((recipe) => Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: _RecommendedRecipeCard(
                                name: recipe['name'],
                                image: recipe['image'],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final String name;
  final String category;
  final String time;
  final String difficulty;
  final String image;
  final VoidCallback onTap;

  const _RecipeCard({
    required this.name,
    required this.category,
    required this.time,
    required this.difficulty,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  image,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendedRecipeCard extends StatelessWidget {
  final String name;
  final String image;

  const _RecommendedRecipeCard({
    required this.name,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            image,
            style: const TextStyle(fontSize: 40),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
