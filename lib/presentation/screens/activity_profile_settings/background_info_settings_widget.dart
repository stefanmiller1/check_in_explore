import 'dart:typed_data';

import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';

class BackgroundInfoSettingsWidget extends StatefulWidget {

  final DashboardModel model;

  const BackgroundInfoSettingsWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<BackgroundInfoSettingsWidget> createState() => _BackgroundInfoSettingsWidgetState();
}

class _BackgroundInfoSettingsWidgetState extends State<BackgroundInfoSettingsWidget> {

  ScrollController? _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    super.initState();
  }


  void _handleImageSelection(BuildContext context) async {

    final file = await ImagePickerWeb.getMultiImagesAsBytes();
    late List<ImageUpload> currentImages = [];
    currentImages.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.activityProfileImages ?? []);


    setState(() {
      if (file != null && (file.isNotEmpty)) {
        if ((file.length + currentImages.length) <= 6 && currentImages.length <= 6) {
        for (Uint8List dataImage in file) {

          currentImages.add(ImageUpload(
              key: dataImage.first.toString(),
              imageToUpload: dataImage
            )
          );
        }
        context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityProfileImagesChanged(currentImages));
      } else {
        final snackBar = SnackBar(
            elevation: 4,
            backgroundColor: widget.model.paletteColor,
            content: Text('Sorry, only 6 Images can be added. Please try again', style: TextStyle(color: widget.model.webBackgroundColor))
        );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    });
  }


  void _handleCreateNewAttendeePartner() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
      barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
      transitionDuration: Duration(milliseconds: 650),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return Scaffold(
            backgroundColor: Colors.transparent,
            body: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  decoration: BoxDecoration(
                      color: widget.model.accentColor,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(17.5), topLeft: Radius.circular(17.5))
                  ),
                  width: 600,
                  height: 750,
                  child: CreateNewPartnerForm(
                    model: widget.model,
                    reservation: context.read<UpdateActivityFormBloc>().state.reservationItem,
                  )
              ),
            )
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0.01)).animate(anim1),
          child: child,
        );
      },
    );
  }

  void _handleCreateNewAttendeeInstructor() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
      barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
      transitionDuration: Duration(milliseconds: 650),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return Scaffold(
            backgroundColor: Colors.transparent,
            body: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  decoration: BoxDecoration(
                      color: widget.model.accentColor,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(17.5), topLeft: Radius.circular(17.5))
                  ),
                  width: 600,
                  height: 750,
                  child: CreateNewInstructorForm(
                    model: widget.model,
                    reservation: context.read<UpdateActivityFormBloc>().state.reservationItem,
                  )
              ),
            )
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0.01)).animate(anim1),
          child: child,
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {

    bool isLessThanMain = (MediaQuery.of(context).size.width <= 1150);

    return Form(
      autovalidateMode: context.read<UpdateActivityFormBloc>().state.showErrorMessages,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),

          SingleChildScrollView(
            controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
              child: (isLessThanMain) ? Column(
                children: [
                  mainTopContainer(
                      context: context,
                      model: widget.model,
                      state: context.read<UpdateActivityFormBloc>().state,
                      didSelectImage: () {
                        setState(() {
                          _handleImageSelection(context);
                        });
                      },
                      activityProfileImagesChanged: (images) {
                        setState(() {
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityProfileImagesChanged(images));
                        });
                      }
                  ),
                  mainContainerForSectionOneRowOne(
                      context: context,
                      model: widget.model,
                      state: context.read<UpdateActivityFormBloc>().state,
                      activityTitleChanged: (value) {
                        context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityTitleChanged(BackgroundInfoTitle(value)));
                      },
                      activityDescriptionChanged: (value) {
                        context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityDescriptionChanged(BackgroundInfoDescription(value)));
                      },
                      activityDescriptionChangedTwo: (value) {
                        context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityDescriptionChangedTwo(BackgroundInfoDescription(value)));
                    }
                  ),
                  mainContainerForSectionOneRowTwo(
                      context: context,
                      model: widget.model,
                      state: context.read<UpdateActivityFormBloc>().state,
                      isPartnersInviteOnly: (isPartner) {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.isPartnersInviteOnly ?? false) {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPartnersInviteOnly(false));
                          } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPartnersInviteOnly(true));
                          }
                        });
                      },
                      getPartnerAttendees: getPartnerAttendees(),
                      didSelectCreateNewPartner: () {
                        _handleCreateNewAttendeePartner();
                      },
                      getInstructorAttendees: getInstructorAttendees(),
                      didSelectCreateInstructor: () {
                        _handleCreateNewAttendeeInstructor();
                      }
                  ),
                ],
              ) : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mainTopContainer(
                      context: context,
                      model: widget.model,
                      state: context.read<UpdateActivityFormBloc>().state,
                      didSelectImage: () {
                        setState(() {
                          _handleImageSelection(context);
                        });
                      },
                      activityProfileImagesChanged: (images) {
                        setState(() {
                          context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityProfileImagesChanged(images));
                      });
                    }
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child:  mainContainerForSectionOneRowOne(
                          context: context,
                          model: widget.model,
                          state: context.read<UpdateActivityFormBloc>().state,
                          activityTitleChanged: (value) {
                            context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityTitleChanged(BackgroundInfoTitle(value)));
                          },
                          activityDescriptionChanged: (value) {
                            context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityDescriptionChanged(BackgroundInfoDescription(value)));
                          },
                          activityDescriptionChangedTwo: (value) {
                            context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityDescriptionChangedTwo(BackgroundInfoDescription(value)));
                          }
                        ),
                      ),
                      const SizedBox(width: 25),
                      Expanded(child: mainContainerForSectionOneRowTwo(
                          context: context,
                          model: widget.model,
                          state: context.read<UpdateActivityFormBloc>().state,
                          isPartnersInviteOnly: (isPartner) {
                            setState(() {
                              if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.isPartnersInviteOnly ?? false) {
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPartnersInviteOnly(false));
                              } else {
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPartnersInviteOnly(true));
                              }
                            });
                          },
                          getPartnerAttendees: getPartnerAttendees(),
                          didSelectCreateNewPartner: () {
                            _handleCreateNewAttendeePartner();
                          },
                          getInstructorAttendees: getInstructorAttendees(),
                          didSelectCreateInstructor: () {
                            _handleCreateNewAttendeeInstructor();
                          }
                        ),
                      ),
                      if (MediaQuery.of(context).size.width >= 1300) SizedBox(width: MediaQuery.of(context).size.width * 0.1)
                    ],
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }

  Widget getPartnerAttendees() {
   return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.partner.toString(), context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityFormId.getOrCrash())),
      child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
            attLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
            loadAllAttendanceFailure: (_) => Container(),
            loadAllAttendanceSuccess: (item) {
              return SingleChildScrollView(
                child: Row(
                  children: item.item.map(
                          (attendee) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: getPartnerAttendeeType(context,
                            widget.model,
                            attendee: attendee,
                            didSelectAttendee: (attendee) {

                          }
                        ),
                      )
                  ).toList(),
                ),
              );
            },
            orElse: () => Container(),
          );
        },
      ),
    );
  }

  Widget getInstructorAttendees() {
    return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.instructor.toString(), context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityFormId.getOrCrash())),
      child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
            attLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
            loadAllAttendanceFailure: (_) => Container(),
            loadAllAttendanceSuccess: (item) {
              return SingleChildScrollView(
                child: Column(
                  children: item.item.map(
                    (attendee) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: getInstructorAttendeeType(
                          context,
                          widget.model,
                          attendee: attendee,
                          didSelectAttendee: (attendee) {

                          }
                      ),
                    )
                    ).toList(),
                  ),
                );
              },
            orElse: () => Container(),
          );
        },
      ),
    );
  }
  //
  // Widget mainTopContainer(BuildContext context) {
  //   Widget buildItem(String text) {
  //     return GestureDetector(
  //       onTap: () {
  //         setState(() {
  //           _handleImageSelection();
  //         });
  //       },
  //       child: Card(
  //         elevation: 0,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //           side: BorderSide(color: widget.model.disabledTextColor, width: 1),
  //         ),
  //         color: Colors.transparent,
  //         key: ValueKey(text),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(15),
  //           child: Container(
  //             height: 150,
  //             width: 150,
  //               child: Icon(Icons.add_circle_rounded, color: widget.model.disabledTextColor, size: 55))
  //         ),
  //       ),
  //     );
  //   }
  //
  //   Widget buildImageItem(ImageUpload imageItem) {
  //     return Card(
  //       elevation: 0,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       color: Colors.transparent,
  //       // key: ValueKey(imageItem.key),
  //       child: Stack(
  //         children: [
  //           ClipRRect(
  //               borderRadius: BorderRadius.circular(15),
  //               child: Container(
  //                   height: 150,
  //                   width: 150,
  //                   child:
  //                   (imageItem.imageToUpload != null) ?
  //                   Image.memory(imageItem.imageToUpload!, fit: BoxFit.cover) :
  //                   (imageItem.uriPath != null) ?
  //                   Image.network(imageItem.uriPath!, fit: BoxFit.cover) :
  //                   Icon(Icons.error_outline, color: widget.model.disabledTextColor, size: 55,)),
  //           ),
  //           Positioned(
  //             right: 0,
  //             top: 0,
  //               child: AnimatedOpacity(
  //                 duration: Duration(milliseconds: 300),
  //                 opacity: 1,
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     /// in facade - if imageURI no longer exists from original images, then remove from array.
  //                     /// in facade - all imageToUpload[Image] images should be uploaded and removed from array.
  //
  //                     setState(() {
  //                       late List<ImageUpload> images = [];
  //                       images.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.activityProfileImages ?? []);
  //
  //                       final index = images.indexWhere((element) => element.key == imageItem.key);
  //                       images.removeAt(index);
  //
  //                       context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityProfileImagesChanged(images));
  //                     });
  //                   },
  //                   child: Icon(Icons.cancel, color: widget.model.paletteColor, size: 35),
  //                 ),
  //               )
  //           )
  //         ],
  //       ),
  //     );
  //   }
  //
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(height: 25),
  //         /// *** select/add profile images for activity *** ///
  //         Text('Photos/Videos', style: TextStyle(
  //           fontSize: widget.model.secondaryQuestionTitleFontSize,
  //           color: widget.model.disabledTextColor,
  //           ),
  //         ),
  //         const SizedBox(height: 10),
  //         Stack(
  //           children: [
  //             Align(
  //               alignment: Alignment.center,
  //               child: Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 child: Wrap(
  //                   children: profileImages.map((e) => buildItem(e)).toList(),
  //                 )
  //               ),
  //             ),
  //             Align(
  //               alignment: Alignment.center,
  //               child: Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   child: Wrap(
  //                     children: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.activityProfileImages?.map((e) => buildImageItem(e)).toList() ?? [],
  //                 )
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 5),
  //         Text('Edit & Add an image for your Activity', style: TextStyle(
  //           color: widget.model.disabledTextColor,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget mainContainerForSectionOneRowOne(BuildContext context) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         /// *** activity name *** ///
  //         SizedBox(height: 25),
  //         Text('Activity Name', style: TextStyle(
  //           fontSize: widget.model.secondaryQuestionTitleFontSize,
  //           color: widget.model.disabledTextColor,
  //           ),
  //         ),
  //         const SizedBox(height: 10),
  //         TextFormField(
  //             maxLength: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.activityTitle.maxLength,
  //             style: TextStyle(color: widget.model.paletteColor),
  //             initialValue: context.read<UpdateActivityFormBloc>().state
  //                 .activitySettingsForm
  //                 .profileService
  //                 .activityBackground
  //                 .activityTitle
  //                 .value
  //                 .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => e, orElse: () => ''), orElse: () => ''), (r) => r),
  //             decoration: InputDecoration(
  //               hintStyle: TextStyle(color: widget.model.disabledTextColor),
  //               hintText: 'Activity Name',
  //               errorStyle: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 14,
  //                 color: widget.model.paletteColor,
  //               ),
  //               prefixIcon: Icon(Icons.home_outlined, color: widget.model.disabledTextColor),
  //               filled: true,
  //               fillColor: widget.model.accentColor,
  //               focusedErrorBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(25.0),
  //                 borderSide: BorderSide(
  //                   width: 2,
  //                   color: widget.model.paletteColor,
  //                 ),
  //               ),
  //               focusedBorder:  OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(25.0),
  //                 borderSide: BorderSide(
  //                   color: widget.model.paletteColor,
  //                 ),
  //               ),
  //               errorBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(25.0),
  //                 borderSide: const BorderSide(
  //                   width: 0,
  //                 ),
  //               ),
  //               enabledBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(25.0),
  //                 borderSide: BorderSide(
  //                   color: widget.model.disabledTextColor,
  //                   width: 0,
  //                 ),
  //               ),
  //             ),
  //             autocorrect: false,
  //             onChanged: (value) => context
  //                 .read<UpdateActivityFormBloc>()
  //                 .add(UpdateActivityFormEvent.activityTitleChanged(BackgroundInfoTitle(value))),
  //             validator: (_) => context.read<UpdateActivityFormBloc>().state
  //                 .activitySettingsForm
  //                 .profileService
  //                 .activityBackground
  //                 .activityTitle
  //                 .value
  //                 .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2, orElse: () => null), orElse: () => null), (r) => r),
  //             ),
  //
  //             /// *** activity description *** ///
  //             SizedBox(height: 25),
  //             Text('About the Activity', style: TextStyle(
  //                 color: widget.model.disabledTextColor,
  //                 fontSize: widget.model.secondaryQuestionTitleFontSize,
  //               )
  //             ),
  //             const SizedBox(height: 20),
  //
  //             TextFormField(
  //               maxLength: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.activityDescription1.maxLength,
  //               maxLines: 8,
  //               initialValue: context.read<UpdateActivityFormBloc>().state
  //                   .activitySettingsForm
  //                   .profileService
  //                   .activityBackground
  //                   .activityDescription1
  //                   .value
  //                   .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => e, orElse: () => ''), orElse: () => ''), (r) => r),
  //               style: TextStyle(color: widget.model.paletteColor),
  //               decoration: InputDecoration(
  //                 hintStyle: TextStyle(color: widget.model.disabledTextColor),
  //                 hintText: 'Tell them about what\'s in store...',
  //                 errorStyle: TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 14,
  //                   color: widget.model.paletteColor,
  //                 ),
  //                 filled: true,
  //                 fillColor: widget.model.accentColor,
  //                 focusedErrorBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(25.0),
  //                   borderSide: BorderSide(
  //                     width: 2,
  //                     color: widget.model.paletteColor,
  //                   ),
  //                 ),
  //                 focusedBorder:  OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(25.0),
  //                   borderSide: BorderSide(
  //                     color: widget.model.paletteColor,
  //                   ),
  //                 ),
  //                 errorBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(25.0),
  //                   borderSide: const BorderSide(
  //                     width: 0,
  //                   ),
  //                 ),
  //                 enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(25.0),
  //                   borderSide: BorderSide(
  //                     color: widget.model.disabledTextColor,
  //                     width: 0,
  //                   ),
  //                 ),
  //               ),
  //               autocorrect: false,
  //               onChanged: (value) => context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityDescriptionChanged(BackgroundInfoDescription(value))),
  //               validator: (_) => context.read<UpdateActivityFormBloc>().state
  //                   .activitySettingsForm
  //                   .profileService
  //                   .activityBackground
  //                   .activityDescription1
  //                   .value
  //                   .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2, orElse: () => null), orElse: () => null), (r) => r),
  //             ),
  //
  //         Visibility(
  //           // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activityType == ProfileActivityTypeOption.gameMatches,
  //           child: Column(
  //             children: [
  //               const SizedBox(height: 25),
  //               Row(
  //                 children: [
  //                   Icon(Icons.videogame_asset_rounded, color: widget.model.paletteColor),
  //                   const SizedBox(width: 15),
  //                   Expanded(child: Text('Tell them more Details', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
  //                 ],
  //               ),
  //               Text(AppLocalizations.of(context)!.activityGameBackgroundSubTitle2, style: TextStyle(color: widget.model.paletteColor)),
  //               const SizedBox(height: 20),
  //               TextFormField(
  //                 maxLength: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.activityDescription2?.maxLength,
  //                 maxLines: 8,
  //                 initialValue: context.read<UpdateActivityFormBloc>().state
  //                     .activitySettingsForm
  //                     .profileService
  //                     .activityBackground
  //                     .activityDescription2
  //                     ?.value
  //                     .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => e, orElse: () => ''), orElse: () => ''), (r) => r),
  //                 style: TextStyle(color: widget.model.paletteColor),
  //                 decoration: InputDecoration(
  //                   hintStyle: TextStyle(color: widget.model.disabledTextColor),
  //                   hintText: 'Tell them about what\'s in store...',
  //                   errorStyle: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 14,
  //                     color: widget.model.paletteColor,
  //                   ),
  //                   filled: true,
  //                   fillColor: widget.model.accentColor,
  //                   focusedErrorBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(25.0),
  //                     borderSide: BorderSide(
  //                       width: 2,
  //                       color: widget.model.paletteColor,
  //                     ),
  //                   ),
  //                   focusedBorder:  OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(25.0),
  //                     borderSide: BorderSide(
  //                       color: widget.model.paletteColor,
  //                     ),
  //                   ),
  //                   errorBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(25.0),
  //                     borderSide: const BorderSide(
  //                       width: 0,
  //                     ),
  //                   ),
  //                   enabledBorder: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(25.0),
  //                     borderSide: BorderSide(
  //                       color: widget.model.disabledTextColor,
  //                       width: 0,
  //                     ),
  //                   ),
  //                 ),
  //                 autocorrect: false,
  //                 onChanged: (value) => context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityDescriptionChangedTwo(BackgroundInfoDescription(value))),
  //                 validator: (_) => context.read<UpdateActivityFormBloc>().state
  //                     .activitySettingsForm
  //                     .profileService
  //                     .activityBackground
  //                     .activityDescription2
  //                     ?.value
  //                     .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2, orElse: () => null), orElse: () => null), (r) => r),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //             Visibility(
  //               // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activityType == ProfileActivityTypeOption.classesLessons,
  //               child: Column(
  //                 children: [
  //                   const SizedBox(height: 25),
  //                   Row(
  //                     children: [
  //                       Icon(Icons.sports, color: widget.model.paletteColor),
  //                       const SizedBox(width: 15),
  //                       Expanded(child: Text('Tell them more Details', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
  //                     ],
  //                   ),
  //                   Text(AppLocalizations.of(context)!.activityClassesBackgroundSubTitle2, style: TextStyle(color: widget.model.paletteColor)),
  //                   const SizedBox(height: 20),
  //
  //                   TextFormField(
  //                     maxLength: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.activityDescription2?.maxLength,
  //                     maxLines: 8,
  //                     initialValue: context.read<UpdateActivityFormBloc>().state
  //                         .activitySettingsForm
  //                         .profileService
  //                         .activityBackground
  //                         .activityDescription2
  //                         ?.value
  //                         .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => e, orElse: () => ''), orElse: () => ''), (r) => r),
  //                     style: TextStyle(color: widget.model.paletteColor),
  //                     decoration: InputDecoration(
  //                       hintStyle: TextStyle(color: widget.model.disabledTextColor),
  //                       hintText: 'Tell them about what\'s in store...',
  //                       errorStyle: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 14,
  //                         color: widget.model.paletteColor,
  //                       ),
  //                       filled: true,
  //                       fillColor: widget.model.accentColor,
  //                       focusedErrorBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(25.0),
  //                         borderSide: BorderSide(
  //                           width: 2,
  //                           color: widget.model.paletteColor,
  //                         ),
  //                       ),
  //                       focusedBorder:  OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(25.0),
  //                         borderSide: BorderSide(
  //                           color: widget.model.paletteColor,
  //                         ),
  //                       ),
  //                       errorBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(25.0),
  //                         borderSide: const BorderSide(
  //                           width: 0,
  //                         ),
  //                       ),
  //                       enabledBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(25.0),
  //                         borderSide: BorderSide(
  //                           color: widget.model.disabledTextColor,
  //                           width: 0,
  //                         ),
  //                       ),
  //                     ),
  //                     autocorrect: false,
  //                     onChanged: (value) => context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityDescriptionChangedTwo(BackgroundInfoDescription(value))),
  //                     validator: (_) => context.read<UpdateActivityFormBloc>().state
  //                         .activitySettingsForm
  //                         .profileService
  //                         .activityBackground
  //                         .activityDescription2
  //                         ?.value
  //                         .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2, orElse: () => null), orElse: () => null), (r) => r),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //             Visibility(
  //               // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity == ProfileActivityTypeOption.experiences,
  //               child: Column(
  //                 children: [
  //                   const SizedBox(height: 25),
  //                   Row(
  //                     children: [
  //                       Icon(Icons.map, color: widget.model.paletteColor),
  //                       const SizedBox(width: 15),
  //                       Expanded(child: Text('Tell them more Details', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
  //                     ],
  //                   ),
  //                   Text(AppLocalizations.of(context)!.activityExperienceBackgroundSubTitle2, style: TextStyle(color: widget.model.paletteColor)),
  //                   const SizedBox(height: 20),
  //                   TextFormField(
  //                     maxLength: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.activityDescription2?.maxLength,
  //                     maxLines: 8,
  //                     initialValue: context.read<UpdateActivityFormBloc>().state
  //                         .activitySettingsForm
  //                         .profileService
  //                         .activityBackground
  //                         .activityDescription2
  //                         ?.value
  //                         .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => e, orElse: () => ''), orElse: () => ''), (r) => r),
  //                     style: TextStyle(color: widget.model.paletteColor),
  //                     decoration: InputDecoration(
  //                       hintStyle: TextStyle(color: widget.model.disabledTextColor),
  //                       hintText: 'Tell them about what\'s in store...',
  //                       errorStyle: TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 14,
  //                         color: widget.model.paletteColor,
  //                       ),
  //                       filled: true,
  //                       fillColor: widget.model.accentColor,
  //                       focusedErrorBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(25.0),
  //                         borderSide: BorderSide(
  //                           width: 2,
  //                           color: widget.model.paletteColor,
  //                         ),
  //                       ),
  //                       focusedBorder:  OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(25.0),
  //                         borderSide: BorderSide(
  //                           color: widget.model.paletteColor,
  //                         ),
  //                       ),
  //                       errorBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(25.0),
  //                         borderSide: const BorderSide(
  //                           width: 0,
  //                         ),
  //                       ),
  //                       enabledBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(25.0),
  //                         borderSide: BorderSide(
  //                           color: widget.model.disabledTextColor,
  //                           width: 0,
  //                         ),
  //                       ),
  //                     ),
  //                     autocorrect: false,
  //                     onChanged: (value) => context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityDescriptionChangedTwo(BackgroundInfoDescription(value))),
  //                     validator: (_) => context.read<UpdateActivityFormBloc>().state
  //                         .activitySettingsForm
  //                         .profileService
  //                         .activityBackground
  //                         .activityDescription2
  //                         ?.value
  //                         .fold((l) => l.maybeMap(textInputTitleOrDetails: (i) => i.f?.maybeWhen(invalidFacilityName: (e) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2, orElse: () => null), orElse: () => null), (r) => r),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //
  //       ],
  //     ),
  //   );
  // }

  // Widget mainContainerForSectionOneRowTwo(BuildContext context) {
  //   return Container(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const SizedBox(height: 25),
  //         /// partnerships
  //         Text('Activity Partners', style: TextStyle(
  //           color: widget.model.disabledTextColor,
  //           fontSize: widget.model.secondaryQuestionTitleFontSize,
  //           )
  //         ),
  //         const SizedBox(height: 20),
  //         Container(
  //           width: 675,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Expanded(child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text('Partners are Invite Only?', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor,)),
  //                   Text('otherwise any partner can request to collaborate with you', style: TextStyle(color: widget.model.disabledTextColor))
  //                   ],
  //                 )
  //               ),
  //               FlutterSwitch(
  //                 width: 60,
  //                 inactiveColor: widget.model.accentColor,
  //                 activeColor: widget.model.paletteColor,
  //                 value: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.isPartnersInviteOnly ?? false,
  //                 onToggle: (value) {
  //                   setState(() {
  //                     if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.isPartnersInviteOnly ?? false) {
  //                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPartnersInviteOnly(false));
  //                     } else {
  //                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPartnersInviteOnly(true));
  //                     }
  //                   });
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(height: 15),
  //         BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.partner.toString(), context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityFormId.getOrCrash())),
  //           child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
  //             builder: (context, state) {
  //               return state.maybeMap(
  //                 attLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
  //                 loadAllAttendanceFailure: (_) => Container(),
  //                 loadAllAttendanceSuccess: (item) {
  //                   return SingleChildScrollView(
  //                     child: Row(
  //                       children: item.item.map(
  //                               (attendee) => Padding(
  //                             padding: const EdgeInsets.symmetric(horizontal: 6.0),
  //                             child: getPartnerAttendeeType(context,
  //                                 widget.model,
  //                                 attendee: attendee,
  //                                 didSelectAttendee: (attendee) {
  //
  //                               }
  //                             ),
  //                           )
  //                       ).toList(),
  //                     ),
  //                   );
  //                 },
  //                 orElse: () => Container(),
  //               );
  //             },
  //           ),
  //         ),
  //         const SizedBox(height: 25),
  //         InkWell(
  //           onTap: () {
  //             showGeneralDialog(
  //               context: context,
  //               barrierDismissible: true,
  //               barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
  //               barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
  //               transitionDuration: Duration(milliseconds: 650),
  //               pageBuilder: (BuildContext contexts, anim1, anim2) {
  //                 return Scaffold(
  //                     backgroundColor: Colors.transparent,
  //                     body: Align(
  //                       alignment: Alignment.bottomCenter,
  //                       child: Container(
  //                           decoration: BoxDecoration(
  //                               color: widget.model.accentColor,
  //                               borderRadius: BorderRadius.only(topRight: Radius.circular(17.5), topLeft: Radius.circular(17.5))
  //                           ),
  //                           width: 600,
  //                           height: 750,
  //                           child: CreateNewPartnerForm(
  //                             model: widget.model,
  //                             reservation: context.read<UpdateActivityFormBloc>().state.reservationItem,
  //                           )
  //                       ),
  //                     )
  //                 );
  //               },
  //               transitionBuilder: (context, anim1, anim2, child) {
  //                 return SlideTransition(
  //                   position: Tween(begin: Offset(0, 1), end: Offset(0, 0.01)).animate(anim1),
  //                   child: child,
  //                 );
  //               },
  //             );
  //           },
  //           child: Container(
  //             width: 675,
  //             height: 60,
  //             decoration: BoxDecoration(
  //               color: widget.model.webBackgroundColor,
  //               borderRadius: const BorderRadius.all(Radius.circular(15)),
  //             ),
  //             child: Align(
  //               child: Text('Invite New Partner', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //             ),
  //           ),
  //         ),
  //         Visibility(
  //           // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activityType == ProfileActivityTypeOption.classesLessons,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const SizedBox(height: 25),
  //               Row(
  //                 children: [
  //                   Icon(Icons.sports, color: widget.model.paletteColor),
  //                   const SizedBox(width: 15),
  //                   Expanded(child: Text('About The Instructors', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
  //                 ],
  //               ),
  //               Text(AppLocalizations.of(context)!.activityClassesBackgroundMoreYearsSub, style: TextStyle(color: widget.model.paletteColor)),
  //               const SizedBox(height: 15),
  //               BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.instructor.toString(), context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityFormId.getOrCrash())),
  //                 child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
  //                   builder: (context, state) {
  //                     return state.maybeMap(
  //                       attLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
  //                       loadAllAttendanceFailure: (_) => Container(),
  //                       loadAllAttendanceSuccess: (item) {
  //                         return SingleChildScrollView(
  //                           child: Column(
  //                             children: item.item.map(
  //                               (attendee) => Padding(
  //                                 padding: const EdgeInsets.symmetric(horizontal: 6.0),
  //                                 child: getInstructorAttendeeType(
  //                                     context,
  //                                     widget.model,
  //                                     attendee: attendee,
  //                                     didSelectAttendee: (attendee) {
  //
  //                                     }
  //                                 ),
  //                               )
  //                               ).toList(),
  //                             ),
  //                           );
  //                         },
  //                       orElse: () => Container(),
  //                     );
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               InkWell(
  //                 onTap: () {
  //                   showGeneralDialog(
  //                     context: context,
  //                     barrierDismissible: true,
  //                     barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
  //                     barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
  //                     transitionDuration: Duration(milliseconds: 650),
  //                     pageBuilder: (BuildContext contexts, anim1, anim2) {
  //                       return Scaffold(
  //                           backgroundColor: Colors.transparent,
  //                           body: Align(
  //                             alignment: Alignment.bottomCenter,
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                   color: widget.model.accentColor,
  //                                   borderRadius: BorderRadius.only(topRight: Radius.circular(17.5), topLeft: Radius.circular(17.5))
  //                               ),
  //                               width: 600,
  //                               height: 750,
  //                               child: CreateNewInstructorForm(
  //                                 model: widget.model,
  //                                 reservation: context.read<UpdateActivityFormBloc>().state.reservationItem,
  //                               )
  //                             ),
  //                           )
  //                       );
  //                     },
  //                     transitionBuilder: (context, anim1, anim2, child) {
  //                       return SlideTransition(
  //                         position: Tween(begin: Offset(0, 1), end: Offset(0, 0.01)).animate(anim1),
  //                         child: child,
  //                       );
  //                     },
  //                   );
  //                 },
  //                 child: Container(
  //                   width: 675,
  //                   height: 60,
  //                   decoration: BoxDecoration(
  //                     color: widget.model.webBackgroundColor,
  //                     borderRadius: const BorderRadius.all(Radius.circular(15)),
  //                   ),
  //                   child: Align(
  //                     child: Text('Invite New Instructor', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //                   ),
  //                 ),
  //               )
  //
  //
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

}

