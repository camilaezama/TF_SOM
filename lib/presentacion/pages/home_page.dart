import 'package:TF_SOM_UNMdP/config/tema.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/dialogs/configurar_parametros_dialog.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/dialogs/seleccionar_opciones_dialog.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/tabla_datos.dart';
import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:TF_SOM_UNMdP/providers/parametros_provider.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:typed_data'; // Para Uint8List
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String funcionVecindad = 'gaussian';
  // String inicializacion = 'random';
  // String normalizacion = 'var';

  List<List<dynamic>> csvData = [];
  List<List<dynamic>> csvData_original = [];
  String botonAceptar = 'Entrenar';
  String botonParam = 'Modificar Parametros';

  bool cargando = false;

  List<String> opciones = [];
  List<bool> seleccionadas = [];
  List<String> opcionesSeleccionadas = [];

  List<String>? columnNames;
  List<String>? columnNames_original;
  late double _width, _height;

  void _loadCSVData(FilePickerResult result) async {
    Uint8List? fileBytes = result.files.first.bytes;
    String fileName = result.files.first.name;

    if (fileName.endsWith('.csv')) {
      String fileContent = utf8.decode(fileBytes!);
      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(fileContent);

      setState(() {
        csvData_original = csvTable;
        csvData = csvTable;
        columnNames_original = csvData[0][0].toString().split(';');
        columnNames = csvData[0][0].toString().split(';');
        columnNames!.forEach((element) {
          seleccionadas.add(true);
        });
      });
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Archivo Invalido'),
            content: const Text('Debe seleccionar un archivo CSV.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
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
                          opciones = columnNames_original!;
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

    for (int i = 0; i < columnNames_original!.length; i++) {
      if (seleccionadas[i]) {
        headerRow.add(columnNames_original![i]);
      }
    }

    for (List<dynamic> fila in csvData_original) {
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

  ByteData csvToByteData(List<List<dynamic>> csvTable) {
    // Supongamos que tienes una función que convierte tu tabla CSV a una lista de bytes
    List<int> byteList = convertCsvTableToBytes(csvTable);

    // Convertir la lista de bytes a Uint8List
    Uint8List uint8List = Uint8List.fromList(byteList);

    // Crear ByteData a partir de Uint8List
    ByteData byteData = uint8List.buffer.asByteData();

    return byteData;
  }

  List<int> convertCsvTableToBytes(List<List<dynamic>> csvTable) {
    // Aquí debes implementar la lógica para convertir tu tabla CSV a una lista de bytes
    // Puedes usar 'utf8.encode' si tu CSV está en formato de texto
    // Por ejemplo, puedes hacer algo como:
    String csvString = const ListToCsvConverter().convert(csvTable);
    List<int> byteList = utf8.encode(csvString);

    return byteList;
  }

  List<Map<String, String>> convertRowsToMap(List<List<dynamic>> rows) {
    List<String> columnNames = List.from(rows[0]);
    List<Map<String, String>> result = [];

    for (int i = 1; i < rows.length; i++) {
      Map<String, String> rowMap = {};

      for (int j = 0; j < columnNames.length; j++) {
        // Convertir el valor a String y asignarlo al mapa con el nombre de la columna
        rowMap[columnNames[j]] = rows[i][j].toString();
      }

      result.add(rowMap);
    }

    return result;
  }

  void _llamadaAPI() async {
    //Navigator.pushNamed(context, '/grillas');

    final parametrosProvider = context.read<ParametrosProvider>();

    final datosProvider = context.read<DatosProvider>();

    if (csvData.isNotEmpty) {
      ByteData byteData = csvToByteData(csvData);

      String content = String.fromCharCodes(byteData.buffer.asUint8List());

      // Parsear el contenido CSV con el delimitador ';'
      List<List<dynamic>> rows =
          const CsvToListConverter(eol: '\n', fieldDelimiter: ';')
              .convert(content);
      List<Map<String, String>> result = convertRowsToMap(rows);

      String jsonResult = jsonEncode(result);

      try {
        String TIPO_LLAMADA = "bmu";
        var url = Uri.parse('http://localhost:7777' + '/' + TIPO_LLAMADA);

        final parametros = <String, dynamic>{
          'filas':
              parametrosProvider.filas != "" ? parametrosProvider.filas : 24,
          'columnas': parametrosProvider.columnas != ""
              ? parametrosProvider.columnas
              : 31, //TODO IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
          'vecindad': parametrosProvider.funcionVecindad,
          'inicializacion': parametrosProvider.inicializacion,
          'iteraciones': parametrosProvider.itera != ""
              ? parametrosProvider.itera
              : 200, //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
          'normalizacion': parametrosProvider.normalizacion,
          'factorEntrenamiento': parametrosProvider.factorEntrenamiento != ""
              ? parametrosProvider.factorEntrenamiento
              : 2 //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
        };

        // final parametros = <String, dynamic>{
        //   'filas': filasController.text != "" ? filasController.text : 24,
        //   'columnas': columnasController.text != ""
        //       ? columnasController.text
        //       : 31, //TODO IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
        //   'vecindad': funcionVecindad,
        //   'inicializacion': inicializacion,
        //   'iteraciones': iteracontroller.text != ""
        //       ? iteracontroller.text
        //       : 200, //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
        //   'normalizacion': normalizacion,
        //   'factorEntrenamiento': factorEntrenamientoController.text != ""
        //       ? factorEntrenamientoController.text
        //       : 2 //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
        // };

        setState(() {
          //boton = "Cargando...";
          cargando = true;
        });
        // var response = await http.post(url,
        //     headers: {'Accept': '/*'}, body: jsonResult);
        var response = await http.post(url,
            headers: {'Accept': '/*'},
            body: jsonEncode({
              "datos": jsonResult,
              "tipo": TIPO_LLAMADA,
              "params": parametros
            }));

        // print('Response status: ${response.statusCode}');
        //print('Response body: ${response.body}');

        // Map<String, dynamic> jsonList = json.decode(response.body);
        // Map<String,Map<String, String>> mapaRta = Map<String,Map<String, String>>.from(jsonList);

        // Decodificar la cadena JSON
        Map<String, dynamic> decodedJson = json.decode(response.body);

        Map<String, dynamic> NeuronsJSON = decodedJson["Neurons"];
        List<dynamic> Codebook = decodedJson["Codebook"];
        List<dynamic> UmatJSON = decodedJson["UMat"];

        print(Codebook);

        /// Procesamiento de datos para Hits
        Map<String, dynamic> HitsJSON = decodedJson["Hits"];
        Map<int, int> hitsMap = Map<int, int>.from(
            HitsJSON.map((key, value) => MapEntry(int.parse(key), value)));

        /// Procesamiento de datos para UMat
        List<List<double>> lista = [];
        UmatJSON.forEach((element) {
          List<double> elementt = [];
          element.forEach((e) {
            elementt.add(double.parse(e.toString()));
          });
          lista.add(elementt);
        });

        Map<String, String> dataMapUmat = {};
        lista.forEach((element) {
          dataMapUmat[element[0].toString()] = element[1].toString();
        });
        //Map<String, dynamic> umatJson = decodedJson["umat"];
        /// Procesamiento de datos para UMat
        lista = [];
        Codebook.forEach((element) {
          List<double> elementt = [];
          element.forEach((e) {
            elementt.add(double.parse(e.toString()));
          });
          lista.add(elementt);
        });

        Map<String, Object> respuesta = {};

        /// Procesamiento de datos para BMUs
        Map<String, Map<String, String>> mapaRta = {};

        // Iterar sobre las claves externas del primer nivel
        for (String outerKey in NeuronsJSON.keys) {
          // Obtener el valor correspondiente a la clave externa
          Map<String, dynamic> innerMap = NeuronsJSON[outerKey];

          // Convertir el mapa interno a Map<String, String>
          Map<String, String> innerMapString = {};
          innerMap.forEach((key, value) {
            if (TIPO_LLAMADA == "json") {
              int keyInt = int.parse(key) + 1;
              String keyy = keyInt.toString();
              innerMapString[keyy] = value.toString();
            } else {
              innerMapString[key] = value.toString();
            }
          });

          // Agregar el par clave-valor al mapa final
          mapaRta[outerKey] = innerMapString;
        }

        respuesta["respuestaBMU"] = mapaRta;
        respuesta["respuestaUmat"] = dataMapUmat;
        respuesta["parametros"] = parametros;
        respuesta["respuestaHits"] = hitsMap;
        respuesta["codebook"] = lista;

        List<String> nombresColumnas = [];
        List<String> keys = mapaRta.keys.toList();
        for (var i = 7; i < keys.length; i++) {
          nombresColumnas.add(keys[i]);
        }
        respuesta["nombrescolumnas"] = nombresColumnas;

        datosProvider.updateDatos(
            dataUdist: mapaRta["Udist"],
            mapaRtaUmat: dataMapUmat,
            codebook: lista,
            filas: int.parse(parametros["filas"]),
            columnas: int.parse(parametros["columnas"]),
            nombresColumnas: nombresColumnas,
            hitsMap: hitsMap);

        //respuesta["codebook"] =
        setState(() {
          //boton = 'La respuesta fue: ${response.body}';
          Navigator.pushNamed(
            context,
            '/grillas',
            arguments: respuesta,
          );
          cargando = false;
        });
      } catch (e) {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content:
                  Text('Error en la  llamada de servicio: ' + e.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
        setState(() {
          cargando = false;
          botonAceptar = "Entrenar";
        });
      }
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error al cargar'),
            content: const Text('Debe seleccionar un archivo.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
  }

  void _llamadaAPIRapida() async {
    String jsonResult = jsonEncode("datos");

    final parametrosProvider = context.read<ParametrosProvider>();

    final datosProvider = context.read<DatosProvider>();

    try {
      String TIPO_LLAMADA = "rapida";
      var url = Uri.parse('http://localhost:7777' + '/' + TIPO_LLAMADA);

      final parametros = <String, dynamic>{
        'filas': parametrosProvider.filas != "" ? parametrosProvider.filas : 24,
        'columnas': parametrosProvider.columnas != ""
            ? parametrosProvider.columnas
            : 31, //TODO IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
        'vecindad': parametrosProvider.funcionVecindad,
        'inicializacion': parametrosProvider.inicializacion,
        'iteraciones': parametrosProvider.itera != ""
            ? parametrosProvider.itera
            : 200, //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
        'normalizacion': parametrosProvider.normalizacion,
        'factorEntrenamiento': parametrosProvider.factorEntrenamiento != ""
            ? parametrosProvider.factorEntrenamiento
            : 2 //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
      };

      setState(() {
        //boton = "Cargando...";
        cargando = true;
      });
      // var response = await http.post(url,
      //     headers: {'Accept': '/*'}, body: jsonResult);
      var response = await http.post(url,
          headers: {'Accept': '/*'},
          body: jsonEncode({
            "datos": jsonResult,
            "tipo": TIPO_LLAMADA,
            "params": parametros
          }));

      // print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Map<String, dynamic> jsonList = json.decode(response.body);
      // Map<String,Map<String, String>> mapaRta = Map<String,Map<String, String>>.from(jsonList);

      // Decodificar la cadena JSON
      Map<String, dynamic> decodedJson = json.decode(response.body);

      Map<String, dynamic> NeuronsJSON = decodedJson["Neurons"];
      List<dynamic> Codebook = decodedJson["Codebook"];
      List<dynamic> UmatJSON = decodedJson["UMat"];

      /// Procesamiento de datos para Hits
      Map<String, dynamic> HitsJSON = decodedJson["Hits"];
      Map<int, int> hitsMap = Map<int, int>.from(
          HitsJSON.map((key, value) => MapEntry(int.parse(key), value)));

      /// Procesamiento de datos para UMat
      List<List<double>> lista = [];
      UmatJSON.forEach((element) {
        List<double> elementt = [];
        element.forEach((e) {
          elementt.add(double.parse(e.toString()));
        });
        lista.add(elementt);
      });

      Map<String, String> dataMapUmat = {};
      lista.forEach((element) {
        dataMapUmat[element[0].toString()] = element[1].toString();
      });
      //Map<String, dynamic> umatJson = decodedJson["umat"];
      /// Procesamiento de datos para UMat
      lista = [];
      Codebook.forEach((element) {
        List<double> elementt = [];
        element.forEach((e) {
          elementt.add(double.parse(e.toString()));
        });
        lista.add(elementt);
      });

      Map<String, Object> respuesta = {};

      /// Procesamiento de datos para BMUs
      Map<String, Map<String, String>> mapaRta = {};

      // Iterar sobre las claves externas del primer nivel
      for (String outerKey in NeuronsJSON.keys) {
        // Obtener el valor correspondiente a la clave externa
        Map<String, dynamic> innerMap = NeuronsJSON[outerKey];

        // Convertir el mapa interno a Map<String, String>
        Map<String, String> innerMapString = {};
        innerMap.forEach((key, value) {
          if (TIPO_LLAMADA == "json") {
            int keyInt = int.parse(key) + 1;
            String keyy = keyInt.toString();
            innerMapString[keyy] = value.toString();
          } else {
            innerMapString[key] = value.toString();
          }
        });

        // Agregar el par clave-valor al mapa final
        mapaRta[outerKey] = innerMapString;
      }

      respuesta["respuestaBMU"] = mapaRta;
      respuesta["respuestaUmat"] = dataMapUmat;
      respuesta["parametros"] = parametros;
      respuesta["respuestaHits"] = hitsMap;
      respuesta["codebook"] = lista;

      List<String> nombresColumnas = [];
      List<String> keys = mapaRta.keys.toList();
      for (var i = 7; i < keys.length; i++) {
        nombresColumnas.add(keys[i]);
      }
      respuesta["nombrescolumnas"] = nombresColumnas;

      datosProvider.updateDatos(
          dataUdist: mapaRta["Udist"],
          mapaRtaUmat: dataMapUmat,
          codebook: lista,
          filas: int.parse(parametros["filas"]),
          columnas: int.parse(parametros["columnas"]),
          nombresColumnas: nombresColumnas,
          hitsMap: hitsMap);
      //respuesta["codebook"] =
      setState(() {
        //boton = 'La respuesta fue: ${response.body}';
        Navigator.pushNamed(
          context,
          '/grillas',
          arguments: respuesta,
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
