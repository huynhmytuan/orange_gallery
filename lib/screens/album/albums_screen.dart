import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:orange_gallery/theme.dart';
import 'package:orange_gallery/widgets/custom_app_bar.dart';
import 'package:orange_gallery/widgets/my_album.dart';
import 'package:orange_gallery/widgets/section_widget.dart';

class AlbumsScreen extends StatelessWidget {
  const AlbumsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    PageController _pageCon =
        PageController(viewportFraction: 0.8, initialPage: 1);
    return NestedScrollView(
      scrollBehavior: const ScrollBehavior(
        androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      ),
      headerSliverBuilder: (context, value) {
        return [
          CustomAppBar(
            title: tr('albums.title'),
            actions: [
              PopupMenuButton(itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    child: Text('data'),
                  ),
                  PopupMenuItem(child: Text('data')),
                  PopupMenuItem(child: Text('data')),
                ];
              })
            ],
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFavorites(),
            _buildAlbums(_screenHeight),
            _buildSuggestions(),
          ],
        ),
      ),
    );
  }

  Widget _buildFavorites() {
    return SectionWidget(
      title: 'albums.favorites.title'.tr(),
      child: Card(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
              height: 210,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "albums.favorites.favorites_album".tr(),
                style: MyThemes.textTheme.headline6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbums(double screenHeight) {
    return SectionWidget(
      leading: SectionButton(
        label: 'buttons.see_all'.tr(),
        onPressed: () {},
      ),
      title: 'albums.title'.tr(),
      child: SizedBox(
        height: screenHeight * .5,
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 6 / 5,
          ),
          itemBuilder: (context, index) {
            return const MyAlbum(
              albumId: 'put album id here',
              albumName: 'This is album name',
              photoCount: 0,
            );
          },
          itemCount: 5,
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return SectionWidget(
      leading: SectionButton(
        label: "buttons.see_all".tr(),
        onPressed: () {},
      ),
      title: 'albums.suggestions'.tr(),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: CircleAvatar(
                radius: 40,
                child: SizedBox(),
              ),
            );
          },
          itemCount: 10,
        ),
      ),
    );
  }
}
