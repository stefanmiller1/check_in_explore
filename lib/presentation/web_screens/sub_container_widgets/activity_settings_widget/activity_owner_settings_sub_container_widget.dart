import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/reservations_widget/reservation_helper_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OwnerSettingsListContainer extends StatefulWidget {

  final DashboardModel model;
  late SettingsItemModel currentSelectedSettingItem;
  final ReservationItem currentReservationItem;
  final ActivityManagerForm currentActivityManagerForm;
  final Function(SettingsItemModel navItem) didSelectNavItem;

  OwnerSettingsListContainer({Key? key, required this.model, required this.currentSelectedSettingItem, required this.didSelectNavItem, required this.currentReservationItem, required this.currentActivityManagerForm}) : super(key: key);

  @override
  State<OwnerSettingsListContainer> createState() => _OwnerSettingsListContainerState();
}

class _OwnerSettingsListContainerState extends State<OwnerSettingsListContainer> {

  @override
  void initState() {
    widget.currentSelectedSettingItem = subActivitySettingItems(widget.currentActivityManagerForm)[0];
    super.initState();
  }

  List<SettingsItemModel> updateListWithReservationOptions(BuildContext context) {

    List<SettingsItemModel> settingsList = [];
    settingsList.addAll(subActivitySettingItems(widget.currentActivityManagerForm));

    for (ReservationSlotItem reservationSlot in widget.currentReservationItem.reservationSlotItem) {
      settingsList.insert(3, SettingsItemModel(settingIcon: getIconDataForActivity(context, reservationSlot.selectedActivityType), sectionNavItem: SettingSectionMarker.profile, navItem: SettingNavMarker.reservation, settingsTitle: '${DateFormat.MMMd().format(reservationSlot.selectedDate)} Activity', settingSubTitle: getTitleForActivityOption(context, reservationSlot.selectedActivityType) ?? '', resSlotItem: reservationSlot));

    }
    return settingsList;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            children: [
              const SizedBox(height: 30),
              ...activitySettingsHeader(context).map(
                      (e) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Text(e.settingTitle, style: TextStyle(color: (widget.currentSelectedSettingItem.sectionNavItem == e.sectionMarker) ? widget.model.paletteColor : widget.model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),),
                        const SizedBox(height: 5),
                        Column(
                          children: updateListWithReservationOptions(context).where((element) => element.sectionNavItem == e.sectionMarker).map(
                                  (f) {
                                return Padding(
                                  padding: (f.navItem == SettingNavMarker.reservation) ? EdgeInsets.only(left: 30.0) : EdgeInsets.zero,
                                  child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        widget.didSelectNavItem(f);
                                      });
                                    },
                                    leading: f.settingImageIcon != null ? CircleAvatar(backgroundImage: Image.network(f.settingImageIcon!).image, backgroundColor: widget.model.paletteColor) : Icon(f.settingIcon, color: (widget.currentSelectedSettingItem.navItem == f.navItem && f.navItem != SettingNavMarker.reservation || widget.currentSelectedSettingItem.settingSpaceOption == f.settingSpaceOption && f.navItem == SettingNavMarker.reservation) ? widget.model.paletteColor : null),
                                    title: Text(f.settingsTitle, style: TextStyle(color: (widget.currentSelectedSettingItem.navItem == f.navItem && f.navItem != SettingNavMarker.reservation || widget.currentSelectedSettingItem.settingSpaceOption == f.settingSpaceOption && f.navItem == SettingNavMarker.reservation && f.settingsTitle == widget.currentSelectedSettingItem.settingsTitle) ? widget.model.paletteColor : widget.model.disabledTextColor)),
                                    trailing: (!(f.isCompletedSetup ?? false)) ? null : Container(height: 7, width: 7, decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: widget.model.paletteColor, border: Border.all(color: widget.model.paletteColor, width: 0.5))),
                                    subtitle: (f.settingSubTitle != '') ? Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(f.settingSubTitle, style: TextStyle(color:(widget.currentSelectedSettingItem.navItem == f.navItem && f.navItem != SettingNavMarker.reservation || widget.currentSelectedSettingItem.settingSpaceOption == f.settingSpaceOption && f.navItem == SettingNavMarker.reservation && f.settingsTitle == widget.currentSelectedSettingItem.settingsTitle) ? widget.model.paletteColor : widget.model.disabledTextColor)),
                                  ) : null,
                                ),
                              );
                            }
                          ).toList(),
                        ),
                        const SizedBox(height: 15),
                        Divider(color: widget.model.disabledTextColor, thickness: 0.25),

                  ],
                ),
              )
            ).toList(),
          ]
        ),
      ),
    );
  }
}