import 'package:flutter/material.dart';
import 'package:skyle_clone/pages/home/home_provider.dart';
import 'package:skyle_clone/services/safety/page_stateful.dart';
import 'package:skyle_clone/utils/app_extension.dart';
import 'package:skyle_clone/utils/app_log.dart';
import 'package:skyle_clone/utils/app_route.dart';
import 'package:skyle_clone/widgets/p_appbar_empty.dart';
import 'package:skyle_clone/widgets/w_keyboard_dismiss.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends PageStateful<HomePage> with WidgetsBindingObserver, RouteAware {
  HomeProvider homeProvider;

  @override
  void initDependencies(BuildContext context) {
    super.initDependencies(context);
    homeProvider = Provider.of(context, listen: false);
  }

  @override
  void afterFirstBuild(BuildContext context) {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppRoute.I.routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    /// Called when the current route has been pushed.
    logger.d('didPush');
  }

  @override
  void didPopNext() {
    /// Called when the top route has been popped off, and the current route
    /// shows up.
    logger.d('didPopNext');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AppRoute.I.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// Log app life cycle state
    logger.d(state);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PAppBarEmpty(
      child: WKeyboardDismiss(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.W),
                child: Text(context.strings.hello),
              ),

              /// As default, when user change language in device setting
              /// -> the locale will change appropriately
              /// This button provides user can change the locale manually
              TextButton(
                onPressed: () {
                  /// Get current locale
                  final Locale myLocale = Localizations.localeOf(context);
                  final String languageCode = myLocale.languageCode;

                  /// Change to new locale
                  if (languageCode == 'en') {
                    localeProvider.locale = const Locale('vi');
                  } else {
                    localeProvider.locale = const Locale('en');
                  }
                },
                child: const Text('Translate'),
              ),

              SizedBox(height: 10.H),

              /// Example to use selector instead consumer to optimize render performance
              Selector<HomeProvider, String>(
                selector: (_, HomeProvider provider) => provider.token?.toJson()?.toString() ?? '',
                builder: (_, String tokenInfo, __) {
                  return Text(
                    tokenInfo,
                    textAlign: TextAlign.center,
                  );
                },
              ),

              SizedBox(height: 10.H),

              /// Navigate to counter page with current timestamp as argument
              ElevatedButton(
                key: const Key(AppRoute.routeCounter),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoute.routeCounter, arguments: 'From Home ${DateTime.now()}');
                },
                child: const Text('Counter Page'),
              ),

              SizedBox(height: 10.H),

              /// Logout
              /// Navigate to login
              ElevatedButton(
                key: const Key(AppRoute.routeLogin),
                onPressed: () async {
                  logout(context);
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
