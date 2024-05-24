import 'package:TF_SOM_UNMdP/config/gradientes.dart';
import 'package:flutter/material.dart';

class GradienteProvider extends ChangeNotifier {

  int indexGradienteElegido = 0;

  Gradient gradienteElegido(){
    return listaGradientes[indexGradienteElegido];
  }

}