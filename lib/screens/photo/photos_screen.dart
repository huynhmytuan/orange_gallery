import 'package:flutter/material.dart';
import 'package:orange_gallery/widgets/custom_sliver_app_bar.dart';

class PhotosScreen extends StatelessWidget {
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: CustomSliverAppBar(expandedHeight: 200, title: 'Photos'),
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
            crossAxisCount: 2,
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
