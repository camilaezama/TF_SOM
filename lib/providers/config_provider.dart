import 'package:flutter/material.dart';

class ConfigProvider extends ChangeNotifier {
  final String defaultIP = 'som-flask.onrender.com';
  final String defaultPuerto = '7777';
  String IP = 'som-flask.onrender.com';
  String puerto = '7777';
  String hosteado = 'host';
  String? selectedOption = 'host';

  void updateSelectedOption({
    String? opcion
  }){
    this.selectedOption = opcion;
  }

  void updateConfig({
    required String IP,
    required String puerto,
    required String hosteado,
  }) {
    this.IP = IP;
    this.puerto = puerto;
    this.hosteado = hosteado;
  }

  String getIP() {
    return hosteado == 'host' ? defaultIP : IP;
  }

  String getPuerto() {
    return hosteado == 'host' ? defaultPuerto : puerto;
  }

  String getStatus() {
    return hosteado;
  }
}
