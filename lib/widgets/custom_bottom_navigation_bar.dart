import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:unifor_mobile/widgets.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Widget child;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void _onItemTapped(int index) {
    if (index == widget.currentIndex) return;

    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/messages');
        break;
      case 2:
        // context.go('/subjects');
        break;
      case 3:
        // context.go('/menu');
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) => const MenuModal(),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(child: widget.child),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 4,
                  offset: Offset(0, -1),
                ),
              ],
            ),
          ),
          BottomNavigationBar(
            currentIndex: widget.currentIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white,
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: theme.colorScheme.onSurface.withAlpha(153),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 28),
                label: 'Início',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.rocket_launch, size: 28),
                label: 'Torpedo',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book, size: 28),
                label: 'Disciplinas',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu, size: 28),
                label: 'Menu',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
