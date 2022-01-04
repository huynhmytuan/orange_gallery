import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:orange_gallery/utils/constants.dart';
import 'package:package_info/package_info.dart';

import 'package:orange_gallery/theme.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  String version = 'Unknown';
  String appName = 'Unknown';
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      version = "settings.about_us.version".tr() +
          " ${info.version} + ${info.buildNumber}";
      appName = info.appName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "settings.about_us.title".tr(),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
            ),
            Text(
              appName,
              style: const TextStyle(
                fontFamily: 'Satisfy',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              version,
              style: MyThemes.textTheme.bodyText1,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              margin: const EdgeInsets.only(
                top: 120,
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {},
                    title: Text(
                      "settings.about_us.dev_intro".tr(),
                      style: MyThemes.textTheme.bodyText1,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_outlined,
                      color: orangeColor,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      showLicensePage(context: context);
                    },
                    title: Text(
                      "settings.about_us.license".tr(),
                      style: MyThemes.textTheme.bodyText1,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right_outlined,
                      color: orangeColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
