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
}
