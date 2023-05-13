import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_type_bar.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_where_when_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'helper.dart';

class SearchExploreHeader extends StatefulWidget {

  final DashboardModel model;
  const SearchExploreHeader({super.key, required this.model});

  @override
  State<SearchExploreHeader> createState() => _SearchExploreHeaderState();
}

class _SearchExploreHeaderState extends State<SearchExploreHeader> with SingleTickerProviderStateMixin {

  late TabController? _tabController;

  @override
  void initState() {
    final int typeIndex = SearchListingType.values.indexWhere((element) => element == context.read<ListingsSearchRequirementsBloc>().state.searchType);
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
      alignment: Alignment.centerLeft,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: searchHeaderHeight(context),
        ),
        Positioned(
          left: 65,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 65,
            height: searchHeaderHeight(context),
            child: SearchWhereWhenBar(model: widget.model),
          ),
        ),
        Positioned(
          left: 10,
          child: Container(
            width: 47.5,
            height: searchHeaderHeight(context) - 20,
            decoration: BoxDecoration(
              color: widget.model.paletteColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: RotatedBox(
              quarterTurns: 1,
              child: TabBar(
                  controller: _tabController,
                  onTap: (index) {
                      context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.selectedListingIdChanged(null));
                      if (index == 0) {
                        context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.selectedSearchTypeChanged(SearchListingType.facilities));
                      }
                      if (index == 1) {
                        context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.selectedSearchTypeChanged(SearchListingType.activities));
                      }

                  },
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: widget.model.paletteColor
                  ),
                  labelColor: widget.model.disabledTextColor,
                  unselectedLabelColor: widget.model.disabledTextColor,
                  tabs: const [
                    Tab(
                      iconMargin: EdgeInsets.zero,
                      icon: RotatedBox(
                          quarterTurns: 3,
                          child: Icon(Icons.house_rounded, size: 18)),
                    ),
                    Tab(
                      // iconMargin: EdgeInsets.only(right: 3),
                      icon: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: RotatedBox(
                          quarterTurns: 3,
                            child: Icon(Icons.accessibility_rounded, size: 18)),
                      )
                    )
                  ]
                ),
              ),
            ),
          ),

      ],
    );
  }
}