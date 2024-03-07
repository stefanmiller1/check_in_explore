import 'dart:io';

import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/profile_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:image_picker/image_picker.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:phone_form_field/phone_form_field.dart';

class PersonalInformationProfile extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel profile;

  const PersonalInformationProfile({super.key, required this.model, required this.profile});

  @override
  State<PersonalInformationProfile> createState() => _PersonalInformationProfileState();
}

class _PersonalInformationProfileState extends State<PersonalInformationProfile> {

  final ImagePicker _imagePicker = ImagePicker();
  late bool isEditingPhone = false;
  late bool isEditingDeniedId  = false;
  Image? _selectedFilePhotoId;
  Image? _selectedFileSelfie;

  PhoneController? _contactPhoneController;
  PhoneController? _emergePhoneController;

  @override
  void initState() {
    _emergePhoneController = PhoneController(null);
    _contactPhoneController = PhoneController(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(create: (context) => getIt<UpdateUserProfileAccountBloc>()..add(UpdateUserProfileAccountEvent.initializedUserProfile(bloc.optionOf(widget.profile))),
        child: BlocConsumer<UpdateUserProfileAccountBloc, UpdateUserProfileAccountState>(
            listenWhen: (p,c) => p.isSubmitting != c.isSubmitting,
            listener: (context, state) {

              state.authFailureOrSuccessOption.fold(
                      () {},
                      (either) => either.fold(
                          (failure) {
                        final snackBar = SnackBar(
                            backgroundColor: widget.model.webBackgroundColor,
                            content: failure.maybeMap(
                              // cancelledByUser: (_) => Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: widget.model.disabledTextColor),),
                              insufficientPermission: (_) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor),),
                              serverError: (_) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor),),
                              orElse: () =>  Text(AppLocalizations.of(context)!.loginFailuresCancelled, style: TextStyle(color: widget.model.disabledTextColor),),
                            )
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }, (_) {
                    final snackBar = SnackBar(
                        elevation: 4,
                        backgroundColor: widget.model.paletteColor,
                        content: Text(AppLocalizations.of(context)!.saved, style: TextStyle(color: widget.model.webBackgroundColor))
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.of(context).pop();

                  }
                  )
              );
            },
            buildWhen: (p,c) => p.showErrorMessages != c.showErrorMessages || p.isEditingProfile != c.isEditingProfile || p.isSubmitting != c.isSubmitting || p.photoIdImagePath != c.photoIdImagePath || p.photoSelfieImagePath != c.photoSelfieImagePath || p.profile.profileUser != c.profile.profileUser,
            builder: (context, state) {

              return Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  titleTextStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
                  elevation: 0,
                  title: Text('Edit Profile'),
                  iconTheme: IconThemeData(
                      color: widget.model.paletteColor
                  ),
                  actions: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: TextButton(
                          onPressed: () async {

                            if (!state.isSubmitting) {
                              context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.didSelectIsSubmitting(true));

                              if (_contactPhoneController!.value != null && _contactPhoneController!.value!.nsn.isEmpty) {
                                context.read<UpdateUserProfileAccountBloc>()..add(UpdateUserProfileAccountEvent.phoneNumberChanged(widget.profile.contactPhones));
                              }
                              if (_emergePhoneController!.value != null && _emergePhoneController!.value!.nsn.isEmpty) {
                                context.read<UpdateUserProfileAccountBloc>()..add(UpdateUserProfileAccountEvent.emergencyPhoneChanged(widget.profile.emergencyContact));
                              }

                              if (state.photoSelfieImagePath != null && state.photoIdImagePath != null) {
                                final UniqueId urlId = UniqueId();
                                final UniqueId selfieId = UniqueId();
                                final File _imageId = File(state.photoIdImagePath!);
                                final File _imageSelfie = File(state.photoSelfieImagePath!);
                                final reference = FirebaseStorage.instance.ref('user/${widget.profile.userId.getOrCrash()}/verification_id');

                                try {

                                  if (widget.profile.identificationState == PhotoIdentificationState.noRequest || widget.profile.identificationState == PhotoIdentificationState.denied) {
                                    if (widget.profile.photoIdUri != null && widget.profile.photoSelfieUri != null) {
                                      try {
                                      await FirebaseStorage.instance.refFromURL(widget.profile.photoIdUri!).delete();
                                      await FirebaseStorage.instance.refFromURL(widget.profile.photoSelfieUri!).delete();
                                      } catch (e) {
                                        context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.didSelectIsSubmitting(false));
                                        final snackBar = SnackBar(
                                          backgroundColor: widget.model.webBackgroundColor,
                                          content: Text(e.toString(), style: TextStyle(color: widget.model.disabledTextColor)),);
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                    }

                                    await reference.child(urlId.getOrCrash()).putFile(_imageId);
                                    await reference.child(selfieId.getOrCrash()).putFile(_imageSelfie);

                                    final uriFromId = await reference.child(urlId.getOrCrash()).getDownloadURL();
                                    final uriFromSelfie = await reference.child(selfieId.getOrCrash()).getDownloadURL();

                                    setState(() {
                                      context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.imageIdUrlChanged(uriFromId));
                                      context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.imageSelfieUrlChanged(uriFromSelfie));
                                      context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.finishedUpdatingUserProfile());
                                    });
                                  }

                                } catch (e) {
                                  context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.didSelectIsSubmitting(false));
                                  final snackBar = SnackBar(
                                    backgroundColor: widget.model.webBackgroundColor,
                                    content: Text(e.toString(), style: TextStyle(color: widget.model.disabledTextColor)),);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              } else {
                                setState(() {
                                  context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.finishedUpdatingUserProfile());
                                });
                              }
                            }
                          },
                          child: (state.isSubmitting) ? JumpingDots(numberOfDots: 3, color: widget.model.paletteColor) : Text('Save', style: TextStyle(color: (state.isEditingProfile) ? widget.model.paletteColor : widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize, decoration: TextDecoration.underline))
                      ),
                    )
                  ],
                ),
                body: SingleChildScrollView(
                    child: Form(
                    autovalidateMode: context.read<UpdateUserProfileAccountBloc>().state.showErrorMessages,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 35),
                            Text('First Name',
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
                                    style: TextStyle(color: widget.model.paletteColor),
                                    initialValue:
                                    widget.profile
                                        .legalName
                                        .value
                                        .fold((l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidLegalName: (i) => i.failedValue, orElse: () => '' ), orElse: () => ''), (r) => r),
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!.signUpDashboardNameHint,
                                      errorStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: widget.model.paletteColor,
                                      ),
                                      prefixIcon: Icon(Icons.person, color: widget.model.disabledTextColor),
                                      filled: true,
                                      fillColor: widget.model.accentColor,
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color: widget.model.paletteColor,
                                        ),
                                      ),
                                      focusedBorder:  OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color: widget.model.disabledTextColor,
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
                                          color: widget.model.webBackgroundColor,
                                          width: 0,
                                        ),
                                      ),
                                    ),
                                    autocorrect: false,
                                    onChanged: (value) => context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.firstLastLegalNameChanged(value)),
                                    validator: (_) => context
                                        .read<UpdateUserProfileAccountBloc>()
                                        .state
                                        .profile
                                        .profileUser
                                        .legalName
                                        .value
                                        .fold(
                                            (f) => f.maybeMap(
                                          userProfile: (u) => u.f?.maybeMap(
                                              empty: (_) => AppLocalizations.of(context)!.signUpDashboardError,
                                              invalidLegalName: (_) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2,
                                              orElse: () => null),
                                          orElse: () => null,
                                    ),
                                  (_) => null
                                )
                              )
                            ),

                            const SizedBox(height: 20),
                            Text('Last Name',
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
                                    style: TextStyle(color: widget.model.paletteColor),
                                    initialValue:
                                    widget.profile
                                        .legalSurname
                                        .value
                                        .fold((l) => l.maybeMap(userProfile: (e) => e.f?.maybeMap(invalidLegalName: (i) => i.failedValue, orElse: () => '' ), orElse: () => ''), (r) => r),
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!.signUpDashboardNameHint,
                                      errorStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: widget.model.paletteColor,
                                      ),
                                      prefixIcon: Icon(Icons.person, color: widget.model.disabledTextColor),
                                      filled: true,
                                      fillColor: widget.model.accentColor,
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color: widget.model.paletteColor,
                                        ),
                                      ),
                                      focusedBorder:  OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color: widget.model.disabledTextColor,
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
                                          color: widget.model.webBackgroundColor,
                                          width: 0,
                                        ),
                                      ),
                                    ),
                                    autocorrect: false,
                                    onChanged: (value) => context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.lastNameLegalChanged(value)),
                                    validator: (_) => context
                                        .read<UpdateUserProfileAccountBloc>()
                                        .state
                                        .profile
                                        .profileUser
                                        .legalSurname
                                        .value
                                        .fold(
                                            (f) => f.maybeMap(
                                          userProfile: (u) => u.f?.maybeMap(
                                              empty: (_) => AppLocalizations.of(context)!.signUpDashboardError,
                                              invalidLegalName: (_) => AppLocalizations.of(context)!.signUpDashboardPasswordConfirmError2,
                                              orElse: () => null),
                                          orElse: () => null,
                                        ),
                                            (_) => null
                                )
                              )
                            ),
                            const SizedBox(height: 20),
                            Divider(color: widget.model.disabledTextColor),
                            const SizedBox(height: 20),

                            Text(AppLocalizations.of(context)!.profileUserEmail,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: widget.model.disabledTextColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 55,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: widget.model.accentColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(35))
                              ),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(maskEmail(widget.profile.emailAddress.getOrCrash()),
                                        style: TextStyle(color: widget.model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: 16),
                                        textAlign: TextAlign.start
                                  ),
                                )
                              ),
                            ),
                            const SizedBox(height: 15),
                            if (widget.profile.isEmailAuth) Row(
                              children: [
                                Icon(Icons.check_circle, color: widget.model.disabledTextColor),
                                const SizedBox(width: 10),
                                Text('Your Current Email is Verified', style: TextStyle(color: widget.model.disabledTextColor)),
                              ],
                            ),
                            if (!widget.profile.isEmailAuth) Column(
                              children: [
                                Text('Select Verify Email and we will send you an Email Confirmation', style: TextStyle(color: widget.model.disabledTextColor)),
                                InkWell(
                                  onTap: () {

                                  },
                                  child: Container(
                                      height: 55,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: widget.model.paletteColor,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    child: Center(child: Text('Verify Email', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold))),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            Divider(color: widget.model.disabledTextColor),
                            const SizedBox(height: 20),

                            Text(AppLocalizations.of(context)!.profileAccountPhone,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: widget.model.disabledTextColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),
                            if (widget.profile.contactPhones != null) Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 55,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color: widget.model.accentColor,
                                            borderRadius: const BorderRadius.all(Radius.circular(35))
                                        ),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 10.0),
                                              child: Text(maskPhone(widget.profile.contactPhones!.nsn),
                                                  style: TextStyle(color: widget.model.disabledTextColor, fontWeight: FontWeight.bold, fontSize: 16),
                                                  textAlign: TextAlign.start
                                            ),
                                          )
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          isEditingPhone = !isEditingPhone;
                                        });
                                      },
                                      child: Container(
                                        height: 55,
                                        decoration: BoxDecoration(
                                          color: (isEditingPhone) ? widget.model.accentColor : widget.model.paletteColor,
                                          borderRadius: BorderRadius.circular(25)
                                        ),
                                        child: Center(child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                          child: Text('Edit', style: TextStyle(color: (isEditingPhone) ? widget.model.paletteColor : widget.model.accentColor),),
                                        )),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                if (!isEditingPhone && !widget.profile.isPhoneAuth) InkWell(
                                  onTap: () {

                                  },
                                  child: Container(
                                    height: 55,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: (widget.profile.contactPhones?.isValid() ?? false) ? widget.model.paletteColor : widget.model.accentColor,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Center(child: Text('Verify Phone Number', style: TextStyle(color: (widget.profile.contactPhones?.isValid() ?? false) ? widget.model.accentColor : widget.model.paletteColor, fontWeight: FontWeight.bold))),
                                  ),
                                ),
                                  const SizedBox(height: 10),
                                Text('Your Contact Number: this number will only be shared with Reservation Holders for when they need to get in touch.', style: TextStyle(color: widget.model.disabledTextColor)),
                                const SizedBox(height: 10),
                                if (isEditingPhone) AnimatedContainer(
                                    duration: const Duration(milliseconds: 2800),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: (isEditingPhone) ? 15 : 0),
                                      child: editAndVerifyPhoneNumber(context)
                                  )
                                )
                              ],
                            ),
                            if (widget.profile.contactPhones == null) editAndVerifyPhoneNumber(context),
                            const SizedBox(height: 20),
                            Divider(color: widget.model.disabledTextColor),
                            const SizedBox(height: 20),
                            Text('Government ID',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: widget.model.disabledTextColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),
                            getVerificationIDWidget(context, state.profile.profileUser.identificationState ?? PhotoIdentificationState.noRequest, state),

                            const SizedBox(height: 20),
                            Divider(color: widget.model.disabledTextColor),
                            const SizedBox(height: 20),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text("${AppLocalizations.of(context)!.profileAccountContact}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: widget.model.disabledTextColor,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            const SizedBox(height: 10),
                            PhoneFieldView(
                              // inputKey: _phoneKey,
                                hintText: AppLocalizations.of(context)!.profileAccountPhone,
                                controller: _emergePhoneController!,
                                selectorNavigator: const CountrySelectorNavigator.draggableBottomSheet(
                                  flagSize: 28
                                ),
                                model: widget.model,
                                validateMode: context.read<UpdateUserProfileAccountBloc>().state.showErrorMessages,
                                onChangedPhoneNumber: (p) {
                                  context.read<UpdateUserProfileAccountBloc>()..add(UpdateUserProfileAccountEvent.emergencyPhoneChanged(p));
                                }
                            ),
                            const SizedBox(height: 35),
                    ],
                  ),
                ),
              )
            )
          );
        }
      )
    );
  }



  Widget editAndVerifyPhoneNumber(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        PhoneFieldView(
            hintText: AppLocalizations.of(context)!.profileAccountPhone,
            controller: _contactPhoneController!,
            selectorNavigator: const CountrySelectorNavigator.draggableBottomSheet(
              flagSize: 28
            ),
            model: widget.model,
            validateMode: context.read<UpdateUserProfileAccountBloc>().state.showErrorMessages,
            onChangedPhoneNumber: (p) {
            setState(() {
              context.read<UpdateUserProfileAccountBloc>()..add(UpdateUserProfileAccountEvent.phoneNumberChanged(p));
            });
          }
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: () {

          },
          child: Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: (_contactPhoneController?.value?.isValid() ?? false) ? widget.model.paletteColor : widget.model.accentColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(child: Text('Verify Phone Number', style: TextStyle(color: (_contactPhoneController?.value?.isValid() ?? false) ? widget.model.accentColor : widget.model.paletteColor, fontWeight: FontWeight.bold))),
          ),
        ),
        const SizedBox(height: 15),
        if (widget.profile.isPhoneAuth) Text('Your Current Phone Number is Verified', style: TextStyle(color: widget.model.disabledTextColor))
      ],
    );
  }


  Widget getVerificationIDWidget(BuildContext context, PhotoIdentificationState state, UpdateUserProfileAccountState blocState) {
    switch (state) {

      case PhotoIdentificationState.denied:
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isEditingDeniedId) Text('You\'re request was denied - please try to upload again.'),
            if (!isEditingDeniedId) const SizedBox(height: 10),
            if (!isEditingDeniedId) InkWell(
              onTap: () {
                setState(() {
                  isEditingDeniedId = !isEditingDeniedId;
                });
              },
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: widget.model.paletteColor, width: 0.5),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Center(child: Text('Try Again', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold))),
              ),
            ),
            if (isEditingDeniedId) createNewVerificationId(context, blocState)
          ],
        );
      case PhotoIdentificationState.accepted:
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle_outline, color: widget.model.paletteColor),
                const SizedBox(width: 15),
                Text('Provided', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: () {

                presentRemovePhotoIdentification(
                    context,
                    widget.model,
                    blocState.isSubmitting,
                    didSelectRemove: () {
                      setState(() {
                        context.read<UpdateUserProfileAccountBloc>().add(const UpdateUserProfileAccountEvent.finishedIdentificationRemoval());
                      });
                  }
                );
              },
              child: Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border.all(color: widget.model.paletteColor, width: 0.5),
                    color: widget.model.paletteColor,
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Center(child: Text('Remove', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold))),
              ),
            ),
          ],
        );
      case PhotoIdentificationState.underReview:
        return Container(
          height: 55,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(color: widget.model.paletteColor, width: 0.5),
              color: widget.model.accentColor,
              borderRadius: BorderRadius.circular(25)
          ),
          child: Center(child: Text('Under Review...', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold))),
        );
      case PhotoIdentificationState.noRequest:
        return createNewVerificationId(context, blocState);
    }
  }



  Widget createNewVerificationId(BuildContext context, UpdateUserProfileAccountState blocState) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  presentAddPhotoIdentification(
                      context,
                      widget.model,
                      imageSource: (source) async {

                        final image = await _imagePicker.pickImage(source: source);

                        if (image != null) {
                          _selectedFilePhotoId = Image.file(File(image.path), fit: BoxFit.cover, height: 55, width: 55);
                          setState(() {
                            context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.imageIdFilePathChanged(image.path));
                          });
                        }

                    }
                  );
                },
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: widget.model.paletteColor,
                      borderRadius: BorderRadius.circular(25)
                  ),
                  child: Center(child: Text((_selectedFilePhotoId != null) ? 'Change Photo ID' : 'Add Photo ID', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold))),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Row(
              children: [
                if (_selectedFilePhotoId != null) ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 55,
                      width: 55,
                      child: Image(image: _selectedFilePhotoId!.image, fit: BoxFit.cover),
                  )
                ),
                if (_selectedFilePhotoId == null) Icon(Icons.cancel_outlined, color: widget.model.disabledTextColor),
              ],
            ),
            const SizedBox(width: 15),
          ],
        ),

        const SizedBox(height: 15),

        if (_selectedFilePhotoId != null) Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  presentAddSelfieIdentification(
                      context,
                      widget.model,
                      imageSource: (source) async {

                        final image = await _imagePicker.pickImage(source: source);

                        if (image != null) {
                          _selectedFileSelfie = Image.file(File(image.path), fit: BoxFit.cover, height: 55, width: 55);
                          setState(() {
                            context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.imageSelfieFilePatheChanged(image.path));
                          });
                        }

                      }
                  );
                },
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: widget.model.paletteColor, width: 0.5),
                      color: (_selectedFileSelfie != null) ? widget.model.paletteColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(25)
                  ),
                  child: Center(child: Text((_selectedFileSelfie != null) ? 'Change Selfie' : 'Add a Selfie', style: TextStyle(color: (_selectedFileSelfie != null) ? widget.model.accentColor : widget.model.paletteColor, fontWeight: FontWeight.bold))),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Row(
              children: [
                if (_selectedFileSelfie != null) ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: 55,
                    width: 55,
                    child: Image(image: _selectedFileSelfie!.image, fit: BoxFit.cover,),
                  ),
                ),
                if (_selectedFileSelfie == null) Icon(Icons.cancel_outlined, color: widget.model.disabledTextColor),
              ],
            ),
            const SizedBox(width: 15),
          ],
        )
      ],
    );
  }


}
