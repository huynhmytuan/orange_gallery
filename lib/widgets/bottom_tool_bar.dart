import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orange_gallery/utils/constants.dart';

class BottomToolBar extends StatelessWidget {
  final Function onAddPressed;
  final Function? onFavoritePressed;
  final Function onSharePressed;
  final Function onDeletePressed;
  bool isFavorite;
  BottomToolBar(
      {required this.onAddPressed,
      this.onFavoritePressed,
      required this.onSharePressed,
      required this.onDeletePressed,
      this.isFavorite = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 5,
      child: SafeArea(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      onAddPressed.call();
                    },
                    icon: const Icon(
                      CupertinoIcons.add,
                    ),
                    tooltip: tr("buttons.add_to_album"),
                    splashRadius: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      onSharePressed.call();
                    },
                    icon: const Icon(
                      Icons.ios_share_rounded,
                    ),
                    tooltip: tr("buttons.share"),
                    splashRadius: 20,
                  ),
                  if (onFavoritePressed != null)
                    IconButton(
                      onPressed: () {
                        onFavoritePressed?.call();
                      },
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: (isFavorite) ? orangeColor : null,
                      ),
                      tooltip: tr("buttons.favorite"),
                      splashRadius: 20,
                    ),
                  IconButton(
                    onPressed: () async {
                      onDeletePressed.call();
                    },
                    icon: const Icon(
                      CupertinoIcons.delete,
                      color: orangeColor,
                    ),
                    tooltip: tr("buttons.delete"),
                    splashRadius: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
