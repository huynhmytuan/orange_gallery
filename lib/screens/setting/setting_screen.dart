import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:orange_gallery/constants.dart';
import 'package:orange_gallery/screens/setting/about_us_screen.dart';
import 'package:orange_gallery/screens/setting/language_setting_screen.dart';
import 'package:orange_gallery/widgets/app_bar.dart';
import 'package:orange_gallery/providers/theme_provider.dart';
import 'package:orange_gallery/screens/setting/theme_setting_screen.dart';
import 'package:orange_gallery/theme.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  Widget _buildSettingTitle({
    required BuildContext context,
    required IconData icon,
    required String title,
    String value = '',
    Function? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          onTap?.call();
        },
        child: Card(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: greyColor60,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      title,
                      style: MyThemes.textTheme.bodyText1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      value,
                      style: const TextStyle(color: greyColor60),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: orangeColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return NestedScrollView(
      physics: const NeverScrollableScrollPhysics(),
      headerSliverBuilder: (context, value) {
        return [
          CustomAppBar(
            title: tr('settings.title'),
          ),
        ];
      },
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 10),
              child: Text(
                "settings.preferences".tr(),
                style: const TextStyle(
                  color: greyColor60,
                  fontSize: 12,
                ),
              ),
            ),
            _buildSettingTitle(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ThemeSettingScreen(),
                ));
              },
              context: context,
              icon: (themeProvider.getThemeMode == ThemeMode.dark)
                  ? CupertinoIcons.moon_stars
                  : Icons.light_mode,
              title: 'settings.theme.title'.tr(),
              value: ThemeProvider.themeModes
                  .firstWhere(
                      (mode) => mode.values.first == themeProvider.getThemeMode)
                  .keys
                  .first
                  .tr(),
            ),
            _buildSettingTitle(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LanguageSettingScreen(),
                ));
              },
              context: context,
              icon: Icons.language,
              title: "settings.languages.title".tr(),
              value: (context.locale == const Locale('vi', 'VI'))
                  ? 'Tiếng Việt'
                  : 'English',
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 10),
              child: Text(
                "settings.info".tr(),
                style: const TextStyle(
                  color: greyColor60,
                  fontSize: 12,
                ),
              ),
            ),
            _buildSettingTitle(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AboutUsScreen(),
                ));
              },
              context: context,
              icon: Icons.info_outline_rounded,
              title: "settings.about_us.title".tr(),
            ),
          ],
        ),
      ),
    );
  }
}
