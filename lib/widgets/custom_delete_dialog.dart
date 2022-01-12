import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:orange_gallery/theme.dart';
import 'package:orange_gallery/utils/constants.dart';

class CustomDeleteDialog extends StatelessWidget {
  final int mediasDeleteCount;
  const CustomDeleteDialog({required this.mediasDeleteCount, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        plural("notice.delete_dialog.title", mediasDeleteCount),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LottieBuilder.asset(
            'assets/images/icon_delete.json',
            width: 90,
            height: 90,
          ),
          const SizedBox(height: 5),
          Text(
            tr("notice.delete_dialog.content"),
            textAlign: TextAlign.center,
            style: MyThemes.textTheme.bodyText2!.copyWith(
              fontSize: 14,
              color: (Theme.of(context).brightness == Brightness.light)
                  ? greyColor80
                  : greyColor40,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      tr("buttons.cancel"),
                      style: TextStyle(
                        color:
                            (Theme.of(context).brightness == Brightness.light)
                                ? greyColor80
                                : greyColor40,
                      ),
                    )),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.Cancel);
                },
              ),
              ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Text(
                    tr("buttons.delete"),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.Accept);
                },
              )
            ],
          ),
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
    );
  }
}
