import 'package:flutter/material.dart';
import '../../data/repositories/community_repository_impl.dart';

class CreateCommunityModal extends StatefulWidget {
  @override
  _CreateCommunityModalState createState() => _CreateCommunityModalState();
}

class _CreateCommunityModalState extends State<CreateCommunityModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final CommunityRepositoryImpl _communityRepository = CommunityRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Crear Comunidad'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre de la Comunidad'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un nombre';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Código de la Comunidad'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un código';
                }
                if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                  return 'El código debe contener solo letras y números';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              try {
                bool success = await _communityRepository.createCommunity(
                  _nameController.text,
                  _codeController.text,
                );
                if (success) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Comunidad creada exitosamente')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al crear la comunidad')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            }
          },
          child: Text('Crear'),
        ),
      ],
    );
  }
}
