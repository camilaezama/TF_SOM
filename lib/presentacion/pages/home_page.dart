import 'package:TF_SOM_UNMdP/config/tema.dart';
import 'package:TF_SOM_UNMdP/models/resultado_entrenamiento_model.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/dialogs/configurar_gradiente_dialog.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/dialogs/configurar_parametros_dialog.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/dialogs/seleccionar_opciones_dialog.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/tabla_datos.dart';
import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:TF_SOM_UNMdP/providers/parametros_provider.dart';
import 'package:TF_SOM_UNMdP/utils/csv_to_data.dart';
import 'package:TF_SOM_UNMdP/utils/mostrar_dialog_texto.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
//import 'dart:typed_data'; // Para Uint8List
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String funcionVecindad = 'gaussian';
  // String inicializacion = 'random';

  List<List<dynamic>> csvData = [];
  List<List<dynamic>> csvDataOriginal = [];
  String botonAceptar = 'Entrenar';
  String botonParam = 'Modificar Parametros';

  bool cargando = false;

  /// Lista con todos los nombres de las columnas, seleccionados o no
  List<String> listaNombresColumnasOriginal = [];

  /// Lista de bool que contiene true o false dependiendo de si la columna esta seleccionada
  List<bool> listaBoolColumnasSeleccionadas = [];
  List<bool> listaBoolEtiquetasSeleccionadas = [];

  /// Lista con nombre de las columnas seleccionadas
  List<String> listaNombresColumnasSeleccionadas = [];

  late double _width, _height;

  String fileName = '';

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
        // Para probar !!!!! TODO: BORRAR
        // listaBoolEtiquetasSeleccionadas[0] = true;
        // listaBoolEtiquetasSeleccionadas[1] = true;
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

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colorFondoPrimary,
        title: const Text('Carga de datos'),
      ),
      body: Container(
        color: AppTheme.colorFondoPrimary,
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
                    IconButton(
                        tooltip: 'Elegir gradiente',
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfigurarGradienteDialog(
                                widthPantalla: _width,
                                heightPantalla: _height,
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.gradient_outlined))
                  ],
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
                // (csvData.isNotEmpty)
                //     ? TablaDatos(
                //         csvData: csvData,
                //         columnNames: listaNombresColumnasSeleccionadas,
                //       )
                //     : const SizedBox.shrink(),
                (csvData.isNotEmpty) ? 
                  (csvData.length > 100) ? 
                    Text("La cantidad de datos es muy grande, la vista previa del archivo $fileName ha sido deshabilitada.") :
                      TablaDatos(
                        csvData: csvData,
                        columnNames: listaNombresColumnasSeleccionadas,
                      ) : 
                    const SizedBox.shrink(), 
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: _llamadaAPIRapida,
                            style: AppTheme.secondaryButtonStyle,
                            child: cargando
                                ? const CircularProgressIndicator()
                                : const Text(
                                    "Devolver json archivo",
                                    style: TextStyle(fontSize: 16),
                                  )),
                        const SizedBox(
                          width: 30.0,
                        ),
                        ElevatedButton(
                            onPressed: _llamadaAPI,
                            style: AppTheme.primaryButtonStyle,
                            child: cargando
                                ? const CircularProgressIndicator()
                                : Text(
                                    botonAceptar,
                                    style: const TextStyle(fontSize: 16),
                                  )),
                        const SizedBox(
                          width: 30.0,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              //loadData();
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfigurarParametrosDialog(
                                    widthPantalla: _width,
                                    heightPantalla: _height,
                                  );
                                },
                              );
                            },
                            child: Text(botonParam))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  // junto ambas listas de bool y filtro csv data origin
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
    List<List<dynamic>> filteredData = filtrarCsvData(columnasATenerEnCuenta,
        listaNombresColumnasOriginal, csvDataOriginal);
    return filteredData;
  }

  void _llamadaAPI() async {
    final parametrosProvider = context.read<ParametrosProvider>();
    final datosProvider = context.read<DatosProvider>();

    if (csvData.isNotEmpty) {

      //TODO: Si hay columnas de string, preguntar si se quieren seleccionar como etiquetas o algo asi
      
      List<List<dynamic>> filteredCsv = filtroColumnasSeleccionadasYEtiquetas();
      List<Map<String, String>> data = csvToData(filteredCsv);
      String jsonResult = jsonEncode(data);

      List<List<dynamic>> filteredEtiquetas = filtrarCsvData(listaBoolEtiquetasSeleccionadas,
        listaNombresColumnasOriginal, csvDataOriginal);
      List<Map<String, String>> dataEtiquetas = csvToData(filteredEtiquetas);
      String jsonResultEtiquetas = jsonEncode(dataEtiquetas);

      try {
        String tipoLlamada = "bmu";
        final parametros = parametrosProvider.mapaParametros();

        setState(() {
          cargando = true;
        });

        ResultadoEntrenamientoModel resultadoEntrenamiento = await datosProvider
            .entrenamiento(tipoLlamada, parametros, jsonResult, jsonResultEtiquetas);

        setState(() {
          Navigator.pushNamed(
            context,
            '/grillas',
            arguments: resultadoEntrenamiento,
          );
          cargando = false;
        });
      } catch (e) {
        print(e);
        mostrarDialogTexto(
            context, 'Error', 'Error en la  llamada de servicio: $e');
        setState(() {
          cargando = false;
          botonAceptar = "Entrenar";
        });
      }
    } else {
      mostrarDialogTexto(
          context, 'Error al cargar', 'Debe seleccionar un archivo.');
    }
  }

  void _llamadaAPIRapida() async {
    final parametrosProvider = context.read<ParametrosProvider>();
    final datosProvider = context.read<DatosProvider>();

    try {
      String tipoLlamada = "rapida";

      String jsonResult = "";

      final parametros = parametrosProvider.mapaParametros();

      setState(() {
        cargando = true;
      });

      ResultadoEntrenamientoModel resultadoEntrenamiento = await datosProvider
          .entrenamiento(tipoLlamada, parametros, jsonResult, "");

      setState(() {
        Navigator.pushNamed(
          context,
          '/grillas',
          arguments: resultadoEntrenamiento,
        );
        cargando = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        cargando = false;
        botonAceptar = "Entrenar";
      });
    }
  }
}


