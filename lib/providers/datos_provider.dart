import 'dart:convert';

import 'package:TF_SOM_UNMdP/models/resultado_entrenamiento_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DatosProvider extends ChangeNotifier {

  ResultadoEntrenamientoModel resultadoEntrenamiento = ResultadoEntrenamientoModel();

  Future<ResultadoEntrenamientoModel> entrenamiento(String tipoLlamada,
      Map<String, dynamic> parametros, String jsonResult) async {
    
    Map<String, dynamic> decodedJson = await llamadaApiEntrenamiento(tipoLlamada,parametros,jsonResult);

    ResultadoEntrenamientoModel resultado = procesarDatos(decodedJson,tipoLlamada, parametros);

    return resultado;
  }

  Future<Map<String, dynamic>> llamadaApiEntrenamiento(String tipoLlamada,
      Map<String, dynamic> parametros, String jsonResult) async {
    var url = Uri.parse('http://localhost:7777/$tipoLlamada');

    var response = await http.post(url,
        headers: {'Accept': '/*'},
        body: jsonEncode(
            {"datos": jsonResult, 
            "tipo": tipoLlamada, 
            "params": parametros}));

    Map<String, dynamic> decodedJson = json.decode(response.body);

    return decodedJson;
  }

  ResultadoEntrenamientoModel procesarDatos(Map<String, dynamic> decodedJson, String tipoLlamada, Map<String, dynamic> parametros) {
    Map<String, dynamic> NeuronsJSON = decodedJson["Neurons"];
    List<dynamic> Codebook = decodedJson["Codebook"];
    List<dynamic> UmatJSON = decodedJson["UMat"];

    Map<String, dynamic> HitsJSON = decodedJson["Hits"];
    Map<String, dynamic> HitsLabelsJSON = decodedJson["HitsLabels"];
    
    var tempHitsMap = procesarHits(HitsJSON);
    var tempHitsLabelsMap = null; //pendiente sacar null y procesar!
    var tempMapaRta = procesarBmus(NeuronsJSON, tipoLlamada);
    var tempDataUdist = tempMapaRta["Udist"]!;
    var tempMapaRtaUmat = procesarUmat(UmatJSON)!;
    var tempCodebook = procesarCodebook(Codebook);
    var tempNombresColumnas = procesarNombresColumnas(tempMapaRta);  

    ResultadoEntrenamientoModel resultado = ResultadoEntrenamientoModel(
      codebook: tempCodebook,
      mapaRta: tempMapaRta,
      mapaRtaUmat: tempMapaRtaUmat,
      dataUdist: tempDataUdist,
      hitsMap: tempHitsMap,
      nombresColumnas: tempNombresColumnas,
      filas: int.parse(parametros["filas"]),
      columnas: int.parse(parametros["columnas"]),
    );  

    resultadoEntrenamiento = resultado;

    return resultado;
  }

  Map<int, int> procesarHits(Map<String, dynamic> HitsJSON) {
    Map<int, int> hitsMap = Map<int, int>.from(
        HitsJSON.map((key, value) => MapEntry(int.parse(key), value)));
    return hitsMap;
  }

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

  Map<String, Map<String, String>> procesarBmus(Map<String, dynamic> NeuronsJSON, String tipoLlamada) {
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