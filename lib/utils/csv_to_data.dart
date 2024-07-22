import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';

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

List<Map<String, String>> csvToData(List<List<dynamic>> csvData) {
  ByteData byteData = csvToByteData(csvData);
  //String content = String.fromCharCodes(byteData.buffer.asUint8List());
  String content = utf8.decode(byteData.buffer.asUint8List());
  // Parsear el contenido CSV con el delimitador ';'
  List<List<dynamic>> rows =
      const CsvToListConverter(eol: '\n', fieldDelimiter: ';').convert(content);
  List<Map<String, String>> result = convertRowsToMap(rows);
  return result;
}

/// A partir de la lista de bool con las columnas seleccionadas, filtra csv data para que contenga las columnas seleccionadas
List<List<dynamic>> filtrarCsvData(List<bool> listaBoolColumnasSeleccionadas,
    List<String> columnNamesOriginal, List<List<dynamic>> csvDataOriginal) {
  List<List<dynamic>> filteredData = [];
  List<dynamic> headerRow = [];

  for (int i = 0; i < columnNamesOriginal.length; i++) {
    if (listaBoolColumnasSeleccionadas[i]) {
      headerRow.add(columnNamesOriginal[i]);
    }
  }

  for (List<dynamic> fila in csvDataOriginal) {
    List<String> columnas = fila[0].split(';');
    List<String> filaFiltrada = [];

    for (int i = 0; i < columnas.length; i++) {
      if (listaBoolColumnasSeleccionadas[i]) {
        filaFiltrada.add(columnas[i]);
      }
    }

    List<dynamic> lista = [filaFiltrada.join(';')];
    filteredData.add(lista);
  }

  return filteredData;
}
