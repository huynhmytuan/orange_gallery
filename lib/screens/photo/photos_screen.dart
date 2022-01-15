import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:orange_gallery/utils/constants.dart';

import 'package:orange_gallery/view_models/medias_view_model.dart';

import 'package:orange_gallery/view_models/selector_provider.dart';
import 'package:orange_gallery/theme.dart';

import 'package:orange_gallery/widgets/custom_app_bar.dart';
import 'package:orange_gallery/widgets/empty_%08handler_widget.dart';
import 'package:orange_gallery/widgets/grouped_grid.dart';
import 'package:provider/provider.dart';

class PhotosScreen extends StatefulWidget {
  static const routeName = '/photos-screen';
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  @override
  void initState() {
    Provider.of<MediasViewModel>(context, listen: false).fetchAllMedias();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediasViewModel = Provider.of<MediasViewModel>(context);
    return NestedScrollView(
      physics: const NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, value) {
        return [
          Consumer<SelectorProvider>(
            builder: (context, selector, child) => CustomAppBar(
              title: tr(
                'photos.title',
              ),
              actions: [
                if (selector.isSelectMode)
                  TextButton.icon(
                    icon: const Icon(Icons.clear),
                    label: Text(
                      plural('albums.item', selector.amount),
                      style: MyThemes.textTheme.button,
                    ),
                    onPressed: () {
                      selector.clearSelection();
                    },
                  ),
              ],
            ),
          ),
        ];
      },
      body: _buildPhotosView(mediasViewModel),
    );
  }

  Widget _buildPhotosView(MediasViewModel mediasViewModel) {
    switch (mediasViewModel.loadingStatus) {
      case LoadingStatus.empty:
        return const EmptyHandlerWidget();
      case LoadingStatus.completed:
        return GroupedGridView(assets: mediasViewModel.mediaAssets);
      default:
        return const Center(child: CircularProgressIndicator.adaptive());
    }
  }
}
