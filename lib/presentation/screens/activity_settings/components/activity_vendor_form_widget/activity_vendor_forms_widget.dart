import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'activity_vendor_form_helper.dart';

class VendorFormsWidget extends StatefulWidget {

  final DashboardModel model;
  final ActivityManagerForm activityForm;
  final UserProfileModel resOwner;
  final ReservationItem reservation;
  final ListingManagerForm? listing;

  const VendorFormsWidget({super.key, required this.model, required this.reservation, required this.activityForm, required this.resOwner, this.listing});

  @override
  State<VendorFormsWidget> createState() => _VendorFormsWidgetState();
}

class _VendorFormsWidgetState extends State<VendorFormsWidget> {

  ScrollController? _scrollController;
  bool isEditingNewForm = false;

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

  void didPublishForm() {

  }

  void didSaveForm() {

  }

  void editCreateForm(BuildContext context, VendorMerchantForm? form) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Send Invite',
      transitionDuration: Duration(milliseconds: 350),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return  Align(
            alignment: Alignment.center,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.model.accentColor,
                      borderRadius: BorderRadius.all(Radius.circular(17.5))
                  ),
                  width: 1200,
                  height: 1050,
                  child: VendorFormEditorWidget(
                    model: widget.model,
                    form: form,
                    reservation: widget.reservation,
                    activityForm: widget.activityForm,
                    resOwner: widget.resOwner,
                    isSaving: (vendorForm) {

                      Navigator.of(contexts).pop();
                      List<VendorMerchantForm> vForms = [];
                      vForms.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.vendorMerchantForms ?? []);

                      if (vForms.map((e) => e.formId).contains(vendorForm.formId)) {
                        final int index = vForms.indexWhere((element) => element.formId == vendorForm.formId);
                        vForms.replaceRange(index, index + 1, [vendorForm]);
                      } else {
                        vForms.add(vendorForm);
                      }

                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.vendorFormsChanged(vForms));
                    },
                    isPublishing:  (vendorForm) {
                      final snackBar = SnackBar(
                          elevation: 4,
                          backgroundColor: widget.model.paletteColor,
                          content: Text('Published', style: TextStyle(color: widget.model.webBackgroundColor))
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      List<VendorMerchantForm> vForms = [];
                      vForms.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.vendorMerchantForms ?? []);

                      if (vForms.map((e) => e.formId).contains(vendorForm.formId)) {
                        /// replace
                        final int index = vForms.indexWhere((element) => element.formId == vendorForm.formId);
                        vForms.replaceRange(index, index + 1, [vendorForm]);
                      } else {
                        /// add
                        vForms.add(vendorForm);
                      }

                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.vendorFormsChanged(vForms));
                      context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.isSavingChanged(true));
                      context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.createActivityFinished());

                    },
                  ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditingNewForm) Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                setState(() {
                  isEditingNewForm = false;
                });
              },
              icon: Icon(Icons.arrow_back_ios_rounded, color: widget.model.paletteColor,
            ),
          )
        ),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              width: 675,
              child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          Container(
                            width: 675,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Vendor or Merchant are supported?', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor,)),
                                    Text('Attendees can join as a Vendor or Merchant based on a form created by you.', style: TextStyle(color: widget.model.disabledTextColor))
                                  ],
                                )
                                ),
                                FlutterSwitch(
                                  width: 60,
                                  inactiveColor: widget.model.accentColor,
                                  activeColor: widget.model.paletteColor,
                                  value: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantSupported ?? false,
                                  onToggle: (value) {
                                    setState(() {
                                      if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantSupported == true) {
                                        context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isMerchantSupportedChanged(false));
                                      } else {
                                        context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isMerchantSupportedChanged(true));
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantSupported == true,
                            child: createNewVendorPreviews(
                                context: context,
                                model: widget.model,
                                hasForms: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.vendorMerchantForms?.isNotEmpty == true,
                                createNewForm: () {
                                  editCreateForm(context, null);
                              }
                            ),
                          ),
                          const SizedBox(height: 25),

                          ...context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.vendorMerchantForms?.toList().asMap().map((i, form) {

                            return MapEntry(i, getVendorFormListTile(
                                context,
                                widget.model,
                                i,
                                form,
                                didSelectEditCreateForm: (selected) {
                                  editCreateForm(context, selected);
                                }
                              )
                            );
                          }).values.toList() ?? []


                  //         Wrap(
                  //             runSpacing: 6,
                  //             spacing: 8,
                  //             alignment: WrapAlignment.start,
                  //             children: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.vendorMerchantForms?.toList().asMap().map(
                  //                   (i, e) => MapEntry(i, SlideInTransitionWidget(
                  //                 durationTime: 300 * i,
                  //                 offset: Offset(0, 0.25),
                  //                 transitionWidget: Container(
                  //                   width: 375,
                  //                   height: 520,
                  //                   decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.circular(18),
                  //                       color: widget.model.disabledTextColor.withOpacity(0.185)
                  //                   ),
                  //                   child: Stack(
                  //                     children: [
                  //                       Container(
                  //                         child: Padding(
                  //                           padding: const EdgeInsets.all(8.0),
                  //                           child: Column(
                  //                             mainAxisSize: MainAxisSize.min,
                  //                             children: [
                  //                                   const SizedBox(height: 80),
                  //                                   Text('Status', style: TextStyle(color: widget.model.disabledTextColor)),
                  //                                   Container(
                  //                                     height: 50,
                  //                                     decoration: BoxDecoration(
                  //                                       color: widget.model.accentColor,
                  //                                       borderRadius: BorderRadius.circular(35),
                  //                                     ),
                  //                                     child: Padding(
                  //                                       padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  //                                       child: Center(child: Text(e.formStatus.name, style: TextStyle(color: getStatusColor(e.formStatus), fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),)),
                  //                                     ),
                  //                                   ),
                  //                                   const SizedBox(height: 15),
                  //                                   Icon(CupertinoIcons.doc_text, color: widget.model.disabledTextColor, size: 160),
                  //                                   const SizedBox(height: 15),
                  //                                   Divider(color: widget.model.disabledTextColor),
                  //                                   const SizedBox(height: 10),
                  //                                   Container(
                  //                                       height: 50,
                  //                                       decoration: BoxDecoration(
                  //                                         color: widget.model.paletteColor,
                  //                                         borderRadius: BorderRadius.circular(35),
                  //                                       ),
                  //                                     child: Padding(
                  //                                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //                                       child: Center(child: Text('Edit form', style: TextStyle(color: widget.model.accentColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),)),
                  //                                     )
                  //                                   ),
                  //                                   const SizedBox(height: 8),
                  //                                   if (e.formStatus != FormStatus.closed) Container(
                  //                                       height: 50,
                  //                                       decoration: BoxDecoration(
                  //                                         border: Border.all(color: Colors.red),
                  //                                         borderRadius: BorderRadius.circular(35),
                  //                                       ),
                  //                                     child: Padding(
                  //                                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //                                       child: Center(child: Text('Close form', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize),)),
                  //                                     )
                  //                                   )
                  //                               ],
                  //                             ),
                  //                         ),
                  //                         ),
                  //
                  //                         Positioned(
                  //                           bottom: 8,
                  //                           left: 8,
                  //                           child: Text('Edited At: ${DateFormat.MMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(e.lastOpenedAt))}', style: TextStyle(color: widget.model.disabledTextColor)),
                  //                         ),
                  //
                  //                         Positioned(
                  //                           top: 8,
                  //                           right: 10,
                  //                           child: Row(
                  //                             children: [
                  //                               if (e.formStatus == FormStatus.published) Container(
                  //                                 decoration: BoxDecoration(
                  //                                   color: widget.model.accentColor,
                  //                                   borderRadius: BorderRadius.circular(35),
                  //                                 ),
                  //                                 height: 60,
                  //                                 width: 60,
                  //                                 child: IconButton(
                  //                                   onPressed: () {
                  //
                  //                                   },
                  //                                   tooltip: 'Manage form',
                  //                                   icon: Icon(Icons.more_horiz, color: widget.model.paletteColor),
                  //                                 ),
                  //                               ),
                  //                               const SizedBox(width: 8),
                  //                               if (e.formStatus == FormStatus.published) Container(
                  //                                 decoration: BoxDecoration(
                  //                                   color: widget.model.accentColor,
                  //                                   borderRadius: BorderRadius.circular(35),
                  //                                 ),
                  //                                 height: 60,
                  //                                 width: 60,
                  //                                 child: IconButton(
                  //                                     onPressed: () {
                  //
                  //                                     },
                  //                                   tooltip: 'share form',
                  //                                   icon: Icon(CupertinoIcons.share, color: widget.model.paletteColor),
                  //                                 ),
                  //                               ),
                  //                               const SizedBox(width: 8),
                  //                               Container(
                  //                                 decoration: BoxDecoration(
                  //                                   color: widget.model.accentColor,
                  //                                   borderRadius: BorderRadius.circular(35),
                  //                                 ),
                  //                                 height: 60,
                  //                                 width: 60,
                  //                                 child: IconButton(
                  //                                     onPressed: () {
                  //
                  //                                     },
                  //                                   tooltip: 'delete',
                  //                                   icon: Icon(Icons.cancel, color: widget.model.paletteColor)),
                  //                               ),
                  //                             ],
                  //                           )
                  //                         ),
                  //                         /// last edited at
                  //                         /// status
                  //                         /// if published show link to share
                  //                         /// manage form.
                  //                         /// edit form
                  //                         /// close form
                  //                         /// delete form
                  //
                  //                   ],
                  //                 )
                  //                                               ),
                  //               )
                  //           )
                  //         ).values.toList() ?? []
                  //       ),
                  //     ],
                  //   )
                  // ),
              //     editorContainer: Container(
              //       width: MediaQuery.of(context).size.width,
              //       child: VendorFormEditorWidget(
              //         model: widget.model,
              //         form: null,
              //       ),
              //     ),
              //     isSelected: isEditingNewForm,
              //     model: widget.model,
              //     didSelectBack: () {
              //       setState(() {
              //         isEditingNewForm = false;
              //     });
              //   }
              // ),

    //       ),
    //     ),
    //   ],
    // );
    // return SingleChildScrollView(
    //   controller: _scrollController,
    //   child: Container(
    //     width: MediaQuery.of(context).size.width,
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           createNewVendorPreviews(
    //             context: context,
    //             model: widget.model,
    //             hasForms: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.vendorMerchantForms?.isNotEmpty == true,
    //             createNewForm: () {
    //               setState(() {
    //                 isEditingNewForm = true;
    //               });
    //             }
    //           ),
    //           const SizedBox(height: 25),
    //           Wrap(
    //             children: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.vendorMerchantForms?.map(
    //               (e) => Container(
    //                 width: 675,
    //                 height: 800,
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(18),
    //                     color: widget.model.accentColor
    //                 ),
    //                 child: mainContainerForVendorFormPreview(
    //                     context: context,
    //                     model: widget.model,
    //                     form: e,
    //                     editSelectedFor: (vendor) {
    //
    //                     },
    //                     changeStatusOfForm: (vendor) {
    //
    //                     },
    //                     deleteSelectedForm: (vendor) {
    //
    //                   }
    //                 ),
    //               )
    //             ).toList() ?? []
    //           ),

                ],
              )
            ),
          ),
        )
      ]
    );
  }
}

