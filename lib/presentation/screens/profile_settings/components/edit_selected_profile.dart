import 'dart:io';

import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/edit_socials_profile.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/profile_settings/components/profile_helper.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:jumping_dot/jumping_dot.dart';

class EditCurrentProfile extends StatefulWidget {

  final UserProfileModel profile;
  final Function(UserProfileModel) didFinishSaving;
  final DashboardModel model;
  
  const EditCurrentProfile({super.key, required this.profile, required this.model, required this.didFinishSaving});

  @override
  State<EditCurrentProfile> createState() => _EditCurrentProfileState();
}

class _EditCurrentProfileState extends State<EditCurrentProfile> {


  final ImagePicker _imagePicker = ImagePicker();
  Image? _currentNetworkSpaceImage;
  Image? _selectedFileSpaceImage;
  // Uint8List? _currentImage;


  @override
  void initState() {
   
    if (widget.profile.profileImage != null) {
      _currentNetworkSpaceImage  = Image(image: widget.profile.profileImage!.image, fit: BoxFit.cover, width: 500, height: 500);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: BlocProvider(create: (context) => getIt<UpdateUserProfileAccountBloc>()..add(UpdateUserProfileAccountEvent.initializedUserProfile(bloc.optionOf(widget.profile))),
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
                      widget.didFinishSaving(state.profile.profileUser);

                }
              )
            );
          },
          buildWhen: (p,c) => p.showErrorMessages != c.showErrorMessages || p.isEditingProfile != c.isEditingProfile || p.isSubmitting != c.isSubmitting ||  p.profile.profileUser != c.profile.profileUser,
          builder: (context, state) {

            return SingleChildScrollView(
              child: Form(
                autovalidateMode: context.read<UpdateUserProfileAccountBloc>().state.showErrorMessages,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 35),
                      Center(
                        child: ClipRRect(
                           borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width/2),
                             child: InkWell(
                               onTap: () async {
                                 presentSelectPictureOptions(
                                     context,
                                     widget.model,
                                     imageSource: (source) async {
                                       try {
                                         final image = await _imagePicker.pickImage(source: source);

                                         if (image != null) {
                                         _selectedFileSpaceImage = Image.file(File(image.path), height: MediaQuery.of(context).size.width/2, width: MediaQuery.of(context).size.height/2, fit: BoxFit.cover);
                                         context.read<UpdateUserProfileAccountBloc>()..add(UpdateUserProfileAccountEvent.imageFilePathChanged(image.path));
                                         }
                                         setState(() {

                                         });
                                       } catch (e) {
                                         final snackBar = SnackBar(
                                             backgroundColor: widget.model.webBackgroundColor,
                                             content: Text(e.toString() ?? 'Sorry, Could not get image', style: TextStyle(color: widget.model.paletteColor))
                                         );
                                         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                     }
                                 });

                               },
                               child: Container(
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  height: MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.5 / 2),
                                    color: widget.model.accentColor
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      (_currentNetworkSpaceImage != null) ? (_selectedFileSpaceImage == null) ?
                                      _currentNetworkSpaceImage! : _selectedFileSpaceImage! :
                                      (_selectedFileSpaceImage != null) ? _selectedFileSpaceImage! :
                                      Center(child: Icon(Icons.camera_alt_outlined, color: widget.model.disabledTextColor)),

                                      Icon(Icons.photo_camera_rounded, size: 35, color: widget.model.disabledTextColor)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Text('Edit Profile Photo', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 25),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(AppLocalizations.of(context)!.profileAccountGender,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: widget.model.disabledTextColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  // offset: const Offset(-10,-15),
                                  isDense: true,
                                  // buttonElevation: 0,
                                  // buttonDecoration: BoxDecoration(
                                  //   color: Colors.transparent,
                                  //   borderRadius: BorderRadius.circular(35),
                                  // ),
                                  hint: Text('not selected' , style: TextStyle(color: widget.model.disabledTextColor)),
                                  customButton: Container(
                                    decoration: BoxDecoration(
                                      color: widget.model.accentColor,
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Row(
                                            children: [
                                              const SizedBox(width: 8.0),
                                              Icon(Icons.person_sharp, color: widget.model.disabledTextColor,),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: Text((context.read<UpdateUserProfileAccountBloc>().state.profile.profileUser.gender != '') ? context.read<UpdateUserProfileAccountBloc>().state.profile.profileUser.gender ?? 'Not Selected' : AppLocalizations.of(context)!.notProvided, style: TextStyle(color: context.read<UpdateUserProfileAccountBloc>().state.profile.profileUser.gender == null ? widget.model.paletteColor.withOpacity(0.65) : widget.model.paletteColor, fontSize: context.read<UpdateUserProfileAccountBloc>().state.profile.profileUser.gender == '' ? 13.5 : null),),
                                              ),
                                            ],
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Icon(Icons.keyboard_arrow_down_rounded, size: 45, color: widget.model.disabledTextColor),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  onChanged: (Object? navItem) {
                                  },
                                  // buttonWidth: 80,
                                  // buttonHeight: 70,
                                  // dropdownElevation: 1,
                                  // dropdownPadding: const EdgeInsets.all(1),
                                  // dropdownDecoration: BoxDecoration(
                                  //     boxShadow: [BoxShadow(
                                  //         color: Colors.black.withOpacity(0.11),
                                  //         spreadRadius: 1,
                                  //         blurRadius: 15,
                                  //         offset: Offset(0, 2)
                                  //       )
                                  //     ],
                                  //     color: widget.model.cardColor,
                                  //     borderRadius: BorderRadius.circular(14)),
                                  // itemHeight: 50,
                                  // dropdownWidth: MediaQuery.of(context).size.width,
                                  // focusColor: Colors.grey.shade100,
                                  items: [...predefinedGenderOptions().map(
                                          (e) => DropdownMenuItem<String>(
                                          onTap: () {
                                            context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.genderChanged(e));
                                          },
                                          value: e,
                                          child: Text(getGenderTitle(context, e), style: TextStyle(color: widget.model.disabledTextColor)
                                      )
                                    )
                                  ).toList()
                                ],
                              )
                            ),
                            const SizedBox(height: 20),

                            Text("${AppLocalizations.of(context)!.profileAccountAddress}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: widget.model.disabledTextColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),
                            Center(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: TextFormField(
                                    style: TextStyle(color: widget.model.paletteColor),
                                    initialValue: widget.profile.userAddress?.value.fold((l) => l.maybeMap(location: (e) => e.f?.maybeMap(invalidAddress: (i) => i.failedValue, orElse: () => '' ), orElse: () => ''), (r) => r),
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: widget.model.paletteColor.withOpacity(0.65)),
                                      hintText: AppLocalizations.of(context)!.notProvided,
                                      errorStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: widget.model.paletteColor,
                                      ),
                                      prefixIcon: Icon(Icons.location_on, color: widget.model.disabledTextColor),
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
                                    onChanged: (value) => context
                                        .read<UpdateUserProfileAccountBloc>()
                                        .add(UpdateUserProfileAccountEvent.addressChanged(value)),
                                    validator: (_) => context
                                        .read<UpdateUserProfileAccountBloc>()
                                        .state
                                        .profile
                                        .profileUser
                                        .userAddress
                                        ?.value.fold((l) => l.maybeMap(location:  (f) => f.f?.maybeMap(
                                        isEmpty: (_) => null,
                                        invalidAddress: (e) => AppLocalizations.of(context)!.facilityLocationStreetError,
                                        orElse: () => null),
                                        orElse: () => null),
                                            (r) => null),
                                ),
                              )
                            ),

                            const SizedBox(height: 20),
                            Divider(color: widget.model.disabledTextColor),
                            const SizedBox(height: 20),

                            Text("${AppLocalizations.of(context)!.profileUserSocials}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: widget.model.disabledTextColor,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) {
                                    return EditSocialsProfile(
                                      model: widget.model,
                                      profile: widget.profile,
                                    );
                                  })
                                );
                              },
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: widget.model.accentColor,
                                ),
                                child: Center(child: Text('Update Socials', style: TextStyle(color: widget.model.paletteColor))),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Divider(color: widget.model.disabledTextColor),
                            const SizedBox(height: 20),
                            if (!state.isSubmitting) InkWell(
                              onTap: () async {


                                  if (state.profileImagePath != null) {
                                      context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.didSelectIsSubmitting(true));

                                      final UniqueId urlId = UniqueId();
                                      final File _image = File(state.profileImagePath!);
                                      final reference =  FirebaseStorage.instance.ref('user/${widget.profile.userId.getOrCrash()}/profile_image/');

                                      try {
                                        if (widget.profile.photoUri != null) {
                                        await FirebaseStorage.instance.refFromURL(widget.profile.photoUri!).delete();
                                        }
                                        await reference.child(urlId.getOrCrash()).putFile(_image);
                                        final uri = await reference.child(urlId.getOrCrash()).getDownloadURL();

                                        setState(() {
                                        context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.imageUrlChanged(uri));
                                        context.read<UpdateUserProfileAccountBloc>().add(UpdateUserProfileAccountEvent.finishedUpdatingUserProfile());
                                        });

                                      } catch(e) {
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

                            if (state.isSubmitting) JumpingDots(numberOfDots: 3, color: widget.model.paletteColor, radius: 8),
                            const SizedBox(height: 20),
                          ],
                        ),

                    ],
                  ),
                ),
              ),
            );
          },
        )
      )
    );
  }
}