import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

List<String> tabWhenList = ['Slots', 'I\'m Flexible', 'Custom'];
List<String> tabWhoList = ['A General Amount','A Range'];

/// CURRENT LOCATION
Widget searchSettingsButton(DashboardModel model, {required Function() didSelectButton, required IconData iconItem, required String buttonTitle, required bool isSelected}) {
  return Container(
    decoration: BoxDecoration(
        color: (isSelected) ? model.paletteColor : model.accentColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: model.disabledTextColor)
    ),
    child: InkWell(
      onTap: () {
        didSelectButton();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 1),
            Container(
                decoration: BoxDecoration(
                  color: model.disabledTextColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(iconItem, color: model.disabledTextColor),
                )
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(buttonTitle, style: TextStyle(color: (isSelected) ? model.accentColor : model.paletteColor, fontWeight: FontWeight.normal, decoration: TextDecoration.none, fontSize: model.secondaryQuestionTitleFontSize), maxLines: 1,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}



List<ReservationSlotItem> getReservationSlotItemForSearch(
    BuildContext context,
    List<ReservationTimeFeeSlotItem> slots,
    UniqueId? activityId,
    UniqueId? spaceId,
    UniqueId? sportSpaceId,
    String? spaceTitle,
    ) {

  List<ReservationSlotItem> newItems = [];

  newItems.addAll(slots.map(
          (e) => DateTime(e.slotRange.start.year, e.slotRange.start.month, e.slotRange.start.day))
      .toSet()
      .toList().map(
          (e) => ReservationSlotItem(
          selectedActivityType: activityId ?? getActivityOptions()[0].activityId,
          selectedSportSpaceId: sportSpaceId,
          selectedSpaceId: spaceId ?? UniqueId(),
          selectedDate: e,
          selectedSideOption: spaceTitle,
          selectedSlots: slots.where((element) => element.slotRange.start.year == e.year && element.slotRange.start.month == e.month && element.slotRange.start.day == e.day).toList())).toList());

  return newItems;
}

Widget searchListItem(BuildContext context, DashboardModel model, {required bool isSelected, required bool isFinishedSelection, required String tagTitle, required Function() didSelectItem, required IconData iconItem, required String selectedTitle, required String defaultTitle, required String subTitle}) {
  return  Hero(
    tag: tagTitle,
    child: AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 550),
      height: (isSelected) ? 65 : 75,
      width: MediaQuery.of(context).size.width - 10,
      decoration: BoxDecoration(
        color: model.accentColor,
        borderRadius: BorderRadius.circular(35),
      ),
      child: InkWell(
        onTap: () {
          didSelectItem();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 6),
            Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(iconItem, color: model.paletteColor),
                )
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [

                    Text((isSelected) ? defaultTitle : selectedTitle, style: TextStyle(color: model.paletteColor, decoration: TextDecoration.none, fontSize: (isSelected) ? 14 : model.questionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: UnconstrainedBox(
                        child: Container(
                          // width: 85,
                            decoration: BoxDecoration(
                              color: (isFinishedSelection) ? model.paletteColor.withOpacity(0.07) : Colors.transparent,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(subTitle, style: TextStyle(color: model.paletteColor, decoration: TextDecoration.none, fontWeight: FontWeight.normal, fontSize: 14), maxLines: 1),
                            )),
                      ),
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

/// WIDGET BREAKDOWN ///
/// SEARCH RESULT WIDGETS ///
Widget listOfDefaultLocations(DashboardModel model, UniqueId? selectedItem, {required Function(LocationOptionModel selectedId) didSelectItem}) {

  return Container(
    height: 190,
    decoration: BoxDecoration(
        color: model.accentColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: model.disabledTextColor)
    ),
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: getMapOptions.map(
              (e) {
            late bool isSelected = false;
            isSelected = (e.locationItemId == selectedItem);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? model.paletteColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          height: 130,
                          decoration: BoxDecoration(
                            color:  model.paletteColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: InkWell(
                            onTap: () {
                              didSelectItem(e);
                            },
                            child: (e.locationIconOverlay == null) ? ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(25)),
                                child: SvgPicture.asset(e.locationIcon ?? '', fit: BoxFit.fitWidth, color: isSelected ? model.accentColor : model.paletteColor, width: 130)) : Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25)),
                                    child: SvgPicture.asset(e.locationIcon ?? '', fit: BoxFit.fitWidth, color: model.disabledTextColor.withOpacity(0.5), width: 130)),
                                ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25)),
                                    child: SvgPicture.asset(e.locationIconOverlay ?? '', fit: BoxFit.fitWidth, color: isSelected ? model.accentColor : model.paletteColor, width: 130))
                              ],
                            ),
                          )
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(e.locationTitle, style: TextStyle(color: isSelected ? model.accentColor : model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ).toList(),
    ),
  );
}


