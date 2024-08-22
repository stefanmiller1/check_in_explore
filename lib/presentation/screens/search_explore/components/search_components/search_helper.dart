
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';


class SearchExploreWebHelperCore {

  static late bool isPanelDraggable = true;

  static late bool isShowingWhereFilter = false;
  static late bool isShowingWhenFilter = false;
  static late bool isShowingWhoFilter = false;

}


Widget closedState(BuildContext context, DashboardModel model, bool isLoading, Set<Marker> listings) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: isLoading ? Center(
      child: Shimmer.fromColors(
        enabled: isLoading,
        baseColor: Colors.grey.shade400,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 35,
          width: 300,
          decoration: BoxDecoration(
            color: model.accentColor.withOpacity(0.15),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    ) : Center(
        child: Text('${listings.length} Listings Found', style: TextStyle(fontSize: 17, color: model.paletteColor, fontWeight: FontWeight.bold))),
  );
}

Widget getActivityTabForReservation(BuildContext context, DashboardModel model, ActivityOption activityOption) {
  return Container(

    child: Column(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            color: model.accentColor,
            border: Border.all(width: 4, color: model.disabledTextColor),
            borderRadius: BorderRadius.circular(65)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(65),
                child: Center(child: SvgPicture.asset(getIconPathForActivity(context, activityOption.activityId), fit: BoxFit.fill, color: model.paletteColor))),
          )
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: model.accentColor,
            borderRadius: BorderRadius.circular(25)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(getTitleForActivityOption(context, activityOption.activityId) ?? 'Activity', style: TextStyle(color: model.paletteColor, fontSize: 14, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1, softWrap: true),
          ),
        ),
      ],
    ),
  );
}

Widget getActivityOptionForSearch(BuildContext context, DashboardModel model, double? selectedWidth, double unselectedWidth, double height, bool isSelected, ActivityOption activityOption, {required Function(ActivityOption) didTapActivity}) {
  return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: (isSelected) ? selectedWidth : unselectedWidth,
          height: height,
          decoration: BoxDecoration(
            color: (isSelected) ? model.paletteColor : model.disabledTextColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(50),
          ),
          child: GestureDetector(
            onTap: () {
              didTapActivity(activityOption);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Expanded(child: SvgPicture.asset(getIconPathForActivity(context, activityOption.activityId), fit: BoxFit.cover, color: (isSelected) ? model.accentColor : model.paletteColor, height: height)),
                    if (isSelected || kIsWeb) Expanded(child: Text(getTitleForActivityOption(context, activityOption.activityId) ?? 'Activity', style: TextStyle(color: (isSelected) ? model.accentColor : model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true,)),
                ],
              ),
            ),
          ),
        ),
    // child: Padding(
    //   padding: const EdgeInsets.only(top: 6.0),
    //   child: Container(
    //     width: 100,
    //     decoration: BoxDecoration(
    //       color: (isSelected) ? model.paletteColor : model.disabledTextColor.withOpacity(0.2),
    //       borderRadius: BorderRadius.circular(15),
    //     ),
    //     child: Center(
    //       child: Padding(
    //         padding: const EdgeInsets.all(4.0),
    //         child: Text(getTitleForActivityOption(context, activityOption.activity) ?? 'Activity', style: TextStyle(color: (isSelected) ? model.accentColor : model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true,),
    //       ),
    //     ),
    //   ),
    // )
  );
}