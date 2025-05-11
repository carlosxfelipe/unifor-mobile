import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuModal extends StatelessWidget {
  const MenuModal({super.key});

  void _openLinkedIn() async {
    final uri = Uri.parse('https://www.linkedin.com/in/carlosxfelipe/');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Não foi possível abrir o LinkedIn.');
    }
  }

  void _openGitHub() async {
    final uri = Uri.parse('https://github.com/carlosxfelipe/unifor-mobile');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Não foi possível abrir o GitHub.');
    }
  }

  Widget get _divider => const Divider(
    height: 1,
    thickness: 0.6,
    color: Color(0xFFE0E0E0),
    indent: 16,
    endIndent: 16,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: _openLinkedIn,
            ),
            _divider,
            const ListTile(
              leading: Icon(Icons.playlist_add),
              title: Text('Matrícula'),
            ),
            _divider,
            const ListTile(
              leading: Icon(Icons.location_on_outlined),
              title: Text('Mapa do campus'),
            ),
            _divider,
            const ListTile(
              leading: Icon(Icons.computer),
              title: Text('Laboratórios'),
            ),
            _divider,
            const ListTile(
              leading: Icon(Icons.book_outlined),
              title: Text('Biblioteca'),
            ),
            _divider,
            const ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Calendário letivo'),
            ),
            _divider,
            const ListTile(leading: Icon(Icons.groups), title: Text('Grupos')),
            _divider,
            const ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('Perguntas frequentes'),
            ),
            _divider,
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('GitHub'),
              onTap: _openGitHub,
            ),
          ],
        ),
      ),
    );
  }
}
