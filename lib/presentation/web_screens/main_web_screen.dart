import 'package:beamer/beamer.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_presentation/core/router_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/dashboard_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/dashboard_main.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/focused_main_container_widgets/activity_attendee_widget/activity_attendee_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/focused_main_container_widgets/activity_settings_widet/activity_settings_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/chat_widget/chat_main_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/profile_widget/profile_main_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/reservations_widget/reservation_main_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/search_explore_widgets/search_explore_main_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_web_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/sub_container_widgets/chat_widget/chat_sub_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/sub_container_widgets/reservation_widget/reservation_sub_container_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/activity_settings/pop_over_screen/activity_onboarding_widget.dart';
import 'focused_main_container_widgets/activity_vendor_form_manage_widget/activity_vendor_form_manage_container_widget.dart';
import 'focused_main_container_widgets/activity_vendor_form_manage_widget/actvity_vendor_form_manager_helper.dart';
import 'main_container_widgets/settings_widget/settings_main_container_widget.dart';
import 'sub_container_widgets/activity_settings_widget/activity_settings_sub_main_widget.dart';
import 'sub_container_widgets/activity_vendor_manager_widget/activity_vendor_manager_sub_container_widget.dart';
import 'sub_container_widgets/settings_widget/settings_sub_container_widget.dart';
import 'package:check_in_facade/check_in_facade.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:check_in_web_mobile_explore/presentation/core/core_helper.dart' if (dart.library.html) 'package:check_in_web_mobile_explore/presentation/core/core_helper_web.dart';


class MainWebScreen extends StatefulWidget {

  final DashboardModel model;
  final bool? isCreatingNewActivity;
  final DashboardMarker initialDashboardMarker;
  final UniqueId? initialReservationId;

  const MainWebScreen({super.key, required this.model, required this.initialDashboardMarker, this.initialReservationId, this.isCreatingNewActivity});

  @override
  State<MainWebScreen> createState() => _MainWebScreenState();
}

class _MainWebScreenState extends State<MainWebScreen> {

