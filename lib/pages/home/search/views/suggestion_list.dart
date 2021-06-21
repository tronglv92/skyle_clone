import 'package:flutter/material.dart';
import 'package:skyle_clone/models/local/db_user.dart';
import 'package:skyle_clone/utils/app_colors.dart';
import 'package:skyle_clone/widgets/cached_image.dart';
import 'package:skyle_clone/widgets/custom_tile.dart';
class SuggestionList extends StatelessWidget {
  final List<DBUser> users;
  final Function onTap;
  SuggestionList({@required this.users,@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: ((context, index) {
      DBUser user=users[index];

        return CustomTile(
          mini: false,
          onTap: (){
            onTap(user);
          },
          leading: CachedImage(
            user.profilePhoto,
            radius: 25,
            isRound: true,
          ),
          // leading: CircleAvatar(
          //   backgroundImage: NetworkImage(searchedUser.profilePhoto),
          //   backgroundColor: Colors.grey,
          // ),
          title: Text(
            user.username,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            user.name,
            style: TextStyle(color: AppColors.greyColor),
          ),
        );
      }),
    );
  }
}
