import 'package:flutter/material.dart';
import '../../data/models/info_model.dart';
import '../../data/repositories/info_repository_impl.dart';

class ContentListWidget extends StatelessWidget {
  final InfoRepositoryImpl repository = InfoRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<InfoModel>>(
      future: repository.getAllContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        } else {
          List<InfoModel> infoList = snapshot.data!;
          return ListView.builder(
            itemCount: infoList.length,
            itemBuilder: (context, index) {
              InfoModel info = infoList[index];
              return Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index % 2 == 0)
                      _buildImageTextSection(
                          info.title, info.description, true),
                    if (index % 2 != 0)
                      _buildImageTextSection(
                          info.title, info.description, false),
                    SizedBox(height: 16),
                    Text(
                      info.content,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 16),
                    if (index < infoList.length - 1) Divider(),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildImageTextSection(
      String title, String description, bool imageLeft) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: imageLeft
          ? [
              Expanded(
                flex: 1,
                child: Container(
                  height: 100,
                  color: Colors.grey[300],
                  child: Center(child: Text('Imagen')),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ]
          : [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Container(
                  height: 100,
                  color: Colors.grey[300],
                  child: Center(child: Text('Imagen')),
                ),
              ),
            ],
    );
  }
}
