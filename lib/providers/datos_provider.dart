import 'dart:convert';
import 'dart:io';

import 'package:TF_SOM_UNMdP/models/resultado_entrenamiento_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class DatosProvider extends ChangeNotifier {
  ResultadoEntrenamientoModel resultadoEntrenamiento =
      ResultadoEntrenamientoModel();
  String responseBody = '';

  Future<ResultadoEntrenamientoModel> entrenamiento(
      String tipoLlamada,
      Map<String, dynamic> parametros,
      String jsonResult,
      String jsonResultEtiquetas) async {
    Map<String, dynamic> decodedJson = await llamadaApiEntrenamiento(
        tipoLlamada, parametros, jsonResult, jsonResultEtiquetas);

    ResultadoEntrenamientoModel resultado =
        procesarDatos(decodedJson, tipoLlamada, parametros);

    return resultado;
  }

  Future<Map<String, dynamic>> llamadaApiEntrenamiento(
      String tipoLlamada,
      Map<String, dynamic> parametros,
      String jsonResult,
      String jsonResultEtiquetas) async {
    var url = Uri.parse('http://localhost:7777/$tipoLlamada');

    var response = await http.post(url,
        headers: {'Accept': '/*'},
        body: jsonEncode({
          "datos": jsonResult,
          "tipo": tipoLlamada,
          "params": parametros,
          "etiquetas": jsonResultEtiquetas
        }));
    if (response.statusCode != 200) {
      var error = json.decode(response.body);
      throw Exception(error["error"]);
    }
    //Descargar response.body para copiar en resultadoPrueba.json
    // final bytes = utf8.encode(response.body);
    // DateTime now = DateTime.now();
    // final blob = html.Blob([bytes]);
    // final urlAux = html.Url.createObjectUrlFromBlob(blob);
    // final anchor = html.AnchorElement(href: urlAux)
    //   ..setAttribute("download", "train-$now.json")
    //   ..click();
    // html.Url.revokeObjectUrl(urlAux);
    responseBody = response.body;

    Map<String, dynamic> decodedJson = json.decode(response.body);
    return decodedJson;
  }

  ResultadoEntrenamientoModel procesarDatos(Map<String, dynamic> decodedJson,
      String tipoLlamada, Map<String, dynamic> parametros) {
    Map<String, dynamic> NeuronsJSON = decodedJson["Neurons"];
    List<dynamic> Codebook = decodedJson["Codebook"];
    List<dynamic> UmatJSON = decodedJson["UMat"];
    List<dynamic> Datos = decodedJson["Datos"];
    Map<String, dynamic> HitsJSON = decodedJson["Hits"];
    //Map<String, dynamic> HitsLabelsJSON = decodedJson["HitsLabels"];
    Map<String, dynamic> etiquetasJSON = decodedJson["Etiquetas"];
    var tempHitsMap = procesarHits(HitsJSON);
    //var tempHitsLabelsMap = null;// procesarHitsLabels(HitsLabelsJSON);
    var tempMapaRta = procesarBmus(NeuronsJSON, tipoLlamada);
    var tempDataUdist = tempMapaRta["Udist"]!;
    var tempMapaRtaUmat = procesarUmat(UmatJSON)!;
    var tempCodebook = procesarCodebook(Codebook);
    var tempNombresColumnas = procesarNombresColumnas(tempMapaRta);
    var etiquetas = procesarEtiquetas(etiquetasJSON);
    var parametrosEntrenamiento = procesarParametos(decodedJson["Parametros"]);
    var erroresEntrenamiento = procesarErrores(decodedJson["Errores"]);
    ResultadoEntrenamientoModel resultado = ResultadoEntrenamientoModel(
        codebook: tempCodebook,
        mapaRta: tempMapaRta,
        mapaRtaUmat: tempMapaRtaUmat,
        dataUdist: tempDataUdist,
        hitsMap: tempHitsMap,
        nombresColumnas: tempNombresColumnas,
        filas: int.parse(parametros["filas"]),
        columnas: int.parse(parametros["columnas"]),
        etiquetas: etiquetas,
        datos: Datos,
        parametros: parametrosEntrenamiento,
        errores: erroresEntrenamiento);

    resultadoEntrenamiento = resultado;
    //Descargar archivo de texto con resultado
    // DateTime now = DateTime.now();
    // downloadSummaryTxtFile(parametrosEntrenamiento, erroresEntrenamiento,
    //     "ResumenEntrenamiento-$now.txt");
    return resultado;
  }

  void descargarResultadoEntrenamiento(){
    final bytes = utf8.encode(responseBody);
    DateTime now = DateTime.now();
    final blob = html.Blob([bytes]);
    final urlAux = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: urlAux)
      ..setAttribute("download", "train-$now.json")
      ..click();
    html.Url.revokeObjectUrl(urlAux);
  }

    void descargarCodebook(){
    final bytes = utf8.encode(resultadoEntrenamiento.codebook.toString());
    DateTime now = DateTime.now();
    final blob = html.Blob([bytes]);
    final urlAux = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: urlAux)
      ..setAttribute("download", "codebook-$now.json")
      ..click();
    html.Url.revokeObjectUrl(urlAux);
  }

  void downloadSummaryTxtFile(Map<String, String> parametros,
      Map<String, String> errores, String fileName) {
    // Convert the map to a string with each key-value pair on a new line
    StringBuffer buffer = StringBuffer();
    buffer.writeln('Parameters:');
    var filas = parametros['filas'];
    var columnas = parametros['columnas'];
    parametros.remove('filas');
    parametros.remove('columnas');
    buffer.writeln('Map size: $columnas columns $filas rows');
    parametros.forEach((key, value) {
      buffer.writeln('\t$key: $value');
    });
    buffer.writeln('--------------------');
    buffer.writeln('Errors:');
    errores.forEach((key, value) {
      buffer.writeln('\t$key: $value');
    });
    // Convert the string buffer to a Blob
    final blob = html.Blob([buffer.toString()], 'text/plain');

    // Create a URL for the Blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and set the href attribute to the Blob URL
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();

    // Clean up by revoking the Blob URL
    html.Url.revokeObjectUrl(url);
  }

  int cantDatosEntrenamiento() {
    return resultadoEntrenamiento.datos.length;
  }

  List<Map<String, dynamic>> procesarEtiquetas(
      Map<String, dynamic> etiquetasJSON) {
    //print('Etiquetas');
    //print(etiquetasJSON);
    //print('fin');
    List<Map<String, dynamic>> listaDeMapas = [];

    int numRows = etiquetasJSON["Dato"].length; // Obtener el número de filas

    for (int i = 0; i < numRows; i++) {
      Map<String, dynamic> nuevoMapa = {
        "Dato": etiquetasJSON["Dato"][i.toString()],
        "BMU": etiquetasJSON["BMU"][i.toString()]
      };
      etiquetasJSON.forEach((key, value) {
        if (key != "Dato" && key != "BMU") {
          nuevoMapa[key] = value[i.toString()];
        }
      });
      listaDeMapas.add(nuevoMapa);
    }

    return listaDeMapas;
  }

  Map<String, String> procesarErrores(
      Map<String, dynamic> erroresEntrenamiento) {
    Map<String, String> errores = Map<String, String>.from(erroresEntrenamiento
        .map((key, value) => MapEntry(key, value.toString())));
    return errores;
  }

  Map<String, String> procesarParametos(
      Map<String, dynamic> parametrosEntrenamiento) {
    Map<String, String> parametros = Map<String, String>.from(
        parametrosEntrenamiento
            .map((key, value) => MapEntry(key, value.toString())));
    return parametros;
  }

  Map<int, int> procesarHits(Map<String, dynamic> HitsJSON) {
    Map<int, int> hitsMap = Map<int, int>.from(
        HitsJSON.map((key, value) => MapEntry(int.parse(key), value)));
    return hitsMap;
  }

  /* Map<int, List> procesarHitsLabels(Map<String, dynamic> HitsLabelsJSON) {
    Map<int, List> hitsLabelsMap = Map<int, List>.from(
        HitsLabelsJSON.map((key, value) => MapEntry(int.parse(key), value)));
    print(hitsLabelsMap);
    return hitsLabelsMap;
  } */

  Map<String, String>? procesarUmat(List<dynamic> UmatJSON) {
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
    return dataMapUmat;
  }

  List<List<double>> procesarCodebook(List<dynamic> Codebook) {
    List<List<double>> lista = [];
    Codebook.forEach((element) {
      List<double> elementt = [];
      element.forEach((e) {
        elementt.add(double.parse(e.toString()));
      });
      lista.add(elementt);
    });
    return lista;
  }

  Map<String, Map<String, String>> procesarBmus(
      Map<String, dynamic> NeuronsJSON, String tipoLlamada) {
    /// Procesamiento de datos para BMUs
    Map<String, Map<String, String>> mapaRta = {};

    // Iterar sobre las claves externas del primer nivel
    for (String outerKey in NeuronsJSON.keys) {
      // Obtener el valor correspondiente a la clave externa
      Map<String, dynamic> innerMap = NeuronsJSON[outerKey];

      // Convertir el mapa interno a Map<String, String>
      Map<String, String> innerMapString = {};
      innerMap.forEach((key, value) {
        if (tipoLlamada == "json") {
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
    return mapaRta;
  }

  List<String> procesarNombresColumnas(
      Map<String, Map<String, String>> mapaRta) {
    List<String> nombresColumnas = [];
    List<String> keys = mapaRta.keys.toList(); //usa mapaRta !!!!!!!!!!!
    for (var i = 7; i < keys.length; i++) {
      nombresColumnas.add(keys[i]);
    }
    return nombresColumnas;
  }
}

// Map<String, Map<String, String>> mapaRta = {};
// Map<String, String> dataUdist = {};
// Map<String, String> mapaRtaUmat = {};
// List<List<double>> codebook = [];
// int filas = 0;
// int columnas = 0;
// List<String> nombresColumnas = [];
// Map<int, int> hitsMap = {};

// void updateDatos(
//     {Map<String, Map<String, String>>? mapaRta,
//     Map<String, String>? dataUdist,
//     Map<String, String>? mapaRtaUmat,
//     List<List<double>>? codebook,
//     int? filas,
//     int? columnas,
//     List<String>? nombresColumnas,
//     Map<int, int>? hitsMap}) {
//   if (mapaRta != null) this.mapaRta = mapaRta;
//   if (dataUdist != null) this.dataUdist = dataUdist;
//   if (mapaRtaUmat != null) this.mapaRtaUmat = mapaRtaUmat;
//   if (codebook != null) this.codebook = codebook;
//   if (filas != null) this.filas = filas;
//   if (columnas != null) this.columnas = columnas;
//   if (nombresColumnas != null) this.nombresColumnas = nombresColumnas;
//   if (hitsMap != null) this.hitsMap = hitsMap;
//   //notifyListeners(); // Notifica a los oyentes sobre los cambios
// }
