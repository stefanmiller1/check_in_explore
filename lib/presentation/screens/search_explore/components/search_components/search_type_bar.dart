import 'dart:ui';

import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_components/search_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';


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
      length: getActivityOptions().length,
      vsync: this,
    );

    if (context.read<ListingsSearchRequirementsBloc>().state.activtityTypeId == null) {
      currentActivityOption ??= getActivityOptions()[0];
    } else {
      currentActivityOption = getActivityOptions().firstWhere((element) => element.activityId == context.read<ListingsSearchRequirementsBloc>().state.activtityTypeId);
    }

    scrollController.addListener(() {
      setState(() {
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: getActivityOptions().map(
                  (e) {

                    final bool isSelected = (context.read<ListingsSearchRequirementsBloc>().state.activtityTypeId == e.activityId);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            currentActivityOption = e;
                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.activityTypeChanged(e.activityId));
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: (isSelected) ? widget.model.paletteColor : widget.model.paletteColor.withOpacity(0.05),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                                  child: SvgPicture.asset(getIconPathForActivity(context, e.activityId), fit: BoxFit.fitHeight, color: (isSelected) ? widget.model.accentColor : widget.model.paletteColor, height: 43.5),
                                ),
                                const SizedBox(width: 5),
                                Text(getTitleForActivityOption(context, e.activityId) ?? 'Activity', style: TextStyle(color: (isSelected) ? widget.model.accentColor : widget.model.paletteColor)),
                                const SizedBox(width: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                ).toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: (scrollController.positions.isNotEmpty) ? scrollController.offset >= 20 ? widget.model.paletteColor : widget.model.accentColor : widget.model.accentColor,
                      border: Border.all(color: widget.model.paletteColor, width: 0.5),
                      borderRadius: BorderRadius.circular(25)
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        scrollController.animateTo(scrollController.offset - 300, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                      });
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded, color: (scrollController.positions.isNotEmpty) ? scrollController.offset >= 20 ? widget.model.disabledTextColor : widget.model.paletteColor : widget.model.paletteColor),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: widget.model.paletteColor,
                      borderRadius: BorderRadius.circular(25)
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        scrollController.animateTo(scrollController.offset + 300, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                      });
                    },
                    icon: Icon(Icons.arrow_forward_ios_rounded, color: widget.model.disabledTextColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: getActivityOptions().length,
        itemBuilder: (context, index) {
          final activityItem = getActivityOptions()[index];

          double selectedWidth = 50 + 6 + ((getTitleForActivityOption(context, activityItem.activityId)?.length ?? 1) * 13);
          _aboveItems = (scrollController.offset)~/((MediaQuery.of(context).size.width + 35)/getActivityOptions().length);

          _belowItems = _aboveItems;
          bool isFirstItem = index >= _aboveItems && index <= _belowItems;

          if (isFirstItem && activityItem != currentActivityOption) {
            currentActivityOption = activityItem;
            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.activityTypeChanged(currentActivityOption?.activityId));
            HapticFeedback.lightImpact();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: getActivityOptionForSearch(
                  context,
                  widget.model,
                  selectedWidth,
                  60,
                  50,
                  (context.read<ListingsSearchRequirementsBloc>().state.activtityTypeId == activityItem.activityId),
                  activityItem,
                  didTapActivity: (activity) {

                   HapticFeedback.lightImpact();
                   scrollController.animateTo(index * 47, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);

              }
            ),
          );
        },
      ),
    );
  }
}