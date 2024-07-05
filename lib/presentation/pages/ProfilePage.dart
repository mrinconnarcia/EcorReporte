import 'package:flutter/material.dart';
import '../widgets/SharedBottomNavigationBar.dart';

class ProfilePage extends StatelessWidget {
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
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hola!',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Bienvenido, Martín', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                  InfoRow(label: 'Nombre:', value: 'Martin'),
                  InfoRow(label: 'Apellidos:', value: 'Rincon Narcia'),
                  InfoRow(label: 'Correo:', value: 'martin@gmail.com'),
                  InfoRow(label: 'Telefono:', value: '9612851122'),
                  InfoRow(label: 'Fecha de nacimiento:', value: '12/10/2002'),
                  InfoRow(label: 'Genero:', value: 'Masculino'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Actualizar cuenta'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9DE976), foregroundColor: Colors.black),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Eliminar cuenta'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red[400], foregroundColor: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SharedBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home-app');
          }

          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/info-app');
          }

          if (index == 2) {
            Navigator.pushReplacementNamed(context, '/add-report');
          }

          if (index == 3) {
            Navigator.pushReplacementNamed(context, '/history');
          }
        },
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}
