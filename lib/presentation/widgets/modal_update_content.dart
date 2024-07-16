import 'package:flutter/material.dart';
import '../../data/models/info_model.dart';
import '../../data/repositories/info_repository_impl.dart';

class UpdateContentModal extends StatefulWidget {
  @override
  _UpdateContentModalState createState() => _UpdateContentModalState();
}

class _UpdateContentModalState extends State<UpdateContentModal> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  final InfoRepositoryImpl repository = InfoRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Modificar Contenido'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'ID del Contenido'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese el ID del contenido';
                }
                return null;
              },
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
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final content = InfoModel(
                id: int.parse(_idController.text),
                title: _titleController.text,
                description: _descriptionController.text,
                content: _contentController.text,
              );
              repository.updateContent(content.id, content).then((_) {
                Navigator.of(context).pop();
              }).catchError((error) {
                // Manejar el error
              });
            }
          },
          child: Text('Modificar'),
        ),
      ],
    );
  }
}
