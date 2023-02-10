import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';

class EditSocialsProfile extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel profile;

  const EditSocialsProfile({super.key, required this.model, required this.profile});

  @override
  State<EditSocialsProfile> createState() => _EditSocialsProfileState();
}

class _EditSocialsProfileState extends State<EditSocialsProfile> {

  ScrollController? _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
          elevation: 0,
          title: Text('Edit Socials'),
          iconTheme: IconThemeData(
          color: widget.model.paletteColor
        ),
      ),
      body: BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchUserSocialsSettingStarted(widget.profile.userId.getOrCrash())),
      child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
              loadInProgress: (_) => Center(child: JumpingDots(color: widget.model.paletteColor, numberOfDots: 3, radius: 8)),
              loadUserProfileSocialsSuccess: (item) {
                return updateSocialForm(context, item.socials, widget.model);
              },
              loadSocialsFailure: (f) => f.failure.maybeMap(
                noSocialsFound: (_) => updateSocialForm(context, SocialsItem.empty(), widget.model),
                profileNotFound: (_) => somethingWentWrongError(context, widget.model),
                serverError: (_) => somethingWentWrongError(context, widget.model),
                orElse: () => somethingWentWrongError(context, widget.model),
              ),
              orElse: () => somethingWentWrongError(context, widget.model),
            );
          }
        )
      )
    );
  }


  Widget updateSocialForm(BuildContext context,  SocialsItem socials, DashboardModel model) {

    return BlocProvider(create: (context) => getIt<UpdateUserProfileAccountBloc>()..add(UpdateUserProfileAccountEvent.initializedSocialsProfile(bloc.optionOf(socials))),
        child: BlocConsumer<UpdateUserProfileAccountBloc, UpdateUserProfileAccountState>(
            listenWhen: (p,c) => p.isSubmitting != c.isSubmitting,
            listener: (context, state) {
              state.authFailureOrSuccessOption.fold(
                      () {},
                      (either) => either.fold(
                          (failure) {
                        final snackBar = SnackBar(
                            elevation: 4,
                            backgroundColor: model.webBackgroundColor,
                            content: failure.maybeMap(
                              recentLoginRequired: (_) => Text('In order to Reset your Password you will need to first logout and log in again'),
                              cannotSendEmailVerification: (_) => Text('Could Not Reach Email Address', style: TextStyle(color: model.disabledTextColor)),
                              // cancelledByUser: (_) => Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: widget.model.disabledTextColor),),
                              insufficientPermission: (_) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: model.disabledTextColor),),
                              serverError: (_) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: model.disabledTextColor),),
                              orElse: () =>  Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: model.disabledTextColor),),
                            )
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }, (_) {
                    final snackBar = SnackBar(
                        elevation: 4,
                        backgroundColor: model.paletteColor,
                        content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: model.webBackgroundColor))
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();
                    }
                  )
              );
            },
            buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages || p.isSubmitting != c.isSubmitting || p.isEditingProfile != c.isEditingProfile || p.isEmailVerified != c.isEmailVerified,
            builder: (context, state) {
              return SingleChildScrollView(
                controller: _scrollController,
                child: Form(
                  autovalidateMode: context.read<UpdateUserProfileAccountBloc>().state.showErrorMessages,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 35),

                        Text("${AppLocalizations.of(context)!.profileAccountSocialIG}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: widget.model.disabledTextColor,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            initialValue: socials.instagram ?? '',
                            style: TextStyle(color: model.paletteColor),
                            decoration: InputDecoration(prefixIcon: Icon(Icons.person, color: model.disabledTextColor),
                              hintText: AppLocalizations.of(context)!.profileAccountSocialIG,
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: model.disabledTextColor,
                                ),
                              ),
                              errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: model.paletteColor,
                              ),
                              filled: true,
                              fillColor: model.accentColor,
                              focusedBorder:  OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: model.disabledTextColor,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  width: 0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: model.webBackgroundColor,
                                  width: 0,
                                ),
                              ),
                            ),
                            autocorrect: false,
                            onChanged:
                                (value) {
                              context.read<UpdateUserProfileAccountBloc>()..add(UpdateUserProfileAccountEvent.instagramContactChanged(value));
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text("${AppLocalizations.of(context)!.profileAccountTwitter}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: widget.model.disabledTextColor,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            initialValue: socials.twitter ?? '',
                            style: TextStyle(color: model.paletteColor),
                            decoration: InputDecoration(prefixIcon: Icon(Icons.person, color: model.disabledTextColor),
                              hintText: AppLocalizations.of(context)!.profileAccountTwitter,
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: model.disabledTextColor,
                                ),
                              ),
                              errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: model.paletteColor,
                              ),
                              filled: true,
                              fillColor: model.accentColor,
                              focusedBorder:  OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: model.disabledTextColor,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  width: 0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: model.webBackgroundColor,
                                  width: 0,
                                ),
                              ),
                            ),
                            autocorrect: false,
                            onChanged:
                                (value) {
                              context.read<UpdateUserProfileAccountBloc>()..add(UpdateUserProfileAccountEvent.twitterContactChanged(value));
                            },
                          ),
                        ),

                        const SizedBox(height: 20),
                        Text("${AppLocalizations.of(context)!.profileAccountFacebook}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: widget.model.disabledTextColor,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 10),


                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            initialValue: socials.facebook ?? '',
                            style: TextStyle(color: model.paletteColor),
                            decoration: InputDecoration(prefixIcon: Icon(Icons.person, color: model.disabledTextColor),
                              hintText: AppLocalizations.of(context)!.profileAccountFacebook,
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: model.disabledTextColor,
                                ),
                              ),
                              errorStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: model.paletteColor,
                              ),
                              filled: true,
                              fillColor: model.accentColor,
                              focusedBorder:  OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: model.disabledTextColor,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: const BorderSide(
                                  width: 0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: model.webBackgroundColor,
                                  width: 0,
                                ),
                              ),
                            ),
                            autocorrect: false,
                            onChanged:
                                (value) {
                              context.read<UpdateUserProfileAccountBloc>()..add(UpdateUserProfileAccountEvent.fbookContactChanged(value));
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        if (!state.isSubmitting) InkWell(
                          onTap: () {
                            setState(() {
                              context.read<UpdateUserProfileAccountBloc>()..add(UpdateUserProfileAccountEvent.finishedUpdatingUserProfileSocials());
                            });
                          },
                          child: Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: (state.isEditingProfile) ? widget.model.paletteColor : widget.model.accentColor,
                            ),
                            child: Center(child: Text('Save Changes', style: TextStyle(color: (state.isEditingProfile) ? widget.model.accentColor : widget.model.paletteColor, fontWeight: FontWeight.bold))),
                          ),
                        ),
                        if (state.isSubmitting) JumpingDots(numberOfDots: 3, color: widget.model.paletteColor, radius: 8)

                    ],
                  ),
                ),
              ),
            );

        }
      )
    );
  }
}