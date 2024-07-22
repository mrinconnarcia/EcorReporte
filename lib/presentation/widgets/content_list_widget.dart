import 'package:flutter/material.dart';
import '../../domain/entities/info.dart';

class ContentListWidget extends StatelessWidget {
  final List<Info> contentList;

  ContentListWidget({required this.contentList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contentList.length,
      itemBuilder: (context, index) {
        Info info = contentList[index]; 
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index % 2 == 0)
                _buildImageTextSection(info.title, info.description, info.imageUrl, true),
              if (index % 2 != 0)
                _buildImageTextSection(info.title, info.description, info.imageUrl, false),
              SizedBox(height: 16),
              Text(
                info.content,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              if (index < contentList.length - 1) Divider(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageTextSection(String title, String description, String imageUrl, bool imageLeft) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: imageLeft
          ? [
              Expanded(
                flex: 1,
                child: Image.network(imageUrl, height: 100, fit: BoxFit.cover),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                child: Image.network(imageUrl, height: 100, fit: BoxFit.cover),
              ),
            ],
    );
  }
}
