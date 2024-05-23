import 'package:flutter/material.dart';

void mostrarDialogTexto(BuildContext context, String title, String content, {String? textoBoton}){
  showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                },
                child: Text(textoBoton ?? 'Cerrar'),
              ),
            ],
          );
        },
      );
}