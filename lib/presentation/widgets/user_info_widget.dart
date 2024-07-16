import 'package:flutter/material.dart';
import 'content_list_widget.dart';

class UserInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ContentListWidget(),
        ),
      ],
    );
  }
}
