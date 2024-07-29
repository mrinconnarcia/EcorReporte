import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:typed_data';
import '../widgets/SharedBottomNavigationBar.dart';
import 'package:photo_view/photo_view.dart';
import '../../utils/secure_storage.dart';
import '../../data/repositories/statistics_report_repository_impl.dart';

class HomeAppPage extends StatefulWidget {
  @override
  _HomeAppPageState createState() => _HomeAppPageState();
}

class _HomeAppPageState extends State<HomeAppPage> {
  final StatisticsReportRepositoryImpl reportRepository =
      StatisticsReportRepositoryImpl();
  final SecureStorage secureStorage = SecureStorage();
  bool isAdmin = false;
  dynamic pieChartData;
  dynamic barChartData;
  bool _mounted = true;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  void _checkAdminStatus() async {
    final userData = await secureStorage.getUserData();
    if (_mounted) {
      setState(() {
        isAdmin = userData?['role'] == 'admin';
      });
      if (isAdmin) {
        _loadChartData();
      }
    }
  }

  void _loadChartData() async {
    try {
      final pieData = await reportRepository.getPieChartImage();
      final barData = await reportRepository.getBarChartImage();
      if (_mounted) {
        setState(() {
          pieChartData = pieData;
          barChartData = barData;
        });
      }
    } catch (e) {
      print('Error loading chart data: $e');
      if (_mounted) {
        setState(() {
          pieChartData = e.toString();
          barChartData = e.toString();
        });
      }
    }
  }

  Widget _buildChartWidget(dynamic chartData, String title) {
    if (chartData == null) {
      return CircularProgressIndicator();
    } else if (chartData is Uint8List) {
      return GestureDetector(
        onTap: () => _showEnlargedChart(context, chartData, title),
        child: Image.memory(
          chartData,
          height: 300,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      );
    } else {
      return Text('Error: $chartData');
    }
  }

  void _showEnlargedChart(
      BuildContext context, Uint8List imageData, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Container(
            child: PhotoView(
              imageProvider: MemoryImage(imageData),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              initialScale: PhotoViewComputedScale.contained,
              backgroundDecoration: BoxDecoration(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.bottomSlide,
                        title: 'Cerrar Sesión',
                        desc: '¿Está seguro que desea cerrar sesión?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
                          await secureStorage.deleteUserInfo();
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                        btnCancelText: 'Cancelar',
                        btnOkText: 'Sí, cerrar sesión',
                      )..show();
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
                    '¡Tu eco, tu voz!',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3F20)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'EcoReporte, el poder de cambiar.',
                    style: TextStyle(fontSize: 18, color: Color(0xFF3E8914)),
                  ),
                  SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/ambiental_img.png',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Color(0xFF3E8914),
                          child: Center(
                            child: Icon(Icons.error, color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(0xFF9DE976),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(Icons.nature_people,
                                size: 50, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Participa activamente en la mejora de tu comunidad reportando problemas ambientales.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Utiliza la tecnología para crear un impacto positivo en tu entorno y mejorar la calidad de vida.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color(0xFF1E3F20),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child:
                                Icon(Icons.eco, size: 50, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'EcoReporte es una plataforma innovadora que te permite informar sobre problemas ambientales en tu comunidad de manera fácil y rápida. Con seguimiento en tiempo real de tus reportes y respuestas de las autoridades, juntos podemos crear un cambio significativo en nuestro entorno. ¡Únete a la comunidad de EcoReporte y sé parte del cambio!',
                    style: TextStyle(fontSize: 16),
                  ),
                  if (isAdmin) ...[
                    SizedBox(height: 32),
                    Text(
                      'Distribución de tipos de reportes',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    _buildChartWidget(
                        pieChartData, 'Distribución de tipos de reportes'),
                    SizedBox(height: 32),
                    Text(
                      'Top Causas de Reportes',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    _buildChartWidget(barChartData, 'Top Causas de Reportes'),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SharedBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/info-app');
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
}
