import 'package:flutter/material.dart';
import 'package:TF_SOM_UNMdP/grillaHexagonos.dart';
import 'package:flutter/services.dart';
import 'package:hexagon/hexagon.dart';
import 'package:http/http.dart' as http;
import 'buttons/dropdownbutton.dart';
import 'dart:convert';

class GrillasPage extends StatefulWidget {
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
  static final clustersController = TextEditingController(text: "10");
  Map<String, String> dataUdist = {};
  Map<String, Object> respuesta = {};
  Map<String, dynamic> mapaRta = {};
  Map<String, dynamic> parametros = {};
  Map<String, String> mapaRtaUmat = {};
  late List<List<int>> mapaRtaClusters;
  Map<String, String> dataComponente = {};
  late List<List<double>> codebook;

  Map<int, int> hitsMap = {};
  String title = "";
  late int filas, columnas;
  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 5, vsync: this);
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
    // mapaRta =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    respuesta =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;

    mapaRta = respuesta["respuestaBMU"] as Map<String, dynamic>;

    mapaRtaUmat = respuesta["respuestaUmat"] as Map<String, String>;

    parametros = respuesta["parametros"] as Map<String, dynamic>;

    hitsMap = respuesta["respuestaHits"] as Map<int, int>;

    codebook = respuesta["codebook"] as List<List<double>>;

    filas = int.parse(parametros["filas"]);
    columnas = int.parse(parametros["columnas"]);
    dataUdist = mapaRta["Udist"]!;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Grillas'),
        ),
        body: DefaultTabController(
          length: 5,
          initialIndex: 0,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                controller: tabController,
                tabs: const [
                  Tab(text: 'BMUs'),
                  Tab(text: 'Umat'),
                  Tab(text: 'Componentes'),
                  Tab(text: 'Hits'),
                  Tab(text: 'Clustering'),
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
                _buildWidgetHits(),
                _buildWidgetClusters(),
              ],
            ),
          ),
        ));
  }

  Widget _buildWidgetUMat() {
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

    return GrillaHexagonos(
        titulo: "UMat",
        gradiente: gradiente,
        dataMap: mapaRtaUmat,
        filas: filas * 2,
        columnas: columnas * 2,
        paddingEntreHexagonos: 0.2);
  }

  Widget _buildWidgetClusters() {
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
    return Center(
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TextField(
          //     controller: clustersController,
          //     keyboardType: TextInputType.number,
          //     // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          //     decoration: const InputDecoration(
          //         border: OutlineInputBorder(),
          //         labelText: 'Cantidad de clusters')),
          // const SizedBox(
          //   width: 25,
          // ),

          ElevatedButton(
              onPressed: _llamadaClustering,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: cargando
                  ? const CircularProgressIndicator()
                  : Text(
                      botonAceptar,
                      style: const TextStyle(fontSize: 16),
                    )),

          mostarGrilla
              ? GrillaHexagonos(
                  dataMap: dataUdist,
                  filas: filas,
                  clusters: mapaRtaClusters,
                  columnas: columnas,
                  titulo: "Clustering")
              : const CircularProgressIndicator()
        ],
      ),
    );
  }

  Widget _buildWidgetHits() {
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
    return GrillaHexagonos(
      titulo: "Hits",
      gradiente: gradiente,
      dataMap: dataUdist,
      filas: filas,
      columnas: columnas,
      hits: true,
      hitsMap: hitsMap,
    );
  }

  Widget _buildWidgetBMUs() {
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
    return GrillaHexagonos(
        titulo: "BMU",
        gradiente: gradiente,
        dataMap: dataUdist,
        clusters: null,
        filas: filas,
        columnas: columnas);
  }

  Widget _buildWidgetGrillaComponentes(Map<String, dynamic> mapaRta) {
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
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Elija la componente a mostrar: '),
        const SizedBox(width: 5),
        GenericDropdownMenu(
          listaOpciones: options,
          onSelected: (String selectedValue) {
            // Step 3: Update dataComponente and trigger rebuild
            setState(() {
              selectedComponente = selectedValue;
              dataComponente = mapaRta[selectedValue] ?? {};
              title = selectedValue;
            });
          },
        ),
        Expanded(
            child: GrillaHexagonos(
                titulo: title,
                gradiente: gradiente,
                dataMap: dataComponente,
                filas: filas,
                columnas: columnas)),
      ],
    ));
  }

  void _llamadaClustering() async {
    try {
      String TIPO_LLAMADA = "clusters";
      var url = Uri.parse('http://localhost:7777' + '/' + TIPO_LLAMADA);

      final parametros = <String, dynamic>{
        'filas': filas != "" ? filas : 24,
        'columnas': columnas != "" ? columnas : 31,
        'cantidadClusters': 10
      };

      var response = await http.post(url,
          headers: {'Accept': '/*'},
          body: jsonEncode(
              {"datos": codebook, "tipo": TIPO_LLAMADA, "params": parametros}));
      List<dynamic> decodedJson = json.decode(response.body);
      List<List<int>> rtaClusters = decodedJson.map((dynamic item) {
        if (item is List<dynamic>) {
          return item.map((dynamic subItem) => subItem as int).toList();
        } else {
          throw Exception('Invalid item in list');
        }
      }).toList();
      setState(() {
        mapaRtaClusters = rtaClusters;
        mostarGrilla = true;
        cargando = false;
      });
    } catch (e) {
      setState(() {
        cargando = false;
        botonAceptar = "Aceptar";
      });
    }
  }
}
