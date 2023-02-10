import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/profile_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationProfile extends StatefulWidget {

  final DashboardModel model;

  const NotificationProfile({super.key, required this.model});

  @override
  State<NotificationProfile> createState() => _NotificationProfileState();
}

class _NotificationProfileState extends State<NotificationProfile> with SingleTickerProviderStateMixin {

  late TabController? _tabController;
  late PageController? _pageController;
  late int _currentPageIndex = 0;

  @override
  void initState() {
    _pageController = PageController();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    List<List<ProfileNotificationSettingModel>> getNotificationSettingsList = [
      offersNotificationList(),
      accountNotificationsList()
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
        elevation: 0,
        title: const Text('Edit Notifications'),
        iconTheme: IconThemeData(
            color: widget.model.paletteColor
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            const SizedBox(height: 35),

            TabBar(
                controller: _tabController,
                onTap: (index) {
                  setState(() {
                    _currentPageIndex = index;
                    _pageController?.animateToPage(index, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
                  });
              },
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: widget.model.paletteColor
              ),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              labelColor: widget.model.accentColor,
              unselectedLabelColor: widget.model.disabledTextColor,
              tabs: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: const Tab(text: 'App Offers & Updates')),
                ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Tab(text: 'Account')
                )
              ],
            ),
            Divider(color: widget.model.disabledTextColor),
            const SizedBox(height: 15),
            Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: getNotificationSettingsList.length,
                  scrollDirection: Axis.horizontal,
                  allowImplicitScrolling: true,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPageIndex = page;
                      _tabController?.animateTo(_currentPageIndex);
                    });
                  },
                  itemBuilder: (_, index) {

                    final List<ProfileNotificationSettingModel> notification = getNotificationSettingsList[_currentPageIndex];

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: ProfileNotificationSectionMarker.values.where((element) => notification.map((e) => e.sectionMarker).contains(element)).map(
                            (e) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getNotificationSection(e, widget.model),
                                  Divider(color: widget.model.disabledTextColor),
                                  const SizedBox(height: 5),
                                  ...notification.where(
                                          (element) => element.sectionMarker == e).map((e) => InkWell(
                                      onTap: () {
                                        switch (e.marker) {

                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(e.title, style: TextStyle(color: widget.model.paletteColor)),
                                                Text(e.subTitle, style: TextStyle(color: widget.model.disabledTextColor)),
                                              ],
                                            ),
                                            Text('Edit', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize, decoration: TextDecoration.underline))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ).toList(),

                                  const SizedBox(height: 35),
                                ],
                              );

                          }
                        ).toList(),
                    ),
                      ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getNotificationSection(ProfileNotificationSectionMarker marker, DashboardModel model, ) {
  switch (marker) {

    case ProfileNotificationSectionMarker.insights:
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Insights And Updates', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
          const SizedBox(height: 8),
          Text('get access to content and information before anyone else.', style: TextStyle(color: model.disabledTextColor))
        ],
      );
    case ProfileNotificationSectionMarker.updates:
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Insights And Updates', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
          const SizedBox(height: 8),
          Text('Get information on News and Updates.', style: TextStyle(color: model.disabledTextColor))
        ],
      );
    case ProfileNotificationSectionMarker.unsubscribe:
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Unsubscribe', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
          const SizedBox(height: 8),
          Text('You will still receive notifications about reservations and listings.', style: TextStyle(color: model.disabledTextColor))
        ],
      );
    case ProfileNotificationSectionMarker.accountActivity:
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Account Activity & Policies', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
          const SizedBox(height: 8),
          Text('Confirm account activity.', style: TextStyle(color: model.disabledTextColor))
        ],
      );
    case ProfileNotificationSectionMarker.messages:
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Messages', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
          const SizedBox(height: 8),
          Text('Receive notifications about new messages from reservations and listings.', style: TextStyle(color: model.disabledTextColor))
        ],
      );
  }
  return Container();
}