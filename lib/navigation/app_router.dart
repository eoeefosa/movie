import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:torihd/models/appState/app_state_manager.dart';
import 'package:torihd/screens/home/home.dart';

import '../provider/profile_manager.dart';

class AppRouter {
  final AppStateManager appStateManager;
  // TODO: other State managers
  final ProfileManager profileManager;
  // final GroceryManager groceryManager;

  AppRouter(this.appStateManager, this.profileManager);

  late final router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: appStateManager,
    initialLocation: '/home/0', // Setting initial location to a valid home path
    routes: [
      GoRoute(
          name: 'home',
          path: '/home/:tab',
          builder: (context, state) {
            final tab = int.tryParse(state.pathParameters['tab'] ?? '') ?? 0;
            return Home(
              currentTab: tab,
            );
          },
          // routes: [
          
          //   GoRoute(
          //     name: 'player',
          //     path: 'player',
          //     pageBuilder: (context, state) => const MaterialPage<void>(
          //       child: Videoplayer(),
          //     ),
          //   ),
          // ]
          )
    ],
    // redirect: (state) {
    //   final loggedIn = appStateManager.isLoggedIn;
    //   //     final loggingIn = state.subloc == '/login';
    //   // if (!loggedIn) return loggingIn ? null : '/login';
    //   final isOnBoardingComplete = appStateManager.isOnboardingComplete;
    //   final onboarding = state. == '/onboarding';
    //   if (!isOnBoardingComplete) {
    //     return onboarding ? null : '/onboarding';
    //   }
    //       if (loggingIn || onboarding) return '/${FooderlichTab.explore}';
    // return null;
    // },
    errorPageBuilder: (context, state) {
      return MaterialPage(
          key: state.pageKey,
          child: Scaffold(body: Center(child: Text(state.error.toString()))));
    },
  );
}
