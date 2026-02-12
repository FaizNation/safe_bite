import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_bite/features/auth/presentation/pages/welcome_page.dart';
import 'package:safe_bite/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:safe_bite/features/profile/presentation/bloc/profile_state.dart';
import 'package:safe_bite/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:safe_bite/features/profile/presentation/pages/change_password_page.dart';
import 'package:safe_bite/features/profile/presentation/pages/about_page.dart';
import 'package:safe_bite/features/profile/presentation/pages/help_support_page.dart';
import 'package:safe_bite/features/auth/presentation/cubit/auth_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

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
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          String name = 'Loading...';
          String email = 'Loading...';
          String? photoUrl;
          ImageProvider? imageProvider;

          if (state is ProfileLoaded) {
            name = state.user.name ?? 'No Name';
            email = state.user.email;
            photoUrl = state.user.photoUrl;
            if (state.user.photoBlob != null) {
              imageProvider = MemoryImage(state.user.photoBlob!);
            } else if (photoUrl != null) {
              imageProvider = NetworkImage(photoUrl);
            }
          } else if (state is ProfileError) {
            name = 'Error';
            email = state.message;
          }

          return SingleChildScrollView(
            child: Column(
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
                        backgroundImage:
                            imageProvider ??
                            const NetworkImage(
                              'https://via.placeholder.com/150',
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D5016),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5D6D5B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const _SectionHeader(title: 'Pengaturan'),
                      const SizedBox(height: 12),
                      _ProfileMenuItem(
                        icon: Icons.person_outline,
                        title: 'Ubah Profil',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfilePage(),
                            ),
                          ).then(
                            (_) => context.read<ProfileCubit>().loadProfile(),
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
                            MaterialPageRoute(
                              builder: (context) => const ChangePasswordPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const _SectionHeader(title: 'Info Lainnya'),
                      const SizedBox(height: 12),
                      _ProfileMenuItem(
                        icon: Icons.info_outline,
                        title: 'Tentang Safe Bite',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _ProfileMenuItem(
                        icon: Icons.help_outline,
                        title: 'Bantuan & Dukungan',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpSupportPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      _ProfileMenuItem(
                        icon: Icons.logout,
                        title: 'Keluar',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Keluar'),
                              content: const Text(
                                'Apakah Anda yakin ingin keluar?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<AuthCubit>().logout();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const WelcomePage(),
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
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D5016),
        ),
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
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}
