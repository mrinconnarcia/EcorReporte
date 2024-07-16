import 'package:flutter/material.dart';
import '../../data/repositories/info_repository_impl.dart';

class DeleteContentModal extends StatefulWidget {
  @override
  _DeleteContentModalState createState() => _DeleteContentModalState();
}

class _DeleteContentModalState extends State<DeleteContentModal> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final InfoRepositoryImpl repository = InfoRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Eliminar Contenido'),
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
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final id = int.parse(_idController.text);
              repository.deleteContent(id).then((_) {
                Navigator.of(context).pop();
              }).catchError((error) {
                // Manejar el error
              });
            }
          },
          child: Text('Eliminar'),
        ),
      ],
    );
  }
}
