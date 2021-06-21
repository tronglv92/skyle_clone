import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skyle_clone/models/local/contact.dart';
import 'package:skyle_clone/models/local/db_user.dart';
import 'package:skyle_clone/models/local/message.dart';
import 'package:skyle_clone/services/app/auth_provider.dart';
import 'package:skyle_clone/services/app/chat_provider.dart';
import 'package:skyle_clone/utils/app_route.dart';
import 'package:skyle_clone/utils/app_style.dart';
import 'package:skyle_clone/widgets/cached_image.dart';
import 'package:skyle_clone/widgets/custom_tile.dart';

import 'last_message_container.dart';
import 'online_dot_indicator.dart';

class ContactView extends StatelessWidget {
  final Contact contact;

  ContactView({@required this.contact});
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider=context.read<AuthProvider>();

    return FutureBuilder(
        future: authProvider.getUserDetailsById(contact?.uid),
        builder: (BuildContext context,snapShot)
        {
          if(snapShot.hasData)
            {
              DBUser user=snapShot.data;
              return ViewLayout(contact: user,);

            }
          return  Center(
            child: CircularProgressIndicator(),
          );
          return ViewLayout();
        });

  }
}

class ViewLayout extends StatelessWidget {

  final DBUser contact;

  ViewLayout({this.contact});
  @override
  Widget build(BuildContext context) {

    AuthProvider authProvider=context.read<AuthProvider>();

    return CustomTile(
      mini: false,
      onTap: () {
        Navigator.of(context).pushNamed(AppRoute.routeChat,arguments:contact );

      },
      title: Text(
        contact.name!=null?contact.name:"",
        style:
        normalTextStyle(19,color: Colors.white),
      ),
      subtitle: StreamBuilder(
        stream: context.read<ChatProvider>().fetchMessagesBetween(senderId: authProvider.user?.uid,receiverId:contact?.uid ),
        builder: (BuildContext context,snapShot)
        {
          if(snapShot.hasData)
            {
              var docsList= snapShot.data.docs;
              if(docsList.isNotEmpty)
                {
                  Message lastMessage=Message.fromJson(docsList.first.data());
                  return LastMessageContainer(lastMessage:lastMessage.message );
                }
              else
                {
                  return Text('No Message',style: normalTextStyle(14,color: Colors.grey),) ;
                }

            }
            return Text('..',style: normalTextStyle(14,color: Colors.grey),) ;
        }
         ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact?.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(),
          ],
        ),
      ),
    );
  }
}
