import 'package:flutter/material.dart';
import 'package:movieboxclone/screens/auth/create_account.dart';
import 'package:movieboxclone/screens/auth/login.dart';
import 'package:movieboxclone/screens/whatsapp/page.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/appState/profile_manager.dart';
import '../download/download.dart';
import '../upload/uploadmovie.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<ProfileManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SignedIn(userProfile: userProfile),
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
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(userProfile.darkMode ? "Dark mode" : "Light Mode"),
            Switch(
                value: userProfile.darkMode,
                onChanged: (value) {
                  Provider.of<ProfileManager>(context, listen: false)
                      .setdarkMode(value);
                })
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
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const Login();
                          },
                        ));
                      },
                      child: const Text("Login")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const CreateAccount();
                            },
                          ),
                        );
                      },
                      child: const Text("Create Account"))
                ],
              ),
        const SizedBox(height: 16),
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
                        return const UploadMovie();
                      },
                    ),
                  );
                },
                child: const Text("Upload Movie"))
            : Container(),
        userProfile.isAdmin
            ? TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const FileDownloader();
                      },
                    ),
                  );
                },
                child: const Text("Image Picker"))
            : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(userProfile.darkMode ? "Dark mode" : "Light Mode"),
            Switch(
                value: userProfile.darkMode,
                onChanged: (value) {
                  Provider.of<ProfileManager>(context, listen: false)
                      .setdarkMode(value);
                })
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
      ],
    );
  }
}
