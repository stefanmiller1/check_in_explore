import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: getActivityOptions(context).length,
      vsync: this,
    );

    if (context.read<ListingsSearchRequirementsBloc>().state.activtityTypeId != null) tabController.animateTo(getActivityOptions(context).indexWhere((element) => element.activityId == context.read<ListingsSearchRequirementsBloc>().state.activtityTypeId), duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ClipRRect(
    borderRadius: const BorderRadius.all(
        Radius.circular(22.5)),
    child: TabBar(
        controller: tabController,
        indicatorWeight: 1.5,
        enableFeedback: true,
        isScrollable: true,
        padding: EdgeInsets.zero,
        labelColor: widget.model.accentColor,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Colors.transparent,
        onTap: (index) {
          setState(() {
            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.activityTypeChanged(getActivityOptions(context)[index].activityId));
          });
        },
        tabs: getActivityOptions(context).map(
                (e) => getActivityTypeTabOption(
                  context,
                  widget.model,
                  searchHeaderHeight(context),
                  (context.read<ListingsSearchRequirementsBloc>().state.activtityTypeId == e.activityId),
                  e
          )
        ).toList()
      ),
    );
  }
}