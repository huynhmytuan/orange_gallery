import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:orange_gallery/constants.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:orange_gallery/theme.dart';
import 'package:orange_gallery/providers/theme_provider.dart';
import 'package:orange_gallery/providers/photo_provider.dart';
import 'package:orange_gallery/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox('Settings');
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VI'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late bool _status = false;
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    PhotoManager.requestPermissionExtend().then((value) {
      setState(() {
        _status = value.isAuth;
      });
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    PhotoManager.requestPermissionExtend().then((value) {
      setState(() {
        _status = value.isAuth;
      });
    });
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PhotoProvider(),
        ),
      ],
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return EasyLocalization(
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('vi', 'VI'),
          ],
          path: 'assets/translations',
          fallbackLocale: const Locale('en', 'US'),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Orange Gallery',
            themeMode: themeProvider.getThemeMode['value'],
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: (_status) ? MyHomePage() : MissingPermissionScreen(),
            routes: {
              MyHomePage.routeName: (context) => MyHomePage(),
              // PhotosScreen.routeName: (context) => PhotosScreen(),
            },
          ),
        );
      },
    );
  }
}

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
              const Text(
                'Something went wrong!\n We need access photos permissions to run this app.',
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () {
                  PhotoManager.openSetting();
                },
                child: const Text(
                  'Open App Settings',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
