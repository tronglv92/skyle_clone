import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skyle_clone/models/local/contact.dart';
import 'package:skyle_clone/models/local/db_user.dart';
import 'package:skyle_clone/pages/home/pageviews/chat_list/views/contact_view.dart';
import 'package:skyle_clone/pages/home/pageviews/chat_list/views/quiet_box.dart';
import 'package:skyle_clone/services/app/auth_provider.dart';
import 'package:skyle_clone/services/app/chat_provider.dart';
import 'package:skyle_clone/services/safety/page_stateful.dart';
import 'package:skyle_clone/utils/app_colors.dart';
import 'package:skyle_clone/utils/app_log.dart';
import 'package:skyle_clone/utils/app_route.dart';
import 'package:skyle_clone/widgets/appbar.dart';

import 'views/new_chat_button.dart';
import 'views/user_circle.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends PageStateful<ChatListPage> {
  @override
  void initDependencies(BuildContext context) {
    super.initDependencies(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(),
    );
  }

  CustomAppBar customAppBar(BuildContext context) {
    // final UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      title: Selector<AuthProvider, DBUser>(
          selector: (_, AuthProvider provider) => provider.user,
          builder: (_, DBUser user, __) {
            return UserCircle(
              name: user?.name,
            );
          }),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.routeSearch);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}

class ChatListContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = context.read<ChatProvider>();

    return Selector<AuthProvider, DBUser>(
        selector: (_, AuthProvider provider) => provider.user,
        shouldRebuild: (DBUser before, DBUser after) {
          return before?.uid != after?.uid;
        },
        builder: (_, DBUser user, __) {
          logger.d("ChatListContainer build userID ${user?.uid}");
          return Container(
            child: StreamBuilder(
                stream: chatProvider.fetchContacts(
                  userId: user?.uid,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var docList = snapshot.data.docs;
                    if (docList.isEmpty) {
                      return QuietBox(
                        heading: "This is where all the contacts are listed",
                        subtitle:
                            "Search for your friends and family to start calling or chatting with them",
                        onPressSearch: () {
                          Navigator.of(context).pushNamed(AppRoute.routeSearch);
                        },
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: docList.length,
                      itemBuilder: (context, index) {
                        Contact contact =
                            Contact.fromJson(docList[index].data());
                        return ContactView(contact: contact);
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          );
        });
  }
}
