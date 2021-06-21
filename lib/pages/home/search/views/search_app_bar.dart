import 'package:flutter/material.dart';

import 'package:skyle_clone/utils/app_colors.dart';
import 'package:skyle_clone/widgets/gradient_appbar.dart';
class SearchAppBar extends StatelessWidget implements PreferredSizeWidget{
  final TextEditingController searchController;
  final Function(String text) onChange;
  SearchAppBar({this.searchController,this.onChange});
  @override
  Widget build(BuildContext context) {
    return GradientAppBar(
      gradient: LinearGradient(
        colors: [
          AppColors.gradientColorStart,
          AppColors.gradientColorEnd,
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 10),

        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: onChange,
            cursorColor: AppColors.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  final Size preferredSize = const Size.fromHeight(kToolbarHeight+50);
}
