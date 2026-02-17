import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A reusable footer row with a prompt text and a navigation link,
/// e.g. "Tidak punya akun? [Daftar]".
class AuthFooterLink extends StatelessWidget {
  final String promptText;
  final String linkText;
  final VoidCallback onPressed;

  const AuthFooterLink({
    super.key,
    required this.promptText,
    required this.linkText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          promptText,
          style: GoogleFonts.poppins(color: const Color(0xFF8D8D8D)),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            linkText,
            style: GoogleFonts.poppins(
              color: const Color(0xFF6B9F5E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
