import 'dart:io';
import 'package:ecoreporte/domain/entities/report.dart';
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
      backgroundColor: Colors.grey[100],
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
                  Navigator.of(context).pushReplacementNamed('/');
                },
                tooltip: 'Cerrar sesión',
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crear Reporte',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                buildInputField(Icons.title, 'Título del Reporte', _titleController),
                SizedBox(height: 16),
                buildDropdownField(Icons.category, 'Tipo de Incidente', _typeController),
                SizedBox(height: 16),
                buildInputField(Icons.description, 'Descripción del Incidente', _descriptionController, maxLines: 3),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: buildInputField(Icons.place, 'Lugar del Incidente', _placeController)),
                    SizedBox(width: 16),
                    Expanded(child: buildInputField(Icons.location_city, 'Código Postal', _postalCodeController)),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: buildInputField(Icons.person, 'Nombres', _namesController, readOnly: true)),
                    SizedBox(width: 16),
                    Expanded(child: buildInputField(Icons.person_outline, 'Apellidos', _lastNameController, readOnly: true)),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: buildInputField(Icons.phone, 'Teléfono', _phoneController, readOnly: true)),
                    SizedBox(width: 16),
                    Expanded(child: buildInputField(Icons.email, 'Correo Electrónico', _emailController, readOnly: true)),
                  ],
                ),
                SizedBox(height: 24),
                if (_selectedFile != null)
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.file(_selectedFile!, fit: BoxFit.cover),
                  ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Icon(Icons.image),
                  label: Text('Seleccionar Imagen'),
                  onPressed: _selectFile,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[300],
                    onPrimary: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        try {
                          final token = await secureStorage.getToken();
                          if (token != null) {
                            final report = Report(
                              titulo_reporte: _titleController.text,
                              tipo_reporte: _typeController.text,
                              descripcion: _descriptionController.text,
                              colonia: _placeController.text,
                              codigo_postal: _postalCodeController.text,
                              nombres: _namesController.text,
                              apellidos: _lastNameController.text,
                              telefono: _phoneController.text,
                              correo: _emailController.text,
                            );

                            if (_selectedFile != null) {
                              await reportRepository.createReport(
                                  report, _selectedFile!.path, token);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Reporte creado exitosamente')),
                              );
                              Navigator.of(context).pushReplacementNamed('/home-app');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Seleccione una imagen')),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('No se encontró el token')),
                            );
                          }
                        } catch (e) {
                          print('Error creating report: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al crear el reporte: $e')),
                          );
                        }
                      }
                    },
                    child: Text('Crear Reporte'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF549CDE),
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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

  Widget buildInputField(IconData icon, String label, TextEditingController controller, {bool readOnly = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        }
        return null;
      },
    );
  }

  Widget buildDropdownField(IconData icon, String label, TextEditingController controller) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      items: [
        DropdownMenuItem(value: 'deforestacion', child: Text('Deforestación')),
        DropdownMenuItem(value: 'contaminacion_agua', child: Text('Contaminación del Agua')),
        DropdownMenuItem(value: 'contaminacion_aire', child: Text('Contaminación del Aire')),
        DropdownMenuItem(value: 'residuos_solidos', child: Text('Basura')),
        DropdownMenuItem(value: 'plantas_animales', child: Text('Plantas y/o animales')),
      ],
      onChanged: (value) {
        controller.text = value ?? '';
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor seleccione un tipo de incidente';
        }
        return null;
      },
    );
  }
}