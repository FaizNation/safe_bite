import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4E7C5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.food_bank_outlined, // Changed icon to be more relevant
                size: 80,
                color: Color(0xFF6B9F5E),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Pantau dan Selamatkan',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF2D5016),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              'Makananmu dengan',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF2D5016),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Safe Bite',
              style: TextStyle(
                fontSize: 36,
                color: Color(0xFF6B9F5E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
