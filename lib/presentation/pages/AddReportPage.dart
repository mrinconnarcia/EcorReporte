import 'package:ecoreporte/data/repositories/report_repository_impl.dart';
import 'package:ecoreporte/presentation/widgets/SharedBottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddReportPage extends StatefulWidget {
  @override
  _CreateReportPageState createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<AddReportPage> {
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

  File? _selectedFile;

  final _picker = ImagePicker();

  Future<void> _selectFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _selectedFile = File(pickedFile.path);
      }
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su correo electrónico';
    }
    final RegExp emailExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailExp.hasMatch(value)) {
      return 'Por favor ingrese un correo electrónico válido';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su teléfono';
    }
    final RegExp phoneExp = RegExp(r'^\d{10}$');
    if (!phoneExp.hasMatch(value)) {
      return 'Por favor ingrese un número de teléfono válido (10 dígitos)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
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
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un título';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Tipo'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el tipo';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una descripción';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _placeController,
              decoration: InputDecoration(labelText: 'Lugar'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el lugar';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _postalCodeController,
              decoration: InputDecoration(labelText: 'Código Postal'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el código postal';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _namesController,
              decoration: InputDecoration(labelText: 'Nombres'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese sus nombres';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Apellido'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su apellido';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Teléfono'),
              validator: _validatePhone,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
              validator: _validateEmail,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectFile,
              child: Text('Seleccionar Imagen'),
            ),
            _selectedFile == null
                ? Text('No se ha seleccionado ninguna imagen')
                : Image.file(_selectedFile!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (_selectedFile != null) {
                    try {
                      await Provider.of<ReportRepositoryImpl>(context, listen: false).createReport({
                        'TITLE': _titleController.text,
                        'TYPE': _typeController.text,
                        'DESCRIPTION': _descriptionController.text,
                        'PLACE': _placeController.text,
                        'POSTAL_CODE': _postalCodeController.text,
                        'NAMES': _namesController.text,
                        'LASTNAME': _lastNameController.text,
                        'PHONE': _phoneController.text,
                        'EMAIL': _emailController.text,
                      }, _selectedFile!.path);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reporte creado exitosamente')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al crear el reporte: $e')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Por favor seleccione una imagen')),
                    );
                  }
                }
              },
              child: Text('Enviar Reporte'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SharedBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home-app');
          }
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/info-app');
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
