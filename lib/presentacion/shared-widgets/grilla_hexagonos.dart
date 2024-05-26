import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:TF_SOM_UNMdP/utils/utils.dart';
import 'package:hexagon/hexagon.dart';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

List<TableRow> crearTablaDatos(List<String> etiquetas, List<dynamic> codebook) {
  List<TableRow> listaTablita = [];
  TableRow filita;

  for (var j = 0; j < etiquetas.length; j++) {
    String etiquetactual = etiquetas[j];
    filita = TableRow(children: [
      Column(children: [
        Text(etiquetactual, style: const TextStyle(fontSize: 20.0))
      ]), //etiqueta
      Column(children: [
        Text(codebook[j].toString(), style: const TextStyle(fontSize: 20.0))
      ]), //valor
    ]);
    listaTablita.add(filita);
  }

  return listaTablita;
}

class GrillaHexagonos extends StatelessWidget {
  final Gradient? gradiente;
  final Map<String, String>? dataMap;
  final List<dynamic> codebook;
  final int filas;
  final int columnas;
  final String titulo;
  final List<List<int>>? clusters;
  final List<String> nombreColumnas;
  final double
      paddingEntreHexagonos; //podria no ser final y luego cambiarse luego de ser generado
  final Map<int, int>? hitsMap;
  final bool hits;
  final bool mostrarGradiente;
  final bool mostrarBotonImprimir;
  final double? min, max;
  final bool transparente;
  GrillaHexagonos(
      {super.key,
      required this.gradiente,
      this.dataMap,
      required this.filas,
      required this.columnas,
      required this.titulo,
      required this.codebook,
      required this.nombreColumnas,
      this.clusters,
      this.paddingEntreHexagonos = 0.6,
      this.hitsMap,
      this.hits = false,
      this.mostrarGradiente = true,
      this.mostrarBotonImprimir = true,
      required this.min,
      required this.max,
      this.transparente = false});

  final _widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(titulo, style: Theme.of(context).textTheme.headlineLarge),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (mostrarBotonImprimir)
                ElevatedButton(
                    onPressed: save, child: const Icon(Icons.download)),

