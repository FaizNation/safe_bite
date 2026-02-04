import 'package:flutter/material.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../resep/presentation/pages/resep_page.dart';
import '../../../stats/presentation/pages/stats_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../scan/presentation/pages/scan_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ResepPage(),
    const StatsPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onScanPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScanPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _pages),
      floatingActionButton: FloatingActionButton(
        onPressed: _onScanPressed,
        backgroundColor: const Color(0xFF6B9F5E),
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: const Color(0xFF2D5016),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Group
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNavItem(0, Icons.home_outlined, Icons.home, "Beranda"),
                  _buildNavItem(
                    1,
                    Icons.restaurant_menu_outlined,
                    Icons.restaurant_menu,
                    "Resep",
                  ),
                ],
              ),

              // Spacer for FAB
              const SizedBox(width: 48),

              // Right Group
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNavItem(
                    2,
                    Icons.bar_chart_outlined,
                    Icons.bar_chart,
                    "Stats",
                  ),
                  _buildNavItem(
                    3,
                    Icons.person_outline,
                    Icons.person,
                    "Profil",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData iconOutline,
    IconData iconFilled,
    String label,
  ) {
    final isSelected = _currentIndex == index;
    return MaterialButton(
      minWidth: 40,
      onPressed: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? iconFilled : iconOutline,
            color: isSelected ? Colors.white : Colors.white70,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
