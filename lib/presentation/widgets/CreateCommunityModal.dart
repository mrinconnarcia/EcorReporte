import 'package:ecoreporte/domain/entities/community.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/community_repository_impl.dart';
import '../../utils/secure_storage.dart';

class CreateCommunityModal extends StatefulWidget {
  @override
  _CreateCommunityModalState createState() => _CreateCommunityModalState();
}

class _CreateCommunityModalState extends State<CreateCommunityModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<CommunityRepositoryImpl>(context);
    final secureStorage = SecureStorage();

    return AlertDialog(
      title: Text('Crear Comunidad'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un nombre';
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
              final community = CommunityModel(
                code: '', // El código se obtiene del token
                name: _nameController.text,
                idAdmin: '', // El ID del administrador se obtiene del token
              );

              final token = await secureStorage.getToken();
              if (token != null) {
                repository.createCommunity(community, token).then((_) {
                  Navigator.of(context).pop();
                }).catchError((error) {
                  // Manejar el error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al crear la comunidad: $error')),
                  );
                });
              } else {
                // Manejar la ausencia del token
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No se encontró un token válido')),
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
