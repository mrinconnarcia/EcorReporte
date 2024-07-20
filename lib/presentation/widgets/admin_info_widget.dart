import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecoreporte/data/models/info_model.dart';
import 'package:ecoreporte/data/repositories/info_repository_impl.dart';
import 'modal_create_content.dart';
import 'modal_update_content.dart';
import 'modal_delete_content.dart';
import 'content_list_widget.dart';
import '../../utils/secure_storage.dart';

class AdminInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final secureStorage = SecureStorage();
    final infoRepository = Provider.of<InfoRepositoryImpl>(context);

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
        Expanded(
          child: FutureBuilder<List<InfoModel>>(
            future: _loadContent(infoRepository, secureStorage),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No hay contenido disponible'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final content = snapshot.data![index];
                    return ListTile(
                      title: Text(content.title),
                      subtitle: Text(content.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return UpdateContentModal(content: content);
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DeleteContentModal(content: content);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Future<List<InfoModel>> _loadContent(InfoRepositoryImpl repository, SecureStorage secureStorage) async {
    final token = await secureStorage.getToken();
    if (token != null) {
      return await repository.getAllContent(token);
    } else {
      throw Exception('Token no disponible');
    }
  }
}
