class Report {
  final int? id;  // Puede ser null para nuevos reportes
  final String titulo_reporte;
  final String tipo_reporte;
  final String descripcion;
  final String colonia;
  final String codigo_postal;
  final String nombres;
  final String apellidos;
  final String telefono;
  final String correo;

  Report({
    this.id,
    required this.titulo_reporte,
    required this.tipo_reporte,
    required this.descripcion,
    required this.colonia,
    required this.codigo_postal,
    required this.nombres,
    required this.apellidos,
    required this.telefono,
    required this.correo,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      titulo_reporte: json['titulo_reporte'],
      tipo_reporte: json['tipo_reporte'],
      descripcion: json['descripcion'],
      colonia: json['colonia'],
      codigo_postal: json['codigo_postal'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      telefono: json['telefono'],
      correo: json['correo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo_reporte': titulo_reporte,
      'tipo_reporte': tipo_reporte,
      'descripcion': descripcion,
      'colonia': colonia,
      'codigo_postal': codigo_postal,
      'nombres': nombres,
      'apellidos': apellidos,
      'telefono': telefono,
      'correo': correo,
    };
  }
}