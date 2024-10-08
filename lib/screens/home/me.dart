import 'package:flutter/material.dart';
import 'package:torihd/screens/auth/create_account.dart';
import 'package:torihd/screens/auth/login.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:torihd/screens/home/updatedlistview.dart';
import 'package:torihd/screens/home/widgets/threewaytoggle.dart';
import 'package:torihd/screens/upload/uploadtvseries.dart';
import 'package:torihd/styles/snack_bar.dart';

import '../../provider/profile_manager.dart';
import '../upload/uploadmovie.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<ProfileManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: userProfile.currentUser == null
              ? SignedIn(userProfile: userProfile)
              : UnSigned(userProfile: userProfile),
        ),
      ),
    );
  }
}

class UnSigned extends StatelessWidget {
  const UnSigned({super.key, required this.userProfile});
  final ProfileManager userProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CachedNetworkImage(
          imageUrl: (userProfile.currentUser != null &&
                  userProfile.currentUser!.photoURL != null)
              ? userProfile.currentUser!.photoURL!
              : userProfile.profileImageUrl, // Use default profile image URL
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: 50,
            backgroundImage: imageProvider,
          ),
          placeholder: (context, url) => CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            child: const CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            child: const Icon(
              Icons.person,
              size: 50,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(userProfile.currentUser!.email!),
        const SizedBox(height: 24),
        userProfile.isAdmin
            ? TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const UploadTVMovie();
                      },
                    ),
                  );
                },
                child: const Text("Upload Movie"),
              )
            : Container(),
        userProfile.isAdmin
            ? TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const UpdatedListView();
                      },
                    ),
                  );
                },
                child: const Text("update download links"),
              )
            : Container(),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Theme Mode",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            ThreeWayToggle(
              themeMode: Provider.of<ProfileManager>(context).themeMode,
              onChanged: (ThemeModeType newMode) {
                Provider.of<ProfileManager>(context, listen: false)
                    .setThemeMode(newMode);
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Favorite Movies',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: userProfile.favoriteMovies.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(userProfile.favoriteMovies[index]),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Provider.of<ProfileManager>(context, listen: false).signOut();
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text("Logout"),
          ),
        )
      ],
    );
  }
}

class SignedIn extends StatelessWidget {
  const SignedIn({
    super.key,
    required this.userProfile,
  });

  final ProfileManager userProfile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        userProfile.isLogin
            ? CachedNetworkImage(
                imageUrl: userProfile.profileImageUrl,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 50,
                  backgroundImage: imageProvider,
                ),
                placeholder: (context, url) => CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: const CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              )
            : Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const Login(); // Replace with your destination widget
                          },
                        ),
                      );
                    },
                    child: const Text("Login"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const CreateAccount(); // Replace with your destination widget
                          },
                        ),
                      );
                    },
                    child: const Text("Create Account"),
                  )
                ],
              ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Theme Mode",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            ThreeWayToggle(
              themeMode: Provider.of<ProfileManager>(context).themeMode,
              onChanged: (ThemeModeType newMode) {
                Provider.of<ProfileManager>(context, listen: false)
                    .setThemeMode(newMode);
              },
            ),
          ],
        ),
        userProfile.isLogin
            ? Text(
                userProfile.username,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            : Container(),
        const SizedBox(height: 8),
        userProfile.isLogin
            ? Text(
                userProfile.email,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              )
            : Container(),
        const SizedBox(height: 24),
        userProfile.isAdmin
            ? TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const UploadTVMovie();
                      },
                    ),
                  );
                },
                child: const Text("Upload Movie"))
            : Container(),
        const SizedBox(height: 24),
        const Text(
          'Favorite Movies',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: userProfile.favoriteMovies.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(userProfile.favoriteMovies[index]),
            );
          },
        ),
      ],
    );
  }
}
