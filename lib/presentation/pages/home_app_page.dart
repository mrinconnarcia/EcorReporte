import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ecoreporte/data/repositories/statistics_report_repository_impl.dart';
import '../widgets/SharedBottomNavigationBar.dart';
import '../../utils/secure_storage.dart';

class HomeAppPage extends StatefulWidget {
  @override
  _HomeAppPageState createState() => _HomeAppPageState();
}

class _HomeAppPageState extends State<HomeAppPage> {
  final StatisticsReportRepositoryImpl reportRepository = StatisticsReportRepositoryImpl();
  final SecureStorage secureStorage = SecureStorage();
  bool isAdmin = false;
  List<PieChartSectionData> pieChartData = [];
  List<BarChartGroupData> barChartData = [];

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    _loadReportData();
    _loadBarChartData();
  }

  void _checkAdminStatus() async {
    final userData = await secureStorage.getUserData();
    setState(() {
      isAdmin = userData?['role'] == 'admin';
    });
  }

  void _loadReportData() async {
    if (isAdmin) {
      final data = await reportRepository.getPieChartStatistics();
      setState(() {
        pieChartData = data.map((item) => PieChartSectionData(
          value: item['value'].toDouble(),
          color: _getRandomColor(),
          title: '${item['label']}\n${item['value']}',
          radius: 50,
          titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        )).toList();
      });
    }
  }

  void _loadBarChartData() async {
    if (isAdmin) {
      final data = await reportRepository.getBarChartStatistics();
      setState(() {
        barChartData = data.map((item) => BarChartGroupData(
          x: item['label'],
          barRods: [
            BarChartRodData(
              toY: item['value'].toDouble(),
              color: _getRandomColor(),
            ),
          ],
        )).toList();
      });
    }
  }

  Color _getRandomColor() {
    return Color((DateTime.now().millisecondsSinceEpoch * 0.001).toInt() << 0).withOpacity(1.0);
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
                            child: Icon(Icons.eco,
                                size: 50, color: Colors.white),
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
                      'Estadísticas de Reportes',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sections: pieChartData,
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Gráfica de Barras de Reportes',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          barGroups: barChartData,
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (double value, TitleMeta meta) {
                                  final style = TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  );
                                  String text;
                                  switch (value.toInt()) {
                                    case 0:
                                      text = 'A';
                                      break;
                                    case 1:
                                      text = 'B';
                                      break;
                                    case 2:
                                      text = 'C';
                                      break;
                                    case 3:
                                      text = 'D';
                                      break;
                                    default:
                                      text = '';
                                      break;
                                  }
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    space: 16,
                                    child: Text(text, style: style),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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