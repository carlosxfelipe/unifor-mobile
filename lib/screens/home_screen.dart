import 'package:flutter/material.dart';
import 'package:unifor_mobile/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 0, // Índice correspondente ao botão "Início"
      child: Scaffold(
        backgroundColor: const Color(0xFFE4F2FD),
        appBar: CustomAppBar(),
        body: HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 16, top: 16),
      child: Align(alignment: Alignment.topLeft, child: Text('Hello World!')),
    );
  }
}
