import 'package:flutter/material.dart';
import '../../data/models/info_model.dart';
import '../../data/repositories/info_repository_impl.dart';

class CreateContentModal extends StatefulWidget {
  @override
  _CreateContentModalState createState() => _CreateContentModalState();
}

class _CreateContentModalState extends State<CreateContentModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  final InfoRepositoryImpl repository = InfoRepositoryImpl();

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final content = InfoModel(
                id: 0,
                title: _titleController.text,
                description: _descriptionController.text,
                content: _contentController.text,
              );
              repository.createContent(content).then((_) {
                Navigator.of(context).pop();
              }).catchError((error) {
                // Manejar el error
              });
            }
          },
          child: Text('Crear'),
        ),
      ],
    );
  }
}
