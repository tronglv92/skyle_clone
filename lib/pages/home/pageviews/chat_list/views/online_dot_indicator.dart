
import 'package:flutter/material.dart';


class OnlineDotIndicator extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        height: 10,
        width: 10,
        margin: EdgeInsets.only(right: 5, top: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
        ),
      ),
    );
  }
}
