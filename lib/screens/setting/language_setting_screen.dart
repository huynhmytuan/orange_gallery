import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:orange_gallery/widgets/selected_list.dart';

class LanguageSettingScreen extends StatelessWidget {
  const LanguageSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "settings.languages.title".tr(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SelectedList(
          selectedIndex: context.supportedLocales.indexOf(context.locale),
          children: [
            SelectedItem(
              onTap: () {
                context.setLocale(const Locale('en', 'US'));
              },
              title: 'settings.languages.english'.tr(),
            ),
            SelectedItem(
              onTap: () {
                context.setLocale(const Locale('vi', 'VI'));
              },
              title: 'settings.languages.vietnamese'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
