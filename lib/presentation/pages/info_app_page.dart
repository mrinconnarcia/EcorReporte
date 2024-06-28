import 'package:flutter/material.dart';
import '../../data/models/info_model.dart';
import '../../data/services/info_service.dart';
import '../widgets/SharedBottomNavigationBar.dart';

class InfoAppPage extends StatefulWidget {
  @override
  _InfoAppPageState createState() => _InfoAppPageState();
}

class _InfoAppPageState extends State<InfoAppPage> {
  late Future<List<InfoModel>> futureInfo;

  @override
  void initState() {
    super.initState();
    futureInfo = InfoService().fetchInfo();
  }

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
            child: FutureBuilder<List<InfoModel>>(
              future: futureInfo,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  List<InfoModel> infoList = snapshot.data!;
                  return ListView.builder(
                    itemCount: infoList.length,
                    itemBuilder: (context, index) {
                      InfoModel info = infoList[index];
                      return Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index % 2 == 0)
                              _buildImageTextSection(
                                  info.title, info.description, true),
                            if (index % 2 != 0)
                              _buildImageTextSection(
                                  info.title, info.description, false),
                            SizedBox(height: 16),
                            Text(
                              info.content,
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 16),
                            if (index < infoList.length - 1) Divider(),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
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
          if (index == 2) {
            Navigator.pushReplacementNamed(context, '/add-report');
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

  Widget _buildImageTextSection(
      String title, String description, bool imageLeft) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: imageLeft
          ? [
              Expanded(
                flex: 1,
                child: Container(
                  height: 100,
                  color: Colors.grey[300],
                  child: Center(child: Text('Imagen')),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ]
          : [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Container(
                  height: 100,
                  color: Colors.grey[300],
                  child: Center(child: Text('Imagen')),
                ),
              ),
            ],
    );
  }
}