  late bool? isCreatingNewActivity = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    isCreatingNewActivity = widget.isCreatingNewActivity;
    context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.currentDashboardMarker(widget.initialDashboardMarker));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {
          return authState.maybeMap(
              loadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
              loadProfileFailure: (_) => retrieveAuthenticationState(null, [], [], [], null, null, null, null, []),
              loadUserProfileSuccess: (item) => retrieveCurrentReservations(item.profile),
              orElse: () {
                return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
              }
          );
        },
      ),
    );
  }


  Widget retrieveCurrentReservations(UserProfileModel currentUser) {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchCurrentUsersReservations([ReservationSlotState.current], currentUser, false, 2, null)),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadCurrentUserReservationsSuccess: (e) {
                return BlocProvider(create: (_) => getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFromReservations(e.item.map((e) => e.reservationId).toList())),
                  child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
                    builder: (context, state) {
                      return state.maybeMap(
                          loadActivityManagerFromResSuccess: (items) {
                            return retrieveSelectedReservation(currentUser, e.item, items.items);
                          },
                          orElse: () => retrieveSelectedReservation(currentUser, e.item, [])
                      );
                    },
                  ),
                );
              },
            orElse: () {
                return retrieveSelectedReservation(currentUser, [], []);
            }
          );
        },
      ),
    );
  }

  // Widget retrieveActivityManagerForms(UserProfileModel currentUser, List<ReservationItem> currentResList) {
  //   if (ReservationHelperCore.selectedReservationItem != null) {
  //
  //   } else if (widget.initialReservationId != null) {
  //     return BlocProvider(create: (_) => getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFromReservations(currentResList.map((e) => e.reservationId.getOrCrash()).toList())),
  //       child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
  //         builder: (context, state) {
  //           return state.maybeMap(
  //               loadActivityManagerFromResSuccess: (items) {
  //                 return retrieveNotifications(currentUser, currentResList, items.items, null, null, null, null, []);
  //               },
  //               orElse: () => retrieveNotifications(currentUser, currentResList, [], null, null, null, null, [])
  //           );
  //         },
  //       ),
  //     );
  //   }
  //   return retrieveNotifications(currentUser, [], [], null, null, null, null, []);
  // }

  //
  Widget retrieveSelectedReservation(UserProfileModel? currentUser, List<ReservationItem> reservations, List<ActivityManagerForm> activities,) {
    if (ReservationHelperCore.selectedReservationItem != null) {
      return retrieveNotifications(currentUser, reservations, activities, ReservationHelperCore.selectedReservationItem!, null, null, null, []);
    } else if (widget.initialReservationId != null) {
      return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationItem(widget.initialReservationId!.getOrCrash())),
        child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
              // resLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
              loadReservationItemSuccess: (e) {
                return retrieveNotifications(currentUser, reservations, activities, e.item, null, null, null, []);
                // ReservationHelperCore.selectedReservationItem ??= e.item;
                // // return retrieveSelectedReservationListing(currentUser, reservations, activities, e.item);
                //   return BlocProvider(create: (_) => getIt<ListingManagerWatcherBloc>()..add(ListingManagerWatcherEvent.watchListingManagerItemStarted(e.item.instanceId.getOrCrash())),
                //     child: BlocBuilder<ListingManagerWatcherBloc, ListingManagerWatcherState>(
                //       builder: (context, state) {
                //         return state.maybeMap(
                //             loadListingManagerItemSuccess: (item) {
                //               ReservationHelperCore.currentListingManagerForm ??= item.failure;
                //               return retrieveSelectedReservationActivity(currentUser, reservations, activities, e.item, item.failure);
                //             },
                //         orElse: () => retrieveSelectedReservationActivity(currentUser, reservations, activities, e.item, null)
                //       );
                //     },
                //   ),
                // );
              },
              orElse: () => retrieveNotifications(currentUser, reservations, activities, null, null, null, null, []),
            );
          },
        )
      );
    } else {
      return retrieveNotifications(currentUser, reservations, activities, null, null, null, null, []);
    }
  }


  // Widget retrieveSelectedReservationActivity(UserProfileModel? currentUser, List<ReservationItem> reservations, List<ActivityManagerForm> activities, ReservationItem? selectedReservation, ListingManagerForm? selectedListingForm,) {
  //   if (selectedReservation != null) {
  //     return BlocProvider(create: (_) => getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(selectedReservation.reservationId.getOrCrash())),
  //       child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
  //         builder: (context, state) {
  //           return state.maybeMap(
  //             loadActivityManagerFormSuccess: (item) {
  //                 return selectedReservationAttendeeItem(currentUser, reservations, activities, selectedReservation, selectedListingForm, item.item);
  //               },
  //             orElse: () => selectedReservationAttendeeItem(currentUser, reservations, activities, selectedReservation, selectedListingForm, null),
  //           );
  //         },
  //       ),
  //     );
  //   } else {
  //     return retrieveNotifications(currentUser, reservations, activities, null, null, null, null, []);
  //   }
  // }


  // Widget selectedReservationAttendeeItem(UserProfileModel? currentUser, List<ReservationItem> reservations, List<ActivityManagerForm> activities, ReservationItem? selectedReservation, ListingManagerForm? selectedListingForm, ActivityManagerForm? selectedActivityForm, ) {
  //   if (selectedReservation != null && currentUser != null) {
  //     return BlocProvider(create: (context) => getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAttendeeItem(selectedReservation.reservationId.getOrCrash(), currentUser.userId.getOrCrash())),
  //         child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
  //             builder: (context, state) {
  //               return state.maybeMap(
  //                   loadAttendeeItemSuccess: (attendee) {
  //                     return retrieveNotifications(currentUser, reservations, activities, selectedReservation, selectedListingForm, selectedActivityForm, attendee.item, []);
  //                   },
  //                   orElse: () {
  //               return retrieveNotifications(currentUser, reservations, activities, selectedReservation, selectedListingForm, selectedActivityForm, null, []);
  //             }
  //           );
  //         }
  //       )
  //     );
  //   } else {
  //     return retrieveNotifications(currentUser, reservations, activities, null, null, null, null, []);
  //   }
  // }

  Widget retrieveNotifications(UserProfileModel? currentUser, List<ReservationItem> reservations, List<ActivityManagerForm> activities, ReservationItem? selectedReservation, ListingManagerForm? selectedListingForm, ActivityManagerForm? selectedActivityForm, AttendeeItem? selectedReservationAttendance, List<TicketItem> selectedReservationAllAttendees) {
    return BlocProvider(create: (_) => getIt<NotificationWatcherBloc>()..add(const NotificationWatcherEvent.watchAllAccountNotificationAmountByType([AccountNotificationType.invite, AccountNotificationType.request, AccountNotificationType.activityPost, AccountNotificationType.joined, AccountNotificationType.message, AccountNotificationType.resSlot], null)),
        child: BlocBuilder<NotificationWatcherBloc, NotificationWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                  loadAllAccountNotificationByTypeSuccess: (item) {
                    return retrieveAuthenticationState(currentUser, reservations, activities, item.notifications, selectedReservation, selectedListingForm, selectedActivityForm, selectedReservationAttendance, selectedReservationAllAttendees);
                  },
            orElse: () {
              return retrieveAuthenticationState(currentUser, reservations, activities, [], selectedReservation, selectedListingForm, selectedActivityForm, selectedReservationAttendance, selectedReservationAllAttendees);
            }
          );
        }
      )
    );
  }


  Widget retrieveAuthenticationState(UserProfileModel? currentUser, List<ReservationItem> reservations, List<ActivityManagerForm> activities, List<AccountNotificationItem> notifications, ReservationItem? selectedReservation, ListingManagerForm? selectedListingForm, ActivityManagerForm? selectedActivityForm, AttendeeItem? selectedReservationAttendance, List<TicketItem> selectedReservationAllAttendees) {
    final searchExploreContainer = SearchExploreMainContainerWidget(
        model: widget.model,
        didUpdate: () {setState(() {
        });},
        currentUser: ChatHelperCore.currentUserProfile,
    );
    final reservationContainer = ReservationMainContainerWidget(
        initialReservationId: widget.initialReservationId,
        model: widget.model
    );
    final reservationSubContainer = ReservationSubContainerWidget(
      model: widget.model,
      notifications: notifications,
      initialReservationId: widget.initialReservationId,
      didSelectReservation: () {
        setState(() {
          _scaffoldKey.currentState?.closeDrawer();
        });
      },
    );
    final chatContainer = ChatMainContainerWidget(
      model: widget.model,
      room: ChatHelperCore.selectedRoom,
      currentUser: ChatHelperCore.currentUserProfile,
    );
    final chatSubContainer = ChatSubContainerWidget(
      model: widget.model,
      didSelectRoom: () {
        setState(() {});
      },
    );
    profileContainer(UserProfileModel currentUserProfile) => ProfileMainContainerWidget(
      model: widget.model,
      currentUser: currentUserProfile,
    );
    final activityAttendeeMainContainer = ActivityAttendeeMainContainerWidget(
      model: widget.model,
        attendee: ActivityAttendeeHelperCore.selectedAttendeeItem,
        selectedProfile: ActivityAttendeeHelperCore.selectedUserProfileItem,
        rebuild: () {
          setState(() {});
      },
    );
    final activityAttendeesSubContainer = ActivityAttendeesListScreen(
      model: widget.model,
      // initialReservationId: widget.initialReservationId,
      reservationItem: ReservationHelperCore.selectedReservationItem,
      activityManagerForm: ReservationHelperCore.currentActivityForm,
      selectedAttendee: ReservationHelperCore.selectedReservationAttendeeItem,
      currentUser: currentUser?.userId.value.fold((l) => null, (r) => r),
      selectedUserProfile: currentUser,
      didSelectAttendee: (attendee, user) {
        setState(() {
          ActivityAttendeeHelperCore.isLoading = true;
          if (ActivityAttendeeHelperCore.selectedAttendeeItem?.attendeeOwnerId == attendee.attendeeOwnerId) {
            ActivityAttendeeHelperCore.selectedAttendeeItem = null;
            ActivityAttendeeHelperCore.selectedUserProfileItem = null;
          } else {
            ActivityAttendeeHelperCore.selectedAttendeeItem = attendee;
            ActivityAttendeeHelperCore.selectedUserProfileItem = user;
          }
        });
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            ActivityAttendeeHelperCore.isLoading = false;
          });
        });
      }
    );

    final activitySettingsContainer = ActivitySettingsMainContainerWidget(
      model: widget.model,
      initialReservation: selectedReservation,
      // listingForm: ReservationHelperCore.currentListingManagerForm,
      // reservationItem: ReservationHelperCore.selectedReservationItem,
      currentUser: currentUser,
      // activityManagerForm: ReservationHelperCore.currentActivityForm,
      currentNavItem: ReservationHelperCore.currentSettingsItemModel,
      rebuild: () {
        setState(() {});
      },
      didPresentSidePanel: () {
        setState(() {
          ReservationHelperCore.didPresentSidePanel = !ReservationHelperCore.didPresentSidePanel;
        });
      }
    );

    final activitySettingsSubContainer = ActivitySubSettingsContainer(
        model: widget.model,
        currentUser: currentUser,
        currentSelectedSettingItem: ReservationHelperCore.currentSettingsItemModel,
        initialReservationId: selectedReservation,
        // currentAttendee: ActivityAttendeeHelperCore.selectedAttendeeItem,
        // currentReservationItem: ReservationHelperCore.selectedReservationItem,
        didSelectNavItem: (selectedNav) {
          setState(() {
            ReservationHelperCore.currentSettingsItemModel = selectedNav;

            if (selectedReservation != null) {
                Beamer.of(context).update(
                  configuration: RouteInformation(
                      location: reservationSettingsRoute(selectedReservation.reservationId.getOrCrash(), selectedNav.navItem.name)
                ),
                rebuild: false
            );
          }
        });
      },
    );

    final activityVendorFormMainContainer = ActivityVendorFormManageMainContainerWidget(
      model: widget.model,
      initialReservation: selectedReservation,
      // activityManagerForm: ReservationHelperCore.currentActivityForm,
      // initialReservationId: widget.initialReservationId,
      selectedForm: ActivityVendorHelperCore.selectedForm,
      rebuild: () {
        setState(() {
        });
      },
    );

    final activityVendorFormSubContainer = ActivityVendorManagerSubContainer(
        model: widget.model,
        initialReservation: selectedReservation,
        // currentReservationItem: ReservationHelperCore.selectedReservationItem,
        currentVendorManagerForm: ActivityVendorHelperCore.selectedForm,
        currentUser: currentUser,
        // listing: ReservationHelperCore.currentListingManagerForm,
        didSelectFormItem: (form) {
          setState(() {
            ActivityVendorHelperCore.isLoading = true;
            ActivityVendorHelperCore.selectedForm = form;
          });
          Future.delayed(const Duration(seconds: 3, milliseconds: 250), () {
            setState(() {
              ActivityVendorHelperCore.isLoading = false;
            });
          });
        },
        didSelectManageVendorForm: () {

        },
    );


    final activityTicketMainContainer = ActivityTicketSettingsMainContainerWidget(
        model: widget.model,
        reservationItem: ReservationHelperCore.selectedReservationItem,
        activityManagerForm: ReservationHelperCore.currentActivityForm,
        selectedTicketOption: ActivityTicketHelperCore.selectedTicket,
        rebuild: () {
          setState(() {
          });
        },
    );


    final activityTicketSubContainer = ActivityTicketSubContainer(
        model: widget.model,
        currentReservationItem: ReservationHelperCore.selectedReservationItem,
        currentActivityManagerForm: ReservationHelperCore.currentActivityForm,
        didSelectTicketItem: (ticket) {
          setState(() {
            ActivityTicketHelperCore.isLoading = true;
            ActivityTicketHelperCore.selectedTicket = ticket;
          });
          Future.delayed(const Duration(seconds: 1, milliseconds: 250), () {
            setState(() {
              ActivityTicketHelperCore.isLoading = false;
          });
        });
      }
    );



    final activityAttendeeTicketMainContainer = ActivityAttendeeTicketSettingMainContainerWidget(
      model: widget.model,
      attendeeTickets: ReservationHelperCore.currentAttendeeTicketItems ?? [],
      reservationItem: ReservationHelperCore.selectedReservationItem,
      activityManagerForm: ReservationHelperCore.currentActivityForm,
      rebuild: () {
        setState(() {
        });
      },
    );

    final getLoginSignUpMainContainer = Padding(
      padding: const EdgeInsets.all(8.0),
      child: GetLoginSignUpWidget(
        showFullScreen: true,
        model: widget.model,
        didLoginSuccess: () {
        setState(() {

          });
        },
      ),
    );

    final accountSettingsMainContainer = SettingsMainContainerWidget(
      model: widget.model,
      currentMarker: ReservationHelperCore.currentProfileSettingsMarker,
      currentUser: currentUser,
      didRebuild: () {
        setState(() {
          Beamer.of(context).update(
              configuration: RouteInformation(
                  location: '/home'
              ),
              rebuild: true
          );
        });
      },
    );

    final accountSettingsSubContainer = SettingsSubContainer(
      model: widget.model,
      currentUser: currentUser,
      didSelectItem: (ProfileSettingMarker navItem) {
        setState(() {
          ReservationHelperCore.currentProfileSettingsMarker = navItem;
          _scaffoldKey.currentState?.closeDrawer();
        });
      },
      rebuild: () {
        // Navigator.of(context).pop();
        didSelectRefresh();
        // SystemNavigator.pop();
        // setState(() {
        //   Beamer.of(context).update(
        //       configuration: RouteInformation(
        //           location: '/home'
        //       ),
        //       rebuild: true
        //   );
        // });
      },
    );

    List<DashboardContainerModel> dashboardContent(UserProfileModel? currentUser, List<ReservationItem> currentRes, List<ActivityManagerForm> currentAct, ReservationItem? selectedReservation, ListingManagerForm? selectedListingForm, ActivityManagerForm? selectedActivityForm, AttendeeItem? selectedReservationAttendance, List<TicketItem> selectedReservationAllAttendees) => [
      DashboardContainerModel(
          mainContainer: DashboardMainContainerModel(
              mainContainer: searchExploreContainer,
              sidePanelMainContainer: Container(),
              isSubContainerAllowed: false,
              presentSidePanel: false),
          subContainer: Container(
            color: Colors.blue,
          ),
          dashboardMarker: DashboardMarker.search,
          iconTab: Icons.public,
          tabTitle: 'Discovery',
          isVisible: true,
      ),
      DashboardContainerModel(
          mainContainer: DashboardMainContainerModel(
              mainContainer: (currentUser != null) ? reservationContainer : getLoginSignUpMainContainer,
              sidePanelMainContainer: Container(),
              isSubContainerAllowed: (currentUser != null),
              presentSidePanel: false
          ),
          subContainer: reservationSubContainer,
          dashboardMarker: DashboardMarker.reservations,
          iconTab: Icons.calendar_today_outlined,
          tabTitle: 'Reservations',
          notificationCount: notifications.where((element) => element.notificationType != AccountNotificationType.review || element.notificationType != AccountNotificationType.message).length,
          isVisible: true,
      ),
      DashboardContainerModel(
          mainContainer: DashboardMainContainerModel(
              mainContainer: (currentUser != null) ? chatContainer : getLoginSignUpMainContainer,
              sidePanelMainContainer: Container(),
              isSubContainerAllowed: currentUser != null,
              presentSidePanel: false
          ),
          subContainer: chatSubContainer,
          dashboardMarker: DashboardMarker.chat,
          iconTab: Icons.chat_bubble_outline_outlined,
          tabTitle: 'Chats',
          isVisible: true,
          notificationCount: notifications.where((element) => element.notificationType == AccountNotificationType.message).length
      ),
      DashboardContainerModel(
        mainContainer: DashboardMainContainerModel(
            mainContainer: (currentUser != null) ? profileContainer(currentUser) : getLoginSignUpMainContainer,
            sidePanelMainContainer: Container(),
            isSubContainerAllowed: false,
            presentSidePanel: false,
        ),
        subContainer: Container(
          color: Colors.lime,
        ),
        isVisible: true,
        dashboardMarker: DashboardMarker.profile,
        iconTab: Icons.account_circle_outlined,
        tabTitle: 'Profile',
        imageUrl: [currentUser?.photoUri ?? ''],
      ),
      DashboardContainerModel(
        mainContainer: DashboardMainContainerModel(
            mainContainer: (currentUser != null) ? reservationContainer : getLoginSignUpMainContainer,
            sidePanelMainContainer: Container(),
            isSubContainerAllowed: (currentUser != null),
            presentSidePanel: false
        ),
        subContainer: reservationSubContainer,
        dashboardMarker: DashboardMarker.reservations,
        iconTab: CupertinoIcons.dot_radiowaves_left_right,
        tabTitle: 'On Now',
        imageUrl: getImageFromCurrentReservations(context, currentRes, currentAct),
        isVisible: currentRes.isNotEmpty,
        isLive: true,
      ),
      DashboardContainerModel(
          mainContainer: DashboardMainContainerModel(
              mainContainer: reservationContainer,
              sidePanelMainContainer: Container(),
              isSubContainerAllowed: false,
              presentSidePanel: false
          ),
          subContainer: reservationSubContainer,
          dashboardMarker: DashboardMarker.resProfile,
          iconTab: Icons.home_outlined,
          tabTitle: 'Reservation',
          isPrivate: ReservationHelperCore.currentActivityForm?.rulesService.accessVisibilitySetting.isPrivateOnly == true || ReservationHelperCore.currentActivityForm?.rulesService.accessVisibilitySetting.isInviteOnly == true,
          imageUrl: [getImageFromSelectedReservationActivity(ReservationHelperCore.currentActivityForm, ReservationHelperCore.selectedReservationItem, ReservationHelperCore.currentListingManagerForm) ?? ''],
          isVisible: (selectedReservation != null && !Responsive.isMobile(context))
      ),
      DashboardContainerModel(
          mainContainer: DashboardMainContainerModel(
              mainContainer: activityAttendeeMainContainer,
              sidePanelMainContainer: Container(),
              isSubContainerAllowed: true,
              presentSidePanel: false
          ),
          subContainer: activityAttendeesSubContainer,
          dashboardMarker: DashboardMarker.resAttendees,
          iconTab: Icons.people_outline_rounded,
          tabTitle: 'Attendees',
          notificationCount: notifications.where((e) =>
            e.notificationType == AccountNotificationType.request && ReservationHelperCore.selectedReservationItem?.reservationId == e.reservationId ||
            e.notificationType == AccountNotificationType.joined && ReservationHelperCore.selectedReservationItem?.reservationId == e.reservationId
          ).length,
          isVisible: (selectedReservation != null && !Responsive.isMobile(context))
      ),
      if (currentUser != null && currentUser.userId == selectedReservation?.reservationOwnerId) DashboardContainerModel(
          mainContainer: DashboardMainContainerModel(
              mainContainer: activityTicketMainContainer,
              sidePanelMainContainer: Container(),
              isSubContainerAllowed: true,
              presentSidePanel: false
          ),
          subContainer: activityTicketSubContainer,
          dashboardMarker: DashboardMarker.resTicket,
          iconTab: Icons.airplane_ticket_outlined,
          tabTitle: 'Tickets',
          isVisible: (selectedReservation != null && ReservationHelperCore.currentActivityForm?.activityAttendance.isTicketBased == true && !Responsive.isMobile(context))
      ),
      if (currentUser != null && currentUser.userId == selectedReservation?.reservationOwnerId) DashboardContainerModel(
          mainContainer: DashboardMainContainerModel(
            mainContainer: activityVendorFormMainContainer,
            sidePanelMainContainer: Container(),
            isSubContainerAllowed: true,
            presentSidePanel: false
          ),
          subContainer: activityVendorFormSubContainer,
          dashboardMarker: DashboardMarker.resVendorForms,
          iconTab: Icons.note_alt_outlined,
          tabTitle: 'Vendor Forms',
          isVisible: (selectedReservation != null || (ReservationHelperCore.selectedReservationItem != null && ReservationHelperCore.currentActivityForm?.rulesService.vendorMerchantForms?.isNotEmpty == true) && !Responsive.isMobile(context))
      ),
      if (currentUser != null && (ReservationHelperCore.currentAttendeeTicketItems ?? []).isNotEmpty) DashboardContainerModel(
          mainContainer: DashboardMainContainerModel(
              mainContainer: activityAttendeeTicketMainContainer,
              sidePanelMainContainer: Container(),
              isSubContainerAllowed: false,
              presentSidePanel: false
          ),
          subContainer: Container(
            color: Colors.red,
          ),
          dashboardMarker: DashboardMarker.resAttendeeTicket,
          iconTab: Icons.airplane_ticket_rounded,
          tabTitle: 'Attendee Tickets',
          isVisible: (selectedReservation != null || (ReservationHelperCore.selectedReservationItem != null) && !Responsive.isMobile(context))
      ),
      DashboardContainerModel(
          mainContainer: DashboardMainContainerModel(
              mainContainer: activitySettingsContainer,
              sidePanelMainContainer: ActivityPreviewScreen(
                  model: widget.model,
                  currentListingId: ReservationHelperCore.currentListingManagerForm?.listingServiceId ?? UniqueId(),
                  currentReservationId: ReservationHelperCore.selectedReservationItem?.reservationId ?? UniqueId(),
                  listing: ReservationHelperCore.currentListingManagerForm ?? ListingManagerForm.empty(),
                  reservation: ReservationHelperCore.selectedReservationItem ?? ReservationItem.empty(),
                  didSelectBack: () {  },
              ),
              isSubContainerAllowed: true,
              presentSidePanel: ReservationHelperCore.didPresentSidePanel,
          ),
          subContainer: activitySettingsSubContainer,
          dashboardMarker: DashboardMarker.resSettings,
          iconTab: Icons.settings_outlined,
          tabTitle: 'Settings',
          /// show if is reservation owner or if is joined reservation attendee
          isVisible: (selectedReservation != null || ((ReservationHelperCore.selectedReservationItem != null && ReservationHelperCore.selectedReservationItem?.reservationOwnerId == currentUser?.userId) || (ReservationHelperCore.selectedReservationAttendeeItem?.contactStatus == ContactStatus.joined) || (ReservationHelperCore.selectedReservationAttendeeItem?.contactStatus == ContactStatus.requested))) && !Responsive.isMobile(context)
      ),
    ];

    final DashboardContainerModel optionsDashboardItem = DashboardContainerModel(
        mainContainer: DashboardMainContainerModel(
            mainContainer: (currentUser != null) ? accountSettingsMainContainer : getLoginSignUpMainContainer,
            sidePanelMainContainer: accountSettingsSubContainer,
            isSubContainerAllowed: currentUser != null,
            presentSidePanel: ReservationHelperCore.didPresentSidePanel,
        ),
      subContainer: accountSettingsSubContainer,
      dashboardMarker: DashboardMarker.settings,
      iconTab: Icons.more_horiz_rounded,
      tabTitle: 'Settings',
      isVisible: !Responsive.isMobile(context)
    );
    return retrieveMainDashboardContainer(context, currentUser, dashboardContent(currentUser, reservations, activities, selectedReservation, selectedListingForm, selectedActivityForm, selectedReservationAttendance, selectedReservationAllAttendees), reservations, activities, notifications, optionsDashboardItem);
  }


  Widget retrieveMainDashboardContainer(BuildContext context, UserProfileModel? currentUser, List<DashboardContainerModel> dashboardContainerModel, List<ReservationItem> currentRes, List<ActivityManagerForm> currentAct, List<AccountNotificationItem> notifications, DashboardContainerModel optionsDashboardItem) {
    return Stack(
      alignment: Alignment.center,
      children: [
        WebDashboardMain(
        isLoggedIn: currentUser != null,
        scaffoldKey: _scaffoldKey,
        model: widget.model,
        dashboardMarker: context.read<ListingsSearchRequirementsBloc>().state.currentDashboardMarker,
        dashboardContainerItems: dashboardContainerModel,
        didSelectDashboardMarkerItem: (marker) {
            setState(() {
              Beamer.of(context).update(
                  configuration: RouteInformation(
                      location: homeTabRoute(marker),
                  ),
                  rebuild: false
              );

              switch (marker) {
                case DashboardMarker.search:
                  if (ExploreWebHelperCore.selectedListing && ExploreWebHelperCore.currentFacilityItemId != null && ExploreWebHelperCore.currentReservationItemId != null) {
                    Beamer.of(context).update(
                        configuration: RouteInformation(
                            location: searchedReservationRoute(ExploreWebHelperCore.currentFacilityItemId!.getOrCrash(), ExploreWebHelperCore.currentReservationItemId!.getOrCrash())
                        ),
                      rebuild: false
                    );
                  }
                  break;
                case DashboardMarker.resProfile:
                  Beamer.of(context).update(
                      configuration: RouteInformation(
                          location: (ReservationHelperCore.selectedReservationItem != null) ? reservationProfileRoute(ReservationHelperCore.selectedReservationItem!.reservationId.getOrCrash()) : '/${marker.name.toString()}',
                      ),
                    rebuild: false
                  );
                  break;
                case DashboardMarker.resCurrent:
                  break;
                case DashboardMarker.resAttendees:
                  // update notification count for attendees joined or requests
                  LocalNotificationCore.updateNotificationToRead(context, notifications.where((e) =>
                    e.notificationType == AccountNotificationType.request && ReservationHelperCore.selectedReservationItem?.reservationId == e.reservationId ||
                    e.notificationType == AccountNotificationType.joined && ReservationHelperCore.selectedReservationItem?.reservationId == e.reservationId).map((e) => e.notificationId).toList(),
                    widget.model.paletteColor,
                    widget.model.accentColor
                  );
                  break;
                case DashboardMarker.resVendorForms:
                  ActivityVendorHelperCore.isLoading = true;
                  ActivityVendorHelperCore.isLoadingSubContainer = true;

                  if (ReservationHelperCore.selectedReservationItem != null) {
                    Beamer.of(context).update(
                        configuration: RouteInformation(
                            location: reservationVendorFormRoute(ReservationHelperCore.selectedReservationItem!.reservationId.getOrCrash())
                        ),
                        rebuild: false
                    );
                  } else if (widget.initialReservationId != null) {
                    Beamer.of(context).update(
                        configuration: RouteInformation(
                            location: reservationVendorFormRoute(widget.initialReservationId!.getOrCrash())
                        ),
                        rebuild: false
                    );
                  } else {
                    Beamer.of(context).update(
                        configuration: RouteInformation(
                            location: homeTabRoute(marker),
                        ),
                        rebuild: false
                    );
                  }

                  Future.delayed(const Duration(seconds: 1, milliseconds: 250), () {
                  setState(() {
                    ActivityVendorHelperCore.isLoading = false;
                    ActivityVendorHelperCore.isLoadingSubContainer = false;
                    });
                  });
                case DashboardMarker.resTicket:
                  // TODO: Handle this case.
                  break;
                case DashboardMarker.resAttendeeTicket:
                  // TODO: Handle this case.
                  break;
                case DashboardMarker.resSettings:
                  if (ReservationHelperCore.selectedReservationItem != null) {
                    Beamer.of(context).update(
                        configuration: RouteInformation(
                            location: reservationSettingsRoute(ReservationHelperCore.selectedReservationItem!.reservationId.getOrCrash(), SettingNavMarker.reports.name)
                        ),
                        rebuild: false
                    );
                  } else if (widget.initialReservationId != null) {
                    Beamer.of(context).update(
                        configuration: RouteInformation(
                            location: reservationSettingsRoute(widget.initialReservationId!.getOrCrash(), SettingNavMarker.reports.name)
                        ),
                        rebuild: false
                    );
                  } else {
                    Beamer.of(context).update(
                        configuration: RouteInformation(
                            location: reservationSettingsRoute('/${marker.name.toString()}', SettingNavMarker.reports.name)
                        ),
                        rebuild: false
                    );
                  }
                  // TODO: Handle this case.
                  break;
                default:
                  break;
              }
              context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.currentDashboardMarker(marker));
              });
            },
          optionsMarkerItem: optionsDashboardItem,
        ),

        if (kIsWeb && Responsive.isMobile(context)) Positioned(
          top: (showTopNavBar(context.read<ListingsSearchRequirementsBloc>().state.currentDashboardMarker) && currentUser != null) ? 130 : 75,
            child: SizedBox(
              height: 60,
              child: FilterChip(
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 8,
                shadowColor: widget.model.disabledTextColor.withOpacity(0.3),
                onSelected: (e) async {
                  if (await canLaunch(iosActivitiesAppLink)) {
                    await launch(iosActivitiesAppLink);
                  } else {
                    throw 'Could not launch $iosActivitiesAppLink';
                  }
                },
                avatar: Icon(Icons.link_rounded, size: 26, color: widget.model.paletteColor),
                label:  Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text('Download on iOS', style: TextStyle(color: widget.model.paletteColor)),
                ),
              backgroundColor:widget.model.accentColor,
            ),
          ),
        ),

        if (isCreatingNewActivity == true) OnBoardingPopOverWidget(
            height: 1050,
            width: 750,
            popOverWidget: CreateNewActivityScreen(
                currentListingManForm: null,
                initPage: null,
                model: widget.model,
                isPopOver: false,
                didSelectClose: () {
                  setState(() {
                    isCreatingNewActivity = false;
                  });
                },
            ),
            model: widget.model
        ),

      ],
    );
  }

}