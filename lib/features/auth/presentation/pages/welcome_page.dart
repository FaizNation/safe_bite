import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_bite/core/widgets/welcome_button.dart';
import 'package:safe_bite/features/auth/presentation/pages/login_page.dart';
import 'package:safe_bite/features/auth/presentation/pages/register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4E7C5),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/login_bottom.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                        children: const [
                          TextSpan(text: 'Selamat Datang\ndi '),
                          TextSpan(
                            text: 'Safe ',
                            style: TextStyle(color: Color(0xFF2D5016)),
                          ),
                          TextSpan(
                            text: 'Bite',
                            style: TextStyle(
                              color: Color(0xFFE8A317),
                            ), // Orange
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Image.asset(
                    'assets/images/welcome.png',
                    fit: BoxFit.contain,
                  ),
                ),
                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black,
                        height: 1.5,
                      ),
                      children: const [
                        TextSpan(text: 'Mari bersama kurangi\n'),
                        TextSpan(
                          text: 'limbah makanan',
                          style: TextStyle(
                            color: Color(0xFF4A6B3E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' dan jaga lingkungan!'),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 40.0,
                    left: 24.0,
                    right: 24.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      WelcomeButton(
                        text: 'Daftar',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      WelcomeButton(
                        text: 'Masuk',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
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
