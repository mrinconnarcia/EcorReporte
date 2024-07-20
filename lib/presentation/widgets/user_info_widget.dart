import 'package:ecoreporte/data/models/info_model.dart';
import 'package:ecoreporte/data/repositories/info_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'content_list_widget.dart';
import '../../utils/secure_storage.dart';

class UserInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final secureStorage = SecureStorage();
    final infoRepository = Provider.of<InfoRepositoryImpl>(context);

    return Column(
      children: [
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
                return ContentListWidget(contentList: snapshot.data!);
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
