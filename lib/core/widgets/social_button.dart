import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String? assetPath;
  final IconData? icon;
  final VoidCallback onPressed;
  final double size;
  final Color? iconColor;

  const SocialButton({
    super.key,
    this.assetPath,
    this.icon,
    required this.onPressed,
    this.size = 24,
    this.iconColor,
  }) : assert(
         assetPath != null || icon != null,
         'Either assetPath or icon must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: assetPath != null
            ? Image.asset(assetPath!, width: size, height: size)
            : Icon(icon, size: size, color: iconColor ?? Colors.black),
      ),
    );
  }
}
