import 'package:flutter/material.dart';
import 'package:orange_gallery/constants.dart';
import 'package:orange_gallery/theme.dart';

class CustomAppBar extends StatefulWidget {
  final String title;
  final List<Widget>? actions;
  const CustomAppBar({
    required this.title,
    this.actions,
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
      expandedHeight: 120.0,
      pinned: true,
      elevation: 1,
      actions: widget.actions,
      foregroundColor: orangeColor,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          top = constraints.biggest.height;
          return FlexibleSpaceBar(
            centerTitle: true,
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: 1.0,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                ),
                child: Row(
                  children: [
                    Text(
                      widget.title,
                      style: MyThemes.textTheme.headline5,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
