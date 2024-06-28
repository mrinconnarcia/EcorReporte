import 'package:flutter/material.dart';
import '../widgets/SharedBottomNavigationBar.dart';

class HistoryPage extends StatelessWidget {
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
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  height: 60,
                  color: Colors.grey[300],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SharedBottomNavigationBar(
        currentIndex: 3,
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
          if (index == 4) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
