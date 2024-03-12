import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:typed_data'; // Para Uint8List
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final filasController = TextEditingController(text: "14");
  static final columnasController = TextEditingController(text: "24");
  static final iteracontroller = TextEditingController(text: "100");
  static final factorEntrenamientoController = TextEditingController(text: "2");
  String funcionVecindad = 'gaussian';
  String inicializacion = 'random';
  String normalizacion = 'var';

  List<List<dynamic>> csvData = [];
  String botonAceptar = 'Aceptar';
  String botonParam = 'Modificar Parametros';

  bool cargando = false;

  void _loadCSVData(FilePickerResult result) async {
    Uint8List? fileBytes = result.files.first.bytes;
    String fileName = result.files.first.name;

    if (fileName.endsWith('.csv')) {
      String fileContent = utf8.decode(fileBytes!);
      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(fileContent);

      setState(() {
        csvData = csvTable;
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

  List<String>? columnNames;
  late double _width, _height;
  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;

    if (csvData.isNotEmpty) {
      columnNames = csvData[0][0].toString().split(';');
    }

    final ScrollController horizontal = ScrollController(),
        vertical = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carga de datos'),
      ),
      body: Padding(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: _selectFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Seleccionar Archivo CSV',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
              (csvData.isNotEmpty)
                  ? mostrarArchivo(vertical, horizontal)
                  : const SizedBox(
                      height: 400.0,
                    ),
              //const SizedBox(height: 20.0,),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: _llamadaAPIRapida,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 78, 147, 81),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: cargando
                              ? const CircularProgressIndicator()
                              : Text(
                                  "Devolver json archivo",
                                  style: const TextStyle(fontSize: 16),
                                )),
                      ElevatedButton(
                          onPressed: _llamadaAPI,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: cargando
                              ? const CircularProgressIndicator()
                              : Text(
                                  botonAceptar,
                                  style: const TextStyle(fontSize: 16),
                                )),
                      ElevatedButton(
                          onPressed: () {
                            //loadData();
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Parametros configurables'),
                                  content: _parametrosConfigurables(
                                      filasController,
                                      columnasController,
                                      iteracontroller,
                                      factorEntrenamientoController),
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
                          child: Text(botonParam))
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

//Esto se podria poner en mas funciones a medida que agreguemos mas parametros.
  Widget _parametrosConfigurables(
      TextEditingController filasController,
      TextEditingController columnasController,
      TextEditingController iteracontroller,
      TextEditingController factorEntrenamientoController) {
    return SizedBox(
      width: _width * 0.5,
      height: _height * 0.5,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: filasController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Cantidad de filas')),
                ),
                const SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: TextField(
                    controller: columnasController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Cantidad de columnas'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                      keyboardType: TextInputType.number,
                      controller: iteracontroller,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText:
                              'Cantidad máxima de iteraciones por época')),
                ),
                const SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: TextField(
                      keyboardType: TextInputType.number,
                      controller: factorEntrenamientoController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText:
                              'Factor de incremento iteraciones del entrenamiento')),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text("Función de vecindad"),
                    ),
                    value: 'gaussian', //valor default
                    items: const [
                      DropdownMenuItem(
                        value: 'gaussian',
                        child: Text(" Gaussiana"),
                      ),
                      DropdownMenuItem(
                        value: 'bubble',
                        child: Text(" Burbuja"),
                      ),
                    ],
                    onChanged: (value) {
                      funcionVecindad = value!;
                    },
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text("Inicialización"),
                    ),
                    value: 'random', //valor default
                    items: const [
                      DropdownMenuItem(
                        value: 'random',
                        child: Text(" Aleatoria"),
                      ),
                      DropdownMenuItem(
                        value: 'pca',
                        child: Text(" PCA"),
                      ),
                    ],
                    onChanged: (value) {
                      inicializacion = value!;
                    },
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      label: Text("Normalizacion"),
                    ),
                    value: 'var', //valor default
                    items: const [
                      DropdownMenuItem(
                        value: 'var',
                        child: Text(" Var"),
                      ),
                      DropdownMenuItem(
                        value: 'None',
                        child: Text(" Ninguna"),
                      ),
                    ],
                    onChanged: (value) {
                      inicializacion = value!;
                    },
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
              ],
            )
          ],
        ),
      ),
    );
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

  Widget mostrarArchivo(vertical, horizontal) {
    return Expanded(
      child: Scrollbar(
        controller: vertical,
        thumbVisibility: true,
        trackVisibility: true,
        child: Scrollbar(
          controller: horizontal,
          thumbVisibility: true,
          trackVisibility: true,
          notificationPredicate: (notif) => notif.depth == 1,
          child: SingleChildScrollView(
            controller: vertical,
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              controller: horizontal,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: List.generate(
                  columnNames!.length,
                  (index) => DataColumn(label: Text(columnNames![index])),
                ),
                rows: List.generate(
                  csvData.length - 1,
                  (rowIndex) => DataRow(
                    cells: List.generate(
                      columnNames!.length,
                      (cellIndex) {
                        String filaCompleta = csvData[rowIndex + 1].toString();
                        String filaSinCorchetes =
                            filaCompleta.replaceAll(RegExp(r'\[|\]'), '');
                        List<String> lista = filaSinCorchetes.split(';');
                        if (lista.length <= cellIndex) {
                          print(
                              'Error: No hay suficientes elementos en la fila $rowIndex');
                          return const DataCell(Text('Error'));
                        }
                        return DataCell(
                          Text('${lista[cellIndex]}'),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _llamadaAPI() async {
    //Navigator.pushNamed(context, '/grillas');
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
          'filas': filasController.text != "" ? filasController.text : 24,
          'columnas': columnasController.text != ""
              ? columnasController.text
              : 31, //TODO IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
          'vecindad': funcionVecindad,
          'inicializacion': inicializacion,
          'iteraciones': iteracontroller.text != ""
              ? iteracontroller.text
              : 200, //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
          'normalizacion': normalizacion,
          'factorEntrenamiento': factorEntrenamientoController.text != ""
              ? factorEntrenamientoController.text
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
          botonAceptar = "Aceptar";
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

    try {
        String TIPO_LLAMADA = "rapida";
        var url = Uri.parse('http://localhost:7777' + '/' + TIPO_LLAMADA);

        final parametros = <String, dynamic>{
          'filas': filasController.text != "" ? filasController.text : 24,
          'columnas': columnasController.text != ""
              ? columnasController.text
              : 31, //TODO IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
          'vecindad': funcionVecindad,
          'inicializacion': inicializacion,
          'iteraciones': iteracontroller.text != ""
              ? iteracontroller.text
              : 200, //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
          'normalizacion': normalizacion,
          'factorEntrenamiento': factorEntrenamientoController.text != ""
              ? factorEntrenamientoController.text
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
          botonAceptar = "Aceptar";
        });
      }

    // try {
    //   String TIPO_LLAMADA = "rapida";
    //   var url = Uri.parse('http://localhost:7777' + '/' + TIPO_LLAMADA);

    //   final parametros = <String, dynamic>{
    //     'filas': filasController.text != "" ? filasController.text : 24,
    //     'columnas': columnasController.text != ""
    //         ? columnasController.text
    //         : 31, //TODO IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
    //     'vecindad': funcionVecindad,
    //     'inicializacion': inicializacion,
    //     'iteraciones': iteracontroller.text != ""
    //         ? iteracontroller.text
    //         : 200, //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
    //     'normalizacion': normalizacion,
    //     'factorEntrenamiento': factorEntrenamientoController.text != ""
    //         ? factorEntrenamientoController.text
    //         : 2 //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
    //   };

    //   setState(() {
    //     //boton = "Cargando...";
    //     cargando = true;
    //   });
    //   // var response = await http.post(url,
    //   //     headers: {'Accept': '/*'}, body: jsonResult);
    //   var response = await http.post(url,
    //       headers: {'Accept': '/*'},
    //       body: jsonEncode({
    //         "datos": jsonResult,
    //         "tipo": TIPO_LLAMADA,
    //         "params": parametros
    //       }));

    //   // print('Response status: ${response.statusCode}');
    //   print('Response body: ${response.body}');

    //   // Map<String, dynamic> jsonList = json.decode(response.body);
    //   // Map<String,Map<String, String>> mapaRta = Map<String,Map<String, String>>.from(jsonList);

    //   // Decodificar la cadena JSON
    //   Map<String, dynamic> decodedJson = json.decode(response.body);

    //   Map<String, dynamic> NeuronsJSON = decodedJson["Neurons"];
    //   List<dynamic> UmatJSON = decodedJson["UMat"];

    //   /// Procesamiento de datos para Hits
    //   Map<String, dynamic> HitsJSON = decodedJson["Hits"];
    //   Map<int, int> hitsMap = Map<int, int>.from(
    //       HitsJSON.map((key, value) => MapEntry(int.parse(key), value)));

    //   /// Procesamiento de datos para UMat
    //   List<List<double>> lista = [];
    //   UmatJSON.forEach((element) {
    //     List<double> elementt = [];
    //     element.forEach((e) {
    //       elementt.add(double.parse(e.toString()));
    //     });
    //     lista.add(elementt);
    //   });

    //   Map<String, String> dataMapUmat = {};
    //   lista.forEach((element) {
    //     dataMapUmat[element[0].toString()] = element[1].toString();
    //   });
    //   //Map<String, dynamic> umatJson = decodedJson["umat"];

    //   Map<String, Object> respuesta = {};

    //   /// Procesamiento de datos para BMUs
    //   Map<String, Map<String, String>> mapaRta = {};

    //   // Iterar sobre las claves externas del primer nivel
    //   for (String outerKey in NeuronsJSON.keys) {
    //     // Obtener el valor correspondiente a la clave externa
    //     Map<String, dynamic> innerMap = NeuronsJSON[outerKey];

    //     // Convertir el mapa interno a Map<String, String>
    //     Map<String, String> innerMapString = {};
    //     innerMap.forEach((key, value) {
    //       if (TIPO_LLAMADA == "json") {
    //         int keyInt = int.parse(key) + 1;
    //         String keyy = keyInt.toString();
    //         innerMapString[keyy] = value.toString();
    //       } else {
    //         innerMapString[key] = value.toString();
    //       }
    //     });

    //     // Agregar el par clave-valor al mapa final
    //     mapaRta[outerKey] = innerMapString;
    //   }

    //   respuesta["respuestaBMU"] = mapaRta;
    //   respuesta["respuestaUmat"] = dataMapUmat;
    //   respuesta["parametros"] = parametros;
    //   respuesta["respuestaHits"] = hitsMap;
    //   setState(() {
    //     //boton = 'La respuesta fue: ${response.body}';
    //     Navigator.pushNamed(
    //       context,
    //       '/grillas',
    //       arguments: respuesta,
    //     );
    //     cargando = false;
    //   });
    // } catch (e) {
    //   print('Error: $e');
    //   setState(() {
    //     cargando = false;
    //     botonAceptar = "Aceptar";
    //   });
    // }
  }
}
