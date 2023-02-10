import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_type_bar.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_where_when_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    _tabController = TabController(length: 2, vsync: this);
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
            child: TabBarView(
                controller: _tabController,
                children: [
                  SearchWhereWhenBar(model: widget.model),
                  SearchTypeBar(model: widget.model),
                ]
            ),
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
                    setState(() {
                    });
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
                          child: Icon(Icons.room, size: 18)),
                    ),
                    Tab(
                      // iconMargin: EdgeInsets.only(right: 3),
                      icon: Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.details, size: 18),
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