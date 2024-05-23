import 'package:flutter/material.dart';

class ParametrosProvider extends ChangeNotifier {
  String filas = "14";
  String columnas = "24";
  String itera = "100";
  String factorEntrenamiento = "2";
  String funcionVecindad = 'gaussian';
  String inicializacion = 'random';
  String normalizacion = 'var';



  // Método para actualizar los parámetros
  void updateParametros({
    required String filas,
    required String columnas,
    required String itera,
    required String factorEntrenamiento,
    required String funcionVecindad,
    required String inicializacion,
    required String normalizacion,
  }) {
    this.filas = filas;
    this.columnas = columnas;
    this.itera = itera;
    this.factorEntrenamiento = factorEntrenamiento;
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
              : 31, //TODO IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
          'vecindad': funcionVecindad,
          'inicializacion': inicializacion,
          'iteraciones': itera != ""
              ? itera
              : 200, //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
          'normalizacion': normalizacion,
          'factorEntrenamiento': factorEntrenamiento != ""
              ? factorEntrenamiento
              : 2 //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
    };
    return parametros;
  }


}
