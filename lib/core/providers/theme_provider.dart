import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider(){
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode{
    return _themeMode == ThemeMode.dark;
  }

  ThemeData get lightTheme{ 
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.blueAccent,
        ),
        appBarTheme: const AppBarTheme(  
          elevation: 0,
          centerTitle: true,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );
  }

  ThemeData get darkTheme{
      return ThemeData(  
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        colorScheme: const ColorScheme.dark(  
          primary: Colors.blueGrey,
          secondary: Colors.blueAccent,
        ),
        appBarTheme: const AppBarTheme(  
          elevation: 0,
          centerTitle: true,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity
      );
  }

  Future<void> _loadThemeMode() async{
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(AppConstants.themeModeKey);

    if (themeModeString != null){
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == themeModeString,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  Future<void> setThemeModel(ThemeMode mode) async{
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.themeModeKey, mode.toString());
    notifyListeners();
  }

  void toggleTheme(){
    if (_themeMode == ThemeMode.light){
      setThemeModel(ThemeMode.dark);
    } else {
      setThemeModel(ThemeMode.light);
    }
  }
}