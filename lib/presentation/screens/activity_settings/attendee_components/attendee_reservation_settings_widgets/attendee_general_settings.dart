import 'dart:typed_data';

import 'package:check_in_application/auth/update_services/listing_update_create_services/attendee_update_create_services/listing_attendee_form_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:check_in_presentation/core/image_picker_core.dart' if (dart.library.html) 'package:check_in_presentation/core/image_picker_core_for_web.dart';

/// show info of attendee contact
/// show when reservation was made
/// show which reservation slots were chosen
/// show ticket or pass purchased (go to tickets)
/// show option to leave.
class AttendeeGeneralSettingsWidget extends StatefulWidget {

  final AttendeeItem attendeeItem;
  final ActivityManagerForm activityForm;
  final DashboardModel model;
  final UserProfileModel userProfileModel;
  final ReservationItem reservationItem;

  const AttendeeGeneralSettingsWidget({super.key,
    required this.attendeeItem,
    required this.userProfileModel,
    required this.reservationItem,
    required this.model, required this.activityForm
  });

  @override
  State<AttendeeGeneralSettingsWidget> createState() => _AttendeeGeneralSettingsWidgetState();
}

class _AttendeeGeneralSettingsWidgetState extends State<AttendeeGeneralSettingsWidget> {

  late ClassesInstructorProfile classInstructorBackground = widget.attendeeItem.classesInstructorProfile ?? ClassesInstructorProfile.empty();
  late EventMerchantVendorProfile? eventMerchantVendor = widget.attendeeItem.eventMerchantVendorProfile;
  late Uint8List? selectedImage = null;

  @override
  void initState() {
    classInstructorBackground = widget.attendeeItem.classesInstructorProfile ?? ClassesInstructorProfile.empty();
    eventMerchantVendor = widget.attendeeItem.eventMerchantVendorProfile;
    super.initState();
  }

  @override
  void dispose() {
    eventMerchantVendor = null;
    super.dispose();
  }

