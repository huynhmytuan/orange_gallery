import 'package:flutter/material.dart';
import 'package:orange_gallery/widgets/custom_sliver_app_bar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: CustomSliverAppBar(expandedHeight: 200, title: 'Favorites'),
        ),
        buildImages(),
      ],
    );
  }

  Widget buildImages() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            crossAxisCount: 3,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(
              color: Colors.amber,
            ),
            childCount: 20,
          )),
    );
  }
}
