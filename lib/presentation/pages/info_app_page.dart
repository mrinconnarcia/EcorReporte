import 'package:dio/dio.dart';
import 'package:ecoreporte/presentation/widgets/InfoDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    _token = await secureStorage.getToken();
    if (_token != null) {
      final role = await infoRepository.getRoleFromToken(_token!);
      setState(() {
        userRole = role;
      });
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
                onPressed: () => _showLogoutDialog(),
              ),
            ],
          ),
        ),
      ),
      body: _buildContent(),
      floatingActionButton: userRole == 'admin'
          ? FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Color(0xFF9DE976),
              onPressed: () => _showCreateContentModal(context, _token!),
            )
          : null,
      bottomNavigationBar: SharedBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home-app');
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

  Widget _buildContent() {
    if (_token == null) {
      return Center(child: Text('No se encontró el token'));
    }
    return _buildEducationalContent(_token!);
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
              Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar tu comunidad por código',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onSubmitted: (value) => _searchByCode(context, token, value),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final content = snapshot.data![index];
                    return InfoCard(
                      content: content,
                      onTap: () => _navigateToDetailPage(context, content),
                      userRole: userRole,
                      onEdit: () => _showUpdateContentModal(context, token, content, content.id),
                      onDelete: () => _showDeleteConfirmationDialog(context, token, content.id),
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

  void _navigateToDetailPage(BuildContext context, Info content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InfoDetailPage(content: content),
      ),
    );
  }

  void _showCreateContentModal(BuildContext context, String token) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final contentController = TextEditingController();
    final codeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Crear Nuevo Contenido',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
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
                    TextField(
                      controller: codeController,
                      decoration: InputDecoration(labelText: 'Código'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text('Seleccionar Imagen'),
                      onPressed: () async {
                        await _pickImage();
                        setModalState(() {});
                      },
                    ),
                    if (_selectedImage != null)
                      Image.file(_selectedImage!, width: 100, height: 100),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          child: Text('Cancelar'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        ElevatedButton(
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
                                Navigator.pop(context);
                                setState(() {});
                              } catch (e) {
                                _showErrorDialog('Error al crear el contenido: $e');
                              }
                            } else {
                              _showErrorDialog('Por favor, seleccione una imagen');
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showUpdateContentModal(BuildContext context, String token, Info content, int contentId) {
    final titleController = TextEditingController(text: content.title);
    final descriptionController = TextEditingController(text: content.description);
    final contentController = TextEditingController(text: content.content);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Actualizar Contenido',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text('Cancelar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      child: Text('Actualizar'),
                      onPressed: () async {
                        final updateData = {
                          'title': titleController.text,
                          'description': descriptionController.text,
                          'content': contentController.text,
                        };

                        try {
                          await infoRepository.updateContent(contentId, updateData, token);
                          Navigator.pop(context);
                          setState(() {});
                        } catch (e) {
                          _showErrorDialog('Error al actualizar el contenido: $e');
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String token, int contentId) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'Confirmar Eliminación',
      desc: '¿Está seguro que desea eliminar este contenido?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        try {
          await infoRepository.deleteContent(contentId, token);
          setState(() {});
        } catch (e) {
          _showErrorDialog('Error al eliminar el contenido: $e');
        }
      },
    )..show();
  }

  void _searchByCode(BuildContext context, String token, String code) async {
    try {
      final content = await infoRepository.getContentByCode(code, token);
      _navigateToDetailPage(context, content);
    } catch (e) {
      _showErrorDialog('Error al buscar el contenido: $e');
    }
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Error',
      desc: message,
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
    )..show();
  }

  void _showLogoutDialog() {
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
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }
}

class InfoCard extends StatelessWidget {
  final Info content;
  final VoidCallback onTap;
  final String? userRole;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const InfoCard({
    Key? key,
    required this.content,
    required this.onTap,
    this.userRole,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              child: content.imageUrl.isNotEmpty
                  ? Image.network(
                      content.imageUrl,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error, size: 50),
                    )
                  : Container(
                      width: double.infinity,
                      height: 150,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, size: 50),
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    content.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Código: ${content.code}',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (userRole == 'admin')
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}