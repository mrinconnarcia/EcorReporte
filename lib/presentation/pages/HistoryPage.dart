import 'package:ecoreporte/presentation/widgets/ReportDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ecoreporte/utils/secure_storage.dart';
import 'package:ecoreporte/domain/entities/report.dart';
import 'package:ecoreporte/presentation/widgets/SharedBottomNavigationBar.dart';
import 'package:ecoreporte/data/repositories/report_repository_impl.dart';
import 'package:ecoreporte/presentation/bloc/authentication_bloc.dart';
import 'package:ecoreporte/presentation/bloc/authentication_event.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final secureStorage = SecureStorage();
  late Future<List<Report>> _reportHistory;

  @override
  void initState() {
    super.initState();
    _loadReportHistory();
  }

  void _loadReportHistory() async {
    final token = await secureStorage.getToken();
    final userData = await secureStorage.getUserData();

    if (token != null && userData != null) {
      final code = userData['code'];
      setState(() {
        _reportHistory = Provider.of<ReportRepositoryImpl>(context, listen: false).fetchReports(token);
      });
    }
  }

  void _editReport(BuildContext context, Report report) {
    final titleController = TextEditingController(text: report.title);
    final typeController = TextEditingController(text: report.type);
    final descriptionController = TextEditingController(text: report.description);
    final placeController = TextEditingController(text: report.place);
    final postalCodeController = TextEditingController(text: report.postalCode);
    final namesController = TextEditingController(text: report.names);
    final lastNameController = TextEditingController(text: report.lastName);
    final phoneController = TextEditingController(text: report.phone);
    final emailController = TextEditingController(text: report.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Reporte'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Tipo'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: placeController,
                decoration: InputDecoration(labelText: 'Lugar'),
              ),
              TextField(
                controller: postalCodeController,
                decoration: InputDecoration(labelText: 'Código Postal'),
              ),
              TextField(
                controller: namesController,
                decoration: InputDecoration(labelText: 'Nombres'),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Apellidos'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Teléfono'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final updatedReport = Report(
                id: report.id,
                title: titleController.text,
                type: typeController.text,
                description: descriptionController.text,
                place: placeController.text,
                postalCode: postalCodeController.text,
                names: namesController.text,
                lastName: lastNameController.text,
                phone: phoneController.text,
                email: emailController.text,
              );

              await Provider.of<ReportRepositoryImpl>(context, listen: false).updateReport(updatedReport);
              Navigator.pop(context);
              _loadReportHistory();
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _deleteReport(BuildContext context, int reportId) async {
    try {
      await Provider.of<ReportRepositoryImpl>(context, listen: false).deleteReport(reportId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reporte eliminado exitosamente')),
      );
      _loadReportHistory();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el reporte: $e')),
      );
    }
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
                onPressed: () async {
                  await secureStorage.deleteUserInfo();
                  BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                  Navigator.of(context).pushReplacementNamed('/');
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
            final code = userData['code'];

            return FutureBuilder<List<Report>>(
              future: _reportHistory,
              builder: (context, reportSnapshot) {
                if (reportSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (reportSnapshot.hasError || !reportSnapshot.hasData) {
                  return Center(child: Text('No se encontraron reportes'));
                } else {
                  final reports = reportSnapshot.data!;
                  final filteredReports = reports.where((report) => report.postalCode == code).toList();

                  return ListView.builder(
                    itemCount: filteredReports.length,
                    itemBuilder: (context, index) {
                      final report = filteredReports[index];
                      return ListTile(
                        title: Text(report.title),
                        subtitle: Text(report.description),
                        trailing: role == 'admin'
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () => _editReport(context, report),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => _deleteReport(context, report.id),
                                  ),
                                ],
                              )
                            : null,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportDetailPage(report: report),
                            ),
                          );
                        },
                      );
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
