import 'package:flutter/material.dart';
import 'package:unifor_mobile/widgets.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 1, // Índice correspondente ao botão "Torpedo"
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: const SearchAppBar(),
        body: const MessagesBody(),
      ),
    );
  }
}

class MessagesBody extends StatelessWidget {
  const MessagesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Nenhuma mensagem ainda.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}
