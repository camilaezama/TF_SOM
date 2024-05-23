import 'dart:convert';

import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ClustersProvider extends ChangeNotifier {
  List<List<int>> mapaRtaClusters = [];
  bool cargando = false;
  bool mostarGrilla = false;


  void updateDatos({
    List<List<int>>? mapaRtaClusters,
  }) {
    if (mapaRtaClusters != null) this.mapaRtaClusters = mapaRtaClusters;
    //notifyListeners(); // Notifica a los oyentes sobre los cambios
  }

  Future<void> llamadaClustering(
      BuildContext context, String cantidadClusters) async {
    
    cargando = true;
    notifyListeners();

    final datosProvider = context.read<DatosProvider>();

    String TIPO_LLAMADA = "clusters";
      var url = Uri.parse('http://localhost:7777' + '/' + TIPO_LLAMADA);

    final parametros = <String, dynamic>{
      'filas': datosProvider.resultadoEntrenamiento.filas.toString() != ""
          ? datosProvider.resultadoEntrenamiento.filas
          : 24,
      'columnas': datosProvider.resultadoEntrenamiento.columnas.toString() != ""
          ? datosProvider.resultadoEntrenamiento.columnas
          : 31,
      'cantidadClusters': cantidadClusters != "" ? cantidadClusters : 10
    };

    var response = await http.post(url,
        headers: {'Accept': '/*'},
        body: jsonEncode({
          "datos": datosProvider.resultadoEntrenamiento.codebook,
          "tipo": TIPO_LLAMADA,
          "params": parametros
        }));
    List<dynamic> decodedJson = json.decode(response.body);
    List<List<int>> rtaClusters = decodedJson.map((dynamic item) {
      if (item is List<dynamic>) {
        return item.map((dynamic subItem) => subItem as int).toList();
      } else {
        throw Exception('Invalid item in list');
      }
    }).toList();

    mapaRtaClusters = rtaClusters;
    
    cargando = false;
    mostarGrilla = true;
    notifyListeners();
  }
}
