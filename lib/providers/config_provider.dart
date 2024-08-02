import 'package:flutter/material.dart';

class ConfigProvider extends ChangeNotifier {
  String IP = '0.0.0.0';
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
}
