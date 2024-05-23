import 'package:flutter/material.dart';

class DatosProvider extends ChangeNotifier{

  Map<String, String> dataUdist = {};
  Map<String, String> mapaRtaUmat = {};
  List<dynamic> codebook = [];
  int filas = 0;
  int columnas = 0;
  List<String> nombresColumnas = [];
  Map<int, int> hitsMap = {};

  void updateDatos({
    Map<String, String>? dataUdist,
    Map<String, String>? mapaRtaUmat,
    List<dynamic>? codebook,
    int? filas,
    int? columnas,
    List<String>? nombresColumnas,
    Map<int, int>? hitsMap
  }) {
    if (dataUdist != null) this.dataUdist = dataUdist;
    if (mapaRtaUmat != null) this.mapaRtaUmat = mapaRtaUmat;
    if (codebook != null) this.codebook = codebook;
    if (filas != null) this.filas = filas;
    if (columnas != null) this.columnas = columnas;
    if (nombresColumnas != null) this.nombresColumnas = nombresColumnas;
    if (hitsMap != null) this.hitsMap = hitsMap;
    //notifyListeners(); // Notifica a los oyentes sobre los cambios
  }

}