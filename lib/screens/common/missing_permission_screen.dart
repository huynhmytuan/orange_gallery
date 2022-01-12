import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:orange_gallery/utils/constants.dart';

class MissingPermissionScreen extends StatelessWidget {
  const MissingPermissionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Wrap(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 25,
              height: 25,
            ),
            const Text(
              'Orange Gallery',
              style: TextStyle(
                fontFamily: 'Satisfy',
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Flexible(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Icon(
                  Icons.video_library_sharp,
                  size: 100,
                  color: greyColor60,
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                tr('notice.missing_permission'),
                textAlign: TextAlign.center,
              ),
            ),
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  PhotoManager.openSetting();
                },
                child: Text(
                  tr('buttons.open_settings'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
