import 'package:flutter/material.dart';
import 'package:phizix/core/providers/theme_provider.dart';
import '../../core/constants/app_constants.dart';
import 'package:provider/provider.dart';

class PhizixAppBar extends StatelessWidget implements PreferredSizeWidget{
  const PhizixAppBar({super.key});

  @override  
  Widget build(BuildContext context){
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return AppBar(
      title: const Text(
        AppConstants.appName,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 40,
        color: Colors.white,
      ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,

      actions: [
        IconButton(  
          icon: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: Colors.white,
          ),
          onPressed: (){
            themeProvider.toggleTheme();
          },
        )
      ],
    );
  }

  @override  
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}