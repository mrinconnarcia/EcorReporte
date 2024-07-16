import 'package:flutter/material.dart';
import 'modal_create_content.dart';
import 'modal_update_content.dart';
import 'modal_delete_content.dart';
import 'content_list_widget.dart';

class AdminInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CreateContentModal();
              },
            );
          },
          child: Text('Crear Contenido'),
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return UpdateContentModal();
              },
            );
          },
          child: Text('Modificar Contenido'),
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return DeleteContentModal();
              },
            );
          },
          child: Text('Eliminar Contenido'),
        ),
        Expanded(
          child: ContentListWidget(),
        ),
      ],
    );
  }
}
