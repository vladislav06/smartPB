import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppTheme extends StatelessWidget {
  final Widget child;

  const AppTheme({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = AppThemeData(context);
    return Provider.value(value: themeData, child: child);
  }
}

class AppThemeData {
  AppThemeData(BuildContext context);

  BorderRadius radius = const BorderRadius.all(Radius.circular(16));
  EdgeInsets padding = const EdgeInsets.all(16);

  ColorScheme colorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
  );
  TabBarTheme tabBarTheme = const TabBarTheme();

  TextStyle largeText = const TextStyle(
    fontSize: 20,
  );

  //apply as default
  ThemeData get materialTheme {
    return ThemeData(
      useMaterial3: false,
      colorScheme: colorScheme,
      tabBarTheme: tabBarTheme,
    );
  }
}

extension BuildContextExtension on BuildContext {
  AppThemeData get appTheme {
    return watch<AppThemeData>();
  }
}
