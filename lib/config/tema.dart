import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        //brightness: Brightness.dark,
        elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
      );

  static final ColorScheme colorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: Colors.green,
  ).copyWith(
    secondary: const Color.fromARGB(255, 155, 205, 247),
  );

  static final Color colorFondoPrimary = colorScheme.primary.withOpacity(0.2);

  static const Color colorFondoGris = Color.fromARGB(255, 234, 234, 234);

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

  static const TextStyle titulo1 = TextStyle(
    fontSize: 20, // Tamaño de la fuente
    fontWeight: FontWeight.bold, // Peso de la fuente
    color: Colors.black87, // Color del texto
  );
}
