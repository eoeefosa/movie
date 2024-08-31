import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:torihd/models/appState/app_state_manager.dart';
import 'package:torihd/provider/profile_manager.dart';
import 'package:torihd/navigation/app_router.dart';
import 'package:torihd/provider/movieprovider.dart';
import 'package:torihd/styles/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ads/ad_controller.dart';
import 'firebase_options.dart';
import 'provider/downloadprovider.dart';
import 'toritheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize FlutterDownloader

  // Register callback for downloads
  // FlutterDownloader.registerCallback(downloadCallback);

  // Initialize AdsController if platform is supported
  AdsController? adsController;
  if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
    adsController = AdsController(instance: MobileAds.instance);
    try {
      await adsController.initialize();
    } catch (e) {
      if (kDebugMode) {
        print("Failed to initialize AdsController: $e");
      }
    }
  }

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.blueAccent,
  ));

  // Initialize AppStateManager
  final appstateManager = AppStateManager();
  await appstateManager.initializeApp();

  runApp(Tori(
    appStateManager: appstateManager,
    adsController: adsController,
  ));
}

class Tori extends StatefulWidget {
  final AppStateManager appStateManager;
  final AdsController? adsController;

  const Tori({
    super.key,
    required this.appStateManager,
    this.adsController,
  });

  @override
  State<Tori> createState() => _ToriState();
}

class _ToriState extends State<Tori> {
  late final ProfileManager _profileManager = ProfileManager();
  late final AppRouter _appRouter = AppRouter(
    widget.appStateManager,
    _profileManager,
  );

  @override
  void dispose() {
    // Dispose AdsController if initialized
    widget.adsController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DownloadProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        Provider<AdsController?>.value(value: widget.adsController),
        ChangeNotifierProvider(create: (context) => widget.appStateManager),
        ChangeNotifierProvider(create: (context) => _profileManager),
      ],
      child: Consumer<ProfileManager>(
        builder: (context, profileManager, child) {
          final theme =
              profileManager.darkMode ? ToriTheme.dark() : ToriTheme.light();
          final router = _appRouter.router;

          return ScreenUtilInit(
            designSize: const Size(400, 900),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                theme: theme,
                title: 'ToriHd',
                routerConfig: router,
                scaffoldMessengerKey: scaffoldMessengerKey,
              );
            },
          );
        },
      ),
    );
  }
}
