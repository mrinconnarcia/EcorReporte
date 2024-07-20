import 'package:flutter/material.dart';
import '../../data/models/info_model.dart';
import '../../data/repositories/info_repository_impl.dart';
import 'package:provider/provider.dart';
import '../../utils/secure_storage.dart'; // Asegúrate de importar SecureStorage

class DeleteContentModal extends StatelessWidget {
  final InfoModel content;

  DeleteContentModal({required this.content});

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<InfoRepositoryImpl>(context);
    final secureStorage = SecureStorage();

    return AlertDialog(
      title: Text('Eliminar Contenido'),
      content: Text('¿Está seguro de que desea eliminar el contenido "${content.title}"?'),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final token = await secureStorage.getToken();
            if (token != null) {
              repository.deleteContent(content.id, token).then((_) {
                Navigator.of(context).pop();
              }).catchError((error) {
                // Manejar el error
              });
            } else {
              // Manejar la ausencia del token
            }
          },
          child: Text('Eliminar'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
      ],
    );
  }
}
