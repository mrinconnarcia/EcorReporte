import 'package:flutter/material.dart';
import '../widgets/SharedBottomNavigationBar.dart';

class AddReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Color(0xFF9DE976),
            padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/eco_reporte_logo.png', height: 40),
                    SizedBox(width: 8),
                    Text(
                      'EcoReporte',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    // Aquí puedes agregar lógica adicional para cerrar sesión si es necesario
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  tooltip: 'Cerrar sesión',
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bienvenido a EcoReporte',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                              decoration:
                                  InputDecoration(labelText: 'Nombres'))),
                      SizedBox(width: 16),
                      Expanded(
                          child: TextField(
                              decoration:
                                  InputDecoration(labelText: 'Apellidos'))),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                              decoration:
                                  InputDecoration(labelText: 'Teléfono'))),
                      SizedBox(width: 16),
                      Expanded(
                          child: TextField(
                              decoration:
                                  InputDecoration(labelText: 'E-MAIL'))),
                    ],
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField(
                    decoration: InputDecoration(labelText: 'Tipo de Servicio'),
                    items: ['Deforestación'].map((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    onChanged: (_) {},
                  ),
                  SizedBox(height: 16),
                  TextField(
                      decoration: InputDecoration(labelText: 'Dirección')),
                  SizedBox(height: 16),
                  TextField(
                    decoration:
                        InputDecoration(labelText: 'Descripción del reporte'),
                    maxLines: 3,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Seleccionar archivo'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: Center(child: Text('Mapa aquí')),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Enviar'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SharedBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home-app');
          }
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/info-app');
          }
          if (index == 3) {
            Navigator.pushReplacementNamed(context, '/history');
          }
          if (index == 4) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
