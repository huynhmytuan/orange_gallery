import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:orange_gallery/widgets/select_list.dart';
import '../../theme.dart';

class LanguageSettingScreen extends StatelessWidget {
  const LanguageSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "settings.languages.title".tr(),
          style: MyThemes.textTheme.headline6,
        ),
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).cardColor,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SelectedList(
          selectedIndex: context.supportedLocales.indexOf(context.locale),
          children: [
            SelectItem(
              onTap: () {
                context.setLocale(const Locale('en', 'US'));
              },
              title: 'settings.languages.english'.tr(),
            ),
            SelectItem(
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
