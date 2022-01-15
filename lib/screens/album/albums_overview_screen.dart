import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orange_gallery/widgets/empty_%08handler_widget.dart';
import 'package:provider/provider.dart';

import 'package:orange_gallery/screens/album/albums_view_all_screen.dart';

import 'package:orange_gallery/screens/common/media_picker_screen.dart';
import 'package:orange_gallery/view_models/album_view_model.dart';
import 'package:orange_gallery/view_models/albums_view_model.dart';
import 'package:orange_gallery/theme.dart';
import 'package:orange_gallery/view_models/selector_provider.dart';
import 'package:orange_gallery/widgets/custom_app_bar.dart';
import 'package:orange_gallery/widgets/album_name_input_dialog.dart';
import 'package:orange_gallery/widgets/my_album.dart';
import 'package:orange_gallery/widgets/section_widget.dart';

class AlbumsScreen extends StatelessWidget {
  static const routeName = '/album-overview';
  const AlbumsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    PageController _pageCon =
        PageController(viewportFraction: 0.8, initialPage: 1);
    return LayoutBuilder(builder: (context, contain) {
      return NestedScrollView(
        key: const PageStorageKey<String>('AlbumScreen'),
        headerSliverBuilder: (context, value) {
          return [
            CustomAppBar(
              title: tr('albums.title'),
            ),
          ];
        },
        body: ListView(
          children: [
            _buildAlbums(_screenHeight, context),
            _buildSuggestions(),
          ],
          // ),
        ),
      );
    });
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
                ).then((albumName) {
                  if (albumName != null) {
                    showBottomSheet(
                      context: context,
                      builder: (context) => MediaPickerScreen(
                        actionName: tr("buttons.add"),
                        action: () {
                          final selector = Provider.of<SelectorProvider>(
                              context,
                              listen: false);
                          final selections = selector.selections;
                          Provider.of<AlbumsViewModel>(context, listen: false)
                              .createAlbum(albumName, selections)
                              .then(
                            (value) {
                              if (!value) {
                                Fluttertoast.showToast(
                                    msg: tr('notice.create_album_fail'));
                              }
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    );
                  }
                }).then(
                  (value) {
                    Provider.of<SelectorProvider>(context, listen: false)
                        .clearSelection();
                  },
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
          child: (albums.isEmpty)
              ? const EmptyHandlerWidget()
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
