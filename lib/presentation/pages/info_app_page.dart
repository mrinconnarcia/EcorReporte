import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:ecoreporte/domain/entities/info.dart';
import 'package:ecoreporte/data/repositories/info_repository_impl.dart';
import 'package:ecoreporte/utils/secure_storage.dart';
import '../widgets/SharedBottomNavigationBar.dart';

class InfoAppPage extends StatefulWidget {
  @override
  _InfoAppPageState createState() => _InfoAppPageState();
}

class _InfoAppPageState extends State<InfoAppPage> {
  final InfoRepositoryImpl infoRepository = InfoRepositoryImpl();
  final SecureStorage secureStorage = SecureStorage();
  String? userRole;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final token = await secureStorage.getToken();
    if (token != null) {
      final role = await infoRepository.getRoleFromToken(token);
      setState(() {
        userRole = role;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Información Educativa',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3F20),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(child: _buildContent()),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SharedBottomNavigationBar(
        currentIndex: 1,
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

  Widget _buildHeader(BuildContext context) {
    return Container(
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
    );
  }

  Widget _buildContent() {
    return FutureBuilder<String?>(
      future: secureStorage.getToken(),
      builder: (context, tokenSnapshot) {
        if (tokenSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (tokenSnapshot.hasError || !tokenSnapshot.hasData) {
          return Center(child: Text('No se encontró el token'));
        } else {
          final token = tokenSnapshot.data!;
          return _buildEducationalContent(token);
        }
      },
    );
  }

  Widget _buildEducationalContent(String token) {
    return FutureBuilder<List<Info>>(
      future: infoRepository.getAllContent(token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay contenido educativo disponible'));
        } else {
          return Column(
            children: [
              if (userRole == 'admin')
                ElevatedButton(
                  child: Text('Crear Nuevo Contenido'),
                  onPressed: () => _showCreateContentDialog(context, token),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final content = snapshot.data![index];
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            content.imageUrl.isNotEmpty
                                ? Image.network(
                                    content.imageUrl,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image, size: 100),
                                  ),
                            SizedBox(height: 8),
                            Text(
                              content.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(content.description),
                            SizedBox(height: 8),
                            Text(content.content),
                          ],
                        ),
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

  void _showCreateContentDialog(BuildContext context, String token) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final contentController = TextEditingController();
    final codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Crear Nuevo Contenido'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                ),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(labelText: 'Contenido'),
                  maxLines: 3,
                ),
                if (_selectedImage != null)
                  Image.file(
                    _selectedImage!,
                    width: 100,
                    height: 100,
                  ),
                TextButton(
                  child: Text('Seleccionar Imagen'),
                  onPressed: () => _pickImage(),
                ),
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(labelText: 'Código'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Crear'),
              onPressed: () async {
                if (_selectedImage != null) {
                  try {
                    final formData = FormData.fromMap({
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'content': contentController.text,
                      'code': codeController.text,
                      'image': await MultipartFile.fromFile(_selectedImage!.path),
                    });

                    await infoRepository.createContent(formData, token);
                    Navigator.of(context).pop();
                    setState(() {}); // Actualizar la lista
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al crear el contenido: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Seleccione una imagen')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _showContentDetails(BuildContext context, Info content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(content.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(content.description),
                SizedBox(height: 8),
                content.imageUrl.isNotEmpty
                    ? Image.network(content.imageUrl)
                    : Icon(Icons.image, size: 100),
                SizedBox(height: 8),
                Text(content.content),
                SizedBox(height: 8),
                Text('Código: ${content.code}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
