import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttendeeSettingsListContainer extends StatefulWidget {

  final DashboardModel model;
  late SettingsItemModel currentSelectedSettingItem;
  final ReservationItem currentReservationItem;
  final AttendeeItem? currentAttendee;
  final ActivityManagerForm? currentActivityManagerForm;
  final Function(SettingsItemModel navItem) didSelectNavItem;

  AttendeeSettingsListContainer({super.key, required this.model, required this.currentSelectedSettingItem, required this.currentReservationItem, required this.currentActivityManagerForm, required this.didSelectNavItem, this.currentAttendee});

  @override
  State<AttendeeSettingsListContainer> createState() => _AttendeeSettingsListContainerState();
}

class _AttendeeSettingsListContainerState extends State<AttendeeSettingsListContainer> {

  @override
  void initState() {
    widget.currentSelectedSettingItem = subActivityAttendeeSettingItems(widget.currentActivityManagerForm, widget.currentAttendee)[0];
    super.initState();
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
              ...attendeeSettingsHeader(context).map(
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
                          children: subActivityAttendeeSettingItems(widget.currentActivityManagerForm, widget.currentAttendee).where((element) => element.sectionNavItem == e.sectionMarker).map(
                                  (f) {
                                return ListTile(
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