import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data'; // Para Uint8List
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> csvData = [];
  String boton = 'Aceptar';

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
      print('Invalid file type. Please select a CSV file.');
    }
  }

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    _loadCSVData(result!);
  }

  List<String>? columnNames;

  @override
  Widget build(BuildContext context) {
    if (csvData.isNotEmpty) {
      columnNames = csvData[0][0].toString().split(';');
    }

    final ScrollController horizontal = ScrollController(),
        vertical = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carga de datos'),
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
                  ? Expanded(
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
                                  (index) => DataColumn(
                                      label: Text(columnNames![index])),
                                ),
                                rows: List.generate(
                                  csvData.length - 1,
                                  (rowIndex) => DataRow(
                                    cells: List.generate(
                                      columnNames!.length,
                                      (cellIndex) {
                                        String filaCompleta =
                                            csvData[rowIndex + 1].toString();
                                        String filaSinCorchetes = filaCompleta
                                            .replaceAll(RegExp(r'\[|\]'), '');
                                        List<String> lista =
                                            filaSinCorchetes.split(';');
                                        if (lista.length <= cellIndex) {
                                          print(
                                              'Error: No hay suficientes elementos en la fila $rowIndex');
                                          return DataCell(Text('Error'));
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
                    )
                  : const SizedBox(
                      height: 400.0,
                    ),
              //const SizedBox(height: 20.0,),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      //Navigator.pushNamed(context, '/grillas');

                      ByteData byteData = csvToByteData(csvData);

                      String content =
                          String.fromCharCodes(byteData.buffer.asUint8List());

                      // Parsear el contenido CSV con el delimitador ';'
                      List<List<dynamic>> rows = const CsvToListConverter(
                              eol: '\n', fieldDelimiter: ';')
                          .convert(content);

                      //print(rows);

                      List<Map<String, String>> result = convertRowsToMap(rows);

                      //print(result);

                      String jsonResult = jsonEncode(result);

                      print(jsonResult);

                      try {
                        var url = Uri.parse('http://localhost:7777');
                        var response = await http.post(url, body: jsonResult);

                        print('Response status: ${response.statusCode}');
                        print('Response body: ${response.body}');
                        setState(() {
                          boton = 'La respuesta fue: ${response.body}';
                        });
                      } catch (e) {
                        print('Error: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      boton,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
}
