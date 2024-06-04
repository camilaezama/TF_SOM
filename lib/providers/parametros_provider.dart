import 'package:flutter/material.dart';

class ParametrosProvider extends ChangeNotifier {
  String filas = "14";
  String columnas = "24";
  String rough = "";
  String finetuning = "";
  String funcionVecindad = 'gaussian';
  String inicializacion = 'random';
  String normalizacion = 'var';



  // Método para actualizar los parámetros
  void updateParametros({
    required String filas,
    required String columnas,
    required String rough,
    required String finetuning,
    required String funcionVecindad,
    required String inicializacion,
    required String normalizacion,
  }) {
    this.filas = filas;
    this.columnas = columnas;
    this.rough = rough;
    this.finetuning = finetuning;
    this.funcionVecindad = funcionVecindad;
    this.inicializacion = inicializacion;
    this.normalizacion = normalizacion;
    //notifyListeners(); // No es necesario notificar cambios todavia
  }

  Map<String, dynamic> mapaParametros(){
    final parametros = <String, dynamic>{
          'filas': filas != "" ? filas : 24,
          'columnas': columnas != ""
              ? columnas
              : 31, 
          'vecindad': funcionVecindad,
          'inicializacion': inicializacion,
          'rough': rough != ""
              ? rough
              : 0, //si viene vacio, va a tomar valor óptimo de IntraSOM
          'normalizacion': normalizacion,
          'finetuning': finetuning != ""
              ? finetuning
              : 0 //si viene vacio, va a tomar valor óptimo de IntraSOM
    };
    return parametros;
  }


}
