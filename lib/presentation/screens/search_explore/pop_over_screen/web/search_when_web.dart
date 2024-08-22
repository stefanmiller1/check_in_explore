import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_by_slots_time_duration.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_when_where_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../components/helper.dart';

class SearchWhenWeb extends StatefulWidget {

  final DashboardModel model;
  final Function() didSelectItem;

  const SearchWhenWeb({super.key, required this.model, required this.didSelectItem});

  @override
  State<SearchWhenWeb> createState() => _SearchWhenWebState();
}

class _SearchWhenWebState extends State<SearchWhenWeb> with TickerProviderStateMixin {

  late DateRangePickerController dController;
  late TabController _tabControllerWhen;
  late int tabIndexWhen = 0;

  @override
  void initState() {
    _tabControllerWhen = TabController(length: 3, vsync: this);
    dController = DateRangePickerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          searchListItem(
            context,
            widget.model,
            isSelected: true,
            tagTitle: 'search_dates',
            didSelectItem: widget.didSelectItem,
            isFinishedSelection: (context.read<ListingsSearchRequirementsBloc>().state.dateRange != null),
            iconItem: Icons.calendar_today_outlined,
            selectedTitle: 'When Will it Be?',
            defaultTitle: 'Any Dates?',
            subTitle: (context.read<ListingsSearchRequirementsBloc>().state.dateRange != null) ? '${DateFormat.yMMMMd().format(context.read<ListingsSearchRequirementsBloc>().state.dateRange?.start ?? DateTime.now())} - ${DateFormat.yMMMMd().format(context.read<ListingsSearchRequirementsBloc>().state.dateRange?.end ?? DateTime.now().add(Duration(days: 1)))}' : (context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.isNotEmpty ?? false) ? '${context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.length} Selected Slots' : 'Days You Need',
          ),
          const SizedBox(height: 15),

          Container(
            decoration: BoxDecoration(
              color: widget.model.accentColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: topTabBarController(
                            widget.model,
                            _tabControllerWhen,
                            tabWhenList,
                            didTapTab: (index) {
                              setState(() {
                                tabIndexWhen = index;
                        });
                      }
                    ),
                  ),
                  SizedBox(
                    height: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabBarView(
                          controller: _tabControllerWhen,
                          children: [
                            ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                const SizedBox(height: 15),
                                if (context.read<ListingsSearchRequirementsBloc>().state.durationType == null || context.read<ListingsSearchRequirementsBloc>().state.durationType == 30) Hero(
                                  tag: '30_slot',
                                  child: searchSettingsButton(
                                      widget.model,
                                      didSelectButton: () {
                                        setState(() {
                                          showGeneralDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierLabel: 'Search When',
                                            // barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
                                            transitionDuration: Duration(milliseconds: 350),
                                            pageBuilder: (BuildContext contexts, anim1, anim2) {
                                              return Scaffold(
                                                backgroundColor: Colors.transparent,
                                                body: PointerInterceptor(
                                                  child: Center(
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(25),
                                                      child: Container(
                                                        height: 650,
                                                        width: 570,
                                                        decoration: BoxDecoration(
                                                            color: widget.model.accentColor,
                                                            borderRadius: BorderRadius.all(Radius.circular(25))
                                                          ),
                                                          child: SearchByTimeSlots(
                                                            model: widget.model,
                                                            heroTag: '30_slot',
                                                            durationType: 30,
                                                            buttonTitle: '30 Min Time Slots',
                                                            reservationItemSlot: context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.toList() ?? [],
                                                            didSelectRes: (slotList) {
                                                              setState(() {
                                                              context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.datesRequiredChanged(null));
                                                              context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.flexibleMonthIdChanged(null));
                                                              context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.flexibleTimeRangeIdChanged(null));

                                                              context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.selectedTimeSlotChanged(slotList));
                                                              context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.searchDurationTypeChanged(30));
                                                              });
                                                          },
                                                        )
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                                        });
                                      },
                                      iconItem: Icons.navigate_next,
                                      buttonTitle: '30 Min Time Slots',
                                      isSelected: false
                                  ),
                                ),
                                const SizedBox(height: 15),
                                if (context.read<ListingsSearchRequirementsBloc>().state.durationType == 30 && (context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.isNotEmpty ?? false))
                                  Container(
                                    height: 170,
                                    child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            viewListOfSelectedSlots(
                                              context,
                                              widget.model,
                                              [],
                                              getReservationSlotItemForSearch(
                                                  context,
                                                  context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.toList() ?? [],
                                                  null,
                                                  null,
                                                  null,
                                                  null
                                              ),
                                              [],
                                              false,
                                              AppLocalizations.of(context)!.profileFacilitySlotTime,
                                              AppLocalizations.of(context)!.profileFacilitySlotBookingLocation,
                                              AppLocalizations.of(context)!.profileFacilitySlotBookingDate,
                                              null,
                                              didSelectReservation: (e) {
                                              },
                                              didSelectCancelResSlot: (e, f) {
                                                setState(() {});
                                              },
                                              didSelectRemoveResSlot: (e, f) {

                                            },
                                          ),
                                          const SizedBox(height: 15),
                                        ],
                                      )
                                    ),
                                  ),
                                if (context.read<ListingsSearchRequirementsBloc>().state.durationType == null || context.read<ListingsSearchRequirementsBloc>().state.durationType == 60) Hero(
                                  tag: '60_slot',
                                  child: searchSettingsButton(
                                      widget.model,
                                      didSelectButton: () {
                                        setState(() {
                                          showGeneralDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierLabel: 'Search When',
                                            // barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
                                            transitionDuration: Duration(milliseconds: 350),
                                            pageBuilder: (BuildContext contexts, anim1, anim2) {
                                              return Scaffold(
                                                backgroundColor: Colors.transparent,
                                                body: PointerInterceptor(
                                                  child: Center(
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(25),
                                                      child: Container(
                                                          height: 650,
                                                          width: 570,
                                                          decoration: BoxDecoration(
                                                              color: widget.model.accentColor,
                                                              borderRadius: BorderRadius.all(Radius.circular(25))
                                                          ),
                                                          child: SearchByTimeSlots(
                                                            model: widget.model,
                                                            heroTag: '60_slot',
                                                            durationType: 60,
                                                            buttonTitle: '60 Min Time Slots',
                                                            reservationItemSlot: context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.toList() ?? [],
                                                            didSelectRes: (slotList) {
                                                              setState(() {
                                                                context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.datesRequiredChanged(null));
                                                                context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.flexibleMonthIdChanged(null));
                                                                context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.flexibleTimeRangeIdChanged(null));

                                                                context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.selectedTimeSlotChanged(slotList));
                                                                context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.searchDurationTypeChanged(60));
                                                              });
                                                            },
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                                        });
                                      },
                                      iconItem: Icons.navigate_next,
                                      buttonTitle: '60 Min Time Slots',
                                      isSelected: false
                                  ),
                                ),
                                const SizedBox(height: 15),
                                if (context.read<ListingsSearchRequirementsBloc>().state.durationType == 60 && (context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.isNotEmpty ?? false))
                                  Container(
                                    height: 170,
                                    child: SingleChildScrollView(
                                        child: viewListOfSelectedSlots(
                                          context,
                                          widget.model,
                                          [],
                                          getReservationSlotItemForSearch(
                                              context,
                                              context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.toList() ?? [],
                                              null,
                                              null,
                                              null,
                                              null
                                          ),
                                          [],
                                          false,
                                          AppLocalizations.of(context)!.profileFacilitySlotTime,
                                          AppLocalizations.of(context)!.profileFacilitySlotBookingLocation,
                                          AppLocalizations.of(context)!.profileFacilitySlotBookingDate,
                                          null,
                                          didSelectReservation: (e) {
                                          },
                                          didSelectCancelResSlot: (e, f) {
                                            setState(() {});
                                          },
                                          didSelectRemoveResSlot: (e, f) {

                                          },
                                        )
                                    ),
                                  ),
                                if (context.read<ListingsSearchRequirementsBloc>().state.durationType == null || context.read<ListingsSearchRequirementsBloc>().state.durationType == 1440) Hero(
                                  tag: 'day_slot',
                                  child: searchSettingsButton(
                                      widget.model,
                                      didSelectButton: () {
                                        setState(() {
                                          widget.didSelectItem();
                                        });
                                      },
                                      iconItem: Icons.navigate_next,
                                      buttonTitle: 'Search Day Slots',
                                      isSelected: false
                                  ),
                                ),


                                // SizedBox(
                                //   height: 360,
                                //   width: MediaQuery.of(context).size.width,
                                //   child: TabBarView(
                                //       controller: _tabControllerWhenTime,
                                //       children: [
                                //         /// day slot duration.
                                //         sfCalendarDateRangePickerView(
                                //             widget.model,
                                //             dController,
                                //             context.read<ListingsSearchRequirementsBloc>().state.dateRange,
                                //             onSelectionChanged: (date) {
                                //               setState(() {
                                //                 context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.datesRequiredChanged(date));
                                //               });
                                //             }
                                //         ),
                                  //   ]
                                  // ),
                                // ),

                                if (context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.isEmpty == true) const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                      child: searchSettingsButton(
                                        widget.model,
                                        didSelectButton: () {
                                          setState(() {
                                            dController.selectedRange = null;
                                            context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.datesRequiredChanged(null));
                                            context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.selectedTimeSlotChanged([]));
                                            context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.searchDurationTypeChanged(null));
                                          });
                                        },
                                        iconItem: Icons.clear,
                                        buttonTitle: 'Clear Dates',
                                        isSelected: false,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: searchSettingsButton(
                                          widget.model,
                                          didSelectButton: () {
                                            setState(() {
                                              widget.didSelectItem();
                                            });
                                          },
                                          iconItem: Icons.navigate_next,
                                          buttonTitle: 'Next',
                                          isSelected: false
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  getFlexibleDatesView(
                                      context,
                                      widget.model,
                                      context.read<ListingsSearchRequirementsBloc>().state.flexibleTimeRangeId,
                                      context.read<ListingsSearchRequirementsBloc>().state.flexibleMonthId,
                                      didSelectByType: (typeId) {
                                        setState(() {

                                          if (context.read<ListingsSearchRequirementsBloc>().state.flexibleTimeRangeId == typeId) {
                                            context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.flexibleTimeRangeIdChanged(null));
                                            context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.datesRequiredChanged(null));
                                          } else {
                                            dController.selectedRange = null;
                                            context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.flexibleMonthIdChanged(null));
                                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.flexibleTimeRangeIdChanged(typeId));
                                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.datesRequiredChanged(getListOfFlexibleDates().firstWhere((element) => element.dateTypeId == typeId).dateRange));
                                          }

                                          context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.searchDurationTypeChanged(null));
                                          context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.selectedTimeSlotChanged([]));
                                        });
                                      },
                                      didSelectByMonth: (monthId) {
                                        setState(() {

                                          if (context.read<ListingsSearchRequirementsBloc>().state.flexibleMonthId == monthId) {
                                            context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.flexibleMonthIdChanged(null));
                                            context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.datesRequiredChanged(null));
                                          } else {
                                            dController.selectedRange = null;
                                            context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.flexibleTimeRangeIdChanged(null));
                                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.flexibleMonthIdChanged(monthId));
                                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.datesRequiredChanged(getListOfMonthDates(context).firstWhere((element) => element.dateTypeId == monthId).dateRange));
                                          }
                                          context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.searchDurationTypeChanged(null));
                                          context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.selectedTimeSlotChanged([]));
                                        });
                                      }
                                  ),
                                  const SizedBox(height: 15),
                                  // searchSettingsButton(
                                  //     widget.model,
                                  //     didSelectButton: () {
                                  //       setState(() {
                                  //         widget.didSelectItem();
                                  //       });
                                  //     },
                                  //     iconItem: Icons.navigate_next,
                                  //     buttonTitle: 'Next',
                                  //     isSelected: false
                                  // ),
                                ],
                              ),
                            ),
                            Container(),
                        ]
                      ),
                    ),
                  ),

                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}