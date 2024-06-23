import 'package:TF_SOM_UNMdP/config/tema.dart';
import 'package:TF_SOM_UNMdP/providers/clusters_provider.dart';
import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:TF_SOM_UNMdP/providers/gradiente_provider.dart';
import 'package:TF_SOM_UNMdP/providers/imagen_nueva_provider.dart';
import 'package:TF_SOM_UNMdP/providers/imagen_provider.dart';
import 'package:TF_SOM_UNMdP/providers/nuevos_datos_provider.dart';
import 'package:TF_SOM_UNMdP/providers/parametros_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'presentacion/pages/menu_grillas_page.dart';
import 'presentacion/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => ParametrosProvider()),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => DatosProvider()),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => ClustersProvider()),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => GradienteProvider()),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => ImagenProvider()),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => ImagenNuevaProvider()),
        ChangeNotifierProvider(
          lazy: false,
          create: (_) => NuevosDatosProvider())
      ],
      child: MaterialApp(
        title: 'TF SOM - UNMdP',
        initialRoute: '/', 
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
        routes: {
          '/': (context) => const HomePage(),
          '/grillas': (context) => const GrillasPage(),
        },
      ),
    );
  }
}
