import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:orange_gallery/screens/album/albums_view_all_screen.dart';
import 'package:orange_gallery/screens/common/empty_screen.dart';
import 'package:orange_gallery/view_models/album_view_model.dart';
import 'package:orange_gallery/view_models/albums_view_model.dart';
import 'package:orange_gallery/view_models/medias_view_model.dart';

import 'package:orange_gallery/theme.dart';
import 'package:orange_gallery/widgets/custom_app_bar.dart';
import 'package:orange_gallery/widgets/custom_text_input_dialog.dart';
import 'package:orange_gallery/widgets/my_album.dart';
import 'package:orange_gallery/widgets/section_widget.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class AlbumsScreen extends StatelessWidget {
  const AlbumsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    PageController _pageCon =
        PageController(viewportFraction: 0.8, initialPage: 1);
    return NestedScrollView(
      key: const PageStorageKey<String>('AlbumScreen'),
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
      body: ListView(
        // child: Wrap(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFavorites(context),
          _buildAlbums(_screenHeight, context),
          _buildSuggestions(),
        ],
        // ),
      ),
    );
  }

  Widget _buildFavorites(BuildContext context) {
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

  Widget _buildAlbums(double screenHeight, BuildContext context) {
    return Selector<AlbumsViewModel, List<AlbumViewModel>>(
      selector: (context, albumsViewModel) {
        return albumsViewModel.allAlbums;
      },
      builder: (context, albums, child) {
        double sectionHeigh =
            (albums.length > 2) ? screenHeight * .5 : screenHeight * .3;
        int crossAxisCount = (albums.length > 2) ? 2 : 1;
        return SectionWidget(
          leading: SectionButton(
            label: (albums.isEmpty)
                ? tr('buttons.new_album')
                : 'buttons.see_all'.tr(),
            onPressed: () {
              if (albums.isEmpty) {
                //TODO-Add new album here
                showDialog(
                  context: context,
                  builder: (ctx) => CustomTextInputDialog(),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AlbumsViewAllScreen(),
                  ),
                );
              }
            },
          ),
          title: 'albums.title'.tr(),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: (albums.isEmpty)
                ? const EmptyScreen()
                : SizedBox(
                    height: sectionHeigh,
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: albums.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 6 / 5,
                      ),
                      itemBuilder: (context, index) {
                        return MyAlbum(
                          albumId: albums[index].id,
                          albumName: albums[index].albumName,
                          photoCount: albums[index].mediaCount,
                          bannerImage: albums[index].albumBanner,
                        );
                      },
                    ),
                  ),
          ),
        );
      },
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
