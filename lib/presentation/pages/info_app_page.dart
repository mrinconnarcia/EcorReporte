import 'package:flutter/material.dart';
import '../widgets/SharedBottomNavigationBar.dart';

class InfoAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Color(0xFF9DE976),
            padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
            child: Row(
              children: [
                Image.asset('../../../assets/eco_reporte_logo.png', height: 40),
                SizedBox(width: 8),
                Text(
                  'EcoReporte',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 150,
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Lorem ipsum es simplemente el texto de relleno de las imprentas y archivos de texto.',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Lorem ipsum es simplemente el texto de relleno de las imprentas y archivos de texto.',
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 150,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Lorem ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen.',
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 100,
                            color: Colors.grey[300],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 100,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SharedBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home-app');
          }
        },
      ),
    );
  }
}