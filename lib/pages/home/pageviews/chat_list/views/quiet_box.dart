import 'package:flutter/material.dart';
import 'package:skyle_clone/utils/app_colors.dart';
import 'package:skyle_clone/utils/app_style.dart';

class QuietBox extends StatelessWidget {
  final String heading;
  final String subtitle;
  final Function onPressSearch;

  QuietBox({
    @required this.heading,
    @required this.subtitle,
    @required this.onPressSearch
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(

          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                heading,
                textAlign: TextAlign.center,
                style: boldTextStyle(30,color: Colors.white),
              ),
              SizedBox(height: 25),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: normalTextStyle(18,color: Colors.white

                ),
              ),
              SizedBox(height: 25),
              TextButton(child: Text("START SEARCHING"), onPressed: onPressSearch),
            ],
          ),
        ),
      ),
    );
  }
}
