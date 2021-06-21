import 'package:flutter/material.dart';
import 'package:skyle_clone/models/local/db_user.dart';
import 'package:skyle_clone/pages/chat/chat_page.dart';
import 'package:skyle_clone/pages/counter/counter_page.dart';
import 'package:skyle_clone/pages/counter/counter_provider.dart';
import 'package:skyle_clone/pages/home/home_page.dart';
import 'package:skyle_clone/pages/home/home_provider.dart';
import 'package:skyle_clone/pages/home/pageviews/chat_list/pick_file_example.dart';
import 'package:skyle_clone/pages/home/search/search_page.dart';
import 'package:skyle_clone/pages/login/login_page.dart';
import 'package:skyle_clone/pages/login/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AppRoute {
  factory AppRoute() => _instance;

  AppRoute._private();

  ///#region ROUTE NAMES
  /// -----------------
  static const String routeRoot = '/';
  static const String routeHome = '/home';
  static const String routeLogin = '/login';
  static const String routeCounter = '/counter';
  static const String routeSearch = '/search';
  static const String routeChat='/chat';
  ///#endregion

  static final AppRoute _instance = AppRoute._private();

  static AppRoute get I => _instance;

  /// Create local provider
  // MaterialPageRoute<dynamic>(
  //             settings: settings,
  //             builder: (_) => AppRoute.createProvider(
  //                 (_) => HomeProvider(),
  //                 HomePage(
  //                   status: settings.arguments as bool,
  //                 )))
  static Widget createProvider<P extends ChangeNotifier>(
    P Function(BuildContext context) provider,
    Widget child,
  ) {
    return ChangeNotifierProvider<P>(
      create: provider,
      builder: (_, __) {
        return child;
      },
    );
  }

  /// Create multi local provider
  // MaterialPageRoute<dynamic>(
  //             settings: settings,
  //             builder: (_) => AppRoute.createProviders(
  //                 <SingleChildWidget>[
  //                     ChangeNotifierProvider<HomeProvider>(
  //                         create: (BuildContext context) => HomeProvider()),
  //                 ],
  //                 HomePage(
  //                   status: settings.arguments as bool,
  //                 )))
  static Widget createProviders(
    List<SingleChildWidget> providers,
    Widget child,
  ) {
    return MultiProvider(
      providers: providers ?? <SingleChildWidget>[],
      child: child,
    );
  }

  /// App route observer
  final RouteObserver<Route<dynamic>> routeObserver = RouteObserver<Route<dynamic>>();

  /// App global navigator key
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Get app context
  BuildContext get appContext => navigatorKey.currentContext;

  /// Generate route for app here
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeCounter:
        return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (_) => AppRoute.createProvider(
                  (_) => CounterProvider(),
                  CounterPage(argument: settings.arguments as String),
                ));

      case routeHome:
        return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (_) => AppRoute.createProvider(
                  (BuildContext context) => HomeProvider(),
                  const HomePage(),
                ));

      case routeRoot:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {

            return  FilePickerDemo();
          },
        );
      case routeLogin:
        return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (_) => AppRoute.createProvider(
                  (_) => LoginProvider(),
                  const LoginPage(),
                ));
      case routeSearch:
        return MaterialPageRoute<dynamic>(
            settings: settings,
            builder: (_) => SearchPage(),
            );
      case routeChat:
        return MaterialPageRoute<dynamic>(
          settings: settings,
          builder: (_) {
            DBUser receiver= settings.arguments;
            return  ChatPage(receiver: receiver,);
          },
        );
      default:
        return null;
    }
  }
}
