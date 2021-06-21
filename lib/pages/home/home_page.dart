import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skyle_clone/pages/home/home_provider.dart';
import 'package:skyle_clone/pages/home/pageviews/chat_list/chat_list_page.dart';
import 'package:skyle_clone/services/app/auth_provider.dart';
import 'package:skyle_clone/services/safety/page_stateful.dart';
import 'package:skyle_clone/utils/app_colors.dart';
import 'package:skyle_clone/utils/app_extension.dart';
import 'package:skyle_clone/utils/app_log.dart';
import 'package:skyle_clone/utils/app_route.dart';
import 'package:skyle_clone/utils/app_style.dart';
import 'package:skyle_clone/widgets/p_appbar_empty.dart';
import 'package:skyle_clone/widgets/w_keyboard_dismiss.dart';
import 'package:provider/provider.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends PageStateful<HomePage> with WidgetsBindingObserver {
  HomeProvider homeProvider;
  PageController pageController;
  AuthProvider _authProvider;
  int _page = 0;
  @override
  void initDependencies(BuildContext context) {
    super.initDependencies(context);
    logger.d("initDependencies");
    homeProvider = Provider.of(context, listen: false);
    _authProvider=Provider.of(context, listen: false);

  }
  @override
  Future<void> afterFirstBuild(BuildContext context) async{
    logger.d("afterFirstBuild");
    refreshUser();
  }


  void refreshUser() async{
    await _authProvider.refreshUser();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }



  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Log app life cycle state
    logger.d(state);
  }
  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }
  @override
  Widget build(BuildContext context) {
    double _labelFontSize = 10;
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: PageView(
        children: [
          Container(
            child: ChatListPage(),
          ),
          Center(
            child: Text(
              "Call Logs",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Center(
              child: Text(
                "Contact Screen",
                style: TextStyle(color: Colors.white),
              )),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child:  CupertinoTabBar(
            backgroundColor: AppColors.blackColor,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.chat,
                    color: (_page == 0)
                        ? AppColors.lightBlueColor
                        : AppColors.greyColor),
                title: Text(
                  "Chats",
                  style: normalTextStyle(
                       _labelFontSize,
                      color: (_page == 0)
                          ? AppColors.lightBlueColor
                          : Colors.grey),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.call,
                    color: (_page == 1)
                        ? AppColors.lightBlueColor
                        : AppColors.greyColor),
                title: Text(
                  "Calls",
                  style: normalTextStyle(
                      _labelFontSize,
                      color: (_page == 1)
                          ? AppColors.lightBlueColor
                          : Colors.grey),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contact_phone,
                    color: (_page == 2)
                        ? AppColors.lightBlueColor
                        : AppColors.greyColor),
                title: Text(
                  "Contacts",
                  style: normalTextStyle(
                      _labelFontSize,
                      color: (_page == 2)
                          ? AppColors.lightBlueColor
                          : Colors.grey),
                ),
              ),
            ],
            onTap: navigationTapped,
            currentIndex: _page,
          ),
        ),
      ),
    );
  }
}
