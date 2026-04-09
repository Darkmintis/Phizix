import 'package:flutter/material.dart';
import 'package:phizix/core/constants/app_routes.dart';
import 'package:phizix/core/navigation/app_router.dart';
import 'package:phizix/core/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'core/di/service_locator.dart';

void main() {
  ServiceLocator.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override  
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child){
    return MaterialApp(
      title: 'Phizix',
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
        },
      ),
    );
  }
}