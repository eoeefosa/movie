import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:movieboxclone/models/appState/app_state_manager.dart';
import 'package:movieboxclone/models/appState/movie_controller.dart';
import 'package:movieboxclone/models/appState/profile_manager.dart';
import 'package:movieboxclone/movieboxtheme.dart';
import 'package:movieboxclone/navigation/app_router.dart';
import 'package:movieboxclone/styles/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/appState/downloadtask.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FlutterDownloader.initialize(debug: true);

  FlutterDownloader.registerCallback(downloadCallback);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.blueAccent,
  ));
  final appstateManager = AppStateManager();
  await appstateManager.initializeApp();
  runApp(MovieBoxClone(appStateManager: appstateManager));
}

void downloadCallback(String id, int status, int progress) {
  final provider = navigatorKey.currentContext != null
      ? Provider.of<DownloadProvider>(navigatorKey.currentContext!, listen: false)
      : null;
  if (provider != null) {
    provider.updateDownload(
      id,
      DownloadTaskStatus.values[status],
      progress,
    );
  }
}

class MovieBoxClone extends StatefulWidget {
  final AppStateManager appStateManager;
  const MovieBoxClone({super.key, required this.appStateManager});

  @override
  State<MovieBoxClone> createState() => _MovieBoxCloneState();
}

class _MovieBoxCloneState extends State<MovieBoxClone> {
  late final ProfileManager _profileManager = ProfileManager();
  late final AppRouter _appRouter = AppRouter(
    widget.appStateManager,
    _profileManager,
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DownloadProvider()),
        ChangeNotifierProvider(create: (context) => widget.appStateManager),
        ChangeNotifierProvider(create: (context) => _profileManager),
      ],
      child: Consumer<ProfileManager>(
        builder: (context, profileManager, child) {
          ThemeData theme;
          if (profileManager.darkMode) {
            theme = MovieBoxTheme.dark();
          } else {
            theme = MovieBoxTheme.light();
          }

          final router = _appRouter.router;
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: theme,
            title: 'MovieBox Clone',
            routerConfig: router,
            scaffoldMessengerKey: scaffoldMessengerKey,
            
          );
        },
      ),
    );
  }
}
