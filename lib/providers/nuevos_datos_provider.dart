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

  int cantDatosOriginal(BuildContext context) {
    final datosProvider = context.read<DatosProvider>();
    return datosProvider.resultadoEntrenamiento.codebook[0].length;
  }

  bool validarColumnas(BuildContext context, String columnas) {
    List<String> columnasNuevosDatos = columnas.split(";");
    List<String> columnasEntrenamiento = context
        .read<DatosProvider>()
        .resultadoEntrenamiento
        .datos[0]
        .keys
        .toList();
    for (int i = 0; i < columnasNuevosDatos.length; i++) {
      if (columnasNuevosDatos[i] != columnasEntrenamiento[i]) {
        return false;
      }
    }
    return true;
  }

  // Map<String, String> {dato:bmu}
  Future<Map<String, String>> llamadaNuevosDatos(BuildContext context,
      String datosNuevos, String jsonResultEtiquetas) async {
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
          "datos": datosProvider.resultadoEntrenamiento.datos,
          "nuevosDatos": datosNuevos,
          "tipo": tipoLlamada,
          "params": parametros,
          "etiquetas": jsonResultEtiquetas
        }));

    //List<dynamic> decodedJson = json.decode(response.body);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    Map<String, dynamic> bmu = jsonResponse['Resultado']['BMU'];

    // {dato:bmu}
    Map<String, String> result = {};

    /// ESTO HACE QUE LOS DATOS QUE SON IGUALES SOLO SE CARGUEN UNA VEZ
    // for (var key in datos.keys) {
    //   result[datos[key].toString()] = bmu[key].toString();
    // }

    bmu.forEach((indice, bmu) {
      int numDato = int.parse(indice) + 1;
      result['Dato $numDato'] = bmu.toString();
    });

    // print(result);
    // print('result.length ${result.length}');

    return result;
  }
}
