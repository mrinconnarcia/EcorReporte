import 'package:ecoreporte/domain/entities/report_summary.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ecoreporte/utils/secure_storage.dart';
import 'package:ecoreporte/presentation/widgets/SharedBottomNavigationBar.dart';
import 'package:ecoreporte/data/repositories/report_repository_impl.dart';
import 'package:ecoreporte/presentation/bloc/authentication_bloc.dart';
import 'package:ecoreporte/presentation/bloc/authentication_event.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final secureStorage = SecureStorage();
  Map<String, String> reportStatuses = {};

  Future<List<ReportSummary>> _fetchReports(BuildContext context, String token) async {
    final reportRepository = Provider.of<ReportRepositoryImpl>(context, listen: false);
    return reportRepository.fetchReports(token);
  }

  void _editReport(BuildContext context, ReportSummary report) async {
    final newStatus = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Reporte'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Cambiar estado del reporte:'),
            DropdownButton<String>(
              value: report.estatus,
              items: ['pendiente', 'en_proceso', 'completado', 'cancelado'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  Navigator.of(context).pop(newValue);
                }
              },
            ),
          ],
        ),
      ),
    );

    if (newStatus != null && newStatus != report.estatus) {
      try {
        final reportRepository = Provider.of<ReportRepositoryImpl>(context, listen: false);
        final token = await secureStorage.getToken();
        if (token == null) {
          throw Exception('No se pudo obtener el token');
        }
        await reportRepository.updateReportStatus(report.id, newStatus, token);
        setState(() {}); // Refresh the list
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el estado: $e')),
        );
      }
    }
  }

  void _deleteReport(BuildContext context, ReportSummary report) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'Eliminar Reporte',
      desc: '¿Estás seguro de que quieres eliminar el reporte "${report.tituloReporte}"?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        try {
          final reportRepository = Provider.of<ReportRepositoryImpl>(context, listen: false);
          final token = await secureStorage.getToken();
          if (token == null) {
            throw Exception('No se pudo obtener el token');
          }
          await reportRepository.deleteReport(report.id, token, tituloReporte: report.tituloReporte);
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.bottomSlide,
            title: 'Éxito',
            desc: 'Reporte eliminado exitosamente',
            btnOkOnPress: () {
              setState(() {
                reportStatuses.remove(report.id);
              });
            },
          )..show();
        } catch (e) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.rightSlide,
            title: 'Error',
            desc: 'Error al eliminar el reporte: $e',
            btnOkOnPress: () {},
            btnOkColor: Colors.red,
          )..show();
        }
      },
    )..show();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir $url');
    }
  }

  Widget _buildViewPDFButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.picture_as_pdf, color: Colors.white, size: 18),
          SizedBox(width: 4),
          Text(
            'Ver PDF',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
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
                      BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
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
      body: FutureBuilder<Map<String, dynamic>?>(
        future: secureStorage.getUserData(),
        builder: (context, userDataSnapshot) {
          if (userDataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (userDataSnapshot.hasError || !userDataSnapshot.hasData) {
            return Center(child: Text('No se encontraron datos del usuario'));
          } else {
            final userData = userDataSnapshot.data!;
            final role = userData['role'];

            return FutureBuilder<String?>(
              future: secureStorage.getToken(),
              builder: (context, tokenSnapshot) {
                if (tokenSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (tokenSnapshot.hasError || !tokenSnapshot.hasData) {
                  return Center(child: Text('No se pudo obtener el token'));
                } else {
                  final token = tokenSnapshot.data!;
                  return FutureBuilder<List<ReportSummary>>(
                    future: Provider.of<ReportRepositoryImpl>(context, listen: false).fetchReports(token),
                    builder: (context, reportSnapshot) {
                      if (reportSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (reportSnapshot.hasError) {
                        return Center(child: Text('Error: ${reportSnapshot.error}'));
                      } else if (!reportSnapshot.hasData || reportSnapshot.data!.isEmpty) {
                        return Center(child: Text('No se encontraron reportes'));
                      } else {
                        final reports = reportSnapshot.data!;
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Historial de Reporte',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: reports.length,
                                itemBuilder: (context, index) {
                                  final report = reports[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          title: Text(
                                            report.tituloReporte,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text('Estatus: ${report.estatus}'),
                                          trailing: role == 'admin'
                                              ? Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.edit, color: Colors.blue),
                                                      onPressed: () => _editReport(context, report),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.delete, color: Colors.red),
                                                      onPressed: () => _deleteReport(context, report),
                                                    ),
                                                  ],
                                                )
                                              : null,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                          child: GestureDetector(
                                            onTap: () => _launchURL(report.pdfUrl),
                                            child: _buildViewPDFButton(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                }
              },
            );
          }
        },
      ),
      bottomNavigationBar: SharedBottomNavigationBar(
        currentIndex: 3,
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
