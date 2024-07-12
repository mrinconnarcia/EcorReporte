import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authentication_bloc.dart';
import '../bloc/authentication_event.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../utils/secure_storage.dart';
import '../widgets/SharedBottomNavigationBar.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final secureStorage = SecureStorage();
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: secureStorage.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('No se encontraron datos del usuario'));
          } else {
            final userData = snapshot.data!;
            return Column(
              children: [
                Container(
                  color: Color(0xFF9DE976),
                  padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/eco_reporte_logo.png',
                              height: 40),
                          SizedBox(width: 8),
                          Text(
                            'EcoReporte',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.exit_to_app),
                        onPressed: () async {
                          await secureStorage.deleteUserInfo();
                          authenticationBloc.add(LoggedOut());
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
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        Text('Bienvenido, ${userData['name']}',
                            style: TextStyle(fontSize: 18)),
                        SizedBox(height: 20),
                        InfoRow(
                            label: 'Nombre:', value: userData['name'] ?? 'N/A'),
                        InfoRow(
                            label: 'Apellidos:',
                            value: userData['lastName'] ?? 'N/A'),
                        InfoRow(
                            label: 'Correo:',
                            value: userData['email'] ?? 'N/A'),
                        InfoRow(
                            label: 'Teléfono:',
                            value: userData['phone'] ?? 'N/A'),
                        InfoRow(
                            label: 'Rol:', value: userData['role'] ?? 'N/A'),
                        InfoRow(
                            label: 'Género:',
                            value: userData['gender'] ?? 'N/A'),
                        // ... resto de tu UI ...

                        ElevatedButton(
                          onPressed: () {
                            // Implementar lógica para actualizar cuenta
                          },
                          child: Text('Actualizar cuenta'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9DE976),
                              foregroundColor: Colors.black),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            // Implementar lógica para eliminar cuenta
                          },
                          child: Text('Eliminar cuenta'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                              foregroundColor: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: SharedBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home-app');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/info-app');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/add-report');
          } else if (index == 3) {
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
