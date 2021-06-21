import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skyle_clone/constants/strings.dart';
import 'package:skyle_clone/models/local/message.dart';
import 'package:skyle_clone/utils/app_log.dart';
import 'package:skyle_clone/utils/app_style.dart';
import 'package:skyle_clone/widgets/cached_image.dart';

class MessageView extends StatelessWidget {
  final Message message;

  MessageView({this.message});

  @override
  Widget build(BuildContext context) {
    if (message.type != MESSAGE_TYPE_IMAGE) {
      return Text(
        message.message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else {
      if (message.photoUrls.length > 0) {
        logger.d("message.photoUrls.length ${message.photoUrls.length}");
        int count = 1;
        int numberMore = 0;
        if (message.photoUrls.length > 1 && message.photoUrls.length <= 3) {
          count = 2;
        } else {
          count = 4;
        }
        numberMore = message.photoUrls.length - count;
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
            itemCount: count,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext ctx, index) {
              return Stack(
                children: [
                  CachedImage(
                    message.photoUrls[index],
                    height: 250,
                    width: 250,
                    radius: 10,
                  ),
                  (index == count - 1 && numberMore > 0)
                      ? Container(
                          height: 250,
                          width: 250,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black54),
                          child: Center(
                            child: Text(
                              "+" + numberMore.toString(),
                              style: boldTextStyle(18, color: Colors.white),
                            ),
                          ),
                        )
                      : Container()
                ],
              );
            });
      } else {
        return Text("Url was null");
      }
    }
  }
}
