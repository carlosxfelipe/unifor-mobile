import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:unifor_mobile/assets/unifor_logo.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFE4F2FD),
      elevation: 0,
      title: Row(
        children: [
          SvgPicture.string(
            uniforLogoSVG,
            height: 36,
            colorFilter: const ColorFilter.mode(
              Color(0xFF1D4ED8),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Mobile',
            style: TextStyle(
              color: Color(0xFF1D4ED8),
              fontSize: 14,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Color(0xFF1D4ED8)),
          onPressed: () {},
        ),
      ],
    );
  }
}
