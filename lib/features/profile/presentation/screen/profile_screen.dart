import 'package:flutter/material.dart';
import 'package:safe_bite/features/auth/presentation/pages/welcome_page.dart';
import 'package:safe_bite/features/profile/presentation/screen/edit_profile_screen.dart';
import 'package:safe_bite/features/profile/presentation/screen/change_password_screen.dart';
import 'package:safe_bite/features/profile/presentation/screen/notification_settings_screen.dart';
import 'package:safe_bite/features/profile/presentation/screen/about_expired_screen.dart';
import 'package:safe_bite/features/profile/presentation/screen/wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4E7C5),
        elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Color(0xFF2D5016),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
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
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: const NetworkImage(
                    'https://via.placeholder.com/150',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'yuai',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D5016),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'yuai@example.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF5D6D5B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _ProfileMenuItem(
                  icon: Icons.person_outline,
                  title: 'Ubah Profil',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ProfileMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Ubah Password',
                  onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ProfileMenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifikasi/Instruksi',
                  onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ProfileMenuItem(
                  icon: Icons.help_outline,
                  title: 'Tentang Bahan Kadaluarsa',
                  onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutExpiredScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ProfileMenuItem(
                  icon: Icons.restaurant_menu,
                  title: 'Daftar Keinginan',
                  onTap: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WishlistScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ProfileMenuItem(
                  icon: Icons.logout,
                  title: 'Keluar',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Keluar'),
                        content: const Text('Apakah Anda yakin ingin keluar?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const WelcomePage(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'Keluar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isLogout;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
            Icon(
              icon,
              color: isLogout ? Colors.red : const Color(0xFF6B9F5E),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isLogout ? Colors.red : const Color(0xFF2D5016),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
