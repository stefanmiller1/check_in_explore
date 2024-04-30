import 'package:check_in_domain/check_in_domain.dart';
import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum SearchWhereWhenMarker {where, when, who}

class SearchExploreCoreHelper {

  static SearchListingType currentSearchListingType = SearchListingType.facilities;

}

final double listingHeaderHeight = 15;
double searchHeaderHeight(BuildContext context) => 120;
// double panelHeight(BuildContext context) => MediaQuery.of(context).size.height - searchHeaderHeight(context) - 65;
double panelHeight(BuildContext context) => MediaQuery.of(context).size.height - searchHeaderHeight(context);




class LocationOptionModel {

  final String locationIcon;
  final String? locationIconOverlay;
  final LatLng locationPosition;
  final double zoom;
  final String locationTitle;
  final String locationId;
  final UniqueId locationItemId;

  LocationOptionModel({required this.locationPosition, required this.zoom, required this.locationItemId, this.locationIconOverlay, required this.locationIcon, required this.locationTitle, required this.locationId});

}

class ParticipantsRangeModel {

  final String partTitle;
  final String partIcon;
  final UniqueId partId;
  final RangeValues rangeValues;

  ParticipantsRangeModel({required this.partTitle, required this.partIcon, required this.partId, required this.rangeValues});

}

class FlexibleDateRangeModel {

  final String dateTypeTitle;
  final DateTimeRange dateRange;
  final UniqueId dateTypeId;

  FlexibleDateRangeModel({required this.dateTypeTitle, required this.dateRange, required this.dateTypeId});

}


List<LocationOptionModel> getMapOptions = [
  LocationOptionModel(
      locationIcon: 'assets/icons_svg/search_explore/noun-world-map-751007.svg',
      locationPosition: const LatLng(32.80746926994453, -97.17418143129657),
      zoom: 3,
      locationTitle: 'Any Where',
      locationId: '',
      locationItemId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-fbbtr5')
  ),
  LocationOptionModel(
      locationIcon: 'assets/icons_svg/search_explore/ontario_map.svg',
      locationIconOverlay: 'assets/icons_svg/search_explore/ontario_map_overlay.svg',
      locationTitle: 'Ontario',
      locationPosition: const LatLng(43.6532, -79.3832),
      zoom: 5,
      locationId: '',
      locationItemId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-34895n')
  ),
];

List<ParticipantsRangeModel> getParticipantRangeOptions = [
  ParticipantsRangeModel(partTitle: 'Just a Friend or Two', partIcon: 'assets/icons_svg/search_explore/noun-friends-drinking-882137.svg', partId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-538nbu4'), rangeValues: const RangeValues(1,3)),
  ParticipantsRangeModel(partTitle: 'A Group of Friends', partIcon: 'assets/icons_svg/search_explore/noun-people-sitting-in-a-circle-1584737.svg', partId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-ni4o390'), rangeValues: const RangeValues(4,10)),
  ParticipantsRangeModel(partTitle: 'A Small Gathering', partIcon: 'assets/icons_svg/search_explore/noun-crowd-with-banner-655212.svg', partId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-3niof33'), rangeValues: const RangeValues(11,50)),
  ParticipantsRangeModel(partTitle: 'A Very Large Crowd', partIcon: 'assets/icons_svg/search_explore/noun-smiling-group-of-people-2739774.svg', partId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-gniu59f'), rangeValues: const RangeValues(51,500))
];


List<FlexibleDateRangeModel> getListOfFlexibleDates() => [
  FlexibleDateRangeModel(dateTypeTitle: 'This Weekend', dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 2))), dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-vghg67n')),
  FlexibleDateRangeModel(dateTypeTitle: 'Next Week', dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 7))), dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-bjhbh8')),
  FlexibleDateRangeModel(dateTypeTitle: 'This Month', dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 30))), dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-hjbhh9')),
  FlexibleDateRangeModel(dateTypeTitle: 'Within The Next Three Months', dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 90))), dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-hjbuy7')),
];


