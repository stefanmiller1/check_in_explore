import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:check_in_presentation/check_in_presentation.dart';


Widget retrieveUserProfile(String profileId, DashboardModel model, Color? backgroundColor, Color? textColor, double? textSize, {required UserProfileType profileType, required Function(UserProfileModel) selectedButton}) {
  return BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchSelectedUserProfileStarted(profileId)),
    child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadInProgress: (_) => (profileType != UserProfileType.firstLetterNameOnlyProfile) ? progressOverlay(model) : Container(),
              loadSelectedProfileFailure: (_) => couldNotRetrieveProfile(model),
              loadSelectedProfileSuccess: (item) {

                switch (profileType) {
                  case UserProfileType.searchProfile:
                    return userProfileWidget(
                        e: item.profile,
                        model: model,
                        buttonTitle: AppLocalizations.of(context)!.remove,
                        selectedButton: (profile) {
                          selectedButton(profile);
                        }
                    );
                  case UserProfileType.slotProfile:
                    return userProfileSlotWidget(
                      e: item.profile,
                      backgroundColor: backgroundColor ?? Colors.transparent,
                      textColor: textColor ?? model.paletteColor,
                      model: model,
                    );
                  case UserProfileType.firstLetterNameOnlyProfile:
                    return userProfileNameOnly(
                        e: item.profile,
                        model: model,
                        textColor: textColor ?? model.paletteColor
                    );
                  case UserProfileType.nameOnlyProfile:
                    return userProfileFullNameOnly(
                        e: item.profile,
                        model: model,
                        textColor: textColor ?? model.paletteColor,
                        fontSize: textSize ?? model.questionTitleFontSize
                    );
                  case UserProfileType.firstLetterOnlyProfile:
                    return userFirstLetterProfileNameOnly(
                        e: item.profile,
                        backgroundColor: backgroundColor ?? Colors.transparent,
                        textColor: textColor ?? model.paletteColor,
                        model: model
                    );
                  case UserProfileType.nameAndEmail:
                    return userProfileNameAndEmail(
                        e: item.profile,
                        model: model,
                        backgroundColor: backgroundColor ?? Colors.transparent,
                        textColor: textColor ?? model.paletteColor,
                        selectedButton: (profile) {
                          selectedButton(profile);
                        }
                    );
                  case UserProfileType.listingProfile:
                    return listingProfileWidget(
                        e: item.profile,
                        model: model
                    );
                }
              },
              orElse: () => couldNotRetrieveProfile(model)
          );
        }
    ),
  );
}