  Widget attendeeTypeSettingsMainContainer(BuildContext context, AttendeeType type) {
    switch (type) {
      case AttendeeType.free:
        /// TODO: Handle this case.
        break;
      case AttendeeType.tickets:
        /// review tickets...ask for refund if possible?

        break;
      case AttendeeType.pass:
        /// review pass...ask for refund if possible?

        break;
      case AttendeeType.instructor:
        /// review instructor form...ask for refund - change instructor info?
        return instructorEditorContainer(
            context: context,
            model: widget.model,
            classInstructorBackground: classInstructorBackground,
            didChangeNumberOfYears: (number) {
              setState(() {
                classInstructorBackground = classInstructorBackground.copyWith(
                    numberOfYearsInExperience: number
                );
                context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateClassesInstructorForm(classInstructorBackground));
              });
            },
            didSelectExperience: (experience, i) {
              setState(() {
                handleSelectedExperience(
                    context,
                    widget.model,
                    i,
                    experience,
                    didSelectSaveExperience: (e, i) {
                      setState(() {
                        late List<ExperienceOption> newExperience = [];
                        newExperience.addAll(classInstructorBackground.experience);

                        newExperience.replaceRange(i, i+1, [e]);
                        classInstructorBackground = classInstructorBackground.copyWith(
                            experience: newExperience
                        );
                        context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateClassesInstructorForm(classInstructorBackground));
                      });
                    }
                );
              });
            },
            didSelectRemoveExperience: (i) {
              setState(() {
                late List<ExperienceOption> newExperience = [];
                newExperience.addAll(classInstructorBackground.experience);

                newExperience.removeAt(i);
                classInstructorBackground = classInstructorBackground.copyWith(
                    experience: newExperience
                );

                classInstructorBackground.experience.toList().addAll(newExperience);
                context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateClassesInstructorForm(classInstructorBackground));
              });
            },
            didSelectCreateExperience: () {
              setState(() {
                handleCreateNewExperience(
                    context,
                    widget.model,
                    didSelectSaveExperience: (experience) {
                      setState(() {
                        late List<ExperienceOption> newExperience = [];
                        newExperience.addAll(classInstructorBackground.experience);

                        newExperience.add(experience);
                        classInstructorBackground = classInstructorBackground.copyWith(
                            experience: newExperience
                        );
                        context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateClassesInstructorForm(classInstructorBackground));
                      });
                    }
                );
              });
            },
            didSelectCertificate: (certificate) {

            },
            didSelectRemoveCertificate: (i) {
              setState(() {
                late List<CertificateOption> newCertificate = [];
                newCertificate.addAll(classInstructorBackground.certificates);

                newCertificate.removeAt(i);
                classInstructorBackground = classInstructorBackground.copyWith(
                    certificates: newCertificate
                );

                classInstructorBackground.certificates.toList().addAll(newCertificate);
                context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateClassesInstructorForm(classInstructorBackground));
              });
            },
            didCreateNewCertificate: () {
              setState(() {
                handleNewCertificate(
                    context,
                    widget.model,
                    didSelectSaveCertificate: (certificate) {
                      setState(() {
                        late List<CertificateOption> newCertificate = [];
                        newCertificate.addAll(classInstructorBackground.certificates);

                        newCertificate.add(certificate);
                        classInstructorBackground = classInstructorBackground.copyWith(
                            certificates: newCertificate
                        );
                        context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateClassesInstructorForm(classInstructorBackground));
                      });
                    }
                );
              });
            }
          );
      case AttendeeType.vendor:
        return vendorMerchantEditorContainer(
            context: context,
            selectedImage: selectedImage,
            eventMerchantVendor: widget.attendeeItem.eventMerchantVendorProfile,
            activityForm: widget.activityForm,
            model: widget.model,
            state: context.read<AttendeeFormBloc>().state,
            handleImageSelection: () {
              _handleImageSelection(context);
            },
            didChangeVendorName: (value) {
              setState(() {
                eventMerchantVendor = eventMerchantVendor?.copyWith(
                    brandName: FirstLastName(value)
                );
                context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateMerchantVendorForm(eventMerchantVendor!));
              });
            },
            didChangeVendorInfo: (value) {
              setState(() {
                eventMerchantVendor = eventMerchantVendor?.copyWith(
                    backgroundInfo: BackgroundInfoDescription(value)
                );
                context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateMerchantVendorForm(eventMerchantVendor!));
            });
          }
        );
      case AttendeeType.partner:
        // TODO: Handle this case.

        break;
      case AttendeeType.organization:
        // TODO: Handle this case.
        break;
      case AttendeeType.interested:
        // TODO: Handle this case.
        break;
    }
    return Container();
  }


  void _handleImageSelection(BuildContext context) async {
    final imageData = await handleImageSelection(context, widget.model);
    try {
      setState(() {
        selectedImage = imageData;
        eventMerchantVendor = eventMerchantVendor?.copyWith(
            vendorLogo: imageData
        );
      });
      context.read<AttendeeFormBloc>().add(AttendeeFormEvent.updateMerchantVendorForm(eventMerchantVendor!));
    } catch (e) {
      final snackBar = SnackBar(
          elevation: 4,
          backgroundColor: widget.model.paletteColor,
          content: Text('Sorry, please try again.', style: TextStyle(color: widget.model.webBackgroundColor))
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 35),
          Text('Your Attendance', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
          const SizedBox(height: 8),

          Container(
              constraints: BoxConstraints(
                  maxWidth: 580,
              ),
              child: attendeeTypeSettingsMainContainer(context, widget.attendeeItem.attendeeType)),

          const SizedBox(height: 35),
          /// when you joined
          Text('Joined: ${DateFormat.MMMEd().format(widget.attendeeItem.dateCreated)}', style: TextStyle(color: widget.model.disabledTextColor)),
          /// an option to leave
          const SizedBox(height: 35),
          InkWell(
            onTap: () {
                context.read<AttendeeFormBloc>().add(const AttendeeFormEvent.didDeleteAttendee());
            },
            child: Container(
              width: 625,
              height: 60,
              decoration: BoxDecoration(
                color: widget.model.webBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Align(
                child: Text('Leave Activity', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget getProfileForPartnerAttendee() {
  return Container(

  );
}


// Widget getProfileFor