List<FlexibleDateRangeModel> getListOfMonthDates(BuildContext context) {
  var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();

  return [
    FlexibleDateRangeModel(dateTypeTitle: DateFormat.MMMM(tag).dateSymbols.MONTHS[0], dateRange: DateTimeRange(start: DateTime(getMonthForNextYear(1), 1, 1), end: DateTime(getMonthForNextYear(1), 1, 1).add(const Duration(days: 29))), dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-vghg67n')),
    FlexibleDateRangeModel(dateTypeTitle: DateFormat.MMMM(tag).dateSymbols.MONTHS[1], dateRange: DateTimeRange(start: DateTime(getMonthForNextYear(2), 2, 1), end: DateTime(getMonthForNextYear(2), 2, 1).add(const Duration(days: 27))), dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-yuyvuy7')),
    FlexibleDateRangeModel(dateTypeTitle: DateFormat.MMMM(tag).dateSymbols.MONTHS[2], dateRange: DateTimeRange(start: DateTime(getMonthForNextYear(3), 3, 1), end: DateTime(getMonthForNextYear(3), 3, 1).add(const Duration(days: 30))), dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-434biu3')),
    FlexibleDateRangeModel(dateTypeTitle: DateFormat.MMMM(tag).dateSymbols.MONTHS[3], dateRange: DateTimeRange(start: DateTime(getMonthForNextYear(4), 4, 1), end: DateTime(getMonthForNextYear(4), 4, 1).add(const Duration(days: 29))), dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-n4io595')),
    FlexibleDateRangeModel(dateTypeTitle: DateFormat.MMMM(tag).dateSymbols.MONTHS[4], dateRange: DateTimeRange(start: DateTime(getMonthForNextYear(5), 5, 1), end: DateTime(getMonthForNextYear(5), 5, 1).add(const Duration(days: 30))), dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-bui3484')),
    FlexibleDateRangeModel(dateTypeTitle: DateFormat.MMMM(tag).dateSymbols.MONTHS[5], dateRange: DateTimeRange(start: DateTime(getMonthForNextYear(6), 6, 1), end: DateTime(getMonthForNextYear(6), 6, 1).add(const Duration(days: 29))), dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-nbui348')),
    FlexibleDateRangeModel(dateTypeTitle: DateFormat.MMMM(tag).dateSymbols.MONTHS[6], dateRange: DateTimeRange(start: DateTime(getMonthForNextYear(7), 7, 1), end: DateTime(getMonthForNextYear(7), 7, 1).add(const Duration(days: 30))), dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-n3ui84g')),
    FlexibleDateRangeModel(dateTypeTitle: DateFormat.MMMM(tag).dateSymbols.MONTHS[7], dateRange: DateTimeRange(start: DateTime(getMonthForNextYear(8), 8, 1), end: DateTime(getMonthForNextYear(8), 8, 1).add(const Duration(days: 29))), dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-5uui3f4')),
    FlexibleDateRangeModel(dateTypeTitle: DateFormat.MMMM(tag).dateSymbols.MONTHS[8], dateRange: DateTimeRange(start: DateTime(getMonthForNextYear(9), 9, 1), end: DateTime(getMonthForNextYear(9), 9, 1).add(const Duration(days: 30))), dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-fnu4985')),
    FlexibleDateRangeModel(dateTypeTitle: DateFormat.MMMM(tag).dateSymbols.MONTHS[9], dateRange: DateTimeRange(start: DateTime(getMonthForNextYear(10),10, 1), end: DateTime(getMonthForNextYear(10), 10, 1).add(const Duration(days: 29))),  dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-3fui238')),
    FlexibleDateRangeModel(dateTypeTitle: DateFormat.MMMM(tag).dateSymbols.MONTHS[10], dateRange: DateTimeRange(start: DateTime(getMonthForNextYear(11), 11, 1), end: DateTime(getMonthForNextYear(11), 11, 1).add(const Duration(days: 30))), dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-23iu83')),
    FlexibleDateRangeModel(dateTypeTitle: DateFormat.MMMM(tag).dateSymbols.MONTHS[11], dateRange: DateTimeRange(start: DateTime(getMonthForNextYear(12), 12, 1), end: DateTime(getMonthForNextYear(12), 12, 1).add(const Duration(days: 29))), dateTypeId: UniqueId.fromUniqueString('sdvwfe-fwefwef-fwebtf-3u2983f')),
  ];
}

int getMonthForNextYear(int month) {
  return DateTime.now().isAfter(DateTime(DateTime.now().year, month, 1)) ? DateTime.now().add(const Duration(days: 365)).year : DateTime.now().year;
}


Widget cannotFindAnyListings() {
  return Container();
}

Widget cannotFindAnyListingsHeader() {
  return Container();
}


