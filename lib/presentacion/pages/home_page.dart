import 'package:TF_SOM_UNMdP/config/tema.dart';
import 'package:TF_SOM_UNMdP/models/resultado_entrenamiento_model.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/dialogs/configuraciones_dialog.dart';
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
  String botonParam = 'Parametros';

  bool cargando = false;
  bool deteccionAutomaticaFeatures = true;

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
        if (deteccionAutomaticaFeatures) {
          deteccionAutomatica(csvData, listaBoolColumnasSeleccionadas,
              listaBoolEtiquetasSeleccionadas);
        }
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
    if (result != null) {
      _loadCSVData(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.colorFondoPrimary,
        actions:  [
          IconButton(onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfiguracionesDialog(
                      widthPantalla: _width,
                      heightPantalla: _height,
                    );
                  },
                );
              } , icon: const Icon(Icons.settings)),
         const SizedBox(width: 15)
        ],
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// LOGO APP
              Flexible(
                child: Image.asset(
                  'assets/logo.png', // replace with your image path
                  height: 50.0, // adjust the height as needed
                  fit: BoxFit
                      .contain, // ensures the image scales to fit within the available space
                ),
              ),
              const SizedBox(width: 10),
              /// TITULO APP
              const Text('VisualiSOM', style: TituloStyleLarge()),
            ],
          ),
        ),
      ),
      body: Container(
        color: AppTheme.colorFondoPrimary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 100.0,
                        ),
                        /// BOTON SELECCIONAR ARCHIVO
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
                        SizedBox(
                          width: 100.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// BOTON GRADIENTE
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
                                  icon: const Icon(Icons.gradient_outlined)),
                              /// CHECK FEATURES
                              Tooltip(
                                message: "Deteccion automática de features",
                                child: Checkbox(
                                  value: deteccionAutomaticaFeatures,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      deteccionAutomaticaFeatures = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

                (csvData.isNotEmpty)
                    ? (csvData.length > 100)
                        ? Text(
                            "La cantidad de datos es muy grande, la vista previa del archivo $fileName ha sido deshabilitada.")
                        : Expanded(
                            child: TablaDatos(
                              csvData: csvData,
                              columnNames: listaNombresColumnasSeleccionadas,
                            ),
                          )
                    : const SizedBox.shrink(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 180.0,
                          child: ElevatedButton(
                              onPressed: _llamadaAPIRapida,
                              style: AppTheme.secondaryButtonStyle,
                              child: cargando
                                  ? const CircularProgressIndicator()
                                  : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.attach_file),
                                        SizedBox(
                                          width: 4.0,
                                        ),
                                        Text(
                                          "Cargar archivo",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: ElevatedButton(
                              onPressed: _llamadaAPI,
                              style: AppTheme.primaryButtonStyle,
                              child: cargando
                                  ? const CircularProgressIndicator()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14.0),
                                      child: Text(
                                        botonAceptar,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    )),
                        ),
                        SizedBox(
                          width: 180.0,
                          child: ElevatedButton(
                            style: AppTheme.secondaryButtonStyle,
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
                              child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.tune),
                                  const SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(botonParam)
                                ],
                              )),
                        )
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
    List<List<dynamic>> filteredData = filtrarCsvData(
        columnasATenerEnCuenta, listaNombresColumnasOriginal, csvDataOriginal);
    return filteredData;
  }

  void _llamadaAPI() async {
    final parametrosProvider = context.read<ParametrosProvider>();
    final datosProvider = context.read<DatosProvider>();

    if (csvData.isNotEmpty) {
      List<List<dynamic>> filteredCsv = filtroColumnasSeleccionadasYEtiquetas();

      List<Map<String, String>> data = csvToData(filteredCsv);
      String jsonResult = jsonEncode(data);
      jsonResult = jsonResult.replaceAll('\\r', '');
      List<List<dynamic>> filteredEtiquetas = filtrarCsvData(
          listaBoolEtiquetasSeleccionadas,
          listaNombresColumnasOriginal,
          csvDataOriginal);
      List<Map<String, String>> dataEtiquetas = csvToData(filteredEtiquetas);
      String jsonResultEtiquetas = jsonEncode(dataEtiquetas);

      try {
        for (int i = 1; i < filteredCsv.length; i++) {
          //ignora el cero pues es el nombre de las columnas
          if (filteredCsv[i][0].contains(RegExp('[a-zA-Z]'))) {
            throw const FormatException(
                "Una de las columnas marcada como Features contiene datos no numéricos. Deseleccione la columna e intente nuevamente.");
          }
        }
        String tipoLlamada = "bmu";
        final parametros = parametrosProvider.mapaParametros();

        setState(() {
          cargando = true;
        });
        ResultadoEntrenamientoModel resultadoEntrenamiento =
            await datosProvider.entrenamiento(context,
                tipoLlamada, parametros, jsonResult, jsonResultEtiquetas);
        setState(() {
          Navigator.pushNamed(
            context,
            'grillas',
            arguments: resultadoEntrenamiento,
          );
          cargando = false;
        });
      } catch (e) {
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
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    final datosProvider = context.read<DatosProvider>();
    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      fileName = result.files.first.name;

      if (fileName.endsWith('.json')) {
        try {
          setState(() {
            cargando = true;
          });
          final contents = utf8.decode(fileBytes!);
          final jsonData = jsonDecode(contents);

          ResultadoEntrenamientoModel resultadoEntrenamiento =
              datosProvider.procesarDatos(jsonData, "", jsonData["Parametros"]);

          setState(() {
            Navigator.pushNamed(
              context,
              'grillas',
              arguments: resultadoEntrenamiento,
            );
            cargando = false;
          });
        } catch (e) {
          mostrarDialogTexto(
              context, 'Error', 'Error en el archivo ingresado.');
          setState(() {
            cargando = false;
            botonAceptar = "Entrenar";
          });
        }
      } else {
        mostrarDialogTexto(
            context, 'Archivo Invalido', 'Debe seleccionar un archivo JSON.');
      }
    }
  }
}

void deteccionAutomatica(
    List<List> csvData,
    List<bool> listaBoolColumnasSeleccionadas,
    List<bool> listaBoolEtiquetasSeleccionadas) {
  List<String> primeraFilaValores = csvData[1][0].toString().split(';');
  for (int i = 0; i < primeraFilaValores.length; i++) {
    try {
      double.parse(primeraFilaValores[i]);
    } catch (e) {
      //si no pudo parsear entonces son letras, es etiqueta
      listaBoolColumnasSeleccionadas[i] = false;
      listaBoolEtiquetasSeleccionadas[i] = true;
    }
  }
}
