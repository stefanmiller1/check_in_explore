import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_components/search_type_bar.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_components/search_where_when_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SearchExploreFilter extends StatefulWidget {

  final DashboardModel model;
  final Function() didSelectFilterBy;
  const SearchExploreFilter({super.key, required this.model, required this.didSelectFilterBy});

  @override
  State<SearchExploreFilter> createState() => _SearchExploreFilterState();
}

class _SearchExploreFilterState extends State<SearchExploreFilter> with SingleTickerProviderStateMixin {

  late TabController? _tabController;

  @override
  void initState() {
    late int typeIndex = SearchListingType.values.indexWhere((element) => element == SearchExploreCoreHelper.currentSearchListingType);
    if (typeIndex != 0 || typeIndex != 1) {
      typeIndex = 0;
    }
    _tabController = TabController(initialIndex: typeIndex, length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: searchHeaderHeight(context),
        ),
        Positioned(
          // left: (kIsWeb) ? null : 65,
          child: SizedBox(
            width: (kIsWeb) ? null : MediaQuery.of(context).size.width,
            height: searchHeaderHeight(context),
            child: SearchWhereWhenBar(
              model: widget.model,
              didSelectFilterBy: widget.didSelectFilterBy,
            ),
          ),
        ),
        // if (kIsWeb == false) Positioned(
        //   left: 10,
        //   child: Container(
        //     width: 47.5,
        //     height: searchHeaderHeight(context) - 20,
        //     decoration: BoxDecoration(
        //       color: widget.model.paletteColor.withOpacity(0.05),
        //       borderRadius: BorderRadius.circular(25.0),
        //     ),
        //     child: RotatedBox(
        //       quarterTurns: 1,
        //       child: TabBar(
        //           indicatorSize: TabBarIndicatorSize.tab,
        //           controller: _tabController,
        //           onTap: (index) {
        //               context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.selectedListingIdChanged(null));
        //               if (index == 0) {
        //                 SearchExploreCoreHelper.currentSearchListingType = SearchListingType.facilities;
        //                 // context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.selectedSearchTypeChanged(SearchListingType.facilities));
        //               }
        //               if (index == 1) {
        //                 SearchExploreCoreHelper.currentSearchListingType = SearchListingType.activities;
        //                 // context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.selectedSearchTypeChanged(SearchListingType.activities));
        //               }
        //
        //           },
        //           indicator: BoxDecoration(
        //             borderRadius: BorderRadius.circular(25.0),
        //             color: widget.model.paletteColor
        //           ),
        //           labelColor: widget.model.disabledTextColor,
        //           unselectedLabelColor: widget.model.disabledTextColor,
        //           tabs: const [
        //             Tab(
        //               iconMargin: EdgeInsets.zero,
        //               icon: RotatedBox(
        //                   quarterTurns: 3,
        //                   child: Icon(Icons.house_rounded, size: 18)),
        //             ),
        //             Tab(
        //               // iconMargin: EdgeInsets.only(right: 3),
        //               icon: Padding(
        //                 padding: EdgeInsets.only(right: 8.0),
        //                 child: RotatedBox(
        //                   quarterTurns: 3,
        //                     child: Icon(Icons.accessibility_rounded, size: 18)),
        //               )
        //             )
        //           ]
        //         ),
        //       ),
        //     ),
        //   ),

      ],
    );
  }
}