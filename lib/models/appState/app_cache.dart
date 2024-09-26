import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static const kUser = 'user';
  static const kOnboarding = 'onboarding';

  // Retore to default
  Future<void> invalidate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kUser, false);
    await prefs.setBool(kOnboarding, false);
  }

  //  set state that there is user
  // TODO: ensure you save username and token next time
  // also check is UserLoggedIn
  Future<void> cacheUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kUser, true);
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kOnboarding, true);
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kUser) ?? false;
  }

// Check if onboarding was complete
  Future<bool> didCompleteOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kOnboarding) ?? false;
  }
}



// class AppRouter {
//   final AppStateManager appStateManager;
//   final ProfileManager profileManager;
//   final GroceryManager groceryManager;

//   AppRouter(
//     this.appStateManager,
//     this.profileManager,
//     this.groceryManager,
//   );

//   late final router = GoRouter(
//     debugLogDiagnostics: true,
//     refreshListenable: appStateManager,
//     initialLocation: '/login',
//     routes: [
//       GoRoute(
//         name: 'login',
//         path: '/login',
//         builder: (context, state) => const LoginScreen(),
//       ),
//       GoRoute(
//         name: 'onboarding',
//         path: '/onboarding',
//         builder: (context, state) => const OnboardingScreen(),
//       ),
//       GoRoute(
//         name: 'home',
//         path: '/:tab',
//         builder: (context, state) {
//           final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
//           return Home(key: state.pageKey, currentTab: tab);
//         },
//         routes: [
//           GoRoute(
//               name: 'item',
//               path: 'item/:id',
//               builder: (context, state) {
//                 final itemId = state.params['id'] ?? '';
//                 final item = groceryManager.getGroceryItem(itemId);
//                 return GroceryItemScreen(
//                   originalItem: item,
//                   onCreate: (item) {
//                     groceryManager.addItem(item);
//                   },
//                   onUpdate: (item) {
//                     groceryManager.updateItem(item);
//                   },
//                 );
//               }),
//           GoRoute(
//               name: 'profile',
//               path: 'profile',
//               builder: (context, state) {
//                 final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;
//                 return ProfileScreen(
//                     user: profileManager.getUser, currentTab: tab);
//               },
//               routes: [
//                 GoRoute(
//                   name: 'rw',
//                   path: 'rw',
//                   builder: (context, state) => const WebViewScreen(),
//                 ),
//               ]),
//         ],
//       ),
//     ],
//     redirect: (state) {
//       final loggedIn = appStateManager.isLoggedIn;
//       final loggingIn = state.subloc == '/login';
//       if (!loggedIn) return loggingIn ? null : '/login';

//       final isOnboardingComplete = appStateManager.isOnboardingComplete;
//       final onboarding = state.subloc == '/onboarding';
//       if (!isOnboardingComplete) {
//         return onboarding ? null : '/onboarding';
//       }

//       if (loggingIn || onboarding) return '/${FooderlichTab.explore}';
//       return null;
//     },
//     errorPageBuilder: (context, state) {
//       return MaterialPage(
//           key: state.pageKey,
//           child: Scaffold(body: Center(child: Text(state.error.toString()))));
//     },
//   );
// }