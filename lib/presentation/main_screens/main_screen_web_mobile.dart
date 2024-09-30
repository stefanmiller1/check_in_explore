import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreenWebMobile extends StatefulWidget {

  final DashboardModel model;

  const MainScreenWebMobile({super.key, required this.model});

  @override
  State<MainScreenWebMobile> createState() => _MainScreenWebMobileState();
}

class _MainScreenWebMobileState extends State<MainScreenWebMobile> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/videos/Circle_Homepage_Animation.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned.fill(
            child: _controller.value.isInitialized
                ? FittedBox(
              fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size?.width ?? 0,
                    height: _controller.value.size?.height ?? 0,
                    child: VideoPlayer(_controller),
                  ),
                )
                : Center(child: JumpingDots(color: widget.model.paletteColor, numberOfDots: 3)),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    widget.model.accentColor.withOpacity(0.7),
                    widget.model.accentColor.withOpacity(0.3),
                    widget.model.accentColor.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo_icon/CIRCLE_LOGO_LIGHT.png'),
                    SizedBox(height: 20),
                    Text(
                      'It\'s Just a Soft Launch',
                      style: TextStyle(
                        color: widget.model.paletteColor,
                        fontSize: widget.model.questionTitleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'While our mobile browser version is under construction, please use one of the options below to access our platform:',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color:  widget.model.paletteColor,),
                    ),
                    SizedBox(height: 30),
                    InkWell(
                      onTap: () => _launchURL('https://cincout.wixstudio.io/circle'),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: widget.model.paletteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Visit Our Website',
                            style: TextStyle(
                              color: widget.model.accentColor,
                              fontSize: widget.model.secondaryQuestionTitleFontSize,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _launchURL(iosActivitiesAppLink),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          widget.model.systemTheme.brightness != Brightness.dark ? 'assets/icons_svg/ios/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg' : 'assets/icons_svg/ios/Download_on_the_App_Store_Badge_US-UK_RGB_wht_092917.svg',
                          height: 50,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'You can also access our application on tablet browsers.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color:  widget.model.paletteColor),
                    ),
                    const SizedBox(height: 10),
                    BasicWebFooter(
                      model: widget.model,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),

          // assets/icons_svg/ios/Download_on_the_App_Store_Badge_US-UK_RGB_blk_092917.svg
          // assets/icons_svg/ios/Download_on_the_App_Store_Badge_US-UK_RGB_wht_092917.svg


        ],
      )
    );
  }
}