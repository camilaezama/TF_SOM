import 'package:flutter/material.dart';

class TablaDatos extends StatelessWidget {

  final List<String>? columnNames;
  final List<List<dynamic>> csvData;

  TablaDatos({super.key, required this.columnNames, required this.csvData});

  final ScrollController horizontal = ScrollController();
  final ScrollController vertical = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        controller: vertical,
        thumbVisibility: true,
        trackVisibility: true,
        child: Scrollbar(
          controller: horizontal,
          thumbVisibility: true,
          trackVisibility: true,
          notificationPredicate: (notif) => notif.depth == 1,
          child: SingleChildScrollView(
            controller: vertical,
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              controller: horizontal,
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: List.generate(
                  columnNames!.length,
                  (index) => DataColumn(label: Text(columnNames![index])),
                ),
                rows: List.generate(
                  csvData.length - 1,
                  (rowIndex) => DataRow(
                    cells: List.generate(
                      columnNames!.length,
                      (cellIndex) {
                        String filaCompleta = csvData[rowIndex + 1].toString();
                        String filaSinCorchetes =
                            filaCompleta.replaceAll(RegExp(r'\[|\]'), '');
                        List<String> lista = filaSinCorchetes.split(';');
                        if (lista.length <= cellIndex) {
                          print(
                              'Error: No hay suficientes elementos en la fila $rowIndex');
                          return const DataCell(Text('Error'));
                        }
                        return DataCell(
                          Text('${lista[cellIndex]}'),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}