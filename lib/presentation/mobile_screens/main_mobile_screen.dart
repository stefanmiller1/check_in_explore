import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/mobile_screens/main_mobile_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/components/direct_chat_archive_rooms_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/direct_chat_rooms_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/direct_chat_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/profile_settings_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/components/reservation_results_main.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations/reservations_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_components/search_explore_filter.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/search_explore_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/chat_widget/chat_helper_core.dart';
import 'package:flutter/material.dart';
import 'package:check_in_facade/check_in_facade.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MainMobileScreen extends StatefulWidget {

  final DashboardModel model;

  const MainMobileScreen({super.key, required this.model});

  @override
  State<MainMobileScreen> createState() => _MainMobileScreenState();
}

class _MainMobileScreenState extends State<MainMobileScreen> {

  late DashboardModel dashboardModel;
  int _selectedIndex = 0;
  double isBottomNavVisible = 0;

  @override
  void initState() {
    dashboardModel = DashboardModel.instance;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final List<MainMobileScreenModel> mainMobileScreen = [
      MainMobileScreenModel(
          iconItem: Icons.public_rounded,
          mainTitle: 'discovery',
          mainWidgetItem: SearchExploreScreen(
            model: widget.model,
            slidePosition: (double pos) {
              setState(() {
                isBottomNavVisible = pos;
              });
            },
          ),
          appBarWidgetItem: AppBar(
              backgroundColor: widget.model.mobileBackgroundColor,
              elevation: 0,
                bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(64),
                    child: SearchExploreFilter(
                        model: widget.model,
                        didSelectFilterBy: () {},
                    )
            ),
          ),
        isSelected: false
      ),
      MainMobileScreenModel(
          iconItem: Icons.calendar_today_outlined,
          mainTitle: 'reservations',
          mainWidgetItem: ReservationScreen(
            model: widget.model,
            didSelectReservation: (listing, reservation, currentUser, activity, attendeeItem, currentUsersTickets) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) {
                    return ReservationResultMain(
                      model: widget.model,
                      isReply: false,
                      listing: listing,
                      currentUser: currentUser,
                      currentUserId: currentUser.userId.getOrCrash(),
                      reservationId: reservation.reservationId.getOrCrash(),
                      currentUserTicketItems: currentUsersTickets
                    );
                  }
                )
              );
            },
          ),
          appBarWidgetItem: AppBar(
            backgroundColor: widget.model.mobileBackgroundColor,
            elevation: 0,
            title: const Text('Reservations'),
            titleTextStyle: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {

                },
                icon: Icon(Icons.favorite_border, color: widget.model.paletteColor)
              ),

            ],
          ),
        isSelected: false
      ),
      MainMobileScreenModel(
          iconItem: Icons.messenger_outline,
          mainTitle: 'chat',
          mainWidgetItem: DirectChatRoomsScreen(
              model: widget.model,
              isArchive: false,
              didSelectChats: () {

              },
              didSelectArchive: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) {
                    return DirectChatArchiveRoomsScreen(
                      model: widget.model,
                    );
                  }));
              },
              didSelectRoom: (room, profile) {
                ChatHelperCore.isLoading = false;
                Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      return DirectChatScreen(
                        model: widget.model,
                        room: room,
                        currentUser: profile,
                        reservationItem: null,
                        isFromReservation: false,
                  );
                }));
            },
          ),
          appBarWidgetItem: AppBar(
            backgroundColor: widget.model.mobileBackgroundColor,
            elevation: 0,
            title: const Text('Chat'),
            titleTextStyle: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold),
            actions: [



              //      Badge(
              //       badgeContent: Text(NotificationCore.chatReceivedNotification.length.toString() ?? '', style: TextStyle(color: model.accentColor),),
              //       position: BadgePosition.topEnd(end: 4, top: 2),
              //       showBadge: (NotificationCore.chatReceivedNotification.isNotEmpty) ? true : false,
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (_) {
                                return DirectChatArchiveRoomsScreen(
                                  model: widget.model,
                                );
                              }));
                        },
                  icon: Icon(Icons.archive_outlined, color: widget.model.paletteColor)
                ),
              // ),
            ],
          ),
          isSelected: false
      ),
      MainMobileScreenModel(
          iconItem: Icons.perm_identity_rounded,
          mainTitle: 'profile',
          appBarWidgetItem:  AppBar(
            backgroundColor: widget.model.mobileBackgroundColor,
            toolbarHeight: 0,
            elevation: 0,
            centerTitle: true,
          ),
          mainWidgetItem: ProfileSettingsScreen(
            model: widget.model,
          ),
          isSelected: false
      ),
    ];


    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: Theme(
          data: ThemeData(
            focusColor: widget.model.accentColor,
            backgroundColor: widget.model.webBackgroundColor,
            primaryColor: widget.model.currentPrimaryColor,
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(
                color: widget.model.paletteColor
              )
            )
          ),
        child: Scaffold(
              appBar: (FirebaseChatCore.instance.firebaseUser != null) ? mainMobileScreen[_selectedIndex].appBarWidgetItem : AppBar(
                  backgroundColor: widget.model.webBackgroundColor,
                  elevation: 0,
              ),
              body: mainMobileScreen[_selectedIndex].mainWidgetItem,
              bottomNavigationBar: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    height: (isBottomNavVisible == 0) ? 70 : 0,
                    child: Wrap(
                      children: [
                        BottomNavigationBar(
                          backgroundColor: widget.model.mobileBackgroundColor,
                          elevation: 0,
                          onTap: (i) {
                            setState(() {
                              _selectedIndex = i;
                            });
                          },
                          enableFeedback: true,
                          currentIndex: _selectedIndex,
                          type: BottomNavigationBarType.fixed,
                          selectedItemColor: widget.model.paletteColor,
                          unselectedItemColor: widget.model.paletteColor.withOpacity(0.65),
                          items: mainMobileScreen.map(
                            (e) => BottomNavigationBarItem(
                                label: e.mainTitle,
                                icon: Icon(e.iconItem),
                            )
                          ).toList()
                        ),
                      ],
                    ),

              ),

        ),
      ),
    );
  }
}