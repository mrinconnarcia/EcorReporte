import 'package:ecoreporte/data/models/info_model.dart';
import 'package:ecoreporte/data/repositories/info_repository_impl.dart';
import 'package:ecoreporte/presentation/bloc/authentication_bloc.dart';
import 'package:ecoreporte/presentation/bloc/authentication_event.dart';
import 'package:ecoreporte/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class InfoAppPage extends StatelessWidget {
  final InfoRepositoryImpl infoRepository = InfoRepositoryImpl();
  final SecureStorage secureStorage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información Educativa'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              secureStorage.deleteToken();
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
          ),
        ],
      ),
      body: FutureBuilder<String?>(
        future: secureStorage.getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No token found'));
          } else {
            final token = snapshot.data!;
            return FutureBuilder<List<InfoModel>>(
              future: infoRepository.getAllContent(token),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No content found'));
                } else {
                  final contentList = snapshot.data!;
                  return ListView.builder(
                    itemCount: contentList.length,
                    itemBuilder: (context, index) {
                      final content = contentList[index];
                      return ListTile(
                        title: Text(content.title),
                        subtitle: Text(content.description),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
