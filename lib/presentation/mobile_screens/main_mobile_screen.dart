import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/mobile_screens/main_mobile_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/profile_settings_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/reservations_history/reservations_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_explore_header.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/search_explore_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MainMobileScreen extends StatefulWidget {


  const MainMobileScreen({super.key});

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

    dashboardModel.systemTheme = Theme.of(context);
    dashboardModel.currentThemeData = dashboardModel.systemTheme.brightness != Brightness.dark
        ? ThemeData.light() : ThemeData.dark();
    dashboardModel.changeTheme(dashboardModel.currentThemeData!);

    final DashboardModel model = dashboardModel;

    final List<MainMobileScreenModel> mainMobileScreen = [
      MainMobileScreenModel(
          iconItem: Icons.public_rounded,
          mainTitle: 'discovery',
          mainWidgetItem: SearchExploreScreen(
            model: model,
            slidePosition: (double pos) {
              setState(() {
                isBottomNavVisible = pos;
              });
            },
          ),
          appBarWidgetItem: AppBar(
              backgroundColor: model.mobileBackgroundColor,
              elevation: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(64),
                    child: SearchExploreHeader(model: model)
            ),
          ),
        isSelected: false
      ),
      MainMobileScreenModel(
          iconItem: Icons.calendar_today_outlined,
          mainTitle: 'reservations',
          mainWidgetItem: ReservationScreen(
            model: model,
          ),
          appBarWidgetItem: AppBar(
            backgroundColor: model.mobileBackgroundColor,
            elevation: 0,
            title: const Text('Reservations'),
            titleTextStyle: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold),
            centerTitle: true,
          ),
        isSelected: false
      ),
      MainMobileScreenModel(
          iconItem: Icons.messenger_outline,
          mainTitle: 'chat',
          appBarWidgetItem: null,
          mainWidgetItem: Container(),
          isSelected: false
      ),
      MainMobileScreenModel(
          iconItem: Icons.perm_identity_rounded,
          mainTitle: 'profile',
          appBarWidgetItem:  AppBar(
            backgroundColor: model.mobileBackgroundColor,
            toolbarHeight: 0,
            elevation: 0,
            centerTitle: true,
          ),
          mainWidgetItem: ProfileSettingsScreen(
            model: model,
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
            focusColor: model.accentColor,
            backgroundColor: model.webBackgroundColor,
            primaryColor: model.currentPrimaryColor,
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(
                color: model.paletteColor
              )
            )
          ),
        child: Scaffold(
              appBar: mainMobileScreen[_selectedIndex].appBarWidgetItem,
              body: mainMobileScreen[_selectedIndex].mainWidgetItem,
              bottomNavigationBar: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    height: (isBottomNavVisible == 0) ? 70 : 0,
                    child: Wrap(
                      children: [
                        BottomNavigationBar(
                          backgroundColor: model.mobileBackgroundColor,
                          elevation: 0,
                          onTap: (i) {
                            setState(() {
                              _selectedIndex = i;
                            });
                          },
                          enableFeedback: true,
                          currentIndex: _selectedIndex,
                          type: BottomNavigationBarType.fixed,
                          selectedItemColor: model.paletteColor,
                          unselectedItemColor: model.paletteColor.withOpacity(0.65),
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