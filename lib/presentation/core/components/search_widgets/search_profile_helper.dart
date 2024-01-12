import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'search_profile_widget.dart';

void didSelectSearchedUser({required BuildContext context, required DashboardModel model, required String? currentUserId, required Function(ContactDetails) didSelectContact}) {
  if (kIsWeb) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Search Contacts & Communities',
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
                    width: 550,
                    height: 750,
                    child: SearchProfileCommunity(
                      model: model,
                      currentUserId: currentUserId,
                      didSelectUser: (contacts) {
                        didSelectContact(contacts);
                      },
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
          return SearchProfileCommunity(
            model: model,
            currentUserId: currentUserId,
            didSelectUser: (contacts) {
              didSelectContact(contacts);
            },
          );
        })
    );
  }
}

