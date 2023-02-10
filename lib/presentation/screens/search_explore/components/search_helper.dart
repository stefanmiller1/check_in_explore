
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SearchHelper {

  static late PageController? controller = null;
  static late bool isPanelDraggable = true;

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

Widget getActivityTypeTabOption(BuildContext context, DashboardModel model, double height, bool isSelected, ActivityOption activityOption) {
  return Tab(
      height: searchHeaderHeight(context),
      iconMargin: EdgeInsets.zero,
      icon: Container(
          width: 100,
          decoration: BoxDecoration(
            color: (isSelected) ? model.paletteColor : model.disabledTextColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SvgPicture.asset(getActivityOptions(context).firstWhere((element) => element.activityId == activityOption.activityId).iconPath ?? '', fit: BoxFit.fitHeight, color: (isSelected) ? model.accentColor : model.paletteColor, height: MediaQuery.of(context).size.height * .08),
            ),
          )),
    child: Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: (isSelected) ? model.paletteColor : model.disabledTextColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(getTitleForActivityOption(
              activityOption.activity,
              toRent: AppLocalizations.of(context)?.activityTypeRent,
              camp: AppLocalizations.of(context)?.activityTypeCamp,
              events: AppLocalizations.of(context)?.activityTypeEvent,
              league: AppLocalizations.of(context)?.activityTypeLeagues ?? 'league',
              teaching: AppLocalizations.of(context)?.activityTypeTeaching ?? 'teaching',
              training: AppLocalizations.of(context)?.activityTypeTrainingState ?? 'training',
              teamsRun: AppLocalizations.of(context)?.activityTypeRuns ?? 'teamsRun',
              equipment: AppLocalizations.of(context)?.activityTypeEquipment ?? 'equipment',
              tournament: AppLocalizations.of(context)?.activityTypeTournament ?? 'tournament',
              coaching: AppLocalizations.of(context)?.activityTypeCoachingState ?? 'coaching',
              informalGame: AppLocalizations.of(context)?.activityTypeInformalGame ?? 'informalGame',
              oneOnOne: AppLocalizations.of(context)?.activityTypeOneOnOne ?? 'oneOnOne',
            ) ?? 'Activity', style: TextStyle(color: (isSelected) ? model.accentColor : model.paletteColor), overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: true,),
          ),
        ),
      ),
    )
  );
}