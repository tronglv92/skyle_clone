import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skyle_clone/services/app/app_loading.dart';
import 'package:skyle_clone/services/app/auth_provider.dart';
import 'package:skyle_clone/services/safety/page_stateful.dart';
import 'package:skyle_clone/utils/app_colors.dart';
import 'package:skyle_clone/utils/app_extension.dart';
import 'package:skyle_clone/utils/app_log.dart';
import 'package:skyle_clone/utils/app_route.dart';
import 'package:skyle_clone/utils/app_style.dart';
import 'package:skyle_clone/widgets/w_button_rounded.dart';
import 'package:skyle_clone/widgets/w_divider_line.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
class LoginPage extends StatefulWidget {

  const LoginPage();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends PageStateful<LoginPage> {

  AuthProvider _authProvider;
  AppLoading _appLoading;

  @override
  void initDependencies(BuildContext context) {
    super.initDependencies(context);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _appLoading = Provider.of(context, listen: false);
  }



  @override
  void initState() {
    super.initState();

  }

  onPressLogin() async{
    _appLoading.showLoading(context);
    User user=await _authProvider.loginByGoogle();
    logger.d(user.toString());
    if (user != null) {
      await authenticateUser(user);
    }
    _appLoading.hideLoading();
    Navigator.pushNamed(context, AppRoute.routeHome);
  }

  authenticateUser(User user) async{
    bool exits=await _authProvider.userExits(user);
    if(exits)
      {
        await _authProvider.addUserToFirebaseDb(user);
      }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width-100.W,
          height:50.H,
          child: WButtonRounded(
            background: Colors.redAccent,
            onPressed: onPressLogin,
            radius: 10,
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Icon(Entypo.google_,size: 30,color: Colors.white,),
                SizedBox(width: 15,),
                WDividerLine(width: 1,height: 50.H,color: Colors.black,),
                Expanded(child:  Center(child: Text("Login with Google", style: semiBoldTextStyle(18,color: Colors.white),)))



              ],
            ),
          ),
        ),
      ),
    );
  }


}
