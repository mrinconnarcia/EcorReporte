import 'package:flutter/material.dart';
import '../../domain/entities/info.dart';
import '../../data/repositories/info_repository_impl.dart';
import 'package:provider/provider.dart';
import '../../utils/secure_storage.dart'; // Asegúrate de importar SecureStorage

class CreateContentModal extends StatefulWidget {
  @override
  _CreateContentModalState createState() => _CreateContentModalState();
}

class _CreateContentModalState extends State<CreateContentModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<InfoRepositoryImpl>(context);
    final secureStorage = SecureStorage();

    return AlertDialog(
      title: Text('Crear Contenido'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una descripción';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Contenido'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el contenido';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'URL de la Imagen'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese la URL de la imagen';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final content = Info(
                id: 0, // Proporciona un ID temporal si es necesario
                title: _titleController.text,
                description: _descriptionController.text,
                content: _contentController.text,
                imageUrl: _imageUrlController.text,
              );

              final token = await secureStorage.getToken();
              if (token != null) {
                repository.createContent(content, token).then((_) {
                  Navigator.of(context).pop();
                }).catchError((error) {
                  // Manejar el error
                });
              } else {
                // Manejar la ausencia del token
              }
            }
          },
          child: Text('Crear'),
        ),
      ],
    );
  }
}
