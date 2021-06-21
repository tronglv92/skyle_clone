import 'package:flutter/material.dart';
import 'package:skyle_clone/constants/strings.dart';
import 'package:skyle_clone/models/local/message.dart';
import 'package:skyle_clone/utils/app_colors.dart';
import 'package:skyle_clone/widgets/cached_image.dart';

import 'message_view.dart';

class SenderLayout extends StatelessWidget {
  final Message message;

  SenderLayout({this.message});

  @override
  Widget build(BuildContext context) {
    Radius messageRadius = Radius.circular(10);

    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
        color: AppColors.senderColor,
        borderRadius: BorderRadius.only(
          topLeft: messageRadius,
          topRight: messageRadius,
          bottomLeft: messageRadius,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child:   MessageView(message: message),
      ),
    );
  }


}
