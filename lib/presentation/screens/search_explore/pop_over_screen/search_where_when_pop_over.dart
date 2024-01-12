import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/core_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_by_slots_time_duration.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_locations_results.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_when_where_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../components/helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchWhereWhenPopOver extends StatefulWidget {

  final DashboardModel model;
  final SearchWhereWhenMarker searchMarker;

  const SearchWhereWhenPopOver({super.key, required this.model, required this.searchMarker});

  @override
  State<SearchWhereWhenPopOver> createState() => _SearchWhereWhenPopOverState();
}

class _SearchWhereWhenPopOverState extends State<SearchWhereWhenPopOver> with TickerProviderStateMixin {

  late DateRangePickerController dController;
  late SearchWhereWhenMarker searchTab = SearchWhereWhenMarker.where;
  late TabController _tabControllerWhen;
  late TabController _tabControllerWho;
  late int tabIndexWhen = 0;
  late int tabIndexWho = 0;

  @override
  void initState() {
    searchTab = widget.searchMarker;
    dController = DateRangePickerController();
    _tabControllerWhen = TabController(length: 3, vsync: this);
    _tabControllerWho = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.cancel, size: 40, color: widget.model.paletteColor), padding: EdgeInsets.zero),
          const SizedBox(width: 10),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              children: [
                // SizedBox(height: searchHeaderHeight(context) + 75),
                searchListItem(
                    context,
                    widget.model,
                    isSelected: (searchTab != SearchWhereWhenMarker.where),
                    tagTitle: 'search_tag',
                    didSelectItem: () {
                      setState(() {
                        searchTab = SearchWhereWhenMarker.where;
                      });
                    },
                    isFinishedSelection: (context.read<ListingsSearchRequirementsBloc>().state.locationItemId != null) || (context.read<ListingsSearchRequirementsBloc>().state.isSomeWhereNear != null) || (context.read<ListingsSearchRequirementsBloc>().state.locationCityFromMap != null),
                    iconItem: Icons.search_rounded,
                    selectedTitle: 'Where Abouts?',
                    defaultTitle: 'Where Would You Like to Be?',
                    subTitle: (context.read<ListingsSearchRequirementsBloc>().state.locationItemId != null) ? getMapOptions.firstWhere((element) => element.locationItemId == context.read<ListingsSearchRequirementsBloc>().state.locationItemId).locationTitle : (context.read<ListingsSearchRequirementsBloc>().state.isSomeWhereNear ?? false) ? 'Somewhere Near Me' : (context.read<ListingsSearchRequirementsBloc>().state.locationCityFromMap != null) ? context.read<ListingsSearchRequirementsBloc>().state.locationCityFromMap! : 'Pick an Area'
                ),

                const SizedBox(height: 15),
                AnimatedContainer(
                  decoration: BoxDecoration(
                    color: widget.model.accentColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 750),
                  width: MediaQuery.of(context).size.width - 10,
                  height: (searchTab == SearchWhereWhenMarker.where) ? 345 : 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        /// search button
                        Hero(
                          tag: 'search_location',
                          child: searchSettingsButton(
                              widget.model,
                              didSelectButton: () {
                                setState(() {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (_) {
                                        return  SearchLocationsResults(
                                            model: widget.model,
                                            locationHistory: context.read<ListingsSearchRequirementsBloc>().state.historyLocationSearch?.toList() ?? [],
                                            onSelectionChanged: ({String? addressStr, String? cityStr, double? lat, double? lng, String? placeId, String? provinceStateStr}) {
                                              setState(() {
                                                context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationIsSomewhereNearChanged(null));
                                                context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.locationItemIdRequiredChanged(null));
                                                context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationCotyFromMapChanged('$addressStr, $cityStr'));
                                              });
                                            },
                                            onTapClearHistory: () {
                                              setState(() {
                                                context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationSearchHistoryChanged([]));
                                              });
                                            },
                                            onTapLocationHistory: (historyItem) {
                                              setState(() {
                                                context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationIsSomewhereNearChanged(null));
                                                context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.locationItemIdRequiredChanged(null));
                                                context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationCotyFromMapChanged('${historyItem.address}, ${historyItem.city}'));
                                              });
                                            },
                                            locationCityFromMap: context.read<ListingsSearchRequirementsBloc>().state.locationCityFromMap ?? '',
                                            historyDidChange: (history) {
                                              setState(() {
                                                context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationSearchHistoryChanged(history));
                                              });
                                            },
                                            didFinishSelection: () {
                                            },
                                        );
                                      }
                                  ));
                                });
                              },
                              iconItem: Icons.search_rounded,
                              buttonTitle: 'Search Locations',
                              isSelected: false,
                          ),
                        ),
                        /// searchable maps
                        const SizedBox(height: 10),
                        listOfDefaultLocations(
                            widget.model,
                            context.read<ListingsSearchRequirementsBloc>().state.locationItemId,
                            didSelectItem: (selectedItem) {
                            setState(() {
                              context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.locationIsSomewhereNearChanged(null));
                              context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.locationCotyFromMapChanged(null));

                              if (selectedItem.locationItemId == context.read<ListingsSearchRequirementsBloc>().state.locationItemId) {
                                context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationItemIdRequiredChanged(null));
                              } else {
                                searchTab = SearchWhereWhenMarker.when;
                                context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationItemIdRequiredChanged(selectedItem.locationItemId));
                                MapHelper.mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            zoom: getMapOptions.firstWhere((element) => element.locationItemId == selectedItem.locationItemId).zoom,
                                            target: getMapOptions.firstWhere((element) => element.locationItemId == selectedItem.locationItemId).locationPosition
                                        )
                                    )
                                );
                              }
                            });
                          }
                        ),
                        /// i'm flexible or near me...?
                        const SizedBox(height: 10),
                        searchSettingsButton(
                            widget.model,
                            didSelectButton: () async {
                              setState(() {
                                if (!(context.read<ListingsSearchRequirementsBloc>().state.isSomeWhereNear ?? false)) {
                                  searchTab = SearchWhereWhenMarker.when;
                                }
                                context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.locationItemIdRequiredChanged(null));
                                context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.locationCotyFromMapChanged(null));

                                context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationIsSomewhereNearChanged(!(context.read<ListingsSearchRequirementsBloc>().state.isSomeWhereNear ?? false)));
                              });


                              if (!(context.read<ListingsSearchRequirementsBloc>().state.isSomeWhereNear ?? false)) {
                                Position position = await MapHelper.determineCurrentPosition(context, widget.model);
                                MapHelper.mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            zoom: 12,
                                            target: LatLng(position.latitude, position.longitude)
                                    )
                                  )
                                );
                              }
                            },
                            iconItem: Icons.location_on_outlined,
                            buttonTitle: 'Somewhere Near Me..',
                            isSelected: context.read<ListingsSearchRequirementsBloc>().state.isSomeWhereNear ?? false
                        )
                      ],
                    ),
                  ),
                ),
                if (searchTab == SearchWhereWhenMarker.where) const SizedBox(height: 15),
                searchListItem(
                    context,
                    widget.model,
                    isSelected: (searchTab != SearchWhereWhenMarker.when),
                    tagTitle: 'search_dates',
                    didSelectItem: () {
                      setState(() {
                        searchTab = SearchWhereWhenMarker.when;
                      });
                    },
                    isFinishedSelection: (context.read<ListingsSearchRequirementsBloc>().state.dateRange != null),
                    iconItem: Icons.calendar_today_outlined,
                    selectedTitle: 'When Will it Be?',
                    defaultTitle: 'Any Dates?',
                    subTitle: (context.read<ListingsSearchRequirementsBloc>().state.dateRange != null) ? '${DateFormat.yMMMMd().format(context.read<ListingsSearchRequirementsBloc>().state.dateRange?.start ?? DateTime.now())} - ${DateFormat.yMMMMd().format(context.read<ListingsSearchRequirementsBloc>().state.dateRange?.end ?? DateTime.now().add(Duration(days: 1)))}' : (context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.isNotEmpty ?? false) ? '${context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.length} Selected Slots' : 'Days You Need',
                ),
                if (searchTab == SearchWhereWhenMarker.when) const SizedBox(height: 15),
                AnimatedContainer(
                  decoration: BoxDecoration(
                    color: widget.model.accentColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 750),
                  width: MediaQuery.of(context).size.width - 10,
                  height: (searchTab == SearchWhereWhenMarker.when) ? 500 : 0,
                  child: Column(
                    children: [
                      SizedBox(
                          height: (searchTab == SearchWhereWhenMarker.when) ? 50 : 0,
                          child: topTabBarController(
                              widget.model,
                              _tabControllerWhen,
                              tabWhenList,
                              didTapTab: (index) {
                                setState(() {
                                  tabIndexWhen = index;
                                });
                          }
                        )
                      ),
                      Expanded(
                        child: SizedBox(
                          height: (searchTab == SearchWhereWhenMarker.when) ? 530 : 0,
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
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (_) {
                                                return SearchByTimeSlots(
                                                      model: widget.model,
                                                      heroTag: '30_slot',
                                                      durationType: 30,
                                                      buttonTitle: '30 Min Time Slots',
                                                      reservationItemSlot: context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.toList() ?? [],
                                                      didSelectRes: (slots) {
                                                        setState(() {
                                                          context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.datesRequiredChanged(null));
                                                          context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.flexibleMonthIdChanged(null));
                                                          context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.flexibleTimeRangeIdChanged(null));

                                                          context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.selectedTimeSlotChanged(slots));
                                                          context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.searchDurationTypeChanged(30));
                                                        });
                                                      },
                                                    );
                                                  })
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
                                        height: 270,
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
                                      if (context.read<ListingsSearchRequirementsBloc>().state.durationType == null || context.read<ListingsSearchRequirementsBloc>().state.durationType == 60) Hero(
                                        tag: '60_slot',
                                        child: searchSettingsButton(
                                            widget.model,
                                            didSelectButton: () {
                                              setState(() {
                                                Navigator.push(context, MaterialPageRoute(
                                                    builder: (_) {
                                                    return SearchByTimeSlots(
                                                        model: widget.model,
                                                        heroTag: '60_slot',
                                                        durationType: 60,
                                                        buttonTitle: '60 Min Time Slots',
                                                        reservationItemSlot: context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.toList() ?? [],
                                                        didSelectRes: (slots) {
                                                          setState(() {
                                                              context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.datesRequiredChanged(null));
                                                              context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.flexibleMonthIdChanged(null));
                                                              context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.flexibleTimeRangeIdChanged(null));

                                                              context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.selectedTimeSlotChanged(slots));
                                                              context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.searchDurationTypeChanged(60));
                                                            });
                                                          },
                                                        );
                                                      })
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
                                          height: 270,
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
                                                searchTab = SearchWhereWhenMarker.who;
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

                                        //  ]
                                        // ),
                                      // ),

                                        if (context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.isEmpty ?? false) const SizedBox(height: 145),
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
                                                      searchTab = SearchWhereWhenMarker.who;
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

                                Column(
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
                                    searchSettingsButton(
                                        widget.model,
                                        didSelectButton: () {
                                          setState(() {
                                            searchTab = SearchWhereWhenMarker.who;
                                          });
                                        },
                                        iconItem: Icons.navigate_next,
                                        buttonTitle: 'Next',
                                        isSelected: false
                                    ),
                                  ],
                                ),
                                Container(),
                              ]
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                searchListItem(
                    context,
                    widget.model,
                    isSelected: (searchTab != SearchWhereWhenMarker.who),
                    tagTitle: 'search_who',
                    didSelectItem: () {
                      setState(() {
                        searchTab = SearchWhereWhenMarker.who;
                      });
                    },
                    isFinishedSelection: (context.read<ListingsSearchRequirementsBloc>().state.participantId != null),
                    iconItem: Icons.group_outlined,
                    selectedTitle: 'How Many Do You Expect?',
                    defaultTitle: 'Who\'s Joining You?',
                    subTitle: (context.read<ListingsSearchRequirementsBloc>().state.participantId != null) ? getParticipantRangeOptions.firstWhere((element) => element.partId == context.read<ListingsSearchRequirementsBloc>().state.participantId).partTitle : (context.read<ListingsSearchRequirementsBloc>().state.participantRange != null) ? '${context.read<ListingsSearchRequirementsBloc>().state.participantRange?.start.toInt()} - ${context.read<ListingsSearchRequirementsBloc>().state.participantRange?.end.toInt()} Friends' : 'Add Friends?'
                ),
                const SizedBox(height: 15),
                AnimatedContainer(
                  decoration: BoxDecoration(
                    color: widget.model.accentColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 750),
                  width: MediaQuery.of(context).size.width - 10,
                  height: (searchTab == SearchWhereWhenMarker.who) ? heightForWhoTabs(tabIndexWho) : 0,
                  child: Column(
                    children: [

                      topTabBarController(
                          widget.model,
                          _tabControllerWho,
                          tabWhoList,
                          didTapTab: (index) {
                            setState(() {
                            tabIndexWho = index;
                          });
                        }
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              /// search button

                                  if (tabIndexWho == 0) getParticipantListView(
                                    widget.model,
                                    context.read<ListingsSearchRequirementsBloc>().state.participantId,
                                    didSelectRange: (selectedRange) {
                                      setState(() {
                                          if (selectedRange.partId == context.read<ListingsSearchRequirementsBloc>().state.participantId) {
                                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.participantsIdChanged(null));
                                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.participantsRequiredChanged(null));
                                          } else {
                                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.participantsIdChanged(selectedRange.partId));
                                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.participantsRequiredChanged(selectedRange.rangeValues));
                                          }
                                        });
                                      }
                                    ),
                                  if (tabIndexWho == 1) getParticipantsBasedOnRange(
                                      widget.model,
                                      context.read<ListingsSearchRequirementsBloc>().state.participantRange ?? RangeValues(1, 4),
                                      onChangeStart: (values) {
                                        setState(() {
                                          context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.participantsIdChanged(null));
                                        });
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.participantsRequiredChanged(value));
                                        });
                                      }, clearItems: () {
                                        setState(() {
                                          context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.participantsRequiredChanged(null));
                                        });
                                      })


                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

