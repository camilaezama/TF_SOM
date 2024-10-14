import 'dart:convert';
import 'dart:typed_data';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/dialogs/seleccionar_opciones_dialog.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/grilla_con_etiquetas.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/tabla_datos.dart';
import 'package:TF_SOM_UNMdP/providers/nuevos_datos_provider.dart';
import 'package:TF_SOM_UNMdP/utils/colores_hits.dart';
import 'package:TF_SOM_UNMdP/utils/csv_to_data.dart';
import 'package:TF_SOM_UNMdP/utils/mostrar_dialog_texto.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NuevoDatoPestana extends StatefulWidget {
  final Gradient gradiente;

  const NuevoDatoPestana({super.key, required this.gradiente});

  @override
  State<NuevoDatoPestana> createState() => _NuevoDatoPestanaState();
}

class _NuevoDatoPestanaState extends State<NuevoDatoPestana>
    with AutomaticKeepAliveClientMixin {
  List<List<dynamic>> csvData = [];
  List<List<dynamic>> csvDataOriginal = [];

  List<List<dynamic>> csvDataIdentificadores = [];

  bool cargando = false;

  /// Lista con todos los nombres de las columnas, seleccionados o no
  List<String> listaNombresColumnasOriginal = [];

  /// Lista de bool que contiene true o false dependiendo de si la columna esta seleccionada
  List<bool> listaBoolColumnasSeleccionadas = [];

  List<bool> listaBoolEtiquetasSeleccionadas = [];

  /// Lista con nombre de las columnas seleccionadas
  List<String> listaNombresColumnasSeleccionadas = [];

  // {4: {Datos: [1]}, 6: {Datos: [2,4]}, ...}
  Map<int, Map<String, List<String>>> mapaBMUconEtiquetas = {};
  // {Datos: [1,2,3,4]}
  Map<String, List<String>> etiquetasMap = {};
  String selectedKey = '';
  List<String> selectedValues = [];
  Map<String, Color> mapaColores = {};

  bool abierto = true;
  bool mostrarGrilla = false;

  String fileName = '';

  final List<ScrollController> _controllers = [];

  void _scrollControllerListener(ScrollController sourceController) {
    _controllers.forEach((element) {
      //print(element.offset);
    });
    //print(sourceController.offset);
    final double offset = sourceController.offset;
    for (var controller in _controllers) {
      if (controller != sourceController && controller.offset != offset) {
        controller.jumpTo(offset);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    double appBarHeight = AppBar().preferredSize.height;
    double tabBarHeight = const TabBar(tabs: []).preferredSize.height;

    double ancho = 0.6;

    double widthPestana = abierto ? size.width * ancho : 0;
    double heightPestana =
        abierto ? (size.height - appBarHeight - tabBarHeight) : 0;

    ScrollController scrollTabla1 = ScrollController();
    ScrollController scrollTabla2 = ScrollController();

    scrollTabla1.addListener(() {
      _scrollControllerListener(scrollTabla1);
    });

    scrollTabla2.addListener(() {
      _scrollControllerListener(scrollTabla2);
    });

    _controllers.clear();
    _controllers.add(scrollTabla1);
    _controllers.add(scrollTabla2);

    return Stack(
      children: [
        if (mostrarGrilla)
          GrillaConEtiquetas(
            mapaBMUconEtiquetas: mapaBMUconEtiquetas,
            etiquetasMap: etiquetasMap,
            gradiente: widget.gradiente,
            tituloGrilla: 'Nuevos Datos',
            tituloColumnaEtiquetas: 'Datos',
          ),
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
            child: Visibility(
                visible: abierto,
                child: pestanaLateral(context, heightPestana,  scrollTabla1, scrollTabla2))),
      ],
    );
  }

  Container pestanaLateral(BuildContext context, double heightPestana,  ScrollController scrollTabla1,  ScrollController scrollTabla2) {
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
                              label: const Text('Features'),
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
                  ? (csvData.length > 100)
                      ? Text(
                          "La cantidad de datos es muy grande, la vista previa del archivo $fileName ha sido deshabilitada.")
                      : SizedBox(
                          height: heightPestana * 0.7,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TablaDatos(
                                csvData: csvDataIdentificadores,
                                columnNames: const ['Dato'],
                                scrollVertical: scrollTabla1,
                              ),
                              Expanded(
                                child: TablaDatos(
                                  csvData: csvData,
                                  columnNames:
                                      listaNombresColumnasSeleccionadas,
                                  scrollVertical: scrollTabla2,
                                ),
                              ),
                            ],
                          ),
                        )
                  : const SizedBox.shrink(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: llamadaApi,
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

  void llamadaApi() async {
    final nuevosDatosProvider = context.read<NuevosDatosProvider>();
    int coderror = -1;
    List<List<dynamic>> filteredCsv = filtroColumnasSeleccionadasYEtiquetas();
    List<Map<String, String>> data = csvToData(filteredCsv);
    String jsonResult = jsonEncode(data);

    List<List<dynamic>> filteredEtiquetas = filtrarCsvData(
        listaBoolEtiquetasSeleccionadas,
        listaNombresColumnasOriginal,
        csvDataOriginal);
    List<Map<String, String>> dataEtiquetas = csvToData(filteredEtiquetas);
    String jsonResultEtiquetas = jsonEncode(dataEtiquetas);

    try {
      setState(() {
        cargando = true;
      });

      //truquito: para contar la cantidad de columnas cuento la cantidad de separadores (;) y le sumo 1 por el ultimo que no tiene
      //si no se cumple, lanzo una excepcion
      if (((';'.allMatches(filteredCsv[0][0]).length) + 1 !=
          nuevosDatosProvider.cantDatosOriginal(context))) {
        coderror = 1;
        throw const FormatException(
            'La cantidad de features no coincide con el archivo original!');
      }

      if (!nuevosDatosProvider.validarColumnas(context, filteredCsv[0][0])) {
        throw const FormatException(
            'Los nombres de las features no coincide las del  archivo original!');
      }

      Map<String, String> resultado = await nuevosDatosProvider
          .llamadaNuevosDatos(context, jsonResult, jsonResultEtiquetas);

      procesarDatos(resultado);

      setState(() {
        mostrarGrilla = true;
        abierto = false;
        cargando = false;
      });
    } catch (e) {
      print(e);
      if (coderror == 1) {
        mostrarDialogTexto(context, 'Error features',
            'La cantidad de features no coincide con el archivo original!');
      } else {
        mostrarDialogTexto(
            context, 'Error', 'Error en la  llamada de servicio: $e');
      }
      setState(() {
        cargando = false;
        mostrarGrilla = false;
      });
    }
  }

  void procesarDatos(Map<String, String> resultado) {
    //Limpiamos por si quedaron datos de un dataset anterior.
    for (var i = 0; i < mapaBMUconEtiquetas.keys.length; i++) {
      if (mapaBMUconEtiquetas[i] != null) {
        mapaBMUconEtiquetas[i]!['Datos']!.clear();
      }
    }

    resultado.forEach((dato, bmu) {
      int bmuInt = int.parse(bmu);
      if (!mapaBMUconEtiquetas.containsKey(bmuInt)) {
        mapaBMUconEtiquetas[bmuInt] = {'Datos': []};
      }
      mapaBMUconEtiquetas[bmuInt]!['Datos']!.add(dato);
    });

    List<String> keysList = resultado.keys.toList();
    etiquetasMap['Datos'] = keysList;

    selectedKey = etiquetasMap.keys.first;
    selectedValues = etiquetasMap[selectedKey]!;
    mapaColores = generateColorMap(selectedValues);

    // print(mapaBMUconEtiquetas);
    // print(etiquetasMap);
    // print(selectedKey);
    // print(selectedValues);
    // print(mapaColores);
  }

  // junto ambas listas de bool y filtro csv data origin //TODO: USAR LA MISMA QUE HOME PAGE
  List<List<dynamic>> filtroColumnasSeleccionadasYEtiquetas() {
    List<bool> columnasATenerEnCuenta = [];
    for (int index = 0; index < listaNombresColumnasOriginal.length; index++) {
      if (listaBoolEtiquetasSeleccionadas[index] == true ||
          listaBoolColumnasSeleccionadas[index] == false) {
        columnasATenerEnCuenta.add(false);
      } else {
        columnasATenerEnCuenta.add(true);
      }
    }
    List<List<dynamic>> filteredData = filtrarCsvData(
        columnasATenerEnCuenta, listaNombresColumnasOriginal, csvDataOriginal);
    return filteredData;
  }

  void _loadCSVData(FilePickerResult result) async {
    Uint8List? fileBytes = result.files.first.bytes;
    fileName = result.files.first.name;

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

        csvDataIdentificadores.clear();
        csvDataIdentificadores.add(['Dato']);
        for (int identificador_dato = 1;
            identificador_dato < csvData.length;
            identificador_dato++) {
          csvDataIdentificadores.add([identificador_dato]);
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
    if (result != null) {
      _loadCSVData(result);
    }
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
