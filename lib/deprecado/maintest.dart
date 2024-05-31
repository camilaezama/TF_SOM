// import 'dart:math';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_application_1/pruebaWidget.dart';
// import 'package:hexagon/hexagon.dart';
// import 'package:csv/csv.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const MyHomePage(title: 'Example'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   MyHomePageState createState() => MyHomePageState();
// }

// class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
//   int depth = 1;
//   List<int> depths = [0, 1, 2, 3, 4];
//   HexagonType type = HexagonType.FLAT;
//   bool hasControls = true;
//   bool showControls = true;

//   late TabController tabController;

//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(initialIndex: 0, length: 5, vsync: this);
//     tabController.addListener(_onTabChange);
//     loadData();
//   }

//   void _onTabChange() {
//     if (tabController.index == 0) {
//       setState(() {
//         hasControls = true;
//       });
//     } else {
//       setState(() {
//         hasControls = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     //var size = MediaQuery.of(context).size;

//     return DefaultTabController(
//       length: 5,
//       initialIndex: 0,
//       child: Scaffold(
//         appBar: AppBar(
//           bottom: TabBar(
//             controller: tabController,
//             tabs: const [
//               Tab(text: 'Grid'),
//               // Tab(text: 'V-Offset'),
//               // Tab(text: 'H-Offset'),
//               // Tab(text: 'Other'),
//               Tab(text: 'Som 3 Boton'),
//               Tab(text: 'Som prueba completa'),
//               Tab(text: 'Som'),
//               Tab(text: 'Som 2 Boton'),
//             ],
//           ),
//           title: Text(widget.title),
//           actions: hasControls
//               ? [
//                   Row(children: [
//                     const Text('Controls'),
//                     Switch(
//                       value: showControls,
//                       activeColor: Colors.lightBlueAccent,
//                       onChanged: (value) => setState(() {
//                         showControls = value;
//                       }),
//                     ),
//                   ])
//                 ]
//               : null,
//         ),
//         body: TabBarView(
//           controller: tabController,
//           physics: const NeverScrollableScrollPhysics(),
//           children: [
//             Stack(
//               children: [
//                 Positioned.fill(child: _buildGrid(context, type)),
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: Visibility(
//                     visible: showControls,
//                     child: Theme(
//                       data: ThemeData(colorScheme: const ColorScheme.dark()),
//                       child: Card(
//                         margin: const EdgeInsets.all(8.0),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 2.0, horizontal: 16.0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               DropdownButton<HexagonType>(
//                                 onChanged: (value) => setState(() {
//                                   if (value != null) {
//                                     type = value;
//                                   }
//                                 }),
//                                 value: type,
//                                 items: const [
//                                   DropdownMenuItem<HexagonType>(
//                                     value: HexagonType.FLAT,
//                                     child: Text('Flat'),
//                                   ),
//                                   DropdownMenuItem<HexagonType>(
//                                     value: HexagonType.POINTY,
//                                     child: Text('Pointy'),
//                                   )
//                                 ],
//                                 selectedItemBuilder: (context) => [
//                                   const Center(child: Text('Flat')),
//                                   const Center(child: Text('Pointy')),
//                                 ],
//                               ),
//                               DropdownButton<int>(
//                                 onChanged: (value) => setState(() {
//                                   if (value != null) {
//                                     depth = value;
//                                   }
//                                 }),
//                                 value: depth,
//                                 items: depths
//                                     .map((e) => DropdownMenuItem<int>(
//                                           value: e,
//                                           child: Text('Depth: $e'),
//                                         ))
//                                     .toList(),
//                                 selectedItemBuilder: (context) {
//                                   return depths
//                                       .map((e) =>
//                                           Center(child: Text('Depth: $e')))
//                                       .toList();
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // _buildVerticalGrid(),
//             // _buildHorizontalGrid(),
//             // _buildMore(size),
//             //_buildSomGrid3(),
//             _buildWidget(),
//             _buildWidget(),
//             _buildSomGrid(),
//             _buildSomGrid2()
//           ],
//         ),
//       ),
//     );
//   }
// //{ }

//   // Gradient gradiente = const LinearGradient(
//   //             colors: [
//   //               Color.fromARGB(255, 8, 82, 143),
//   //               Colors.blue,
//   //               Colors.green,
//   //               Colors.yellow,
//   //               Colors.red,
//   //             ],
//   //             stops: [0.0, 0.3, 0.5, 0.7, 1.0],
//   //           );
//   Gradient gradiente = const LinearGradient(
//               colors: [
//                 Color.fromARGB(255, 8, 82, 143),
//                 Colors.blue,
//                 Colors.green,
//                 Colors.yellow,
//                 Colors.orange,
//                 Colors.red,
//               ],
//               stops: [0.0, 0.2, 0.4, 0.6,0.8, 1.0],
//   );

// Widget _buildWidget(){ 
//   return grillaSimple(gradiente: gradiente, dataMap: dataMap);
// }

//   Widget _buildGrid(BuildContext context, HexagonType type) {
//     return InteractiveViewer(
//       minScale: 0.2,
//       maxScale: 4.0,
//       child: HexagonGrid(
//         hexType: type,
//         color: Colors.pink,
//         depth: depth,
//         buildTile: (coordinates) => HexagonWidgetBuilder(
//           padding: 2.0,
//           cornerRadius: 8.0,
//           child: Text('${coordinates.q}, ${coordinates.r}'),
//           // Text('${coordinates.x}, ${coordinates.y}, ${coordinates.z}\n  ${coordinates.q}, ${coordinates.r}'),
//         ),
//       ),
//     );
//   }

//   Widget _buildHorizontalGrid() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: HexagonOffsetGrid.oddPointy(
//         color: Colors.black54,
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
//         columns: 9,
//         rows: 4,
//         buildTile: (col, row) => row.isOdd && col.isOdd
//             ? null
//             : HexagonWidgetBuilder(
//                 elevation: col.toDouble(),
//                 padding: 4.0,
//                 cornerRadius: row.isOdd ? 24.0 : null,
//                 color: col == 1 || row == 1 ? Colors.lightBlue.shade200 : null,
//                 child: Text('$col, $row'),
//               ),
//       ),
//     );
//   }

//   Widget _buildVerticalGrid() {
//     return HexagonOffsetGrid.evenFlat(
//       color: Colors.yellow.shade100,
//       padding: const EdgeInsets.only(left: 200.0, top: 50.0, bottom: 50.0),
//       columns: 8,
//       rows: 8,
//       buildTile: (col, row) => HexagonWidgetBuilder(
//         color: row.isEven ? Colors.yellow : Colors.orangeAccent,
//         elevation: 0.0,
//         padding: 0.6,
//       ),
//       buildChild: (col, row) => Text('$col, $row'),
//     );
//     // return SingleChildScrollView(
//     //   child: Column(
//     //     crossAxisAlignment: CrossAxisAlignment.stretch,
//     //     children: [
//     //       HexagonOffsetGrid.evenFlat(
//     //         color: Colors.yellow.shade100,
//     //         padding: const EdgeInsets.only(left: 200.0, right: 200.0, top: 10.0),
//     //         columns: 5,
//     //         rows: 5,
//     //         buildTile: (col, row) => HexagonWidgetBuilder(
//     //           color: row.isEven ? Colors.yellow : Colors.orangeAccent,
//     //           elevation: 2.0,
//     //           padding: 2.0,
//     //         ),
//     //         buildChild: (col, row) => Text('$col, $row'),
//     //       ),
//     //     ],
//     //   ),
//     // );
//   }

//   Widget _buildSomGrid() {
//     return HexagonOffsetGrid.evenPointy(
//       //color: Colors.yellow.shade100,
//       padding: const EdgeInsets.only(left: 200.0, top: 50.0, bottom: 50.0),
//       columns: 8,
//       rows: 8,
//       buildTile: (col, row) => HexagonWidgetBuilder(
//         color:
//             generarColorAleatorioEnEspectro(), //row.isEven ? Colors.yellow : Colors.orangeAccent,
//         elevation: 0.0,
//         padding: 0.6,
//       ),
//       buildChild: (col, row) => Text('$col, $row'),
//     );
//   }

//   Widget _buildSomGrid2() {
//     return HexagonOffsetGrid.evenPointy(
//       //color: Colors.yellow.shade100,
//       padding: const EdgeInsets.only(left: 200.0, top: 50.0, bottom: 50.0),
//       columns: 8,
//       rows: 8,
//       buildTile: (col, row) => HexagonWidgetBuilder(
//         color:
//             generarColorAleatorioEnEspectro(), //row.isEven ? Colors.yellow : Colors.orangeAccent,
//         elevation: 0.0,
//         padding: 0.6,
//       ),
//       buildChild: (col, row) => ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.transparent, // Fondo transparente
//             //onPrimary: Colors.blue, // Color del texto cuando se presiona
//             elevation: 0, // Elimina la sombra del botón
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//               //side: BorderSide(color: Colors.blue), // Borde del color deseado
//             ),
//           ),
//           onPressed: () {
//             //loadData();
//             showDialog<void>(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   title: const Text('Información'),
//                   content: const SingleChildScrollView(
//                     child: ListBody(
//                       children: [
//                         Text('Este es un cuadro de diálogo de ejemplo.'),
//                         Text('..........'),
//                       ],
//                     ),
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.of(context)
//                             .pop(); // Cerrar el cuadro de diálogo
//                       },
//                       child: Text('Cerrar'),
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//           child: Text('$col, $row')),
//     );
//   }









  

//   Map<String, String> dataMap = {};

//   Future<void> loadData() async {
//     String archivoCsv = 'assets/archivo.csv';
//     ByteData data = await rootBundle.load(archivoCsv);
//     String content = String.fromCharCodes(data.buffer.asUint8List());

//     // Parsear el contenido CSV con el delimitador ';'
//     List<List<dynamic>> rows =
//         const CsvToListConverter(eol: '\n', fieldDelimiter: ';')
//             .convert(content);

//     if (rows.isNotEmpty) {
//       rows.removeAt(0);
//     }

//     for (var row in rows) {
//       String bmu =
//           row[0]?.toString() ?? ''; // Assuming 'BMU' is in the first column
//       String udist =
//           row[1]?.toString() ?? ''; // Assuming 'Udist' is in the second column
//       dataMap[bmu] = udist;
//     }

//     print(dataMap);
//   }

//   Color generarColorAleatorioEnEspectro({
//     double hueInicio = 190.0, // Hue del color inicial (celeste)
//     double hueFin = 220.0, // Hue del color final (azul)
//     double saturacion = 1.0,
//     double valor = 1.0,
//   }) {
//     Random random = Random();
//     double hue =
//         lerpDouble(hueInicio, hueFin, random.nextDouble()) ?? hueInicio;
//     return HSVColor.fromAHSV(1.0, hue, saturacion, valor).toColor();
//   }






// } 