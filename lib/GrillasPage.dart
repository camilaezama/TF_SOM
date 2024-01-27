import 'package:flutter/material.dart';
import 'package:flutter_application_1/grillaHexagonos.dart';
import 'package:hexagon/hexagon.dart';
import 'grillaCompleja.dart';
import 'utils.dart';

import 'buttons/dropdownbutton_componentes.dart';

class GrillasPage extends StatefulWidget {
  @override
  State<GrillasPage> createState() => _GrillasPageState();
}

class _GrillasPageState extends State<GrillasPage>
    with TickerProviderStateMixin {
  int depth = 1;
  List<int> depths = [0, 1, 2, 3, 4];
  HexagonType type = HexagonType.FLAT;
  bool hasControls = true;
  bool showControls = true;

  late TabController tabController;
  Map<String, String> dataUdist = {};
  Map<String, dynamic> mapaRta = {};
  Map<String, String> dataComponente = {};

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    tabController.addListener(_onTabChange);
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

  String selectedComponente = '';
  @override
  Widget build(BuildContext context) {
    mapaRta =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    dataUdist = mapaRta["Udist"]!;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Grillas'),
        ),
        body: DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                controller: tabController,
                tabs: const [
                  Tab(text: 'BMUs'),
                  Tab(text: 'Umat'),
                  Tab(text: 'Componentes'),
                ],
              ),
              toolbarHeight: 0.0,
            ),
            body: TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildWidgetBMUs(),
                _buildWidgetUMat(),
                _buildWidgetGrillaComponentes(mapaRta),

                // _buildWidget2(),
              ],
            ),
          ),
        ));
  }

  Widget _buildWidgetComponentes(Map<String, dynamic> mapaRta) {
    List<String> options = [];
    //Ignora las primeras 6 (i = 7) porque son BMU, Udist, etc etc, me quedo con las que son componentes
    List<String> keys = mapaRta.keys.toList();
    for (var i = 7; i < keys.length; i++) {
      options.add(keys[i]);
    }

    //Aca hay que generar la/las grilla(s), meterla en el widget que se hace return
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Elija la componente a mostrar: '),
        const SizedBox(width: 5),
        DropdownMenuComponentes(
          listaOpciones: options,
          onSelected: (String selectedValue) {
            // Step 3: Update dataComponente and trigger rebuild
            setState(() {
              selectedComponente = selectedValue;
              dataComponente = mapaRta[selectedValue] ?? {};
            });
          },
        )
      ],
    ));
  }

  Widget _buildWidgetUMat() {
    String archivoCsv = 'assets/salidaColoresOutput1.csv';
    int columnaNumeroNeuronas = 0;
    int columnaValores = 1;
    Gradient gradiente = const LinearGradient(
      colors: [
        Color.fromARGB(255, 8, 82, 143),
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.orange,
        Colors.red,
      ],
      stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
    );
    return FutureBuilder<Map<String, String>>(
      future: loadData(archivoCsv, columnaNumeroNeuronas, columnaValores),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar los datos'));
        } else {
          Map<String, String> dataMap = snapshot.data!;
          return GrillaCompleja(gradiente: gradiente, dataMap: dataMap);
        }
      },
    );
  }

  Widget _buildWidgetBMUs() {
    String archivoCsv = 'assets/archivo.csv';
    int columnaNumeroNeuronas = 0;
    int columnaValores = 1;
    Gradient gradiente = const LinearGradient(
      colors: [
        Color.fromARGB(255, 8, 82, 143),
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.orange,
        Colors.red,
      ],
      stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
    );
    return FutureBuilder<Map<String, String>>(
      future: loadData(archivoCsv, columnaNumeroNeuronas, columnaValores),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar los datos'));
        } else {
          // Construir la interfaz con los datos cargados
          Map<String, String> dataMap = snapshot.data!;
          // print('Mapa actual que usamos: ${dataMap}');
          //return GrillaSimple(gradiente: gradiente, dataMap: dataUdist);
          print('Mapa que llega: ${dataUdist}');
          return GrillaHexagonos(gradiente: gradiente, dataMap: dataUdist, filas: 14, columnas: 24);
        }
      },
    );
  }

  Widget _buildWidgetGrillaComponentes(Map<String, dynamic> mapaRta) {
    String archivoCsv = 'assets/archivo.csv';
    int columnaNumeroNeuronas = 0;
    int columnaValores = 1;
    List<String> options = [];
    options.add("Seleccione");
    //Ignora las primeras 6 (i = 7) porque son BMU, Udist, etc etc, me quedo con las que son componentes
    List<String> keys = mapaRta.keys.toList();
    for (var i = 7; i < keys.length; i++) {
      options.add(keys[i]);
    }
    Gradient gradiente = const LinearGradient(
      colors: [
        Color.fromARGB(255, 8, 82, 143),
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.orange,
        Colors.red,
      ],
      stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
    );
    return FutureBuilder<Map<String, String>>(
        future: loadData(archivoCsv, columnaNumeroNeuronas, columnaValores),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos'));
          } else {
            // Construir la interfaz con los datos cargados
            Map<String, String> dataMap = snapshot.data!;
            print('Mapa actual que usamos: ${dataMap}');

            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Elija la componente a mostrar: '),
                const SizedBox(width: 5),
                DropdownMenuComponentes(
                  listaOpciones: options,
                  onSelected: (String selectedValue) {
                    // Step 3: Update dataComponente and trigger rebuild
                    setState(() {
                      selectedComponente = selectedValue;
                      dataComponente = mapaRta[selectedValue] ?? {};
                    });
                  },
                ),
                Expanded(
                    child: GrillaHexagonos(
                        gradiente: gradiente, dataMap: dataComponente, filas: 14, columnas: 24)),
                // Expanded(
                //     child: GrillaSimple(
                //         gradiente: gradiente, dataMap: dataComponente)),
              ],
            ));
          }
        });
  }
}
