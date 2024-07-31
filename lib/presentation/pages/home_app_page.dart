import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:video_player/video_player.dart';
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
  late VideoPlayerController _videoController;
  bool _isPlaying = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    _videoController = VideoPlayerController.network(
        'https://firebasestorage.googleapis.com/v0/b/service-education.appspot.com/o/educationalContents%2Fvideo1.mp4?alt=media&token=cc2c495e-9bd0-4185-a08c-0b1edc7a2438')
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _startAutoReplay();
      });
  }

  @override
  void dispose() {
    _mounted = false;
    _timer?.cancel();
    _videoController.dispose();
    super.dispose();
  }

  void _startAutoReplay() {
    _timer = Timer.periodic(Duration(seconds: 15), (timer) {
      if (_videoController.value.position >= _videoController.value.duration) {
        _videoController.seekTo(Duration.zero);
        _videoController.play();
      }
    });
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

  void _updateCharts() {
    setState(() {
      pieChartData = null;
      barChartData = null;
    });
    _loadChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(96),
        child: Container(
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                            height: 180,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(0, 156, 233, 118),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Image.asset(
                                  'assets/conservacion-ambiental.png',
                                  fit: BoxFit.cover),
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
                            height: 180,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(0, 95, 95, 95),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Image.asset(
                                  'assets/tecnologia-reporte.png',
                                  fit: BoxFit.cover),
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
                    SizedBox(height: 16),
                    if (_videoController.value.isInitialized)
                      Column(
                        children: [
                          AspectRatio(
                            aspectRatio: _videoController.value.aspectRatio,
                            child: VideoPlayer(_videoController),
                          ),
                          VideoProgressIndicator(_videoController,
                              allowScrubbing: true),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_isPlaying) {
                                      _videoController.pause();
                                    } else {
                                      _videoController.play();
                                    }
                                    _isPlaying = !_isPlaying;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (isAdmin) ...[
                      SizedBox(height: 32),
                      Text(
                        'Distribución de tipos de reportes',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      _buildChartWidget(
                          pieChartData, 'Distribución de tipos de reportes'),
                      SizedBox(height: 32),
                      Text(
                        'Top Causas de Reportes',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      _buildChartWidget(barChartData, 'Top Causas de Reportes'),
                      SizedBox(height: 32),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.8, // 80% of screen width
                          child: ElevatedButton(
                            onPressed: _updateCharts,
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF9DE976),
                              onPrimary: Color.fromARGB(255, 33, 33, 33),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.refresh, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  'Actualizar Gráficas',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32), // Add some space at the bottom
                    ],
                  ]),
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
