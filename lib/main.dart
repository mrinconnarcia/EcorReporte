import 'package:flutter/material.dart';
import 'package:ecoreporte/presentation/routes/app_routes.dart';

void main() {
  runApp(EcoReporteApp());
}

class EcoReporteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoReporte',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/',
      routes: AppRoutes.routes,
    );
  }
}
