import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:TF_SOM_UNMdP/utils.dart';
import 'package:hexagon/hexagon.dart';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class GrillaHexagonos extends StatelessWidget {
  final Gradient? gradiente;
  final Map<String, String>? dataMap;
  final int filas;
  final int columnas;
  String titulo;
  List<List<int>>? clusters;
  final double
      paddingEntreHexagonos; //podria no ser final y luego cambiarse luego de ser generado
  Map<int, int>? hitsMap;
  bool hits;
  bool mostrarGradiente;
  bool mostrarBotonImprimir;
  GrillaHexagonos(
      {super.key,
      this.gradiente,
      this.dataMap,
      required this.filas,
      required this.columnas,
      required this.titulo,
      this.clusters,
      this.paddingEntreHexagonos = 0.6,
      this.hitsMap,
      this.hits = false,
      this.mostrarGradiente = true,
      this.mostrarBotonImprimir = true});

  final _widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(titulo, style: Theme.of(context).textTheme.headlineLarge),
        Expanded(
          child: Row(
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
                                      ? getInterpolatedColor(
                                          valor, gradiente, dataMap)
                                      : getClusterColor(col, row, clusters),
                                  //color: getColorForValue(valor),
                                  //generarColorAleatorioEnEspectro(), //row.isEven ? Colors.yellow : Colors.orangeAccent,
                                  elevation: 0.0,
                                  padding: paddingEntreHexagonos,
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
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Cerrar el cuadro de diálogo
                                                  },
                                                  child: Text('Cerrar'),
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
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment
                                .topCenter, // comienza desde la parte superior
                            end: Alignment
                                .bottomCenter, // termina en la parte inferior
                            colors: [
                              Colors.red,
                              Colors.orange,
                              Colors.yellow,
                              Colors.green,
                              Colors.blue,
                              Color.fromARGB(255, 8, 82, 143),
                            ],
                            stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            for (double stop in [1.0, 0.8, 0.6, 0.4, 0.2, 0.0])
                              Text(
                                '${stop}',
                                style: TextStyle(color: Colors.black),
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
      ..setAttribute('download', "UMatrixSimple.png")
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}
