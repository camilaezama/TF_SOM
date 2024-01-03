import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexagon/hexagon.dart';
import 'grillaCompleja.dart';
import 'grillaSimple.dart';
import 'utils.dart';

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

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Grillas Page'),
        ),
        body: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
            appBar: AppBar(              
              bottom: TabBar(
                controller: tabController,
                tabs: const [
                  Tab(text: 'Umat'),
                  Tab(text: 'BMUs'),
                ],
              ),
              toolbarHeight: 0.0,
            ),
            body: TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildWidgetUMat(),
                _buildWidgetBMUs()
                // _buildWidget2(),
              ],
            ),
          ),
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
          return GrillaSimple(gradiente: gradiente, dataMap: dataMap);
        }
      },
    );
  }
}
