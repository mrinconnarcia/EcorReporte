import 'package:ecoreporte/domain/entities/info.dart';
import 'package:flutter/material.dart';
import 'package:ecoreporte/data/repositories/info_repository_impl.dart';
import 'package:ecoreporte/utils/secure_storage.dart';
import '../widgets/SharedBottomNavigationBar.dart';

class InfoAppPage extends StatelessWidget {
  final InfoRepositoryImpl infoRepository = InfoRepositoryImpl();
  final SecureStorage secureStorage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container simulating the AppBar
            Container(
              color: Color(0xFF9DE976), // Same color as HomeAppPage
              padding: EdgeInsets.fromLTRB(16, 40, 16, 16), // Same padding as HomeAppPage
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/eco_reporte_logo.png', height: 40),
                      SizedBox(width: 8),
                      Text(
                        'EcoReporte',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                    tooltip: 'Cerrar sesión',
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información de la Aplicación',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3F20)),
                  ),
                  SizedBox(height: 16),
                  // Aquí puedes añadir más contenido de la información de la aplicación
                  FutureBuilder<String?>(
                    future: secureStorage.getToken(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Center(child: Text('No token found'));
                      } else {
                        final token = snapshot.data!;
                        return FutureBuilder<List<Info>>(
                          future: infoRepository.getAllContent(token),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(child: Text('No content found'));
                            } else {
                              final contentList = snapshot.data!;
                              return ListView.builder(
                                itemCount: contentList.length,
                                itemBuilder: (context, index) {
                                  final content = contentList[index];
                                  return ListTile(
                                    title: Text(content.title),
                                    subtitle: Text(content.description),
                                  );
                                },
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SharedBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home-app');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/info-app');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/add-report');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/history');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
