import 'dart:ui';

import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityOnBoardingWidget extends StatelessWidget {

  final DashboardModel model;
  final Function() didSelectClose;

  const ActivityOnBoardingWidget({super.key, required this.model, required this.didSelectClose});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: model.paletteColor,
          automaticallyImplyLeading: false,
          title: Text('Getting Started', style: TextStyle(color: model.accentColor)),
          centerTitle: true,
          actions: [

          ],
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
                color: model.webBackgroundColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height
            ),

            /// info about current activity
            Positioned(
              top: 10,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: model.paletteColor
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Create Your Market/Pop-Up', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold, color: model.accentColor)),
                                      const SizedBox(height: 4),
                                      Text('Publish your Market/Pop-Up, you get to control who joins and how it appears on the marketplace. Open Setting to finish Creating your Activity - Fill Out all Required Details in order to get your activity Published*', style: TextStyle(color: model.disabledTextColor)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: model.paletteColor,),
                                  const SizedBox(width: 25),
                                  Text('Have your activity published and added to the map!', style: TextStyle(color: model.paletteColor)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              /// give ideas to other bookers on how to adapt this space.
                              Row(
                                children: [
                                  Icon(Icons.lightbulb_outlined, color: model.paletteColor),
                                  const SizedBox(width: 25),
                                  Text('Give ideas to other bookers on how to adapt this space', style: TextStyle(color: model.paletteColor),),
                                ],
                              ),
                              const SizedBox(height: 8),
                              /// advertise your activity for potential attendees
                              Row(
                                children: [
                                  Icon(Icons.people_outline, color: model.paletteColor),
                                  const SizedBox(width: 25),
                                  Text('Advertise your activity for potential attendees', style: TextStyle(color: model.paletteColor),),
                                ],
                              ),
                              const SizedBox(height: 8),
                              /// send out an open call if your looking for vendors, partners, or circles.
                              Row(
                                children: [
                                  Icon(Icons.add_alert_outlined, color: model.paletteColor),
                                  const SizedBox(width: 25),
                                  Text('Send out an open call if your looking for vendors, partners, or circles', style: TextStyle(color: model.paletteColor),),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text('1', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: model.disabledTextColor)
                                    ),
                                    child: const Icon(Icons.photo_camera_outlined, size: 32),
                                  ),
                                  const SizedBox(height: 12),
                                  Text('1. Upload at least 1 Photo', textAlign: TextAlign.center, style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('2', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: model.disabledTextColor)
                                    ),
                                    child: const Icon(Icons.title, size: 32),
                                  ),
                                  const SizedBox(height: 12),
                                  Text('2. Add a Title', textAlign: TextAlign.center, style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('3', style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: model.disabledTextColor)
                                    ),
                                    child: const Icon(Icons.text_snippet_outlined, size: 32),
                                  ),
                                  const SizedBox(height: 12),
                                  Text('3. Add a brief description', textAlign: TextAlign.center, style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// duplicate past activity

            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  color: model.accentColor.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /// create new activity
                        InkWell(
                          onTap: () {
                            didSelectClose();
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 200
                            ),
                            height: 45,
                            width: 150,
                            decoration: BoxDecoration(
                              color: model.paletteColor,
                              borderRadius: const BorderRadius.all(Radius.circular(40)),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text('Create Activity', style: TextStyle(color: model.accentColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            )

          ],
        ),
      ),
    );
  }


}