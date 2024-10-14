import 'dart:math';
import 'dart:ui';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/dialogs/hit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:TF_SOM_UNMdP/utils/utils.dart';
import 'package:hexagon/hexagon.dart';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

List<TableRow> crearTablaDatos(
    List<String> etiquetas, List<dynamic> codebook, String titulo) {
  List<TableRow> listaTablita = [];
  TableRow filita;

  for (var j = 0; j < etiquetas.length; j++) {
    String etiquetactual = etiquetas[j];
    filita = TableRow(children: [
      Column(children: [
        Text(etiquetactual,
            style: etiquetactual == titulo
                ? const TextStyle(
                    fontSize: 20.0,
                    backgroundColor: Colors.yellow,
                    fontWeight: FontWeight.bold)
                : const TextStyle(fontSize: 20.0))
      ]), //etiqueta
      Column(children: [
        Text(codebook[j].toString(),
            style: etiquetactual == titulo
                ? const TextStyle(
                    fontSize: 20.0,
                    backgroundColor: Colors.yellow,
                    fontWeight: FontWeight.bold)
                : const TextStyle(fontSize: 20.0))
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
  final bool expandida;
  //final List<Map<String, dynamic>> etiquetas;
  final Map<int, Map<String, List<String>>>? mapaBMUconEtiquetas;
  final Map<String, List<String>>? etiquetasMap;
  final Map<String, Color>? mapaColores;
  final String? selectedKey;
  final bool grillaBlanca;
  final bool hitsPorMayoritario;
  final Map<int, Color>? mapaBmuColor;
  final bool deshabilitarBotonesHexagonos;

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
      this.expandida = false,
      //this.etiquetas = const [],
      this.mapaBMUconEtiquetas,
      this.etiquetasMap,
      this.selectedKey,
      this.mapaColores,
      this.grillaBlanca = false,
      this.hitsPorMayoritario = false,
      this.mapaBmuColor,
      this.deshabilitarBotonesHexagonos = false});
  late double _width; //_height;
  final _widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    //_height = MediaQuery.of(context).size.height; no se usa

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(titulo, style: Theme.of(context).textTheme.headlineLarge),
            if (mostrarBotonImprimir)
              Row(
                children: [
                  const SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: save, child: const Icon(Icons.download)),
                ],
              ),
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                                  color: colorHexagono(valor, bmu, row, col),
                                  // color: grillaBlanca
                                  //     ? const Color.fromARGB(255, 211, 211, 211)
                                  //     : clusters == null
                                  //         ? getInterpolatedColor(
                                  //             valor, gradiente, min!, max!)
                                  //         : getClusterColor(col, row, clusters),
                                  //antes
                                  // color: clusters == null
                                  //     ? getInterpolatedColor(
                                  //         valor, gradiente, min!, max!)
                                  //     : getClusterColor(col, row, clusters),
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
                              int columna = col;
                              if (dataMap![(row * columnas + 1).toString()] ==
                                  "-1") {
                                columna = col - 1;
                              }
                              int bMU = row * columnas + col + 1;
                              String valorDist = dataMap![bMU.toString()]!;
                              if (expandida) {
                                if (!((row + 1) % 2 == 0 ||
                                    (columna + 1) % 2 == 0)) {
                                  if (row != 0) {
                                    bMU = int.parse(
                                        (((row * (columnas / 2)) / 2 +
                                                1 +
                                                (columna / 2))
                                            .toString()));
                                  } else {
                                    bMU = int.parse(((bMU + 1) / 2).toString());
                                  }
                                }
                              }

                              return deshabilitarBotonesHexagonos == true
                                  ? const Text('')
                                  : valorDist == '-1'
                                      ? const Text("")
                                      : (((row + 1) % 2 == 0 ||
                                                  (columna + 1) % 2 == 0) &&
                                              expandida)
                                          ? const Text("")
                                          : Tooltip(
                                              message:
                                                  hits ? tooltipHits(bMU) : '',
                                              child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          textStyle:
                                                              const TextStyle(
                                                            // Tamaño del texto
                                                            color: Colors
                                                                .black, // Color del texto
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

                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0.0)),
                                                  onPressed: () {
                                                    showDialog<void>(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return hits
                                                            ? dialogBotonHits(
                                                                context,
                                                                bMU,
                                                                valorDist)
                                                            : dialogBotonBMUS(
                                                                context,
                                                                bMU,
                                                                valorDist);
                                                      },
                                                    );
                                                  },
                                                  child: hits
                                                      ? widgetHits(bMU,
                                                          mayoritario:
                                                              hitsPorMayoritario)
                                                      : const Text(
                                                          '',
                                                          //'',
                                                          //'123456789',
                                                          //'$BMU',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        )),
                                            );
                            }),
                      ),
                    ),
                    if (mostrarGradiente)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: [
                            Container(
                              width:
                                  60.0, // ajusta la altura según tus necesidades
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black, // Color del borde
                                  width: 1.0, // Grosor del borde
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment
                                      .topCenter, // comienza desde la parte superior
                                  end: Alignment
                                      .bottomCenter, // termina en la parte inferior
                                  colors: gradiente!.colors.reversed
                                      .toList(), //para que quede bien (arriba hacia abajo)
                                  stops: gradiente!.stops,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (double stop in [
                                  double.parse(max!.toStringAsFixed(1)),
                                  double.parse((min! +
                                          4 *
                                              double.parse(((max! - min!) / 5)
                                                  .toStringAsFixed(1)))
                                      .toStringAsFixed(1)),
                                  double.parse((min! +
                                          3 *
                                              double.parse(((max! - min!) / 5)
                                                  .toStringAsFixed(1)))
                                      .toStringAsFixed(1)),
                                  double.parse((min! +
                                          2 *
                                              double.parse(((max! - min!) / 5)
                                                  .toStringAsFixed(1)))
                                      .toStringAsFixed(1)),
                                  double.parse((min! +
                                          1 *
                                              double.parse(((max! - min!) / 5)
                                                  .toStringAsFixed(1)))
                                      .toStringAsFixed(1)),
                                  double.parse(min!.toStringAsFixed(1)),
                                ])
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      '$stop',
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                    ),
                                  ),
                              ],
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

  /// Funcion que devuelve el color del hexagono
  Color colorHexagono(double valor, int bmu, int row, int col) {
    if (grillaBlanca) {
      return const Color.fromARGB(255, 211, 211, 211);
    }
    if (clusters != null) {
      return getClusterColor(col, row, clusters);
    }
    if (mapaBmuColor != null) {
      return mapaBmuColor![bmu]!;
    }

    return getInterpolatedColor(valor, gradiente, min!, max!);
  }

  // Un solo color para cada circulo
  // Widget widgetHits(int bmu) {
  //   if (mapaBMUconEtiquetas!.containsKey(bmu)) {
  //     final etiquetas = mapaBMUconEtiquetas![bmu]![selectedKey];
  //     if (etiquetas != null && etiquetas.isNotEmpty) {
  //       final primerColor = mapaColores![
  //           etiquetas[0]]; // Obtiene el color de la primera etiqueta
  //       return CircleAvatar(
  //         backgroundColor: primerColor,
  //         radius: 10, // Ajusta el tamaño del círculo según sea necesario
  //       );
  //     }
  //   }
  //   return SizedBox(); // Retorna un widget vacío si el BMU no tiene etiquetas o no existe en el mapa
  // }

  Widget dialogBotonBMUS(BuildContext context, int bMU, String valorDist) {
    return AlertDialog(
      title: const Text('Información'),
      content: SizedBox(
        width: _width / 3,
        child: SingleChildScrollView(
          child: ListBody(
            children: [
              Text('BMU = $bMU'),
              Text('Udist = $valorDist'),
              const Text(
                "Codebook",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromARGB(255, 52, 56, 253), fontSize: 30.0),
              ),
              Table(
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 1),
                children: crearTablaDatos(
                    nombreColumnas, (codebook[bMU - 1]), titulo),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }

  Widget dialogBotonHits(BuildContext context, int bmu, String valorDist) {
    bool tieneEtiquetas = mapaBMUconEtiquetas!.containsKey(bmu);

    if (!tieneEtiquetas) {
      return dialogBotonBMUS(context, bmu, valorDist);
    } else {
      final etiquetas = mapaBMUconEtiquetas![bmu]![selectedKey];
      if (etiquetas!.length <= 20) {
        final List<Color> colores =
            etiquetas.map((etiqueta) => mapaColores![etiqueta]!).toList();
        return HitDialog(
          bmu: bmu,
          etiquetas: etiquetas,
          colores: colores,
          tablaDatos: Table(
            border: TableBorder.all(
                color: Colors.black, style: BorderStyle.solid, width: 1),
            children:
                crearTablaDatos(nombreColumnas, (codebook[bmu - 1]), titulo),
          ),
          selectedKey: selectedKey!,
        );
      } else {
        return dialogBotonBMUS(context, bmu, valorDist);
      }
    }
  }

  /// Multiples colores en cada circulo
  Widget widgetHits(int bmu, {bool mayoritario = false}) {
    if (mapaBMUconEtiquetas!.containsKey(bmu)) {
      final etiquetas = mapaBMUconEtiquetas![bmu]![selectedKey];

      if (etiquetas != null && etiquetas.isNotEmpty) {
        if (mayoritario) {
          String? etiquetaMayoritaria = obtenerEtiquetaMayoritaria(etiquetas);
          Color color = mapaColores![etiquetaMayoritaria]!;
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: Colors.black, width: 1.0), // Borde negro
            ),
            child: CircleAvatar(
              backgroundColor: color,
              radius: 10, // Ajusta el tamaño del círculo según sea necesario
            ),
          );
        } else {
          final List<Color> colores =
              etiquetas.map((etiqueta) => mapaColores![etiqueta]!).toList();
          if (colores.length > 1) {
            return CustomPaint(
              size: const Size(20, 20), // Tamaño del círculo
              painter: MultipleCirclePainter(colores),
            );
          } else if (colores.length == 1) {
            // Si solo hay un color, mostrar un círculo con ese color
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.black, width: 1.0), // Borde negro
              ),
              child: CircleAvatar(
                backgroundColor: colores[0],
                radius: 10, // Ajusta el tamaño del círculo según sea necesario
              ),
            );
          }
        }
      }
    }
    return const SizedBox(); // Retorna un widget vacío si el BMU no tiene etiquetas o no existe en el mapa
  }

  String tooltipHits(int bmu) {
    if (mapaBMUconEtiquetas!.containsKey(bmu)) {
      final bmuInfo = mapaBMUconEtiquetas![bmu]!;
      final StringBuffer infoBuffer = StringBuffer();
      final etiquetas = mapaBMUconEtiquetas![bmu]![selectedKey];
      if (etiquetas!.length <= 20) {
        bmuInfo.forEach((key, value) {
          infoBuffer.write('$key: ');
          infoBuffer.writeAll(value, ', ');
          // Agregar un salto de línea solo si no es la última clave
          if (key != bmuInfo.keys.last) {
            infoBuffer.writeln();
          }
        });

        return infoBuffer.toString();
      } else {
        // Si el BMU no existe en el mapa, retornar un string vacío
        return 'La cantidad de etiquetas supera el límite.';
      }
    } else {
      // Si el BMU no existe en el mapa, retornar un string vacío
      return '';
    }
  }

  void save() async {
    final boundary =
        _widgetKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final byteData = await image.toByteData(format: ImageByteFormat.png);

    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final blob = html.Blob([pngBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    DateTime now = new DateTime.now();
    html.AnchorElement(href: url)
      ..setAttribute('download', "$titulo-$now.png")
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}

class MultipleCirclePainter extends CustomPainter {
  final List<Color> coloresDes;

  MultipleCirclePainter(this.coloresDes);

  @override
  void paint(Canvas canvas, Size size) {
    // Ordeno lista para que me queden los colores consecutivos
    // Crear un mapa para agrupar los colores por tipo
    Map<Color, List<Color>> colorMap = {};
    coloresDes.forEach((color) {
      if (!colorMap.containsKey(color)) {
        colorMap[color] = [];
      }
      colorMap[color]!.add(color);
    });

    // Crear una lista ordenada con los colores agrupados
    List<Color> colores = [];
    colorMap.values.forEach((lista) {
      colores.addAll(lista);
    });

    double startAngle = 0;
    double sweepAngle = (2 * pi) / colores.length;
    double radius = size.width / 2;

    // Dibujar el borde negro alrededor del círculo
    Paint borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(Offset(radius, radius), radius, borderPaint);

    // Dibujar los círculos internos con los colores
    for (int i = 0; i < colores.length; i++) {
      Paint paint = Paint()..color = colores[i];

      Rect rect =
          Rect.fromCircle(center: Offset(radius, radius), radius: radius);
      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

String? obtenerEtiquetaMayoritaria(List<String>? etiquetas) {
  if (etiquetas == null || etiquetas.isEmpty) {
    return null;
  }

  Map<String, int> frecuencia = {};

  for (var etiqueta in etiquetas) {
    if (frecuencia.containsKey(etiqueta)) {
      frecuencia[etiqueta] = frecuencia[etiqueta]! + 1;
    } else {
      frecuencia[etiqueta] = 1;
    }
  }

  String? etiquetaMayoritaria;
  int maxFrecuencia = 0;

  frecuencia.forEach((key, value) {
    if (value > maxFrecuencia) {
      maxFrecuencia = value;
      etiquetaMayoritaria = key;
    }
  });

  return etiquetaMayoritaria;
}
