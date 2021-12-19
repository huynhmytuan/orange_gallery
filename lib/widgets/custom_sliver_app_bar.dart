import 'package:flutter/material.dart';
import 'package:orange_gallery/theme.dart';

class CustomSliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final String title;
  final List<Widget>? actions;

  CustomSliverAppBar(
      {required this.expandedHeight, required this.title, this.actions});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        buildTitleBanner(
          shrinkOffset,
        ),
        buildAppBar(shrinkOffset),
      ],
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildTitleBanner(double shrinkOffset) {
    return Opacity(
        opacity: disappear(shrinkOffset),
        child: Container(
          // color: Colors.amber,
          padding: const EdgeInsets.only(
            left: 20,
            top: 75,
          ),
          // alignment: Alignment.bottomLeft,
          child: Text(
            title,
            style: MyThemes.textTheme.headline5,
          ),
        ));
  }

  Widget buildAppBar(double shrinkOffset) {
    return Opacity(
      opacity: appear(shrinkOffset),
      child: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => expandedHeight;

  @override
  // TODO: implement minExtent
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    throw UnimplementedError();
  }
}
