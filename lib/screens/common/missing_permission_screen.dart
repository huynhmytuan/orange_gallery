import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'package:orange_gallery/utils/constants.dart';

class MissingPermissionScreen extends StatelessWidget {
  const MissingPermissionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 100,
                color: greyColor60,
              ),
              Text(
                tr('notice.missing_permission'),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () {
                  PhotoManager.openSetting();
                },
                child: Text(
                  tr('buttons.open_settings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
