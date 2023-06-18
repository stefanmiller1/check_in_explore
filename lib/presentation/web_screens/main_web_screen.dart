import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/account/login_signup_core.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/dashboard_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/core/web_dashboard/dashboard_main.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/activity_settings_widet/activity_settings_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/chat_widget/chat_helper_core.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/chat_widget/chat_main_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/profile_widget/profile_main_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/reservations_widget/reservation_helper_core.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/reservations_widget/reservation_main_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/search_explore_widgets/search_explore_main_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_web_screen_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/sub_container_widgets/activity_settings_widget/activity_settings_sub_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/sub_container_widgets/chat_widget/chat_sub_container_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/sub_container_widgets/reservation_widget/reservation_sub_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainWebScreen extends StatefulWidget {

  final DashboardModel model;

  const MainWebScreen({super.key, required this.model});

  @override
  State<MainWebScreen> createState() => _MainWebScreenState();
}

class _MainWebScreenState extends State<MainWebScreen> {

  late DashboardMarker currentDashboardMarker;


  @override
  void initState() {
    currentDashboardMarker = DashboardMarker.home;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return retrieveAuthenticationState(context);
  }



  Widget retrieveAuthenticationState(BuildContext context) {

    final searchExploreContainer = SearchExploreMainContainerWidget(
        model: widget.model
    );
    final reservationContainer = ReservationMainContainerWidget(
        model: widget.model
    );
    final reservationSubContainer = ReservationSubContainerWidget(
      model: widget.model,
      didSelectReservation: () {
        setState(() {});
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

    final activitySettingsContainer = ActivitySettingsMainContainerWidget(
      model: widget.model,
      reservationItem: ReservationHelperCore.selectedReservationItem,
      currentUser: ReservationHelperCore.currentUserProfile,
      activityManagerForm: ReservationHelperCore.currentActivityForm,
      currentNavItem: ReservationHelperCore.currentSettingsItemModel,
      rebuild: () {
        setState(() {});
      },
    );
    final activitySettingsSubContainer = SettingsListContainer(
        model: widget.model,
        currentSelectedSettingItem: ReservationHelperCore.currentSettingsItemModel,
        didSelectNavItem: (selectedNav) {
          setState(() {
            ReservationHelperCore.currentSettingsItemModel = selectedNav;
          });
        },
        currentReservationItem: ReservationHelperCore.selectedReservationItem,
        currentActivityManagerForm: ReservationHelperCore.currentActivityForm
    );

    final getLoginSignUpMainContainer = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Container(
            constraints: BoxConstraints(
              maxWidth: 600
            ),
            child: GetLoginSignUpWidget(model: widget.model)
            )
          ),
        ],
      ),
    );

    List<DashboardContainerModel> dashboardContent(UserProfileModel? currentUser) => [
      DashboardContainerModel(
          mainContainer: DashboardMainContainerModel(
              mainContainer: searchExploreContainer,
              sidePanelMainContainer: Container(),
              isSubContainerAllowed: false,
              presentSidePanel: false),
          subContainer: Container(
            color: Colors.blue,
          ),
          dashboardMarker: DashboardMarker.home,
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
        imageUrl: currentUser?.photoUri,
      ),
      DashboardContainerModel(
          mainContainer: DashboardMainContainerModel(mainContainer: reservationContainer, sidePanelMainContainer: Container(), isSubContainerAllowed: false, presentSidePanel: false),
          subContainer: reservationSubContainer,
          dashboardMarker: DashboardMarker.resProfile,
          iconTab: Icons.home_outlined,
          tabTitle: 'Reservation',
          imageUrl: getImageFromSelectedReservationActivity(ReservationHelperCore.currentActivityForm, ReservationHelperCore.selectedReservationItem, ReservationHelperCore.currentListingManagerForm),
          isVisible: (ReservationHelperCore.selectedReservationItem != null && !Responsive.isMobile(context))
      ),
      DashboardContainerModel(
          mainContainer: DashboardMainContainerModel(mainContainer: Container(), sidePanelMainContainer: Container(), isSubContainerAllowed: false, presentSidePanel: false),
          subContainer: Container(
            color: Colors.lime,
          ),
          dashboardMarker: DashboardMarker.resAttendees,
          iconTab: Icons.people_outline_rounded,
          tabTitle: 'Attendees',
          isVisible: (ReservationHelperCore.selectedReservationItem != null && !Responsive.isMobile(context))
      ),
      DashboardContainerModel(
          mainContainer: DashboardMainContainerModel(mainContainer: activitySettingsContainer, sidePanelMainContainer: Container(), isSubContainerAllowed: true, presentSidePanel: false),
          subContainer: activitySettingsSubContainer,
          dashboardMarker: DashboardMarker.resSettings,
          iconTab: Icons.settings_outlined,
          tabTitle: 'Settings',
          isVisible: (ReservationHelperCore.selectedReservationItem != null) && !Responsive.isMobile(context)
      ),
    ];

    final DashboardContainerModel optionsDashboardItem = DashboardContainerModel(
        mainContainer: DashboardMainContainerModel(mainContainer: Container(), sidePanelMainContainer: Container(), isSubContainerAllowed: false, presentSidePanel: false),
        subContainer: Container(
          color: Colors.lime,
        ),
        dashboardMarker: DashboardMarker.settings,
        iconTab: Icons.more_horiz_rounded,
        tabTitle: 'Settings'
    );

    return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, authState) {

          return authState.maybeMap(
              loadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
              loadProfileFailure: (_) => retrieveMainDashboardContainer(context, dashboardContent(null), optionsDashboardItem),
              loadUserProfileSuccess: (item) => retrieveMainDashboardContainer(context, dashboardContent(item.profile), optionsDashboardItem),
              orElse: () {
                return JumpingDots(color: widget.model.paletteColor, numberOfDots: 3);
              }
          );
        },
      ),
    );
  }


  Widget retrieveMainDashboardContainer(BuildContext context, List<DashboardContainerModel> dashboardContainerModel, DashboardContainerModel optionsDashboardItem) {
    return WebDashboardMain(
    model: widget.model,
    dashboardMarker: currentDashboardMarker,
      dashboardContainerItems: dashboardContainerModel,
      didSelectDashboardMarkerItem: (marker) {
      setState(() {
        currentDashboardMarker = marker;
        });
      },
      optionsMarkerItem: optionsDashboardItem,
    );
  }

}