import 'package:flutter/material.dart';
import 'package:skyle_clone/utils/app_extension.dart';
import 'package:skyle_clone/utils/app_theme.dart';

/// Remember call super.build(context) in widget
abstract class BaseStateful<T extends StatefulWidget> extends State<T> {
  AppTheme appTheme;

  /// Context valid to create providers
  @mustCallSuper
  @protected
  void initDependencies(BuildContext context) {
    appTheme = context.appTheme();
  }

  @protected
  Future<void> afterFirstBuild(BuildContext context) async{}

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      if (mounted) {
        await afterFirstBuild(context);
      }
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    initDependencies(context);
    return null;
  }
}
