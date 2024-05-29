class ResultadoEntrenamientoModel {
  Map<String, Map<String, String>> mapaRta = {};
  Map<String, String> dataUdist = {};
  Map<String, String> mapaRtaUmat = {};
  List<List<double>> codebook = [];
  int filas = 0;
  int columnas = 0;
  List<String> nombresColumnas = [];
  Map<int, int> hitsMap = {};
  Map<int,List> hitsLabels = {};

  ResultadoEntrenamientoModel(
      {Map<String, Map<String, String>>? mapaRta,
      Map<String, String>? dataUdist,
      Map<String, String>? mapaRtaUmat,
      List<List<double>>? codebook,
      int? filas,
      int? columnas,
      List<String>? nombresColumnas,
      Map<int, int>? hitsMap,
      Map<int,List>? hitsLabels}) {
    if (mapaRta != null) this.mapaRta = mapaRta;
    if (dataUdist != null) this.dataUdist = dataUdist;
    if (mapaRtaUmat != null) this.mapaRtaUmat = mapaRtaUmat;
    if (codebook != null) this.codebook = codebook;
    if (filas != null) this.filas = filas;
    if (columnas != null) this.columnas = columnas;
    if (nombresColumnas != null) this.nombresColumnas = nombresColumnas;
    if (hitsMap != null) this.hitsMap = hitsMap;
    if (hitsLabels != null) this.hitsLabels = hitsLabels;
    //notifyListeners(); // Notifica a los oyentes sobre los cambios
  }

}