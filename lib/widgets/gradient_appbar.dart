import 'package:flutter/material.dart';
import 'package:skyle_clone/utils/app_colors.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Gradient gradient;
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;
  final PreferredSize bottom;

  GradientAppBar(
      {Key key,
      @required this.gradient,
      this.title,
      this.actions = const [],
      @required this.leading,
      this.centerTitle = true,
      this.bottom})
      : preferredSize = Size.fromHeight(
            kToolbarHeight + (bottom?.preferredSize?.height ?? 0.0)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
        bottom: bottom,
      ),
    );
  }

  final Size preferredSize;
}
