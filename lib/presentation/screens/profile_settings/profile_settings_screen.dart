import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/notifications_profile.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/payments_payouts_profile.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/personal_information_profile.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/review_current_profile.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/profile_settings_screen_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSettingsScreen extends StatefulWidget {

  final DashboardModel model;

  const ProfileSettingsScreen({super.key, required this.model});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {

  late bool isLoggedIn = false;
  late bool logOutIsOn = false;

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: retrieveAuthenticationState(context),
        ),
        tablet: Container(),
        desktop: Container()
    );
  }

  Widget retrieveAuthenticationState(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<AuthBloc>()..add(const AuthEvent.mobileAuthCheckRequested())),
          BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted())),
        ],
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            setState(() {
            state.maybeMap(
                authenticatedUser: (_) {
                  isLoggedIn = true;
                  return;
                },
                unauthenticated: (_) {
                  isLoggedIn = false;
                  return;
                },
                orElse: () {
                  isLoggedIn = false;
                  return;
                }
              );
            });
          },
          child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
            builder: (context, authState) {
              return authState.maybeMap(
                  loadInProgress: (_) => progressOverlay(widget.model),
                  loadProfileFailure: (_) => GetLoginSignUpWidget(model: widget.model),
                  loadUserProfileSuccess: (item) {
                    if (!logOutIsOn) {
                      isLoggedIn = true;
                    } else {
                      isLoggedIn = false;
                    }
                    return getUserProfileSettings(context, widget.model, item.profile);
                  },
                  orElse: () {
                    return progressOverlay(widget.model);
              }
            );
          },
        ),
      ),
    );
  }


  Widget getUserProfileSettings(BuildContext context, DashboardModel model, UserProfileModel profile) {
    if (!isLoggedIn) {
      return GetLoginSignUpWidget(model: widget.model);
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text('Profile', style: TextStyle(color: model.paletteColor,
                fontSize: model.questionTitleFontSize,
                fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            Container(
              decoration: BoxDecoration(
                  color: model.paletteColor,
                  borderRadius: BorderRadius.circular(15)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.event, color: model.accentColor, size: 32,),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Start Hosting an Event or Space',
                                style: TextStyle(color: model.accentColor,
                                    fontSize: model
                                        .secondaryQuestionTitleFontSize,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Let everyone know what you are looking to do.',
                                style: TextStyle(color: model.accentColor))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return ReviewCurrentProfile(
                    model: model,
                    currentUser: profile,
                    didSelectEditProfile: (profile) {

                        },
                      );
                    }
                  )
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      if (profile.profileImage != null) ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          height: 75,
                          width: 75,
                          child: Image(image: profile.profileImage!.image, fit: BoxFit.cover),
                        ),
                      ),
                      if (profile.profileImage == null) Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: model.accentColor,
                            borderRadius: BorderRadius.circular(25)
                        ),
                        child: Center(child: Text(profile.legalName
                            .getOrCrash()[0], style: TextStyle(
                            color: model.paletteColor,
                            fontSize: model.questionTitleFontSize))),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${profile.legalName.getOrCrash()}\'s profile',
                              style: TextStyle(color: model.paletteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: model
                                      .secondaryQuestionTitleFontSize)),
                          const SizedBox(height: 4),
                          Text('review profile', style: TextStyle(color: model
                              .disabledTextColor))
                        ],
                      )
                    ],
                  ),

                  Icon(Icons.keyboard_arrow_right_rounded,
                      color: model.paletteColor)

                ],
              ),
            ),

            const SizedBox(height: 12),
            Divider(color: model.disabledTextColor),
            const SizedBox(height: 12),

            Text('Account Settings', style: TextStyle(color: model.paletteColor,
                fontSize: model.secondaryQuestionTitleFontSize,
                fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ...accountSettingsList(context).map(
                    (e) =>
                    profileSettingItemWidget(
                        model,
                        e.icon,
                        e.title,
                        false,
                        didSelectItem: () {
                          switch (e.marker) {
                            case ProfileSettingMarker.personalIno:
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                return PersonalInformationProfile(
                                  model: widget.model,
                                  profile: profile,
                                );
                              }));
                              break;
                            case ProfileSettingMarker.payments:
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                return PaymentsPayoutsProfile(
                                  model: widget.model,
                                  profile: profile,
                                );
                              }));
                              break;
                            case ProfileSettingMarker.notification:
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                return NotificationProfile(
                                  model: widget.model
                                );
                              }));
                              break;
                            case ProfileSettingMarker.privacy:
                            // TODO: Handle this case.
                              break;
                            default:
                              break;
                          }
                        }
                    )
            ).toList(),

            const SizedBox(height: 32),
            Text('Hosting', style: TextStyle(color: model.paletteColor,
                fontSize: model.secondaryQuestionTitleFontSize,
                fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ...accountHostingList(context).map(
                    (e) =>
                    profileSettingItemWidget(
                        model,
                        e.icon,
                        e.title,
                        false,
                        didSelectItem: () {
                          switch (e.marker) {
                            case ProfileSettingMarker.switchToHosting:
                            // TODO: Handle this case.
                              break;
                            case ProfileSettingMarker.listSpace:
                            // TODO: Handle this case.
                              break;
                            case ProfileSettingMarker.listActivity:
                            // TODO: Handle this case.
                              break;
                            case ProfileSettingMarker.manageSpace:
                            // TODO: Handle this case.
                              break;
                            default:
                              break;
                          }
                        }
                    )
            ).toList(),

            const SizedBox(height: 32),
            Text('Support', style: TextStyle(color: model.paletteColor,
                fontSize: model.secondaryQuestionTitleFontSize,
                fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ...accountSupportList(context).map(
                    (e) =>
                    profileSettingItemWidget(
                        model,
                        e.icon,
                        e.title,
                        false,
                        didSelectItem: () {
                          switch (e.marker) {
                            case ProfileSettingMarker.howWorks:
                            // TODO: Handle this case.
                              break;
                            case ProfileSettingMarker.getHelp:
                            // TODO: Handle this case.
                              break;
                            case ProfileSettingMarker.giveFeedback:
                            // TODO: Handle this case.
                              break;
                            case ProfileSettingMarker.termsOfService:
                            // TODO: Handle this case.
                              break;
                            case ProfileSettingMarker.privacyPolicy:
                            // TODO: Handle this case.
                              break;
                            default:
                              break;
                          }
                        }
                    )
            ).toList(),

            const SizedBox(height: 32),
            Text('Legal', style: TextStyle(color: model.paletteColor,
                fontSize: model.secondaryQuestionTitleFontSize,
                fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ...accountLegalList(context).map(
                    (e) =>
                    profileSettingItemWidget(
                        model,
                        e.icon,
                        e.title,
                        false,
                        didSelectItem: () {
                          switch (e.marker) {
                            case ProfileSettingMarker.termsOfService:
                            // TODO: Handle this case.
                              break;
                            case ProfileSettingMarker.privacyPolicy:
                            // TODO: Handle this case.
                              break;
                            default:
                              break;
                          }
                        }
                    )
            ).toList(),
            const SizedBox(height: 32),

            InkWell(
              onTap: () {
                setState(() {
                  context.read<AuthBloc>().add(const AuthEvent.signedOut());
                  isLoggedIn = false;
                  logOutIsOn = true;
                });
              },
              child: Text('Log Out', style: TextStyle(color: model.paletteColor,
                  fontSize: model.secondaryQuestionTitleFontSize,
                  decoration: TextDecoration.underline),),
            ),
            const SizedBox(height: 32),
          ],
        ),
      );
    }
  }
}