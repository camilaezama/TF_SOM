import 'dart:convert';
import 'dart:typed_data';

import 'package:TF_SOM_UNMdP/config/tema.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/dialogs/seleccionar_opciones_dialog.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/tabla_datos.dart';
import 'package:TF_SOM_UNMdP/utils/csv_to_data.dart';
import 'package:TF_SOM_UNMdP/utils/mostrar_dialog_texto.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class NuevoDatoPestana extends StatefulWidget {
  const NuevoDatoPestana({super.key});

  @override
  State<NuevoDatoPestana> createState() => _NuevoDatoPestanaState();
}

class _NuevoDatoPestanaState extends State<NuevoDatoPestana> {
  List<List<dynamic>> csvData = [];
  List<List<dynamic>> csvDataOriginal = [];

  bool cargando = false;

  /// Lista con todos los nombres de las columnas, seleccionados o no
  List<String> listaNombresColumnasOriginal = [];

  /// Lista de bool que contiene true o false dependiendo de si la columna esta seleccionada
  List<bool> listaBoolColumnasSeleccionadas = [];

  List<bool> listaBoolEtiquetasSeleccionadas = [];

  /// Lista con nombre de las columnas seleccionadas
  List<String> listaNombresColumnasSeleccionadas = [];

  bool abierto = true;
  bool mostrarGrilla = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double appBarHeight = AppBar().preferredSize.height;
    double tabBarHeight = TabBar(tabs: []).preferredSize.height;

    double ancho = 0.6;

    double widthPestana = abierto ? size.width * ancho : 0;
    double heightPestana =
        abierto ? (size.height - appBarHeight - tabBarHeight) : 0;

    return Stack(
      children: [
        if (mostrarGrilla) const Center(child: Text('Grilla hexagonos')),
        Row(
          children: [
            Container(
              color: Colors.white,
              width: widthPestana,
              height: heightPestana,
            ),
            Container(
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.topLeft,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          abierto = !abierto;
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 3,
                                )
                              ],
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10))),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          child: const Text('Datos'))),
                ),
              ),
            ),
          ],
        ),
        Positioned(
            width: widthPestana,
            height: heightPestana,
            child:
                Visibility(visible: abierto, child: pestanaLateral(context))),
      ],
    );
  }

  Container pestanaLateral(BuildContext context) {
    return Container(
      //color: AppTheme.colorFondoPrimary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200], // Color de fondo medio claro
            borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400]!, // Color de la sombra
                blurRadius: 5.0, // Radio de desenfoque de la sombra
                offset: const Offset(0.0, 3.0), // Desplazamiento de la sombra
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: _selectFile,
                      child: const Text(
                        'Seleccionar Archivo CSV',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  (csvData.isNotEmpty)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              label: const Text('Columnas'),
                              icon: const Icon(Icons.list),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogOpciones(
                                      opciones: listaNombresColumnasOriginal,
                                      seleccionadas:
                                          listaBoolColumnasSeleccionadas,
                                      actualizarOpciones: actualizarOpciones,
                                    );
                                  },
                                );
                              },
                              //onPressed: () => {_mostrarListaOpciones(context)},
                            ),
                            TextButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogOpciones(
                                      tituloDialog:
                                          'Seleccionar columnas que son etiquetas',
                                      opciones: listaNombresColumnasOriginal,
                                      seleccionadas:
                                          listaBoolEtiquetasSeleccionadas,
                                      actualizarOpciones:
                                          actualizarOpcionesEtiquetas,
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.sell_outlined),
                              label: const Text('Etiquetas'),
                            )
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              (csvData.isNotEmpty)
                  ? TablaDatos(
                      csvData: csvData,
                      columnNames: listaNombresColumnasSeleccionadas,
                    )
                  : const SizedBox.shrink(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              mostrarGrilla = true;
                              abierto = false;
                            });
                          },
                          child: cargando
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "Devolver BMU datos",
                                  style: TextStyle(fontSize: 16),
                                )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadCSVData(FilePickerResult result) async {
    Uint8List? fileBytes = result.files.first.bytes;
    String fileName = result.files.first.name;

    if (fileName.endsWith('.csv')) {
      String fileContent = utf8.decode(fileBytes!);
      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(fileContent);

      setState(() {
        csvDataOriginal = csvTable;
        csvData = csvTable;
        listaNombresColumnasOriginal = csvData[0][0].toString().split(';');
        listaNombresColumnasSeleccionadas = csvData[0][0].toString().split(';');
        // Inicializo lista de bools
        listaBoolColumnasSeleccionadas = [];
        for (int i = 0; i < listaNombresColumnasOriginal.length; i++) {
          listaBoolColumnasSeleccionadas.add(true);
        }
        listaBoolEtiquetasSeleccionadas = [];
        for (int i = 0; i < listaNombresColumnasOriginal.length; i++) {
          listaBoolEtiquetasSeleccionadas.add(false);
        }
        // Para probar !!!!! TODO: BORRAR
        listaBoolEtiquetasSeleccionadas[0] = true;
        listaBoolEtiquetasSeleccionadas[1] = true;
      });
    } else {
      mostrarDialogTexto(
          context, 'Archivo Invalido', 'Debe seleccionar un archivo CSV.');
    }
  }

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    _loadCSVData(result!);
  }

  void actualizarOpciones(List<bool> opcionesSeleccionadasBool) {
    listaBoolColumnasSeleccionadas = opcionesSeleccionadasBool;

    // A partir de los datos originales y las col seleccionadas, devuelve datos solo con col seleccionadas
    List<List<dynamic>> filteredData = filtrarCsvData(opcionesSeleccionadasBool,
        listaNombresColumnasOriginal, csvDataOriginal);

    // Armo lista de nombres con columnas seleccionadas
    List<String> seleccionadasList = [];
    for (int i = 0; i < listaNombresColumnasOriginal.length; i++) {
      if (listaBoolColumnasSeleccionadas[i]) {
        seleccionadasList.add(listaNombresColumnasOriginal[i]);
      }
    }

    setState(() {
      listaNombresColumnasSeleccionadas = seleccionadasList;
      csvData = filteredData;
    });
  }

  void actualizarOpcionesEtiquetas(List<bool> opcionesSeleccionadasBool) {
    listaBoolEtiquetasSeleccionadas = opcionesSeleccionadasBool;

    setState(() {});
  }
}
