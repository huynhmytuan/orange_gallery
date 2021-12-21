import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:orange_gallery/widgets/app_bar.dart';

class PhotosScreen extends StatelessWidget {
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, value) {
        return [
          CustomAppBar(
            title: tr('photos.title'),
          ),
        ];
      },
      body: buildImages(),
    );
  }

  Widget buildImages() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) => Container(
            color: Colors.green,
            child: Image.network(
              "https://imagecolorpicker.com/imagecolorpicker.png",
              fit: BoxFit.cover,
            ),
          ),
          staggeredTileBuilder: (int index) =>
              StaggeredTile.count(2, index.isEven ? 2 : 1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ));
  }
}
