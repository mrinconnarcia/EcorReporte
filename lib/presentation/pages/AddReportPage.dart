import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ecoreporte/data/repositories/report_repository_impl.dart';
import 'package:ecoreporte/utils/secure_storage.dart';
import '../widgets/SharedBottomNavigationBar.dart';

class AddReportPage extends StatefulWidget {
  @override
  _AddReportPageState createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _placeController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _namesController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final SecureStorage secureStorage = SecureStorage();
  final ReportRepositoryImpl reportRepository = ReportRepositoryImpl();
  File? _selectedFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final userData = await secureStorage.getUserData();
    setState(() {
      _namesController.text = userData?['name'] ?? '';
      _lastNameController.text = userData?['lastName'] ?? '';
      _phoneController.text = userData?['phone'] ?? '';
      _emailController.text = userData?['email'] ?? '';
    });
  }

  Future<void> _selectFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _selectedFile = File(pickedFile.path);
      }
    });
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
                  onPressed: () async {
                    await secureStorage.deleteUserInfo();
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  tooltip: 'Cerrar sesión',
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Crear Reporte',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Título del Reporte',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese un título para el reporte';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Tipo de Incidente',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(
                              value: 'deforestacion',
                              child: Text('Deforestación')),
                          DropdownMenuItem(
                              value: 'contaminacion_agua',
                              child: Text('Contaminación del Agua')),
                          DropdownMenuItem(
                              value: 'contaminacion_aire',
                              child: Text('Contaminación del Aire')),
                          DropdownMenuItem(
                              value: 'residuos_solidos', child: Text('Basura')),
                          DropdownMenuItem(
                              value: 'plantas_animales',
                              child: Text('Plantas y/o animales')),
                        ],
                        onChanged: (value) {
                          _typeController.text = value ?? '';
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor seleccione un tipo de incidente';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Descripción del Incidente',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese una descripción';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _placeController,
                        decoration: InputDecoration(
                          labelText: 'Lugar del Incidente',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el lugar del incidente';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _postalCodeController,
                        decoration: InputDecoration(
                          labelText: 'Código Postal',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el código postal';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _namesController,
                        decoration: InputDecoration(
                          labelText: 'Nombres',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Apellidos',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Teléfono',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Correo Electrónico',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                      ),
                      SizedBox(height: 16),
                      if (_selectedFile != null)
                        Image.file(
                          _selectedFile!,
                          width: 100,
                          height: 100,
                        ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _selectFile,
                        child: Text('Seleccionar Imagen'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            try {
                              final token = await secureStorage.getToken();
                              if (token != null) {
                                final reportData = {
                                  'titulo_reporte': _titleController.text,
                                  'tipo_reporte': _typeController.text,
                                  'descripcion': _descriptionController.text,
                                  'colonia': _placeController.text,
                                  'codigo_postal': _postalCodeController.text,
                                  'nombres': _namesController.text,
                                  'apellidos': _lastNameController.text,
                                  'telefono': _phoneController.text,
                                  'correo': _emailController.text,
                                };

                                if (_selectedFile != null) {
                                  await reportRepository.createReport(
                                      reportData, _selectedFile!.path, token);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Reporte creado exitosamente')),
                                  );
                                  Navigator.of(context).pop();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Seleccione una imagen')),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('No se encontró el token')),
                                );
                              }
                            } catch (e) {
                              print('Error creating report: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Error al crear el reporte: $e')),
                              );
                            }
                          }
                        },
                        child: Text('Crear Reporte'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SharedBottomNavigationBar(
        currentIndex: 2,
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