              // Container(
              //     height: 50.0,
              //     decoration: BoxDecoration(gradient: widget.gradiente)),
              RepaintBoundary(
                key: _widgetKey,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: InteractiveViewer(
                        child: HexagonOffsetGrid.oddPointy(
                            //color: Colors.yellow.shade100,
                            // padding: const EdgeInsets.only(
                            //     left: 50.0, top: 50.0, bottom: 10.0, right: 100.0),
                            columns: columnas,
                            rows: filas,
                            buildTile: (col, row) {
                              int bmu = row * columnas + col + 1;
                              String valorDist = dataMap![bmu.toString()]!;
                              if (dataMap!.isNotEmpty) {
                                String valorDistConPunto =
                                    valorDist.replaceAll(',', '.');
                                double valor = double.parse(valorDistConPunto);
                                return HexagonWidgetBuilder(
                                  color: clusters == null
                                      ? transparente ? Color.fromARGB(0, 0, 0, 0) : getInterpolatedColor(
                                          valor, gradiente, min!, max!) 
                                      : getClusterColor(col, row, clusters),
                                  //color: getColorForValue(valor),
                                  //generarColorAleatorioEnEspectro(), //row.isEven ? Colors.yellow : Colors.orangeAccent,
                                  elevation: transparente ?  1.0 : 0.0,
                                  padding:  transparente ? 0.0 : paddingEntreHexagonos,
                                );
                              } else {
                                return HexagonWidgetBuilder(
                                  color: Colors.white,
                                  //generarColorAleatorioEnEspectro(), //row.isEven ? Colors.yellow : Colors.orangeAccent,
                                  elevation: 0.0,
                                  padding: 0.6,
                                );
                              }
                            },
                            buildChild: (col, row) {
                              int bMU = row * columnas + col + 1;
                              String valorDist = dataMap![bMU.toString()]!;
                              return valorDist == '-1'
                                  ? const Text("")
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        // side: transparente ? const BorderSide(
                                        //   color: Colors.black, width: 2
                                        // ) : null,
                                          textStyle: const TextStyle(
                                            // Tamaño del texto
                                            color:
                                                Colors.black, // Color del texto
                                          ),
                                          backgroundColor: Colors
                                              .transparent, // Fondo transparente
                                          //onPrimary: Colors.blue, // Color del texto cuando se presiona
                                          elevation:
                                              0, // Elimina la sombra del botón
                                          // shape: RoundedRectangleBorder(
                                          //   borderRadius: BorderRadius.circular(8.0),
                                          //side: BorderSide(color: Colors.blue), // Borde del color deseado
                                          //),
                                          padding: EdgeInsets.all(0.0)),
                                      onPressed: () {
                                        showDialog<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Información'),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: [
                                                    const Text(
                                                        'Este es un cuadro de diálogo de ejemplo.'),
                                                    Text('BMU = $bMU'),
                                                    Text('Udist = $valorDist'),
                                                    const Text(
                                                      "Codebook",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 52, 56, 253),
                                                          fontSize: 30.0),
                                                    ),
                                                    Table(
                                                      border: TableBorder.all(
                                                          color: Colors.black,
                                                          style:
                                                              BorderStyle.solid,
                                                          width: 1),
                                                      children: crearTablaDatos(
                                                          nombreColumnas,
                                                          (codebook[bMU - 1])),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Cerrar el cuadro de diálogo
                                                  },
                                                  child: const Text('Cerrar'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        hits ? hits_count(bMU) : '',
                                        //'',
                                        //'123456789',
                                        //'$BMU',
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ));
                            }),
                      ),
                    ),
                    if (mostrarGradiente)
                      Container(
                        width: 100.0, // ajusta la altura según tus necesidades
                        decoration: BoxDecoration(gradient: gradiente
                            // gradient: LinearGradient(
                            //   begin: Alignment
                            //       .topCenter, // comienza desde la parte superior
                            //   end: Alignment
                            //       .bottomCenter, // termina en la parte inferior
                            //   colors: [
                            //     Colors.red,
                            //     Colors.orange,
                            //     Colors.yellow,
                            //     Colors.green,
                            //     Colors.blue,
                            //     Color.fromARGB(255, 8, 82, 143),
                            //   ],
                            //   stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                            // ),
                            ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (double stop in [
                              double.parse(max!.toStringAsFixed(1)),
                              double.parse((min! +
                                      4 *
                                          double.parse(
                                              ((max!-min!) / 5).toStringAsFixed(1)))
                                  .toStringAsFixed(1)),
                              double.parse((min! +
                                      3 *
                                          double.parse(
                                              ((max!-min!) / 5).toStringAsFixed(1)))
                                  .toStringAsFixed(1)),
                              double.parse((min! +
                                      2 *
                                          double.parse(
                                              ((max!-min!) / 5).toStringAsFixed(1)))
                                  .toStringAsFixed(1)),
                              double.parse((min! +
                                      1 *
                                          double.parse(
                                              ((max!-min!) / 5).toStringAsFixed(1)))
                                  .toStringAsFixed(1)),
                              double.parse(min!.toStringAsFixed(1))
                            ])
                              Text(
                                '${stop}',
                                style: (gradiente!.colors.contains(
                                            Color.fromARGB(255, 0, 0, 0)) ||
                                        gradiente!.colors.contains(
                                            Color.fromARGB(255, 40, 40, 40)))
                                    ? TextStyle(
                                        color: Color.fromARGB(255, 247, 255, 9))
                                    : TextStyle(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String hits_count(int bmu) {
    String cant;
    if (hitsMap!.keys.contains(bmu)) {
      cant = hitsMap![bmu].toString();
    } else {
      cant = "";
    }
    return cant;
  }

  void save() async {
    final boundary =
        _widgetKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final byteData = await image.toByteData(format: ImageByteFormat.png);

    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final blob = html.Blob([pngBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    // ignore: unused_local_variable
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', "$titulo.png")
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}
