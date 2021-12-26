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
      expandedHeight: 110.0,
      floating: false,
      pinned: true,
      actions: widget.actions,
      foregroundColor: orangeColor,
      elevation: 5,
      centerTitle: false,
      backgroundColor: Theme.of(context).cardColor,
      title: Wrap(
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 25,
            height: 25,
          ),
          const Text(
            'Orange Gallery',
            style: TextStyle(
              fontFamily: 'Satisfy',
              fontSize: 18,
            ),
          ),
        ],
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.only(bottom: 10, left: 20),
          height: 200,
          child: Text(
            widget.title.toUpperCase(),
            style: MyThemes.textTheme.headline5,
          ),
        ),
      ),
    );
  }
}