/// WHEN WIDGETS
Widget sfCalendarDateRangePickerView(DashboardModel model, DateRangePickerController dController, DateTimeRange? initialDates, {required Function(DateTimeRange) onSelectionChanged}) {
  return SizedBox(
    height: 320,
    child: SfDateRangePicker(
        initialSelectedRange: (initialDates != null) ? PickerDateRange(initialDates.start, initialDates.end) : null,
        navigationMode: DateRangePickerNavigationMode.snap,
        controller: dController,
        view: DateRangePickerView.month,
        allowViewNavigation: false,
        enableMultiView: false,
        enablePastDates: false,
        showNavigationArrow: true,
        showTodayButton: false,
        monthViewSettings: DateRangePickerMonthViewSettings(

          weekNumberStyle: DateRangePickerWeekNumberStyle(
              textStyle: TextStyle(color: model.paletteColor)
          ),
          firstDayOfWeek: 1,
        ),
        monthCellStyle: DateRangePickerMonthCellStyle(
            textStyle: TextStyle(color: model.paletteColor),
            todayTextStyle: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold)
        ),
        toggleDaySelection: true,
        headerHeight: 70,
        headerStyle: DateRangePickerHeaderStyle(

            textStyle: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize)
        ),
        selectionMode: DateRangePickerSelectionMode.extendableRange,
        todayHighlightColor: model.paletteColor,
        rangeTextStyle: TextStyle(
            color: model.paletteColor.withOpacity(0.7)),
        selectionColor: model.paletteColor,

        startRangeSelectionColor: model.paletteColor,
        endRangeSelectionColor: model.paletteColor,
        rangeSelectionColor: model.paletteColor.withOpacity(0.15),
        selectionTextStyle:  TextStyle(
            color: model.accentColor,
            fontWeight: FontWeight.bold),
        onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
          if (args.value is PickerDateRange) {

            final DateTime? rangeStartDate = args.value.startDate;
            final DateTime? rangeEndDate = args.value.endDate;

            if (rangeStartDate != null && rangeEndDate != null) {
              onSelectionChanged(DateTimeRange(start: rangeStartDate, end: rangeEndDate));
            }

          }
        }
    ),
  );
}


Widget getFlexibleDatesView(
    BuildContext context,
    DashboardModel model,
    UniqueId? selectedByType,
    UniqueId? selectedByMonth,
    {required Function(UniqueId) didSelectByType,
      required  Function(UniqueId) didSelectByMonth
    }
    ) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      //title for type filter
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Text('Pick a Time Frame', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
      //     Text('From Today', style: TextStyle(color: model.paletteColor)),
      //   ],
      // ),
      // const SizedBox(height: 5),
      // Divider(color: model.disabledTextColor),
      const SizedBox(height: 10),
      getFlexibleDatesByType(
          model,
          selectedByType,
          didSelectType: (typeId) {
            didSelectByType(typeId);
          }
      ),
      const SizedBox(height: 15),
      // title for month filter
      Text('Any Month Works', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
      const SizedBox(height: 10),
      Divider(color: model.disabledTextColor),
      getFlexibleByMonth(
          context,
          model,
          selectedByMonth,
          didSelectMonthType: (typeId) {
            didSelectByMonth(typeId);
          })
    ],
  );
}

Widget getFlexibleDatesByType(DashboardModel model, UniqueId? selectedId, {required Function(UniqueId) didSelectType}) {
  return Container(
    height: 70,
    decoration: BoxDecoration(
        color: model.accentColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: model.disabledTextColor)
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: getListOfFlexibleDates().map(
                  (e) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: (e.dateTypeId == selectedId) ? model.paletteColor : model.disabledTextColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: model.disabledTextColor)
                  ),
                  height: 50,
                  child: InkWell(
                    onTap: () {
                      didSelectType(e.dateTypeId);
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                        child: Text(e.dateTypeTitle, style: TextStyle(color: (e.dateTypeId == selectedId) ? model.accentColor : model.paletteColor, fontWeight: (e.dateTypeId == selectedId) ? FontWeight.bold : (e.dateTypeId == selectedId) ? FontWeight.bold : FontWeight.normal )),
                      ),
                    ),
                  ),
                ),
              )
          ).toList()
      ),
    ),
  );
}

