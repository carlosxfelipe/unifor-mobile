import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unifor_mobile/theme/theme.dart';
import 'package:unifor_mobile/theme/theme_provider.dart';
import 'package:unifor_mobile/routes/router.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme.copyWith(
        scaffoldBackgroundColor: themeProvider.scaffoldColor,
      ),
      // darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,
      routerConfig: router,
      builder: (context, child) {
        final systemUiStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        );

        SystemChrome.setSystemUIOverlayStyle(systemUiStyle);
        return child!;
      },
    );
  }
}
