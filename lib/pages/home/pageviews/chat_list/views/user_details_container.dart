import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skyle_clone/models/local/db_user.dart';
import 'package:skyle_clone/services/app/auth_provider.dart';
import 'package:skyle_clone/services/safety/page_stateful.dart';
import 'package:skyle_clone/widgets/appbar.dart';
import 'package:skyle_clone/widgets/cached_image.dart';



class UserDetailsContainer extends StatefulWidget {
  @override
  _UserDetailsContainerState createState() => _UserDetailsContainerState();
}

class _UserDetailsContainerState extends PageStateful<UserDetailsContainer> {


  @override
  Widget build(BuildContext context) {
    super.build(context);


    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Column(
        children: <Widget>[
          CustomAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.maybePop(context),
            ),
            centerTitle: true,
            title: Text("Skyle Clone"),
            actions: <Widget>[
              TextButton(
                onPressed: () => logout(context),

                child: Text(
                  "Sign Out",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            ],
          ),
          UserDetailsBody(),
        ],
      ),
    );
  }
}


class UserDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DBUser currentUser=context.watch<AuthProvider>().user;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          CachedImage(
            currentUser.profilePhoto,
            isRound: true,
            radius: 50,
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                currentUser.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                currentUser.email,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
