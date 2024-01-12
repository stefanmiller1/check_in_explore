import 'dart:ui';

import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/invite_widgets/send_invitation_request.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/invite_widgets/send_invitation_request_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_card.dart';
import 'package:check_in_web_mobile_explore/presentation/core/loading_containers/loading_widgets.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_attendees/activity_attendees_list_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/widgets/reservation_footer_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityAttendeesListScreen extends StatefulWidget {

  final DashboardModel model;
  final ReservationItem? reservationItem;
  final ActivityManagerForm? activityManagerForm;
  final UserProfileModel? currentUser;
  late AttendeeItem? selectedAttendee;
  late UserProfileModel? selectedUserProfile;
  final Function(AttendeeItem attendee, UserProfileModel user) didSelectAttendee;

  ActivityAttendeesListScreen({super.key, required this.model, required this.activityManagerForm, required this.reservationItem, required this.didSelectAttendee, required this.currentUser, this.selectedAttendee, this.selectedUserProfile});

  @override
  State<ActivityAttendeesListScreen> createState() => _ActivityAttendeesListScreenState();
}

class _ActivityAttendeesListScreenState extends State<ActivityAttendeesListScreen> {

  late TextEditingController _textController;
  String querySearch = '';
  bool isLoading = false;

  @override
  void initState() {
    _textController = TextEditingController();
    widget.selectedAttendee = null;
    widget.selectedUserProfile = null;
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: (kIsWeb) ? Colors.transparent : null,
        appBar: (!(kIsWeb)) ? AppBar(
          elevation: 0,
          backgroundColor: widget.model.paletteColor,
          title: Text('Attendees', style: TextStyle(color: widget.model.accentColor)),
          actions: [
            /// add 'invite' button (and edit button)`
          ],
        ) : null,
      body: (widget.currentUser != null && widget.reservationItem != null && widget.activityManagerForm != null) ?
        BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendance(widget.reservationItem!.reservationId.getOrCrash())),
        child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
        builder: (context, state) {
        return state.maybeMap(
        loadAllAttendanceActivitySuccess: (allAttendees) {

        final AttendeeItem? currentAttendee = allAttendees.item.where((element) => element.attendeeOwnerId == widget.currentUser?.userId).isNotEmpty ? allAttendees.item.where((element) => element.attendeeOwnerId == widget.currentUser?.userId).first : null;
        final bool isAttendee = currentAttendee != null && currentAttendee.contactStatus == ContactStatus.joined;
        final bool isOwner = widget.reservationItem?.reservationOwnerId == widget.currentUser?.userId;

      return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Container(
                    height: 75,
                    // width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: widget.model.accentColor.withOpacity(0.35)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                                controller: _textController,
                                style: TextStyle(color: widget.model.paletteColor),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.zoom_out, color: widget.model.disabledTextColor),
                                  hintText: 'Search a Name or Email',
                                  errorStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: widget.model.disabledTextColor
                                  ),
                                  filled: true,
                                  contentPadding: const EdgeInsets.only(bottom: 15, top: 15),
                                  fillColor: widget.model.accentColor,
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        color: widget.model.paletteColor,
                                        width: 0
                                    ),
                                  ),
                                  focusedBorder:  OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent,
                                        width: 0
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: const BorderSide(
                                      width: 0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: widget.model.webBackgroundColor,
                                      width: 0,
                                    ),
                                  ),
                                ),
                                autocorrect: true,
                                keyboardType: TextInputType.name,
                                maxLines: 1,
                                minLines: 1,
                                onChanged: (query) {
                                  setState(() {
                                    querySearch = query.toLowerCase();
                                    isLoading = true;
                                  });

                                  Future.delayed(const Duration(milliseconds: 750), () {
                                    setState(() {
                                      isLoading = false;
                                    });
                                });
                            }
                          ),
                        ),
                      ),
                    ),
                  )
                ),
                /// show current list
                if (isLoading == false) Expanded(
                  child: GestureDetector(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 15),

                                if (querySearch.isEmpty) Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isOwner && allAttendees.item.where((element) => element.contactStatus == ContactStatus.requested).toList().isNotEmpty) getActivityRequestedAttendees(widget.activityManagerForm!, allAttendees.item.where((element) => element.contactStatus == ContactStatus.requested).toList()),
                                    activityOwnerList(widget.reservationItem!),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Divider(color: widget.model.disabledTextColor),
                                    ),
                                  ],
                                ),

                                /// all reservation affiliates
                                if (allAttendees.item.where((element) => element.attendeeType == AttendeeType.partner).isNotEmpty) getActivityPartnersAttendees(widget.activityManagerForm!, allAttendees.item.where((element) => element.attendeeType == AttendeeType.partner).toList()),
                                if (allAttendees.item.where((element) => element.attendeeType == AttendeeType.instructor).isNotEmpty) getActivityInstructorAttendees(widget.activityManagerForm!, allAttendees.item.where((element) => element.attendeeType == AttendeeType.instructor).toList()),
                                if (allAttendees.item.where((element) => element.attendeeType == AttendeeType.vendor).isNotEmpty) getActivityVendorAttendees(widget.activityManagerForm!, allAttendees.item.where((element) => element.attendeeType == AttendeeType.vendor).toList()),

                                /// reservation attendees for attendees or owner - show each
                                if (isOwner || isAttendee) Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Visibility(
                                          visible: attendeesOnlyList(allAttendees.item).isNotEmpty && querySearch.isEmpty,
                                          child: Text('Attendees', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize))),
                                      const SizedBox(height: 8),
                                      getActivityAllAttendees(widget.activityManagerForm!, attendeesOnlyList(allAttendees.item)),
                                  ]
                                ),

                                /// if not an attendee - show totals
                                const SizedBox(height: 225),
                              ]
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                if (isLoading == true) Expanded(
                  child: SingleChildScrollView(
                    child: emptyLoadingListView(context, kIsWeb),
                  ),
                )
              ],
            ),


            Container(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: ClipRRect(
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: widget.model.accentColor.withOpacity(0.35)
                            ),
                            child: getSelectedAttendeeFooterWidget(context, widget.activityManagerForm!, isOwner, currentAttendee, allAttendees.item))
                  ),
                ),
              )
            ),
          ],
        );
    },
    orElse: () => noItemsFound(
      widget.model,
      Icons.people_alt_outlined,
      'No Attendees Yet!',
      'Join this reservation to be get added to the attending list',
      'Go Back',
      didTapStartButton: () {})
        );
      },
    )) : noItemsFound(
          widget.model,
          Icons.people_alt_outlined,
          'No Attendees Yet!',
          'Join this reservation to be get added to the attending list',
          'Go Back',
          didTapStartButton: () {})
    );
  }


  Widget getSelectedAttendeeFooterWidget(BuildContext context, ActivityManagerForm activityForm, bool isOwner, AttendeeItem? currentAttendee, List<AttendeeItem> allAttendees) {
    final bool isAttendee = true;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if ((isOwner) || isAttendee)
          if (widget.reservationItem != null && widget.activityManagerForm != null) getNumberOfAttendees(widget.activityManagerForm!, widget.reservationItem!, isOwner, currentAttendee, allAttendees),

        // getHeaderAttendeeByType(ActivityAttendeeHelperCore.selectedAttendeeItem!.attendeeType),
        const SizedBox(height: 10),
        Expanded(
          child: Row(
            children: [
              if (isOwner) Expanded(
                child: InkWell(
                  onTap: () {

                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: widget.model.paletteColor
                      ),
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Center(child: Text('Edit Attendees', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1,)),
                      )
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if ((widget.activityManagerForm?.rulesService.accessVisibilitySetting.isInviteOnly == false) || (widget.activityManagerForm?.rulesService.accessVisibilitySetting.isPrivateOnly == false) || isOwner) Expanded(
                child: InkWell(
                  onTap: () {
                    didSelectInvitationRequest(
                        context: context,
                        model: widget.model,
                        currentUser: widget.currentUser!,
                        attendeeType: AttendeeType.free,
                        reservationItem: widget.reservationItem!,
                        inviteType: InvitationType.reservation,
                        activityManagerForm: widget.activityManagerForm
                    );
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: widget.model.paletteColor
                      ),
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Center(child: Text('Invite', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold))),
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (!(kIsWeb)) const SizedBox(height: 15),
      ]
    );
  }

  Widget getNumberOfAttendees(ActivityManagerForm activityForm, ReservationItem reservation, bool isOwner, AttendeeItem? currentAttendee, List<AttendeeItem> allAttendees) {
    return Column(
      children: [
        getReservationFooterWidget(
          context,
          widget.model,
          activityForm,
          reservation,
          currentAttendee,
          allAttendees,
          widget.currentUser!.userId,
          isOwner,
          true,
          didSelectFindPass: () { },
          didSelectManage: () { },
          didSelectJoin: () { },
          didSelectManageTickets: () { },
          didSelectFindTickets: () { },
          didSelectManagePasses: () { },
          didSelectShare: () { },
          didSelectMoreOptions: () { },
          didSelectInterested: () { }
        )
      ]
    );
  }



  /// if not an attendee show numbers?
  /// if not attendee show attendee of those in your circle

  /// watchActivityOwners
  Widget activityOwnerList(ReservationItem reservation) {
    final AttendeeItem resOwner = AttendeeItem(attendeeId: UniqueId(), attendeeOwnerId: reservation.reservationOwnerId, reservationId: reservation.reservationId, cost: '', contactStatus: ContactStatus.pending, paymentStatus: PaymentStatusType.noStatus, attendeeType: AttendeeType.free, paymentIntentId: '', dateCreated: DateTime.now());

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Host', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
          const SizedBox(height: 8),
          getActivityAttendeeTile(
            widget.model,
            resOwner,
            widget.selectedAttendee?.attendeeOwnerId == reservation.reservationOwnerId,
            didSelectAttendee: (attendee, user) {
              setState(() {
                widget.didSelectAttendee(attendee, user);
            });
          }
        ),
      ]
    );
  }


  Widget getActivityRequestedAttendees(ActivityManagerForm activityForm, List<AttendeeItem> attendees) {
    if (querySearch.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Requests', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
          const SizedBox(height: 8),
          ...attendees.map(
                  (e) => getActivityAttendeeTile(
                  widget.model,
                  e,
                  widget.selectedAttendee?.attendeeOwnerId == e.attendeeOwnerId,
                  didSelectAttendee: (attendee, user) {
                    setState(() {
                      widget.didSelectAttendee(attendee, user);
                    });
                  })).toList(),
          const SizedBox(height: 8),
        ],
      );
    }
    return Container();
  }

  Widget getActivityPartnersAttendees(ActivityManagerForm activityForm, List<AttendeeItem> attendees) {
      if (querySearch.isNotEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...querySearchItems(attendees).map(
                    (e) => getActivityAttendeeTile(
                    widget.model,
                    e,
                    widget.selectedAttendee?.attendeeOwnerId == e.attendeeOwnerId,
                    didSelectAttendee: (attendee, user) {
                      setState(() {
                        widget.didSelectAttendee(attendee, user);
                      });
                    })).toList()
          ],
        );
      } else {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Partners', style: TextStyle(color: widget.model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
            const SizedBox(height: 8),
            ...attendees.map(
                (e) => getActivityAttendeeTile(
                        widget.model,
                        e,
                        widget.selectedAttendee?.attendeeOwnerId == e.attendeeOwnerId,
                        didSelectAttendee: (attendee, user) {
                          setState(() {
                            widget.didSelectAttendee(attendee, user);
                          });
                        })).toList(),

          ],
        ),
      );
    }
  }


  Widget getActivityInstructorAttendees(ActivityManagerForm activityForm, List<AttendeeItem> attendees) {
              if (querySearch.isNotEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...querySearchItems(attendees).map(
                            (e) {
                              return getActivityAttendeeTile(
                                  widget.model,
                                  e,
                                  widget.selectedAttendee?.attendeeOwnerId == e.attendeeOwnerId,
                                  didSelectAttendee: (attendee, user) {
                                    setState(() {
                                      widget.didSelectAttendee(attendee, user);
                                    });
                                  }
                              );
                            }).toList()
                  ],
                );
              } else {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Instructor', style: TextStyle(color: widget.model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    const SizedBox(height: 8),
                    ...attendees.map(
                            (e) => getActivityAttendeeTile(
                            widget.model,
                            e,
                            widget.selectedAttendee?.attendeeOwnerId == e.attendeeOwnerId,
                            didSelectAttendee: (attendee, user) {
                              setState(() {
                                widget.didSelectAttendee(attendee, user);
                              });
                            })).toList()
          ],
        ),
      );
    }
  }


  Widget getActivityVendorAttendees(ActivityManagerForm activityForm, List<AttendeeItem> attendees) {
              if (querySearch.isNotEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...querySearchItems(attendees).map(
                            (e) => getActivityAttendeeTile(
                            widget.model,
                            e,
                            widget.selectedAttendee?.attendeeOwnerId == e.attendeeOwnerId,
                            didSelectAttendee: (attendee, user) {
                              setState(() {
                                widget.didSelectAttendee(attendee, user);
                              });
                            })).toList()
                  ],
                );
              } else {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vendors', style: TextStyle(color: widget.model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    const SizedBox(height: 8),
                    ...attendees.map(
                            (e) => getActivityAttendeeTile(
                            widget.model,
                            e,
                            widget.selectedAttendee?.attendeeOwnerId == e.attendeeOwnerId,
                            didSelectAttendee: (attendee, user) {
                              setState(() {
                                widget.didSelectAttendee(attendee, user);
                              });
                            })).toList()
          ],
        ),
      );
    }
  }


  Widget getActivityAllAttendees(ActivityManagerForm activityForm, List<AttendeeItem> attendees) {
    if (querySearch.isNotEmpty) {
      return Column(
        children: [
          ...querySearchItems(attendees).map(
                  (e) => getActivityAttendeeTile(
                  widget.model,
                  e,
                  widget.selectedAttendee?.attendeeOwnerId == e.attendeeOwnerId,
                  didSelectAttendee: (attendee, user) {
                    setState(() {
                      widget.didSelectAttendee(attendee, user);
                    });
                  })).toList()
        ],
      );
    } else {
    return Column(
      children: [
        ...attendees.map(
                (e) => getActivityAttendeeTile(
                widget.model,
                e,
                widget.selectedAttendee?.attendeeOwnerId == e.attendeeOwnerId,
                didSelectAttendee: (attendee, user) {
                  setState(() {
                    widget.didSelectAttendee(attendee, user);
                  });
                })).toList()
        ],
      );
    }
  }

  
  List<AttendeeItem> querySearchItems(List<AttendeeItem> allAttendees) {
    return allAttendees.where((element) => (element.attendeeDetails?.name.value.fold((l) => '', (r) => r).toLowerCase().contains(querySearch) ?? false)).toList();
  }
}