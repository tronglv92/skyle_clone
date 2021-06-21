import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skyle_clone/pages/home/pageviews/chat_list/views/user_details_container.dart';
import 'package:skyle_clone/utils/app_colors.dart';
import 'package:skyle_clone/utils/app_helper.dart';
import 'package:skyle_clone/utils/helper/user_helper.dart';


class UserCircle extends StatelessWidget {

  final String name;
  UserCircle({this.name});
  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: AppColors.blackColor,
        builder: (context) => UserDetailsContainer(),
      ),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColors.separatorColor,
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                  name!=null?UserHelper.getInitials(name).toUpperCase():'',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightBlueColor,
                  fontSize: 13,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.blackColor, width: 2),
                  color: AppColors.onlineDotColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
