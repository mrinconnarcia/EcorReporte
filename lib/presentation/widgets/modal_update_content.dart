import 'package:flutter/material.dart';
import '../../domain/entities/info.dart';
import '../../data/repositories/info_repository_impl.dart';
import 'package:provider/provider.dart';
import '../../utils/secure_storage.dart'; // Asegúrate de importar SecureStorage

class UpdateContentModal extends StatefulWidget {
  final Info content;

  UpdateContentModal({required this.content});

  @override
  _UpdateContentModalState createState() => _UpdateContentModalState();
}

class _UpdateContentModalState extends State<UpdateContentModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _contentController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.content.title);
    _descriptionController = TextEditingController(text: widget.content.description);
    _contentController = TextEditingController(text: widget.content.content);
    _imageUrlController = TextEditingController(text: widget.content.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<InfoRepositoryImpl>(context);
    final secureStorage = SecureStorage();

    return AlertDialog(
      title: Text('Modificar Contenido'),
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
              final updatedContent = Info(
                id: widget.content.id,
                title: _titleController.text,
                description: _descriptionController.text,
                content: _contentController.text,
                imageUrl: _imageUrlController.text,
              );

              final token = await secureStorage.getToken();
              if (token != null) {
                repository.updateContent(updatedContent.id, updatedContent, token).then((_) {
                  Navigator.of(context).pop();
                }).catchError((error) {
                  // Manejar el error
                });
              } else {
                // Manejar la ausencia del token
              }
            }
          },
          child: Text('Modificar'),
        ),
      ],
    );
  }
}
