import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:orange_gallery/theme.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "settings.about_us.title".tr(),
          style: MyThemes.textTheme.headline6,
        ),
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).cardColor,
        elevation: 1,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 150,
              height: 150,
            ),
            Text(
              "Orange Gallery",
              style: MyThemes.textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }
}
