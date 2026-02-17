import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A reusable primary button styled for auth pages.
class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AuthButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6B9F5E),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
