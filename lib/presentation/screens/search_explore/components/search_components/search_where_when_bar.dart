import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/core_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_components/search_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_components/search_type_bar.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_where_when_pop_over.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helper.dart';


class SearchWhereWhenBar extends StatefulWidget {

  final DashboardModel model;
  final Function() didSelectFilterBy;
  
  const SearchWhereWhenBar({super.key, required this.model, required this.didSelectFilterBy});

  @override
  State<SearchWhereWhenBar> createState() => _SearchWhereWhenBarState();
}

class _SearchWhereWhenBarState extends State<SearchWhereWhenBar> with SingleTickerProviderStateMixin {

  late TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void showSettingsPopOverScreen(BuildContext context, SearchWhereWhenMarker searchMarker) {
    setState(() {
      if (kIsWeb) {
        widget.didSelectFilterBy();
        switch (searchMarker) {
          case SearchWhereWhenMarker.where:
            SearchExploreWebHelperCore.isShowingWhereFilter = !SearchExploreWebHelperCore.isShowingWhereFilter;
            SearchExploreWebHelperCore.isShowingWhenFilter = false;
            SearchExploreWebHelperCore.isShowingWhoFilter = false;
            break;
          case SearchWhereWhenMarker.when:
            SearchExploreWebHelperCore.isShowingWhenFilter = !SearchExploreWebHelperCore.isShowingWhenFilter;
            SearchExploreWebHelperCore.isShowingWhereFilter = false;
            SearchExploreWebHelperCore.isShowingWhoFilter = false;
            break;
          case SearchWhereWhenMarker.who:
            SearchExploreWebHelperCore.isShowingWhoFilter = !SearchExploreWebHelperCore.isShowingWhoFilter;
            SearchExploreWebHelperCore.isShowingWhenFilter = false;
            SearchExploreWebHelperCore.isShowingWhereFilter = false;
            break;
        }
      } else {
        Navigator.push(context, MaterialPageRoute(
            builder: (_) {
              return SearchWhereWhenPopOver(
                  searchMarker: searchMarker,
                  model: widget.model
              );
            }
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: (kIsWeb) ? const EdgeInsets.symmetric(horizontal: 6.0) : EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Hero(
                      tag: 'search_tag',
                      child: Container(
                        height: searchHeaderHeight(context) / 2.5,
                        width: MediaQuery.of(context).size.width - 80,
                        decoration: BoxDecoration(
                          color: (SearchExploreWebHelperCore.isShowingWhereFilter) ? widget.model.paletteColor : widget.model.disabledTextColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                            showSettingsPopOverScreen(
                                context,
                                SearchWhereWhenMarker.where
                              );
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 6),
                              Container(
                                  decoration: BoxDecoration(
                                    color: widget.model.disabledTextColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.search_rounded, color: (SearchExploreWebHelperCore.isShowingWhereFilter) ? widget.model.accentColor : widget.model.paletteColor),
                                )
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Where Would You Like to Be?', style: TextStyle(color: (SearchExploreWebHelperCore.isShowingWhereFilter) ? widget.model.accentColor : widget.model.paletteColor, decoration: TextDecoration.none, fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1,),
                                    Row(
                                      children: [
                                        Expanded(child: Text((context.read<ListingsSearchRequirementsBloc>().state.locationItemId != null) ? getMapOptions.firstWhere((element) => element.locationItemId == context.read<ListingsSearchRequirementsBloc>().state.locationItemId).locationTitle : (context.read<ListingsSearchRequirementsBloc>().state.isSomeWhereNear ?? false) ? 'Somewhere Near Me' : (context.read<ListingsSearchRequirementsBloc>().state.locationCityFromMap != null) ? context.read<ListingsSearchRequirementsBloc>().state.locationCityFromMap! : 'Pick an Area', style: TextStyle(color: (SearchExploreWebHelperCore.isShowingWhereFilter) ? widget.model.accentColor : widget.model.paletteColor, decoration: TextDecoration.none, fontWeight: FontWeight.normal, fontSize: 14), maxLines: 1,)),
                                        // Expanded(child: Text(co)) /
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                    ),
                  ),
                  if (kIsWeb) const SizedBox(width: 7),
                  if (kIsWeb) Expanded(
                    child: Hero(
                      tag: 'search_dates',
                      child: Container(
                        decoration: BoxDecoration(
                          color: (SearchExploreWebHelperCore.isShowingWhenFilter) ? widget.model.paletteColor :  widget.model.disabledTextColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: InkWell(
                          onTap: () {
                            showSettingsPopOverScreen(context,
                                SearchWhereWhenMarker.when
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              children: [
                                const SizedBox(width: 6),
                                Container(
                                  decoration: BoxDecoration(
                                    color: widget.model.disabledTextColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.calendar_today_outlined, color: (SearchExploreWebHelperCore.isShowingWhenFilter) ? widget.model.accentColor : widget.model.paletteColor,),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if ((context.read<ListingsSearchRequirementsBloc>().state.dateRange == null)) Text('Any Dates?', style: TextStyle(color: (SearchExploreWebHelperCore.isShowingWhenFilter) ? widget.model.accentColor : widget.model.paletteColor, decoration: TextDecoration.none, fontWeight: FontWeight.normal, fontSize: 14), maxLines: 1,),
                                      if (context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots != null && context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots!.isNotEmpty) Text('${context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots!.length} Slots', style: TextStyle(color:  (SearchExploreWebHelperCore.isShowingWhenFilter) ? widget.model.accentColor : widget.model.paletteColor, decoration: TextDecoration.none, fontWeight: FontWeight.normal, fontSize: 14), maxLines: 1),
                                      if (context.read<ListingsSearchRequirementsBloc>().state.dateRange != null) Text('${DateFormat.yMMMMd().format(context.read<ListingsSearchRequirementsBloc>().state.dateRange?.start ?? DateTime.now())}', style: TextStyle(color: (SearchExploreWebHelperCore.isShowingWhenFilter) ? widget.model.accentColor : widget.model.paletteColor, decoration: TextDecoration.none, fontWeight: FontWeight.normal, fontSize: 14), maxLines: 1,),
                                      if (context.read<ListingsSearchRequirementsBloc>().state.dateRange != null) Text('${DateFormat.yMMMMd().format(context.read<ListingsSearchRequirementsBloc>().state.dateRange?.end ?? DateTime.now().add(Duration(days: 1)))}', style: TextStyle(color: (SearchExploreWebHelperCore.isShowingWhenFilter) ? widget.model.accentColor : widget.model.paletteColor, decoration: TextDecoration.none, fontWeight: FontWeight.normal, fontSize: 14), maxLines: 1,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (kIsWeb) const SizedBox(width: 7),
                  if (kIsWeb) Expanded(
                    child: Hero(
                      tag: 'search_who',
                      child: Container(
                        decoration: BoxDecoration(
                          color: (SearchExploreWebHelperCore.isShowingWhoFilter) ? widget.model.paletteColor :  widget.model.disabledTextColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: InkWell(
                          onTap: () {
                            showSettingsPopOverScreen(context,
                                SearchWhereWhenMarker.who);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              children: [
                                const SizedBox(width: 6),
                                Container(
                                  decoration: BoxDecoration(
                                    color: widget.model.disabledTextColor.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.group_outlined, color: (SearchExploreWebHelperCore.isShowingWhoFilter) ? widget.model.accentColor : widget.model.paletteColor),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(child: Text((context.read<ListingsSearchRequirementsBloc>().state.participantId != null) ? getParticipantRangeOptions.firstWhere((element) => element.partId == context.read<ListingsSearchRequirementsBloc>().state.participantId).partTitle : (context.read<ListingsSearchRequirementsBloc>().state.participantRange != null) ? '${context.read<ListingsSearchRequirementsBloc>().state.participantRange?.start.toInt()} - ${context.read<ListingsSearchRequirementsBloc>().state.participantRange?.end.toInt()} Friends' : 'Add Friends?', style: TextStyle(color: (SearchExploreWebHelperCore.isShowingWhoFilter) ? widget.model.accentColor : widget.model.paletteColor, decoration: TextDecoration.none, fontWeight: FontWeight.normal, fontSize: 14), maxLines: 2)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: SearchTypeBar(
              model: widget.model,
            ),
          ),

        ],
      ),
    );
  }
}
