import 'package:flutter/material.dart';
import 'package:unifor_mobile/widgets.dart';
import 'package:flutter/foundation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomNavigationBar(
      currentIndex: 0, // Índice correspondente ao botão "Início"
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
    Widget content = ListView(
      children: const [
        Divider(height: 1, thickness: 1, color: Colors.black12),
        Padding(
          padding: EdgeInsets.only(left: 16, top: 16),
          child: GreetingHeader(),
        ),
        // RecentMessagesSection(),
        StoryCircleList(),
        TodayClassesSection(),
        MoodCheckSection(),
        LatestNoticesSection(),
      ],
    );

    // Limita a largura apenas na web
    if (kIsWeb) {
      content = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 768),
          child: content,
        ),
      );
    }

    return content;
  }
}
