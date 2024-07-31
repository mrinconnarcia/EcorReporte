import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:math';
import '../../data/repositories/community_repository_impl.dart';

class CreateCommunityModal extends StatefulWidget {
  final Function(String) onCommunityCreated; // Cambiado a Function(String) para pasar el código

  CreateCommunityModal({required this.onCommunityCreated});

  @override
  _CreateCommunityModalState createState() => _CreateCommunityModalState();
}

class _CreateCommunityModalState extends State<CreateCommunityModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final CommunityRepositoryImpl _communityRepository = CommunityRepositoryImpl();

  @override
  void initState() {
    super.initState();
    _generateRandomCode();
  }

  void _generateRandomCode() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    final hash = sha256.convert(values);
    final code = hash.bytes.sublist(0, 3).map((byte) => byte.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
    _codeController.text = code;
  }

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
              decoration: InputDecoration(
                labelText: 'Código de la Comunidad',
                suffixIcon: IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      _generateRandomCode();
                    });
                  },
                ),
              ),
              readOnly: true,
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
                  widget.onCommunityCreated(_codeController.text); // Pasar el código creado
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
