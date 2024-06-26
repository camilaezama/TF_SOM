import 'dart:convert';

import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:TF_SOM_UNMdP/providers/nuevos_datos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ImagenNuevaProvider extends ChangeNotifier {
  /// mapaBmuCluster es un mapa BMU: cluster
  /// {1: 3, 2: 3, 3: 3, 4: 3, 5: 3, ...., 333: 2, 334: 2, 335: 2, 336: 2}
  Map<int, int> mapaBmuCluster = {};

  bool cargando = false;
  bool mostarGrilla = false;

  /// Devuelve mapa DATO: CLUSTER
  /// {0: 4, 1: 4, 2: 4, 3: 4, ... , 39274: 4, 39275: 4, 39276: 4}
  Future<Map<int, int>> llamadaImagen(
      BuildContext context,
      String cantidadClusters,
      String datosNuevos,
      String jsonResultEtiquetas) async {
    cargando = true;
    notifyListeners();

    final nuevosDatosProvider = context.read<NuevosDatosProvider>();

    // Map<String, String> {'dato':bmu} 'DATO' es todo el dato
    Map<String, String> mapaDatoCompletoBmu = await nuevosDatosProvider
        .llamadaNuevosDatos(context, datosNuevos, jsonResultEtiquetas);

    Map<int, int> mapaDatoBmu = {};
    int idDato = 1;
    mapaDatoCompletoBmu.forEach((dato, bmu) {
      int bmuInt = int.parse(bmu);
      mapaDatoBmu[idDato] = bmuInt;
      idDato++;
    });

    /// mapaBmuCluster es un mapa BMU: cluster
    /// {1: 3, 2: 3, 3: 3, 4: 3, 5: 3, ...., 333: 2, 334: 2, 335: 2, 336: 2}
    mapaBmuCluster = await llamadaClustering(context, cantidadClusters);

    /// Creamos el mapaDatoCluster que machea dato -> bmu en que cayo -> cluster asociado al bmu
    /// Es un mapa DATO: CLUSTER
    /// {0: 4, 1: 4, 2: 4, 3: 4, ... , 39274: 4, 39275: 4, 39276: 4}
    Map<int, int> mapaDatoCluster = {};

    mapaDatoBmu.forEach((dato, bmu) {
      int? cluster = mapaBmuCluster[bmu];
      if (cluster != null) {
        mapaDatoCluster[dato] = cluster;
      }
    });

    //print(mapaDatoCluster);

    cargando = false;
    mostarGrilla = true;
    notifyListeners();

    return mapaDatoCluster;
  }

  /// Devuelve un mapa BMU: cluster
  /// {1: 3, 2: 3, 3: 3, 4: 3, 5: 3, ...., 333: 2, 334: 2, 335: 2, 336: 2}
  Future<Map<int, int>> llamadaClustering(
      BuildContext context, String cantidadClusters) async {
    final datosProvider = context.read<DatosProvider>();

    String tipoLlamada = "clusters";
    var url = Uri.parse('http://localhost:7777/$tipoLlamada');

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
          "datos": datosProvider.resultadoEntrenamiento.datos,
          "codebook": datosProvider.resultadoEntrenamiento.codebook,
          "tipo": tipoLlamada,
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

    int position = 1;
    mapaBmuCluster = {};
    for (var cluster in rtaClusters) {
      for (var value in cluster) {
        mapaBmuCluster[position] = value;
        position++;
      }
    }

    return mapaBmuCluster;
  }
}