import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:orange_gallery/utils/constants.dart';
import 'package:orange_gallery/widgets/custom_delete_dialog.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'package:orange_gallery/screens/album/albums_view_all_screen.dart';
import 'package:orange_gallery/screens/common/album_chose.dart';
import 'package:orange_gallery/theme.dart';
import 'package:orange_gallery/utils/string_extension.dart';
import 'package:orange_gallery/view_models/albums_view_model.dart';
import 'package:orange_gallery/view_models/media_view_model.dart';
import 'package:orange_gallery/view_models/medias_view_model.dart';
import 'package:orange_gallery/widgets/album_name_input_dialog.dart';
import 'package:orange_gallery/widgets/bottom_tool_bar.dart';
import 'package:orange_gallery/widgets/hero.dart';
import 'package:orange_gallery/widgets/loading_dialog.dart';

typedef DoubleClickAnimationListener = void Function();

class GalleryViewScreen extends StatefulWidget {
  final ExtendedPageController _pageController;
  List<MediaViewModel> assets;
  final int index;
  GalleryViewScreen({
    Key? key,
    required this.assets,
    this.index = 0,
  })  : _pageController = ExtendedPageController(
          initialPage: index,
          pageSpacing: 10,
          shouldIgnorePointerWhenScrolling: false,
        ),
        super(key: key);

  @override
  _GalleryViewScreenState createState() => _GalleryViewScreenState();
}

