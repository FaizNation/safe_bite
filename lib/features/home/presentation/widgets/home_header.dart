import 'package:flutter/material.dart';
import 'package:safe_bite/features/auth/domain/entities/user_entity.dart';

class HomeHeader extends StatelessWidget {
  final UserEntity? user;

  const HomeHeader({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: user?.photoUrl != null
                      ? NetworkImage(user!.photoUrl!)
                      : const AssetImage('assets/images/user_placeholder.png')
                            as ImageProvider,
                  fit: BoxFit.cover,
                ),
                color: Colors.grey.shade300,
              ),
              
              child: user?.photoUrl == null
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat datang',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    user?.name ?? 'User',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF558B49),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, size: 28),
        ),
      ],
    );
  }
}
