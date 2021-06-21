import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class LastMessageContainer extends StatelessWidget {


  final String lastMessage;
  LastMessageContainer({this.lastMessage});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    );
  }
}
