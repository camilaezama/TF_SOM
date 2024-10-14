import 'package:flutter/material.dart';

Color colorPrimaryRojo = const Color.fromARGB(255,233,81,81);
Color colorSecondaryRojo = const Color.fromARGB(223, 223, 147, 147);

Color colorPrimaryAzul = const Color.fromARGB(255, 0, 151, 178);
Color colorSecondaryAzul = const Color.fromARGB(255,204,234,240);

Color colorPrimaryVerde = const Color.fromARGB(255,126,217,87);
Color colorSecondaryVerde  = const Color.fromARGB(255, 163, 214, 141);

Color colorPrimary = colorPrimaryAzul;
Color colorSecondary = colorSecondaryAzul; 

class AppTheme {
  static ThemeData getTheme() => ThemeData(
      useMaterial3: true,
      //brightness: Brightness.dark,
      elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
      colorScheme: ColorScheme(
        brightness: const ColorScheme.light().brightness,
        primary: colorPrimary,
        onPrimary: const ColorScheme.light().onPrimary,
        secondary: colorSecondary,
        onSecondary: const ColorScheme.light().onSecondary,
        error: const ColorScheme.light().error,
        onError: const ColorScheme.light().onError,
        surface: const ColorScheme.light().surface,
        onSurface: const ColorScheme.light().onSurface,
      ));

  static final Color colorFondoPrimary = getTheme().colorScheme.primary.withOpacity(0.2);

  static const Color colorFondoGris = Color.fromARGB(255, 234, 234, 234);

  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: const ColorScheme.light().onPrimary,
    backgroundColor: colorPrimary,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    textStyle: const TextStyle(
      fontSize: 16.0,
      //fontWeight: FontWeight.bold
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  );

  static final ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.black, // const ColorScheme.light().onSecondary,
    backgroundColor: colorSecondary,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    textStyle: const TextStyle(
      fontSize: 16.0,
      //fontWeight: FontWeight.bold
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
  );

}


class TituloStyleLarge extends TextStyle{
  const TituloStyleLarge({super.color})
      : super(
          fontSize: 25,
          fontWeight: FontWeight.w500,
        );
}

class TitleStyleMedium extends TextStyle{
  const TitleStyleMedium({super.color})
      : super(          
          fontSize: 18,
          fontWeight: FontWeight.w500, 
        );
}

class TitleStyleSmall extends TextStyle{
  const TitleStyleSmall({super.color})
      : super(          
          fontSize: 14,
          fontWeight: FontWeight.w500, 
        );
}
