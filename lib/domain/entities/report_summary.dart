class ReportSummary {
  final String id;
  final String pdfUrl;
  final String tituloReporte;

  ReportSummary({required this.id, required this.pdfUrl, required this.tituloReporte});

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      id: json['id'],
      pdfUrl: json['pdf_url'],
      tituloReporte: json['titulo_reporte'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'pdf_url': pdfUrl,
    'titulo_reporte': tituloReporte,
  };
}
