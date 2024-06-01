import 'dart:convert';

import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class NuevosDatosProvider extends ChangeNotifier {
  List<List<int>> mapaRtaClusters = [];
  
  bool cargando = false;

  void updateDatos({
    List<List<int>>? mapaRtaClusters,
  }) {
    //
  }

  Future<String> llamadaNuevosDatos(
      BuildContext context, 
      String datosNuevos,
      String jsonResultEtiquetas
    ) async {
    
    cargando = true;
    notifyListeners();

    final datosProvider = context.read<DatosProvider>();

    String tipoLlamada = "nuevosDatos";
      var url = Uri.parse('http://localhost:7777/$tipoLlamada');

    final parametros = <String, dynamic>{
      'filas': datosProvider.resultadoEntrenamiento.filas.toString() != ""
          ? datosProvider.resultadoEntrenamiento.filas
          : 24,
      'columnas': datosProvider.resultadoEntrenamiento.columnas.toString() != ""
          ? datosProvider.resultadoEntrenamiento.columnas
          : 31,
    };

    var response = await http.post(url,
        headers: {'Accept': '/*'},
        body: jsonEncode({
          "codebook": datosProvider.resultadoEntrenamiento.codebook,
          "datos": datosNuevos,
          "tipo": tipoLlamada,
          "params": parametros,
          "etiquetas": jsonResultEtiquetas
        }));
    
    //List<dynamic> decodedJson = json.decode(response.body);

    print(response.body);
    
    return response.body;
  }
}