Widget getFlexibleByMonth(BuildContext context, DashboardModel model, UniqueId? selectedId,{required Function(UniqueId) didSelectMonthType}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: Container(
      height: 150,
      decoration: BoxDecoration(
          color: model.accentColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: model.disabledTextColor)
      ),
      child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: getListOfMonthDates(context).map(
                  (e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                      color: (e.dateTypeId == selectedId) ? model.paletteColor : model.disabledTextColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: model.disabledTextColor)
                  ),
                  height: 120,
                  child: InkWell(
                    onTap: () {
                      didSelectMonthType(e.dateTypeId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today_outlined, color: (e.dateTypeId == selectedId) ? model.accentColor : model.paletteColor),
                          const SizedBox(height: 10),
                          Text(e.dateTypeTitle, style: TextStyle(color: (e.dateTypeId == selectedId) ? model.accentColor : model.paletteColor, fontWeight: (e.dateTypeId == selectedId) ? FontWeight.bold : (e.dateTypeId == selectedId) ? FontWeight.bold : FontWeight.normal )),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ).toList()
      ),
    ),
  );
}

/// PARTICIPANT LIST
Widget getParticipantListView(DashboardModel model, UniqueId? selectedId, {required Function(ParticipantsRangeModel) didSelectRange}) {

  return ListView(
    shrinkWrap: true,
    children: getParticipantRangeOptions.map(
            (e) {
          late bool isSelected = false;
          isSelected = e.partId == selectedId;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                  color: isSelected ? model.paletteColor : model
                      .accentColor,
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: model.disabledTextColor)
              ),
              child: InkWell(
                onTap: () {
                  didSelectRange(e);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 10),
                      ClipRRect(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(25)),
                          child: SvgPicture.asset(
                              e.partIcon ?? '',
                              fit: BoxFit.cover,
                              color: isSelected ? model.accentColor : model.paletteColor,
                              width: 80)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(e.partTitle, style: TextStyle(
                            color: isSelected ? model.accentColor : model.paletteColor,
                            fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: isSelected ? model.paletteColor : model
                                      .accentColor,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: model.disabledTextColor),
                                ),
                                child: Center(child: Text(e.rangeValues.start.toInt().toString(), style: TextStyle(color: isSelected ? model.accentColor : model.paletteColor))),
                              ),
                              const SizedBox(width: 10),
                              Text('-', style: TextStyle(color: isSelected ? model.accentColor : model.paletteColor)),
                              const SizedBox(width: 10),
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: isSelected ? model.paletteColor : model
                                      .accentColor,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: model.disabledTextColor),
                                ),
                                child: Center(child: Text(e.rangeValues.end.toInt().toString(), style: TextStyle(color: isSelected ? model.accentColor : model.paletteColor))),
                              ),

                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    ).toList(),
  );
}

/// range widget for participant count
Widget getParticipantsBasedOnRange(DashboardModel model, RangeValues range, {required Function(RangeValues) onChanged, required Function(RangeValues) onChangeStart, required Function() clearItems}) {
  late RangeLabels label = RangeLabels(range.start.toString(), range.end.toString());
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('1', style: TextStyle(color: model.paletteColor)),
          Expanded(
            child: RangeSlider(
                activeColor: model.paletteColor,
                inactiveColor: model.disabledTextColor,
                labels: label,
                min: 1,
                max: 500,
                values: range,
                onChangeStart: (values) {
                  onChangeStart(values);
                },
                onChanged: (values){
                  onChanged(values);
                }
            ),
          ),
          Text('500', style: TextStyle(color: model.paletteColor))
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: model.accentColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: model.disabledTextColor),
            ),
            child: Center(child: Text(range.start.toInt().toString(), style: TextStyle(color: model.paletteColor))),
          ),
          // const SizedBox(width: 10),
          Text('Range of Friends', style: TextStyle(color: model.paletteColor)),
          // const SizedBox(width: 10),
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              color: model.accentColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: model.disabledTextColor),
            ),
            child: Center(child: Text(range.end.toInt().toString(), style: TextStyle(color: model.paletteColor))),
          ),
        ],
      ),
      const SizedBox(height: 10),
      searchSettingsButton(
        model,
        didSelectButton: () {
          clearItems();
        },
        iconItem: Icons.clear,
        buttonTitle: 'Clear Range',
        isSelected: false,
      ),
    ],
  );
}

/// TAB
Widget topTabBarController(DashboardModel model, TabController tabController, List<String> tabList, {required Function(int) didTapTab}) {
  return TabBar(
    controller: tabController,
    indicator: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        color: model.paletteColor
    ),
    labelColor: model.disabledTextColor,
    unselectedLabelColor: model.disabledTextColor,
    onTap: (index) {
      didTapTab(index);
    },
    tabs: tabList.map(
            (e) => Tab(
          iconMargin: EdgeInsets.zero,
          text: e,
        )
    ).toList(),
  );
}

double heightForWhoTabs(int index) {
  switch (index) {
    case 0:
      return 380;
    case 1:
      return 230;
  }
  return 0;
}
