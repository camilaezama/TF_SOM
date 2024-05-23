import 'package:flutter/material.dart';

class AppTheme {

  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        //brightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
  );

  static final ColorScheme colorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.brown,
    accentColor: Colors.green,
  ).copyWith(
    secondary: Colors.red,
  );

  static final Color colorFondoPrimary = colorScheme.primary.withOpacity(0.2);

  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: colorScheme.onPrimary,
    backgroundColor: colorScheme.primary,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    textStyle: const TextStyle(
      fontSize: 16.0, 
      //fontWeight: FontWeight.bold
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  );

  static final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: colorScheme.onSecondary,
    backgroundColor: colorScheme.secondary,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    textStyle: const TextStyle(
      fontSize: 16.0, 
      //fontWeight: FontWeight.bold
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  );
}
