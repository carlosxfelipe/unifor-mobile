import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:unifor_mobile/assets/unifor_logo.dart';
import 'package:unifor_mobile/theme/theme_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        PopupMenuButton<Color>(
          icon: const Icon(Icons.palette, color: Color(0xFF1D4ED8)),
          onSelected: (color) {
            Provider.of<ThemeProvider>(
              context,
              listen: false,
            ).setScaffoldColor(color);
          },
          itemBuilder:
              (context) => [
                _buildColorOption("Azul claro", const Color(0xFFE4F2FD)),
                // _buildColorOption("Branco", Colors.white),
                _buildColorOption("Amarelo claro", const Color(0xFFFEEFC3)),
                _buildColorOption("Laranja claro", const Color(0xFFFFF3E0)),
                _buildColorOption("Vermelho claro", const Color(0xFFFFEBEE)),
                _buildColorOption("Ciano claro", const Color(0xFFE0F7FA)),
                _buildColorOption("Roxo claro", const Color(0xFFF3E5F5)),
                _buildColorOption("Verde claro", const Color(0xFFE8F5E9)),
                // _buildColorOption("Cinza claro", const Color(0xFFF5F5F5)),
              ],
        ),
      ],
    );
  }
}

PopupMenuItem<Color> _buildColorOption(String name, Color color) {
  return PopupMenuItem(
    value: color,
    child: Row(
      children: [
        CircleAvatar(backgroundColor: color, radius: 10),
        const SizedBox(width: 8),
        Text(name),
      ],
    ),
  );
}
