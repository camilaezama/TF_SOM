import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/grillaCompleja.dart';
import 'package:flutter_application_1/grillaSimple.dart';
import 'package:hexagon/hexagon.dart';
import 'package:csv/csv.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int depth = 1;
  List<int> depths = [0, 1, 2, 3, 4];
  HexagonType type = HexagonType.FLAT;
  bool hasControls = true;
  bool showControls = true;

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    tabController.addListener(_onTabChange);
    loadData();
    loadData2();
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
    //var size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: 'Som BMUs general'),
              Tab(text: 'Som completo'),
              Tab(text: 'Som completoooooo'),
            ],
          ),
          //title: Text(widget.title),
          toolbarHeight: 5.0,
          actions: hasControls
              ? [
                  Row(children: [
                    const Text('Controls'),
                    Switch(
                      value: showControls,
                      activeColor: Colors.lightBlueAccent,
                      onChanged: (value) => setState(() {
                        showControls = value;
                      }),
                    ),
                  ])
                ]
              : null,
        ),
        body: TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildWidget(),
            _buildWidget2(), 
            _buildWidget2(),           
          ],
        ),
      ),
    );
  }
//{ }

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

  Widget _buildWidget() {
    if (dataMap.isEmpty){
      return const Center(
          child: CircularProgressIndicator(),
        );
      
    }else{
      return GrillaSimple(gradiente: gradiente, dataMap: dataMap);
    }
    
  }

  Widget _buildWidget2() {
    if (dataMap2.isEmpty){
      return const Center(
          child: CircularProgressIndicator(),
        );
      
    }else{
      return GrillaCompleja(gradiente: gradiente, dataMap: dataMap2);
    }
    
  }

  Map<String, String> dataMap = {};
  Map<String, String> dataMap2 = {};

  bool? cargo;
  bool? cargo2;

  Future<void> loadData() async {
    String archivoCsv = 'assets/archivo.csv';
    ByteData data = await rootBundle.load(archivoCsv);
    String content = String.fromCharCodes(data.buffer.asUint8List());

    // Parsear el contenido CSV con el delimitador ';'
    List<List<dynamic>> rows =
        const CsvToListConverter(eol: '\n', fieldDelimiter: ';')
            .convert(content);

    if (rows.isNotEmpty) {
      rows.removeAt(0);
    }

    for (var row in rows) {
      String bmu =
          row[0]?.toString() ?? ''; // Assuming 'BMU' is in the first column
      String udist =
          row[9]?.toString() ?? ''; // Assuming 'Udist' is in the second column
      dataMap[bmu] = udist;
    }

    setState(() {
        cargo = true;
    });

    print(dataMap);
  }

  Future<void> loadData2() async {
    // String archivoCsv = 'assets/salidaColoresOutput.csv';
    String archivoCsv = 'assets/salidaColoresOutput1.csv';
    ByteData data = await rootBundle.load(archivoCsv);
    String content = String.fromCharCodes(data.buffer.asUint8List());

    // Parsear el contenido CSV con el delimitador ';'
    List<List<dynamic>> rows =
        const CsvToListConverter(eol: '\n', fieldDelimiter: ';')
            .convert(content);

    if (rows.isNotEmpty) {
      rows.removeAt(0);
    }

    for (var row in rows) {
      String bmu =
          row[0]?.toString() ?? ''; // Assuming 'BMU' is in the first column
      String udist =
          row[1]?.toString() ?? ''; // Assuming 'Udist' is in the second column      
      dataMap2[bmu] = udist.replaceAll('.', ',');
    }

    setState(() {
        cargo2 = true;
    });

    print(dataMap2);
  }
}
