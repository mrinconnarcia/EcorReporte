import 'package:flutter/material.dart';
import 'package:ecoreporte/domain/entities/report.dart';

class ReportDetailPage extends StatelessWidget {
  final Report report;

  ReportDetailPage({required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Reporte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Título: ${report.title}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Tipo: ${report.type}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Descripción: ${report.description}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Lugar: ${report.place}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Código Postal: ${report.postalCode}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Nombres: ${report.names}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Apellidos: ${report.lastName}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Teléfono: ${report.phone}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Email: ${report.email}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
