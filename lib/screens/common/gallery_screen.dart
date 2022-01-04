import 'dart:typed_data';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:orange_gallery/view_models/media_asset_view_model.dart';

import 'package:video_player/video_player.dart';

import 'package:orange_gallery/utils/string_extension.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryScreen extends StatefulWidget {
  final PageController _pageController;
  List<MediaAssetViewModel> assets;
  final int index;
  GalleryScreen({
    Key? key,
    required this.assets,
    this.index = 0,
  })  : _pageController =
            PageController(initialPage: index, viewportFraction: 1.05),
        super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animation;
  VideoPlayerController? _videoPlayerController;
  late int currentIndex = widget.index;
  bool isFullScreen = false;
  bool _disposed = false;
  // bool isPlaying = false;

  @override
  void initState() {
    _animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _initializeAndPlay(currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    _disposed = true;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    if (_videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized) {
      _videoPlayerController?.pause(); // mute instantly
      _videoPlayerController?.dispose();
    }

    super.dispose();
  }

  void _toggleFullScreen() async {
    setState(() {
      isFullScreen = !isFullScreen;
    });
    if (isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    }
  }

  void _initializeAndPlay(int index) async {
    final oldController = _videoPlayerController;
    if (oldController != null) {
      oldController.pause();
    }
    final media = widget.assets[index];
    if (media.mediaType == AssetType.video) {
      final videoFile = await media.file;
      final controller = VideoPlayerController.file(
        videoFile!,
      );
      _videoPlayerController = controller;
      controller.initialize().then(
        (_) {
          oldController?.dispose();
          controller.play();
          _animation.reverse();
          setState(() {});
        },
      );
    } else {
      return;
    }
  }

  void _togglePlayButton() {
    if (_videoPlayerController != null &&
        _videoPlayerController!.value.isPlaying) {
      _animation.forward();
      _videoPlayerController!.pause();
    } else {
      _animation.reverse();
      _videoPlayerController!.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _buildAppBar(deviceSize),
      body: GestureDetector(
        onTap: () => _toggleFullScreen(),
        child: PhotoViewGallery.builder(
          gaplessPlayback: true,
          onPageChanged: (index) {
            if (widget.assets[currentIndex].mediaType !=
                widget.assets[index].mediaType) {
              setState(() {
                // currentIndex = index;
              });
              currentIndex = index;
            } else {
              currentIndex = index;
            }
            _initializeAndPlay(index);
          },
          pageController: widget._pageController,
          scrollPhysics: const BouncingScrollPhysics(),
          itemCount: widget.assets.length,
          builder: (context, index) {
            final media = widget.assets[index];
            if (media.mediaType == AssetType.image) {
              return _buildImageView(media);
            }
            return _buildVideoPlayer(media, index, deviceSize);
          },
        ),
      ),
      // ),
      bottomNavigationBar: _buildBottomBar(deviceSize),
    );
  }

  PhotoViewGalleryPageOptions _buildImageView(MediaAssetViewModel media) {
    return PhotoViewGalleryPageOptions.customChild(
      heroAttributes: PhotoViewHeroAttributes(
        tag: media.id,
      ),
      child: FractionallySizedBox(
        widthFactor: 1 / widget._pageController.viewportFraction,
        child: ImageView(
          asset: media,
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildVideoPlayer(
      MediaAssetViewModel media, int index, Size deviceSize) {
    return PhotoViewGalleryPageOptions.customChild(
      heroAttributes: PhotoViewHeroAttributes(
        tag: media.id,
      ),
      // minScale: PhotoViewComputedScale.contained,
      // maxScale: PhotoViewComputedScale.contained * 5,
      disableGestures: true,
      child: FractionallySizedBox(
        widthFactor: 1 / widget._pageController.viewportFraction,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: (currentIndex != index)
              ? FutureBuilder<Uint8List?>(
                  future: media.thumbnail,
                  builder: (_, thumbnailSnapshot) {
                    if (thumbnailSnapshot.hasData) {
                      return Center(
                        child: AspectRatio(
                          aspectRatio: media.width / media.height,
                          child: Image.memory(
                            thumbnailSnapshot.data!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    return SizedBox();
                  },
                )
              : FutureBuilder<File?>(
                  future: media.file,
                  builder: (_, snapshot) {
                    final file = snapshot.data;
                    if (file != null &&
                        _videoPlayerController != null &&
                        _videoPlayerController!.value.isInitialized) {
                      return Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio:
                                  _videoPlayerController!.value.aspectRatio,
                              child: VideoPlayer(
                                _videoPlayerController!,
                              ),
                            ),
                            // if (widget.assets[index].mediaType ==
                            //     AssetType.video)
                            _buildPlayButton()
                          ],
                        ),
                      );
                    }
                    return AspectRatio(
                      aspectRatio: media.width / media.height,
                      child: const CircularProgressIndicator.adaptive(),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Positioned(
      child: Material(
        color: Colors.transparent,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isFullScreen
              ? null
              : Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(.6),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    iconSize: 35,
                    splashRadius: 15,
                    onPressed: () {
                      _togglePlayButton();
                    },
                    icon: AnimatedIcon(
                      color: Colors.white,
                      progress: _animation,
                      icon: AnimatedIcons.pause_play,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  PreferredSize _buildAppBar(Size deviceSize) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50), // Set this height
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isFullScreen
            ? null
            : AppBar(
                centerTitle: true,
                title: Column(
                  children: [
                    Text(
                      DateFormat.yMMMMEEEEd(context.locale.languageCode)
                          .format(widget.assets[currentIndex].createDt)
                          .capitalize(),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      DateFormat.Hm(context.locale.languageCode)
                          .format(widget.assets[currentIndex].createDt),
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                backgroundColor: Theme.of(context).cardColor,
                elevation: 2,
              ),
      ),
    );
  }

  Widget _buildBottomBar(Size deviceSize) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: isFullScreen
          ? null
          : BottomAppBar(
              child: Container(
                // height: 50,
                height: deviceSize.height * .1,
                width: deviceSize.width,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    if (widget.assets[currentIndex].mediaType ==
                        AssetType.video)
                      Row(
                        // direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text('00:00'),
                          Expanded(
                            child: Slider(
                              value: 30,
                              min: 0,
                              max: 100,
                              onChanged: (value) {},
                            ),
                          ),
                          Text(''.formatDuration(
                              widget.assets[currentIndex].duration)),
                        ],
                      )
                  ],
                ),
              ),
            ),
    );
  }
}

class ImageView extends StatelessWidget {
  final MediaAssetViewModel asset;
  const ImageView({required this.asset, Key? key}) : super(key: key);

// Laadas akdmaskdm
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<File?>(
        future: asset.file,
        builder: (_, snapshot) => PageTransitionSwitcher(
          transitionBuilder: (child, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeIn,
              ),
              child: child,
            );
          },
          //TODO: Fix duration without flashing please
          duration: const Duration(milliseconds: 300),
          child: (snapshot.hasData)
              ? Image.file(
                  snapshot.data!,
                )
              : AspectRatio(
                  aspectRatio: asset.width / asset.height,
                  child: FutureBuilder<Uint8List?>(
                    future: asset.thumbnail,
                    builder: (_, thumbnail) {
                      final bytes = thumbnail.data;
                      if (thumbnail.hasData) {
                        return Image.memory(
                          bytes!,
                          fit: BoxFit.contain,
                        );
                      }
                      return const CircularProgressIndicator.adaptive();
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