class _GalleryViewScreenState extends State<GalleryViewScreen>
    with TickerProviderStateMixin {
  final StreamController<bool> rebuildOverlay =
      StreamController<bool>.broadcast();
  GlobalKey<ExtendedImageSlidePageState> slidePageKey =
      GlobalKey<ExtendedImageSlidePageState>();
  Color? backgroundColor;
  late AnimationController _playButtonAnimation;
  late AnimationController _doubleClickAnimationController;
  Animation<double>? _doubleClickAnimation;
  late DoubleClickAnimationListener _doubleClickAnimationListener;
  VideoPlayerController? _videoPlayerController;
  late int mediaCount;
  late int currentIndex;
  List<double> doubleTapScales = <double>[1.0, 3.0];
  bool isFullScreen = false;
  bool _disposed = false;
  double _progress = 0.0;
  double opacity = 1.0;
  bool _isPlaying = false;
  // double _updateProgressInterval = 0.0;
  Duration? _duration;
  Duration? _position;

  @override
  void initState() {
    currentIndex = widget.index;
    mediaCount = widget.assets.length;
    _initializeAndPlay(currentIndex);
    _doubleClickAnimationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    _playButtonAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    _disposed = true;
    _doubleClickAnimationController.dispose();
    _playButtonAnimation.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    if (_videoPlayerController != null) {
      _videoPlayerController?.pause(); // mute instantly
      _videoPlayerController?.dispose();
    }
    PhotoManager.releaseCache();
    super.dispose();
  }

  void _toggleHideStatusBar() {
    isFullScreen = !isFullScreen;
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
      oldController.removeListener(_onControllerUpdated);
      oldController.pause();
    }
    final media = widget.assets[index];
    if (media.mediaType != AssetType.video) {
      return;
    }
    File? videoFile = await media.file;
    final controller = VideoPlayerController.file(videoFile!);
    _videoPlayerController = controller;
    controller.initialize().then(
      (_) {
        oldController?.dispose();
        _duration = null;
        _position = null;
        controller.addListener(_onControllerUpdated);
        controller.play();
        _playButtonAnimation.reverse();
        _isPlaying = true;
        setState(() {});
      },
    );
  }

  void _onControllerUpdated() async {
    if (_disposed) return;
    // final now = DateTime.now().millisecondsSinceEpoch;
    // if (_updateProgressInterval > now) {
    //   return;
    // }
    // _updateProgressInterval = now + 200.0;

    final controller = _videoPlayerController;
    if (controller == null) return;
    if (!controller.value.isInitialized) return;
    _duration ??= _videoPlayerController!.value.duration;
    var duration = _duration;
    if (duration == null) return;

    var position = await controller.position;
    final isEndOfClip = position!.inMilliseconds > 0 &&
        position.inMilliseconds + 500 >= duration.inMilliseconds;
    setState(
      () {
        _position = position;
        _progress = position.inMilliseconds.ceilToDouble() /
            duration.inMilliseconds.ceilToDouble();
      },
    );
    if (isEndOfClip) {
      _isPlaying = false;
      _playButtonAnimation.forward();
    }
  }

  void _togglePlayButton() {
    if (_videoPlayerController != null &&
        _videoPlayerController!.value.isPlaying) {
      _playButtonAnimation.forward();
      _videoPlayerController!.pause();
      _isPlaying = false;
    } else {
      _playButtonAnimation.reverse();
      _videoPlayerController!.play();
      _isPlaying = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    backgroundColor = (isFullScreen)
        ? Colors.black
        : Theme.of(context).scaffoldBackgroundColor;
    final deviceSize = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: ExtendedImageSlidePage(
        key: slidePageKey,
        onSlidingPage: (state) {
          final _showOverlay = !state.isSliding;
          rebuildOverlay.add(_showOverlay);
          if (isFullScreen && !state.isSliding) {
            _toggleHideStatusBar();
          }
        },
        slidePageBackgroundHandler: (offset, pageSize) {
          double dyOffset = offset.dy;
          if (dyOffset != 0) {
            opacity = 1 - (dyOffset.abs() / pageSize.height);
            return backgroundColor!.withOpacity(opacity);
          }
          return backgroundColor!;
        },
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(deviceSize),
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onTap: () {
              rebuildOverlay.add(isFullScreen);
              _toggleHideStatusBar();
            },
            child: ExtendedImageGesturePageView.builder(
              onPageChanged: (index) {
                final beforeMediaType = widget.assets[currentIndex].mediaType;
                final afterMediaType = widget.assets[index].mediaType;
                currentIndex = index;
                _initializeAndPlay(currentIndex);
                rebuildOverlay.add(!isFullScreen);
              },
              itemCount: widget.assets.length,
              controller: widget._pageController,
              itemBuilder: (ctx, index) {
                final media = widget.assets[index];
                return (media.mediaType == AssetType.video)
                    ? _buildVideoPlayer(media, index)
                    : _buildImageView(media);
              },
            ),
          ),
          bottomNavigationBar: _buildBottomBar(deviceSize),
        ),
        slideAxis: SlideAxis.vertical,
      ),
    );
  }

  Widget _buildImageView(MediaViewModel media) {
    return FutureBuilder<File?>(
      key: Key(media.id + "future"),
      future: media.file,
      builder: (ctx, snapshot) => HeroWidget(
        tag: media.id,
        slidePagekey: slidePageKey,
        slideType: SlideType.onlyImage,
        child: (!snapshot.hasData)
            ? FutureBuilder<Uint8List?>(
                future: media.thumbnail,
                builder: (_, thumbnail) => (thumbnail.hasData)
                    ? Container(
                        height: media.height.toDouble(),
                        width: media.width.toDouble(),
                        child: AspectRatio(
                          aspectRatio: media.height / media.width,
                          child: ExtendedImage.memory(
                            thumbnail.data!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : const CircularProgressIndicator.adaptive(),
              )
            : ExtendedImage.file(
                snapshot.data!,
                key: Key(media.id + 'image'),
                clearMemoryCacheWhenDispose: true,
                enableSlideOutPage: true,
                gaplessPlayback: true,
                imageCacheName: media.id,
                fit: BoxFit.contain,
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: (state) {
                  return GestureConfig(
                    inPageView: true,
                    initialScale: 1.0,
                    minScale: 1.0,
                    maxScale: 5.0,
                    initialAlignment: InitialAlignment.center,
                  );
                },
                onDoubleTap: (state) {
                  //default value is double tap pointer down postion.
                  final Offset? pointerDownPosition = state.pointerDownPosition;
                  final double? begin = state.gestureDetails!.totalScale;
                  double end;
                  //remove old
                  _doubleClickAnimation
                      ?.removeListener(_doubleClickAnimationListener);
                  //stop pre
                  _doubleClickAnimationController.stop();
                  //reset to use
                  _doubleClickAnimationController.reset();
                  if (begin == doubleTapScales[0]) {
                    end = doubleTapScales[1];
                  } else {
                    end = doubleTapScales[0];
                  }
                  _doubleClickAnimationListener = () {
                    state.handleDoubleTap(
                        scale: _doubleClickAnimation!.value,
                        doubleTapPosition: pointerDownPosition);
                  };
                  _doubleClickAnimation = _doubleClickAnimationController
                      .drive(Tween<double>(begin: begin, end: end));
                  _doubleClickAnimation!
                      .addListener(_doubleClickAnimationListener);
                  _doubleClickAnimationController.forward();
                },
              ),
      ),
    );
  }

  Widget _buildVideoPlayer(media, index) {
    Widget videoView = (_videoPlayerController != null &&
            _videoPlayerController!.value.isInitialized)
        ? Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _videoPlayerController!.value.aspectRatio,
                  child: VideoPlayer(
                    _videoPlayerController!,
                  ),
                ),
                _buildPlayButton()
              ],
            ),
          )
        : Center(
            child: AspectRatio(
            aspectRatio: media.width / media.height,
            child: const CircularProgressIndicator.adaptive(),
          ));
    return ExtendedImageSlidePageHandler(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
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
                  return Center(
                    child: AspectRatio(
                      aspectRatio: media.width / media.height,
                      child: const CircularProgressIndicator.adaptive(),
                    ),
                  );
                },
              )
            : videoView,
      ),
      heroBuilderForSlidingPage: (Widget result) {
        return Hero(
          tag: media.id,
          child: result,
          flightShuttleBuilder: (BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext) {
            final Hero hero = (flightDirection == HeroFlightDirection.pop
                ? fromHeroContext.widget
                : toHeroContext.widget) as Hero;

            return hero.child;
          },
        );
      },
    );
  }

  Widget _buildPlayButton() {
    return Positioned(
      child: Material(
        color: Colors.transparent,
        child: StreamBuilder<bool>(
            initialData: true,
            stream: rebuildOverlay.stream,
            builder: (context, snapshot) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isFullScreen
                    ? null
                    : Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(.6),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: IconButton(
                          iconSize: 35,
                          splashRadius: 25,
                          onPressed: () {
                            _togglePlayButton();
                          },
                          icon: AnimatedIcon(
                            color: Colors.white,
                            progress: _playButtonAnimation,
                            icon: AnimatedIcons.pause_play,
                          ),
                        ),
                      ),
              );
            }),
      ),
    );
  }

  PreferredSize _buildAppBar(Size deviceSize) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: StreamBuilder<bool>(
          initialData: true,
          stream: rebuildOverlay.stream,
          builder: (context, snapshot) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: (snapshot.data == null || !snapshot.data!)
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
            );
          }),
    );
  }

  Widget _buildBottomBar(Size deviceSize) {
    final noMute = (_videoPlayerController?.value.volume ?? 0) > 0;
    return StreamBuilder<bool>(
      stream: rebuildOverlay.stream,
      initialData: true,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: (snapshot.data == null || !snapshot.data!)
              ? null
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: (widget.assets[currentIndex].mediaType ==
                                  AssetType.video &&
                              _videoPlayerController != null)
                          ? _buildVideoControlUI()
                          : const SizedBox(),
                    ),
                    BottomToolBar(
                      onAddPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (ctx) => AlbumChose(
                            selectionsMedia: [widget.assets[currentIndex]],
                          ),
                        ).then((value) {
                          if (value == 'create_new') {
                            showDialog(
                              context: context,
                              builder: (ctx) => CustomTextInputDialog(),
                            ).then(
                              (albumName) {
                                if (albumName != null) {
                                  Provider.of<AlbumsViewModel>(context,
                                          listen: false)
                                      .createAlbum(albumName,
                                          [widget.assets[currentIndex]]).then(
                                    (value) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => AlbumsViewAllScreen(),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          }
                          if (value == 'add_to_album') {
                            Navigator.of(context).restorablePopAndPushNamed(
                                AlbumsViewAllScreen.routeName);
                          }
                        });
                      },
                      onSharePressed: () async {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return const LoadingDialog();
                          },
                        );
                        Provider.of<MediasViewModel>(context, listen: false)
                            .shareMedias([widget.assets[currentIndex]]).then(
                                (value) => Navigator.pop(context));
                      },
                      onDeletePressed: () async {
                        final media = widget.assets[currentIndex];
                        final mediasAssetViewModel =
                            Provider.of<MediasViewModel>(context,
                                listen: false);
                        if (Platform.isIOS) {
                          await mediasAssetViewModel.deleteAssets([media],
                              context).then((value) => Navigator.pop(context));
                        } else if (Platform.isAndroid) {
                          showDialog(
                            context: context,
                            builder: (ctx) {
                              return const CustomDeleteDialog(
                                mediasDeleteCount: 1,
                              );
                            },
                          ).then(
                            (result) async {
                              if (result == ConfirmAction.Accept) {
                                await mediasAssetViewModel
                                    .deleteAssets([media], context).then(
                                        (value) => Navigator.pop(context));
                              }
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildVideoControlUI() {
    final noMute = (_videoPlayerController?.value.volume ?? 0) > 0;
    return SafeArea(
      top: false,
      bottom: false,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                ''.formatDuration(_position?.inSeconds ?? 0),
                style: MyThemes.textTheme.bodyText2,
              ),
              Expanded(
                child: Slider(
                  value: max(0, min(_progress * 100, 100)),
                  min: 0,
                  max: 100,
                  onChanged: (value) {
                    setState(
                      () {
                        _progress = value * 0.01;
                        var newValue = max(0, min(value, 99)) * 0.01;
                        final duration = _videoPlayerController?.value.duration;
                        if (duration != null) {
                          {
                            var millis =
                                (duration.inMilliseconds * newValue).toInt();
                            _videoPlayerController
                                ?.seekTo(Duration(milliseconds: millis));
                          }
                        }
                      },
                    );
                  },
                  onChangeStart: (value) {
                    _playButtonAnimation.forward();
                    _videoPlayerController?.pause();
                  },
                  onChangeEnd: (value) {
                    if (_isPlaying) {
                      _playButtonAnimation.reverse();
                      _videoPlayerController?.play();
                    }
                  },
                ),
              ),
              Text(
                ''.formatDuration(
                    _videoPlayerController!.value.duration.inSeconds),
                style: MyThemes.textTheme.bodyText2,
              ),
              IconButton(
                splashRadius: 20,
                onPressed: () {
                  if (noMute) {
                    _videoPlayerController?.setVolume(0);
                  } else {
                    _videoPlayerController?.setVolume(1.0);
                  }
                  setState(() {});
                },
                icon: Icon(
                  noMute ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
