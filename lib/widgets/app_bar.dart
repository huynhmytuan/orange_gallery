import 'package:flutter/material.dart';
import 'package:orange_gallery/constants.dart';
import 'package:orange_gallery/theme.dart';

class CustomAppBar extends StatefulWidget {
  final String title;
  final Widget? action;
  CustomAppBar({
    required this.title,
    this.action,
    Key? key,
  }) : super(key: key);
  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  var top = 0.0;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      backgroundColor: greyColor20,
      // expandedHeight: 100,
      floating: true,
      pinned: false,
      snap: true,

      bottom: PreferredSize(
        child: Text(
          widget.title,
          style: MyThemes.textTheme.headline5,
        ),
        preferredSize: MediaQuery.of(context).size * 0.05,
      ),
      // flexibleSpace: LayoutBuilder(
      //   builder: (BuildContext context, BoxConstraints constraints) {
      //     top = constraints.biggest.height;
      //     return FlexibleSpaceBar(
      //       centerTitle: true,
      //       title: AnimatedOpacity(
      //         duration: const Duration(milliseconds: 300),
      //         opacity: 1.0,
      //         child: Text(
      //           widget.title,
      //           style: MyThemes.textTheme.headline5,
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
