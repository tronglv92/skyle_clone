import 'package:flutter/material.dart';
import 'package:skyle_clone/models/local/db_user.dart';
import 'package:skyle_clone/pages/home/search/views/suggestion_list.dart';
import 'package:skyle_clone/services/app/auth_provider.dart';
import 'package:skyle_clone/services/safety/page_stateful.dart';
import 'package:skyle_clone/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:skyle_clone/utils/app_log.dart';
import 'package:skyle_clone/utils/app_route.dart';
import 'views/search_app_bar.dart';
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends PageStateful<SearchPage> {
  TextEditingController searchController;
  AuthProvider _authProvider;
  String search='';

  List<DBUser> usersSuggestion=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController=TextEditingController();
  }

  @override
  void initDependencies(BuildContext context) {
    super.initDependencies(context);
    _authProvider=Provider.of(context,listen: false);
  }
  @override
  Future<void> afterFirstBuild(BuildContext context)  async{
    super.afterFirstBuild(context);
    logger.d("afterFirstBuild");
    List<DBUser> users=await _authProvider.fetchAllUsers(_authProvider.user);
    setState(() {
      usersSuggestion=users;

    });
  }
  onSearchChange(String _search)
  {
    setState(() {
      search = _search;
    });
  }

  onPressItem(DBUser receiver){
    Navigator.of(context).pushNamed(AppRoute.routeChat,arguments:receiver );
  }

  @override
  Widget build(BuildContext context) {

    List<DBUser> suggestionList=search.isEmpty?[]:usersSuggestion.where((user) {
      String username=user.username.toLowerCase();
      String name=user.name.toLowerCase();
      bool matchesName=name.contains(search.toLowerCase());
      bool matchesUserName=username.contains(search.toLowerCase());
      return matchesName || matchesUserName;
    }).toList();
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: SearchAppBar(searchController: searchController,onChange:onSearchChange ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SuggestionList(users: suggestionList,onTap:onPressItem),
      ),
    )
    ;
  }


}
