import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:torihd/video_dowloader/screens/app_screen.dart';
import 'package:torihd/video_dowloader/utils/custom_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppUpdateInfo? updateInfo;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  void showSkanck(String text) {
    ScaffoldMessenger.of(scaffoldKey.currentContext!)
        .showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void initState() {
    super.initState();
    if (updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
      InAppUpdate.performImmediateUpdate().catchError((e) {
        showSkanck(e.toString());
      });
    } else {
      Future.delayed(
        const Duration(seconds: 3),
        () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const AppScreen()));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.background,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Hi",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: CustomColors.primary,
                        fontSize: 80),
                  ),
                  Text(
                    "Video Downloader",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: CustomColors.white,
                      fontSize: 35,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Very fast, secure and ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 20,
                        color: CustomColors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "supports",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 35,
                      color: CustomColors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "Source",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.w700,
                      color: CustomColors.primary,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "HM Video Downloader is the easiest application to download videos from multiple sources.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  color: CustomColors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
