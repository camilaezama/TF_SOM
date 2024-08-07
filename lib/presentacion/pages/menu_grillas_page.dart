import 'package:TF_SOM_UNMdP/presentacion/pestanas/bmu_pestana.dart';
import 'package:TF_SOM_UNMdP/presentacion/pestanas/clusters_pestana.dart';
import 'package:TF_SOM_UNMdP/presentacion/pestanas/componentes_pestana.dart';
import 'package:TF_SOM_UNMdP/presentacion/pestanas/hits_pestana.dart';
import 'package:TF_SOM_UNMdP/presentacion/pestanas/imagen_nueva_pestana.dart';
import 'package:TF_SOM_UNMdP/presentacion/pestanas/imagen_pestana.dart';
import 'package:TF_SOM_UNMdP/presentacion/pestanas/nuevo_dato_pestana.dart';
import 'package:TF_SOM_UNMdP/presentacion/pestanas/umat_pestana.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/dialogs/info_errores_dialog.dart';
import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:TF_SOM_UNMdP/providers/gradiente_provider.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:provider/provider.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class GrillasPage extends StatefulWidget {
  const GrillasPage({super.key});

  @override
  State<GrillasPage> createState() => _GrillasPageState();
}

class _GrillasPageState extends State<GrillasPage>
    with TickerProviderStateMixin {
  bool cargando = false;
  bool mostarGrilla = false;
  String botonAceptar = 'Aceptar';
  int depth = 1;
  List<int> depths = [0, 1, 2, 3, 4];
  HexagonType type = HexagonType.FLAT;
  bool hasControls = true;
  bool showControls = true;
  late TabController tabController;
  late Gradient gradiente;
  late double _width, _height;

  Map<int, int> hitsMap = {};
  String title = "";
  late int filas, columnas;
  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 8, vsync: this);
    tabController.addListener(_onTabChange);
    final gradienteProvider = context.read<GradienteProvider>();
    gradiente = gradienteProvider.gradienteElegido();
    // Check if the page is being reloaded
    if (html.window.localStorage['isReloading'] == 'true') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Navigate to HomePage after the initial build
        Navigator.pushReplacementNamed(context, '/');
      });
      // Clear the flag
      html.window.localStorage.remove('isReloading');
    }

    // Set a flag indicating that the page is about to be reloaded
    html.window.onBeforeUnload.listen((event) {
      html.window.localStorage['isReloading'] = 'true';
    });
  }

  void _onTabChange() {
    if (tabController.index == 0) {
      setState(() {
        hasControls = true;
      });
    } else {
      setState(() {
        hasControls = false;
      });
    }
  }

  String appBarTitle = 'Mapa';
  String selectedComponente = '';
  @override
  Widget build(BuildContext context) {
    final datosProvider = context.read<DatosProvider>();

    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        actions: [
          /// BOTON DE INFORMACION
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(
              message: 'Información',
              child: ElevatedButton(
                child: Icon(Icons.info),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return InfoErroresDialog(
                        widthPantalla: _width,
                        heightPantalla: _height,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
        title: Text(appBarTitle),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logo.png', // replace with your image path
                      height: 80.0, // adjust the height as needed
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'VisualiSOM',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                  ],
                )),
            ListTile(
              leading: Icon(Icons.grid_3x3_sharp),
              title: Text('Mapa'),
              onTap: () {
                setState(() {
                  appBarTitle = 'Mapa';
                });
                tabController.animateTo(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.grid_on),
              title: Text('Umat+'),
              onTap: () {
                setState(() {
                  appBarTitle = 'Umat+';
                });
                tabController.animateTo(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Componentes'),
              onTap: () {
                setState(() {
                  appBarTitle = 'Componentes';
                });
                tabController.animateTo(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.insert_chart),
              title: Text('Hits'),
              onTap: () {
                setState(() {
                  appBarTitle = 'Hits';
                });
                tabController.animateTo(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.group_work),
              title: Text('Clustering'),
              onTap: () {
                setState(() {
                  appBarTitle = 'Clustering';
                });
                tabController.animateTo(4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Nuevo dato'),
              onTap: () {
                setState(() {
                  appBarTitle = 'Nuevo dato';
                });
                tabController.animateTo(5);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Imagen Datos Train'),
              onTap: () {
                setState(() {
                  appBarTitle = 'Imagen Datos Train';
                });
                tabController.animateTo(6);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.image_search),
              title: Text('Imagen Nueva'),
              onTap: () {
                setState(() {
                  appBarTitle = 'Imagen Nueva';
                });
                tabController.animateTo(7);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          BmuPestana(
            gradiente: gradiente,
          ),
          UmatPestana(gradiente: gradiente),
          ComponentesPestana(
            mapaRta: datosProvider.resultadoEntrenamiento.mapaRta,
            codebook: datosProvider.resultadoEntrenamiento.codebook,
            nombrecolumnas:
                datosProvider.resultadoEntrenamiento.nombresColumnas,
            filas: datosProvider.resultadoEntrenamiento.filas,
            columnas: datosProvider.resultadoEntrenamiento.columnas,
            gradiente: gradiente,
          ),
          HitsPestana(gradiente: gradiente),
          ClustersPestana(
            gradiente: gradiente,
          ),
          NuevoDatoPestana(gradiente: gradiente),
          //ImagenPestana(gradiente: gradiente),
          ImagenNuevaPestana(
            gradiente: gradiente,
            usarDatosTrain: true,
          ),
          ImagenNuevaPestana(
            gradiente: gradiente,
            usarDatosTrain: false,
          )
        ],
      ),
    );
  }
}
