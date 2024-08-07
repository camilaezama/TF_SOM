import 'package:flutter/material.dart';

class ConfigProvider extends ChangeNotifier {
  final String defaultIP = '127.0.0.1';
  final String defaultPuerto = '7777';
  String IP = '127.0.0.1';
  String puerto = '7777';
  String hosteado = 'host';

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
