import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movieboxclone/models/appState/app_state_manager.dart';
import 'package:movieboxclone/models/appState/profile_manager.dart';
import 'package:movieboxclone/movieboxtheme.dart';
import 'package:movieboxclone/navigation/app_router.dart';
import 'package:movieboxclone/styles/snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//  
// }
Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );
// Ideal time to initialize
await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
//...
 SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.blueAccent,
  ));
  final appstateManager = AppStateManager();
  await appstateManager.initializeApp();
  runApp(MovieBoxClone(appStateManager: appstateManager));
}

class MovieBoxClone extends StatefulWidget {
  final AppStateManager appStateManager;
  const MovieBoxClone({super.key, required this.appStateManager});

  @override
  State<MovieBoxClone> createState() => _MovieBoxCloneState();
}

class _MovieBoxCloneState extends State<MovieBoxClone> {
  // Other state managers
  //  late final _groceryManager = GroceryManager();
  late final _profileManager = ProfileManager();
  late final _appRouter = AppRouter(
    widget.appStateManager,
    _profileManager,
    // _groceryManager,
  );
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => widget.appStateManager),
        ChangeNotifierProvider(create: (context) => _profileManager)
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
