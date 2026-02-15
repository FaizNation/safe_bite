import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4E7C5), // Light green background
      body: Stack(
        children: [
          // Scrollable content to prevent overflow on small screens
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60), // Top padding
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: RichText(
                    textAlign: TextAlign.left,
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily:
                            'Plus Jakarta Sans', // Assuming font family, change if needed
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                      children: [
                        TextSpan(text: 'Selamat Datang\ndi '),
                        TextSpan(
                          text: 'Safe ',
                          style: TextStyle(
                            color: Color(0xFF2D5016),
                          ), // Dark Green
                        ),
                        TextSpan(
                          text: 'Bite',
                          style: TextStyle(color: Color(0xFFE8A317)), // Orange
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Center Image
                Image.asset(
                  'assets/images/welcome.png',
                  height: 300,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 16,
                        color: Colors.black,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(text: 'Mari bersama kurangi\n'),
                        TextSpan(
                          text: 'limbah makanan',
                          style: TextStyle(
                            color: Color(0xFF4A6B3E), // Greenish
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' dan jaga lingkungan!'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 200), // Space for bottom sheet
              ],
            ),
          ),
          // Bottom Section with Image and Buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Bottom Background Image
                Image.asset(
                  'assets/images/login_bottom.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Buttons
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 40.0,
                    left: 24.0,
                    right: 24.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF4A6B3E),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF4A6B3E),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
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
