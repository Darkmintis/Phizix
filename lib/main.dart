import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phizix/core/constants/app_routes.dart';
import 'package:phizix/core/navigation/app_router.dart';
import 'package:phizix/core/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'core/di/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  PlatformDispatcher.instance.onError = (error, stack){
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };

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