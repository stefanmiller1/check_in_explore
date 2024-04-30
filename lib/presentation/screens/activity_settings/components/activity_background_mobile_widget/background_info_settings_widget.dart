import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_picker_web/image_picker_web.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';

import 'package:check_in_web_mobile_explore/presentation/core/conditional/mobile/image_selector_widget_mobile.dart' if (dart.library.html) 'package:check_in_web_mobile_explore/presentation/core/conditional/web/image_selector_widget_web.dart';


class BackgroundInfoSettingsWidget extends StatefulWidget {

  final DashboardModel model;
  final ReservationItem reservationItem;
  final UserProfileModel currentUser;
  final ActivityManagerForm activityManagerForm;


  const BackgroundInfoSettingsWidget({Key? key, required this.model, required this.activityManagerForm, required this.currentUser, required this.reservationItem}) : super(key: key);

  @override
  State<BackgroundInfoSettingsWidget> createState() => _BackgroundInfoSettingsWidgetState();
}

class _BackgroundInfoSettingsWidgetState extends State<BackgroundInfoSettingsWidget> {

  ScrollController? _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    super.initState();
  }


  void _handleCreateNewAttendeePartner(BuildContext context) {
    if (kIsWeb) {
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: 'Send Invite',
        transitionDuration: Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return  Align(
              alignment: Alignment.center,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: Container(
                      decoration: BoxDecoration(
                          color: widget.model.accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(17.5))
                      ),
                      width: 550,
                      height: 750,
                      child: SendInvitationRequest(
                        model: widget.model,
                        currentUserId: widget.currentUser.userId.getOrCrash(),
                        attendeeType: AttendeeType.partner,
                        reservationItem: widget.reservationItem,
                        inviteType: InvitationType.reservation,
                        activityForm: widget.activityManagerForm,
                        didSelectInvite: (contacts) {},

                      )
                  )
              )
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                  opacity: anim1.value,
                  child: child
              )
          );
        },
      );
    } else {
      Navigator.push(context, MaterialPageRoute(
          builder: (_) {
            return SendInvitationRequest(
              model: widget.model,
              currentUserId: widget.currentUser.userId.getOrCrash(),
              attendeeType: AttendeeType.partner,
              reservationItem: widget.reservationItem,
              inviteType: InvitationType.reservation,
              activityForm: widget.activityManagerForm,
              didSelectInvite: (contacts) {},
            );
          })
      );
    }
  }

  void _handleCreateNewAttendeeInstructor(BuildContext context) {
    if (kIsWeb) {
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: 'Send Invite',
        transitionDuration: Duration(milliseconds: 350),
        pageBuilder: (BuildContext contexts, anim1, anim2) {
          return  Align(
              alignment: Alignment.center,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: Container(
                      decoration: BoxDecoration(
                          color: widget.model.accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(17.5))
                      ),
                      width: 550,
                      height: 750,
                      child: SendInvitationRequest(
                        model: widget.model,
                        currentUserId: widget.currentUser.userId.getOrCrash(),
                        attendeeType: AttendeeType.instructor,
                        reservationItem: widget.reservationItem,
                        inviteType: InvitationType.reservation,
                        activityForm: widget.activityManagerForm,
                        didSelectInvite: (contacts) {},

                      )
                  )
              )
          );
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                  opacity: anim1.value,
                  child: child
              )
          );
        },
      );
    } else {
      Navigator.push(context, MaterialPageRoute(
          builder: (_) {
            return SendInvitationRequest(
              model: widget.model,
              currentUserId: widget.currentUser.userId.getOrCrash(),
              attendeeType: AttendeeType.instructor,
              reservationItem: widget.reservationItem,
              inviteType: InvitationType.reservation,
              activityForm: widget.activityManagerForm,
              didSelectInvite: (contacts) {},
            );
          })
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendance(widget.reservationItem.reservationId.getOrCrash())),
        child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
            builder: (context, state) {
              return state.maybeMap(
                  loadAllAttendanceActivitySuccess: (allAttendees) => getMainContainer(context, allAttendees.item),
                  orElse: () => getMainContainer(context, [])
              );
            }
        )
    );
  }


  Widget getMainContainer(BuildContext context, List<AttendeeItem> attendees) {
    bool isLessThanMain = (MediaQuery.of(context).size.width <= 1150) || ReservationHelperCore.didPresentSidePanel;

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
                child: Row(
                  children: [
                    if (isLessThanMain) Flexible(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          children: [
                            ImageSelectorWithPreview(
                              model: widget.model,
                              currentImageList: widget.activityManagerForm.profileService.activityBackground.activityProfileImages ?? [],
                              imagesToUpLoad: (images) {
                                setState(() {
                                  context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityProfileImagesChanged(images));
                                });
                              },
                            ),
                            mainContainerForSectionOneRowOne(
                                context: context,
                                model: widget.model,
                                state: context.read<UpdateActivityFormBloc>().state,
                                activityManagerForm: widget.activityManagerForm,
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
                                activityForm: widget.activityManagerForm,
                                isPartnersInviteOnly: (isPartner) {
                                  setState(() {
                                    if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.isPartnersInviteOnly == true) {
                                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isPartnersInviteOnly(false));
                                    } else {
                                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isPartnersInviteOnly(true));
                                    }
                                  });
                                },
                                isInstructorInviteOnly: (isInvite) {
                                  setState(() {
                                    if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.isInstructorInviteOnly == true) {
                                      context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.isInstructorInviteOnly(false));
                                    } else {
                                      context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.isInstructorInviteOnly(true));
                                    }
                                  });
                                },
                                getPartnerAttendees: getPartnerAttendees(attendees.where((element) => element.attendeeType == AttendeeType.partner).toList()),
                                didSelectCreateNewPartner: () {
                                  _handleCreateNewAttendeePartner(context);
                                },
                                getInstructorAttendees: getInstructorAttendees(attendees.where((element) => element.attendeeType == AttendeeType.instructor).toList()),
                                didSelectCreateInstructor: () {
                                  _handleCreateNewAttendeeInstructor(context);
                                }
                            ),
                            const SizedBox(height: 25),
                            if (widget.activityManagerForm.profileService.isActivityPost == null || widget.activityManagerForm.profileService.isActivityPost == true) mainActivityBackgroundContainerFooter(
                              context: context,
                              model: widget.model,
                              activityForm: widget.activityManagerForm,
                              state: context.read<UpdateActivityFormBloc>().state,
                              contactEmailChanged: (value) {
                                context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityPostContactEmail(value));
                              },
                              contactWebsiteChanged: (value) {
                                context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityPostContactWebsite(value));
                              },
                              contactInstagramChanged: (value) {
                                context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityPostContactInstagram(value));
                              }
                            )
                          ],
                        ),
                      ),
                    ) else Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageSelectorWithPreview(
                            model: widget.model,
                            currentImageList: widget.activityManagerForm.profileService.activityBackground.activityProfileImages ?? [],
                            imagesToUpLoad: (images) {
                              setState(() {
                                context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityProfileImagesChanged(images));
                              });
                            },
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child:  mainContainerForSectionOneRowOne(
                                  context: context,
                                  model: widget.model,
                                  state: context.read<UpdateActivityFormBloc>().state,
                                  activityManagerForm: widget.activityManagerForm,
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
                                  activityForm: widget.activityManagerForm,
                                  isPartnersInviteOnly: (isPartner) {
                                    setState(() {
                                      if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.isPartnersInviteOnly ?? false) {
                                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPartnersInviteOnly(false));
                                      } else {
                                        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isPartnersInviteOnly(true));
                                      }
                                    });
                                  },
                                  isInstructorInviteOnly: (isInvite) {
                                    setState(() {
                                      if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityBackground.isInstructorInviteOnly == true) {
                                        context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.isInstructorInviteOnly(false));
                                      } else {
                                        context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.isInstructorInviteOnly(true));
                                      }
                                    });
                                  },
                                  getPartnerAttendees: getPartnerAttendees(attendees.where((element) => element.attendeeType == AttendeeType.partner).toList()),
                                  didSelectCreateNewPartner: () {
                                    _handleCreateNewAttendeePartner(context);
                                  },
                                  getInstructorAttendees: getInstructorAttendees(attendees.where((element) => element.attendeeType == AttendeeType.instructor).toList()),
                                  didSelectCreateInstructor: () {
                                    _handleCreateNewAttendeeInstructor(context);
                                  }
                                ),
                              ),
                            if (MediaQuery.of(context).size.width >= 1300) SizedBox(width: MediaQuery.of(context).size.width * 0.1)
                          ],
                        ),
                        const SizedBox(height: 25),
                        if (widget.activityManagerForm.profileService.isActivityPost == null || widget.activityManagerForm.profileService.isActivityPost == true) mainActivityBackgroundContainerFooter(
                            context: context,
                            model: widget.model,
                            activityForm: widget.activityManagerForm,
                            state: context.read<UpdateActivityFormBloc>().state,
                            contactEmailChanged: (value) {
                              context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityPostContactEmail(value));
                            },
                            contactWebsiteChanged: (value) {
                              context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityPostContactWebsite(value));
                            },
                            contactInstagramChanged: (value) {
                              context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.activityPostContactInstagram(value));
                            }
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: ReservationHelperCore.didPresentSidePanel && isLessThanMain == false,
                      child: AnimatedContainer(
                        width: (ReservationHelperCore.didPresentSidePanel && isLessThanMain == false) ? ReservationHelperCore.previewerWidth + 20 : 0,
                        duration: const Duration(milliseconds: 650),
                        curve: Curves.easeInOut,
                        child: Visibility(
                          visible: ReservationHelperCore.didPresentSidePanel,
                          child: Row(
                            children: [
                              const SizedBox(width: 60),
                              Expanded(
                                child: SizedBox(
                                    width: ReservationHelperCore.previewerWidth,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  )
                ],
              )
            )
          )
        ],
      ),
    );
  }


  Widget getPartnerAttendees(List<AttendeeItem> partners) {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: partners.map(
                  (attendee) => Padding(
                padding: const EdgeInsets.all(6.0),
                child: getPartnerAttendeeType(context,
                    widget.model,
                    attendee: attendee,
                    didSelectAttendee: (attendee) {

                  }
                ),
              )
          ).toList(),
        ),
      ),
    );
  }

  Widget getInstructorAttendees(List<AttendeeItem> instructors) {
    return SingleChildScrollView(
        child: Column(
          children: instructors.map(
            (attendee) => Padding(
              padding: const EdgeInsets.all(6.0),
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
  }

}

