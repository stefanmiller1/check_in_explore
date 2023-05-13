import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'helper.dart';
import 'search_helper.dart';

class SearchTypeBar extends StatefulWidget {

  final DashboardModel model;

  const SearchTypeBar({super.key, required this.model});

  @override
  State<SearchTypeBar> createState() => _SearchTypeBarState();
}

class _SearchTypeBarState extends State<SearchTypeBar> with TickerProviderStateMixin {

  late TabController tabController;
  late ActivityOption? currentActivityOption;
  ScrollController scrollController = ScrollController();

  late int _aboveItems = 0;
  late int _belowItems = 0;


  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: getActivityOptions(context).length,
      vsync: this,
    );

    if (context.read<ListingsSearchRequirementsBloc>().state.activtityTypeId == null) {
      currentActivityOption ??= getActivityOptions(context)[0];
    } else {
      currentActivityOption = getActivityOptions(context).firstWhere((element) => element.activityId == context.read<ListingsSearchRequirementsBloc>().state.activtityTypeId);
    }

    scrollController.addListener(() {
      setState(() {
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: getActivityOptions(context).length,
        itemBuilder: (context, index) {
          final activityItem = getActivityOptions(context)[index];

          double selectedWidth = 50 + ((getTitleForActivityOption(context, activityItem.activity)?.length ?? 1) * 13);
          _aboveItems = (scrollController.offset)~/((MediaQuery.of(context).size.width + 35)/getActivityOptions(context).length);

          _belowItems = _aboveItems;
          bool isFirstItem = index >= _aboveItems && index <= _belowItems;

          if (isFirstItem && activityItem != currentActivityOption) {
            currentActivityOption = activityItem;
            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.activityTypeChanged(currentActivityOption?.activityId));
            HapticFeedback.lightImpact();
          }

          return getActivityOptionForSearch(
                context,
                widget.model,
                selectedWidth,
                60,
                50,
                (context.read<ListingsSearchRequirementsBloc>().state.activtityTypeId == activityItem.activityId),
                activityItem
              );

        },
      ),
    );
  }
}