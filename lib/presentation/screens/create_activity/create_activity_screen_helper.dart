import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'create_activity_screen.dart';

bool showNextButtonNewActivity(int index, ListingManagerForm? listing, bool isConfirmed, List<ReservationSlotItem> slots) {
  switch (index) {
    case 0:
      return true;
    case 1:
      return listing != null;
    case 2:
      return isConfirmed;
    case 3:
      return true;
    case 4:
      return slots.isNotEmpty;
    case 5:
      return true;
    case 6:
      return false;
  }
  return true;
}
bool showBackButtonNewActivity() => true;



void didSelectCreateNewActivity(BuildContext context, DashboardModel model, ListingManagerForm? listing, int? initPage) {
  if (kIsWeb) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Create Activity',
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return  Align(
            alignment: Alignment.center,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Container(
                    decoration: BoxDecoration(
                        color: model.accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(17.5))
                    ),
                    width: 750,
                    height: 1050,
                    child: CreateNewActivityScreen(
                      currentListingManForm: listing,
                      initPage: initPage,
                      model: model,
                    )
                )
            )
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
            scale: anim1.value,
            child: Opacity(
                opacity: anim1.value,
                child: child
            )
        );
      },
    );
  } else {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return CreateNewActivityScreen(
              currentListingManForm: listing,
              initPage: initPage,
              model: model
          );
        })
    );
  }
}