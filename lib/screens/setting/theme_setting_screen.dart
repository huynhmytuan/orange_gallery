import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:orange_gallery/constants.dart';
import 'package:orange_gallery/providers/theme_provider.dart';
import 'package:orange_gallery/theme.dart';
import 'package:orange_gallery/widgets/select_list.dart';

class ThemeSettingScreen extends StatelessWidget {
  const ThemeSettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "settings.theme.title".tr(),
          style: MyThemes.textTheme.headline6,
        ),
        foregroundColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).cardColor,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SelectedList(
              selectedIndex: ThemeProvider.themeModes.indexWhere((element) =>
                  element.values.first == themeProvider.getThemeMode),
              onSelect: (index) {
                themeProvider
                    .toggleTheme(ThemeProvider.themeModes[index].values.first);
              },
              children: ThemeProvider.themeModes
                  .map((e) => SelectItem(title: e.keys.first.tr()))
                  .toList(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: Text(
                "settings.theme.description".tr(),
                style: MyThemes.textTheme.bodyText2?.copyWith(
                  color: greyColor60,
                  fontWeight: FontWeight.w100,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
