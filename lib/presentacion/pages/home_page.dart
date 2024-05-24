import 'package:TF_SOM_UNMdP/config/tema.dart';
import 'package:TF_SOM_UNMdP/models/resultado_entrenamiento_model.dart';
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
  // String normalizacion = 'var';

  List<List<dynamic>> csvData = [];
  List<List<dynamic>> csvDataOriginal = [];
  String botonAceptar = 'Aceptar';
  String botonParam = 'Modificar Parametros';

  bool cargando = false;

  List<String> opciones = [];
  List<bool> seleccionadas = [];
  List<String> opcionesSeleccionadas = [];

  List<String>? columnNames;
  List<String>? columnNamesOriginal;
  late double _width, _height;

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
        columnNamesOriginal = csvData[0][0].toString().split(';');
        columnNames = csvData[0][0].toString().split(';');
        columnNames!.forEach((element) {
          seleccionadas.add(true);
        });
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: _selectFile,
                      child: const Text(
                        'Seleccionar Archivo CSV',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                (csvData.isNotEmpty)
                    ? IconButton(
                        icon: const Icon(Icons.list),
                        onPressed: () {
                          opciones = columnNamesOriginal!;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogOpciones(
                                opciones: opciones,
                                seleccionadas: seleccionadas,
                                actualizarOpciones: actualizarOpciones,
                              );
                            },
                          );
                        },
                        //onPressed: () => {_mostrarListaOpciones(context)},
                      )
                    : const SizedBox.shrink(),
                (csvData.isNotEmpty)
                    ? TablaDatos(
                        csvData: csvData,
                        columnNames: columnNames,
                      )
                    : const SizedBox.shrink(),
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
    seleccionadas = opcionesSeleccionadasBool;

    List<List<dynamic>> filteredData = [];

    List<dynamic> headerRow = [];

    for (int i = 0; i < columnNamesOriginal!.length; i++) {
      if (seleccionadas[i]) {
        headerRow.add(columnNamesOriginal![i]);
      }
    }

    for (List<dynamic> fila in csvDataOriginal) {
      List<String> columnas = fila[0].split(';');
      List<String> filaFiltrada = [];

      for (int i = 0; i < columnas.length; i++) {
        if (seleccionadas[i]) {
          filaFiltrada.add(columnas[i]);
        }
      }

      List<dynamic> lista = [filaFiltrada.join(';')];
      filteredData.add(lista);
    }

    seleccionadas = opcionesSeleccionadasBool;

    List<String> seleccionadasList = [];

    for (int i = 0; i < opciones.length; i++) {
      if (seleccionadas[i]) {
        seleccionadasList.add(opciones[i]);
      }
    }
    setState(() {
      opcionesSeleccionadas = seleccionadasList;
      csvData = filteredData;
      columnNames = opcionesSeleccionadas;
    });
  }

  void _llamadaAPI() async {
    final parametrosProvider = context.read<ParametrosProvider>();
    final datosProvider = context.read<DatosProvider>();

    if (csvData.isNotEmpty) {
      List<Map<String, String>> data = csvToData(csvData);

      String jsonResult = jsonEncode(data);

      try {
        String tipoLlamada = "bmu";
        final parametros = parametrosProvider.mapaParametros();

        setState(() {
          cargando = true;
        });

        ResultadoEntrenamientoModel resultadoEntrenamiento = await datosProvider
            .entrenamiento(tipoLlamada, parametros, jsonResult);

        setState(() {
          Navigator.pushNamed(
            context,
            '/grillas',
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
          .entrenamiento(tipoLlamada, parametros, jsonResult);

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
