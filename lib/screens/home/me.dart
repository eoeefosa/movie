import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/appState/profile_manager.dart';

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
        CachedNetworkImage(
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
        ),
        const SizedBox(height: 16),
        Text(
          userProfile.username,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          userProfile.email,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
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
