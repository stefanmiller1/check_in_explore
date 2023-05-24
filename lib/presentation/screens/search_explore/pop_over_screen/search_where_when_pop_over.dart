import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/core_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_by_slots_time_duration.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_locations_results.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_when_where_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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


  List<String> tabWhenList = ['Slots', 'I\'m Flexible', 'Custom'];
  List<String> tabWhoList = ['A General Amount','A Range'];

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
                                  Navigator.push(context, HeroDialogRoute(
                                      barrierLabelString: '',
                                      builder: (context) {
                                        return  SearchLocationsResults(
                                            model: widget.model
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
                                            Navigator.push(context, HeroDialogRoute(
                                              barrierLabelString: '',
                                              builder: (context) {
                                                return SearchByTimeSlots(
                                                    model: widget.model,
                                                    heroTag: '30_slot',
                                                    durationType: 30,
                                                    buttonTitle: '30 Min Time Slots'
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
                                                Navigator.push(context, HeroDialogRoute(
                                                barrierLabelString: '',
                                                  builder: (context) {
                                                    return SearchByTimeSlots(
                                                        model: widget.model,
                                                        heroTag: '60_slot',
                                                        durationType: 60,
                                                        buttonTitle: '60 Min Time Slots'
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
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pick a Time Frame', style: TextStyle(color: model.disabledTextColor, fontSize: model.secondaryQuestionTitleFontSize)),
          Text('From Today', style: TextStyle(color: model.paletteColor)),
        ],
      ),
      const SizedBox(height: 5),
      Divider(color: model.disabledTextColor),
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
        buttonTitle: 'Clear Dates',
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

