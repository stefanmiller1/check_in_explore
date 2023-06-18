import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';

class RequirementSettingsWidget extends StatefulWidget {

  final DashboardModel model;

  const RequirementSettingsWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<RequirementSettingsWidget> createState() => _RequirementSettingsWidgetState();
}

class _RequirementSettingsWidgetState extends State<RequirementSettingsWidget> {

  ScrollController? _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController = ScrollController();
    super.dispose();
  }

  void _isMensOnly(BuildContext context) {
    setState(() {
      if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isMensOnly ?? false) {
        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(false));
        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(false));
        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(false));
      } else {
        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(true));
        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(false));
        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(false));
      }
    });
  }

  void _isWomenOnly(BuildContext context) {
    setState(() {
      if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isWomenOnly ?? false) {
        context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isMenOnlyChanged(false));
        context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isWomenOnlyChanged(false));
        context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isCoEdOnlyChanged(false));
      } else {
        context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isMenOnlyChanged(false));
        context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isWomenOnlyChanged(true));
        context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isCoEdOnlyChanged(false));
      }
    });
  }

  void _isCoEdOnly(BuildContext context) {
    setState(() {
      if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isCoEdOnly ?? false) {
        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(false));
        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(false));
        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(false));

      } else {
        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(false));
        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(false));
        context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(true));
      }
    });
  }

  void _handleCreateNewAttendeeVendor(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
      barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
      transitionDuration: Duration(milliseconds: 650),
      pageBuilder: (BuildContext contexts, anim1, anim2) {
        return Scaffold(
            backgroundColor: Colors.transparent,
            body: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  decoration: BoxDecoration(
                      color: widget.model.accentColor,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(17.5), topLeft: Radius.circular(17.5))
                  ),
                  width: 600,
                  height: 750,
                  child: CreateNewVendorMerchant(
                    model: widget.model,
                    reservation: context.read<UpdateActivityFormBloc>().state.reservationItem,
                  )
              ),
            )
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0.01)).animate(anim1),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    bool isLessThanMain = (MediaQuery.of(context).size.width <= 1150);

    return Form(
      autovalidateMode: context.read<UpdateActivityFormBloc>().state.showErrorMessages,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),

          SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: (isLessThanMain) ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  mainContainerForSectionOneRowOneReq(
                      context: context,
                      model: widget.model,
                      state: context.read<UpdateActivityFormBloc>().state,
                      isSeventeenAndUnder: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isSeventeenAndUnder) {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSeventeenAndUnderChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSeventeenAndUnderChanged(true));
                          }
                        });
                      },
                      minimumAgeChanged: (v) {
                        setState(() {
                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.minimumAgeChanged(v));
                        });
                      },
                      isMensOnly: () {
                        setState(() {
                          _isMensOnly(context);
                        });
                      },
                      isWomenOnly: () {
                        setState(() {
                           _isWomenOnly(context);
                          });
                        },
                        isCoEdOnly: () {
                          setState(() {
                            _isCoEdOnly(context);
                          });
                        },
                        skillLevelExpectationChanged: (skills) {
                          setState(() {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.skillLevelExpectationChanged(skills));
                            });
                          },
                        ),
                        mainContainerForSectionOneRowTwoReq(
                        context: context,
                        model: widget.model,
                        state: context.read<UpdateActivityFormBloc>().state,
                        isAlcoholForSale: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholForSale ?? false) {
                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholForSaleChanged(true));
                            } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholForSaleChanged(false));
                            }
                          });
                        },
                        isFoodForSale: () {
                        setState(() {
                        if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodForSale ?? false) {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodForSaleChanged(true));
                            } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodForSaleChanged(false));
                          }
                        });
                      },
                      getVendorAttendees: getVendorAttendees(),
                      didSelectCreateVendor: () {
                        _handleCreateNewAttendeeVendor;
                      }
                  ),
                  mainContainerForSectionFooterReq(
                      context: context,
                      model: widget.model,
                      state: context.read<UpdateActivityFormBloc>().state,
                      isGearProvided: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isGearProvided ?? false) {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isGearProvidedChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isGearProvidedChanged(true));
                          }
                        });
                      },
                      isEquipmentProvided: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false) {
                            context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isEquipmentProvidedChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isEquipmentProvidedChanged(true));
                          }
                        });
                      },
                      isAnalyticsProvided: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isAnalyticsProvided ?? false) {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAnalyticsProvidedChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAnalyticsProvidedChanged(true));
                          }
                        });
                      },
                      isOfficiatorProvided: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isOfficiatorProvided ?? false) {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isOfficiatorProvidedChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isOfficiatorProvidedChanged(true));
                          }
                        });
                      },
                      isAlcoholProvided: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholProvided ?? false) {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholProvidedChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholProvidedChanged(true));
                          }
                        });
                      },
                      isFoodProvided: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided ?? false) {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodProvidedChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodProvidedChanged(true));
                          }
                        });
                      },
                      isSecurityProvided: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isSecurityProvided ?? false) {
                            context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isSecurityProvidedChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isSecurityProvidedChanged(true));
                          }
                        });
                      }
                  ),
                ],
              ) : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity == ProfileActivityTypeOption.experiences)
                    Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: mainContainerForSectionOneRowOneReq(
                            context: context,
                            model: widget.model,
                            state: context.read<UpdateActivityFormBloc>().state,
                            isSeventeenAndUnder: () {
                              setState(() {
                                if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isSeventeenAndUnder) {
                                  context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSeventeenAndUnderChanged(false));
                                } else {
                                  context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSeventeenAndUnderChanged(true));
                                }
                              });
                            },
                            minimumAgeChanged: (v) {
                              setState(() {
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.minimumAgeChanged(v));
                              });
                            },
                            isMensOnly: () {
                              _isMensOnly(context);
                            },
                            isWomenOnly: () {
                              _isWomenOnly(context);
                            },
                            isCoEdOnly: () {
                              _isCoEdOnly(context);
                            },
                            skillLevelExpectationChanged: (skills) {
                              setState(() {
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.skillLevelExpectationChanged(skills));
                              });
                            }
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(child: mainContainerForSectionOneRowTwoReq(
                            context: context,
                            model: widget.model,
                            state: context.read<UpdateActivityFormBloc>().state,
                            isAlcoholForSale: () {
                              setState(() {
                                if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholForSale ?? false) {
                                  context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholForSaleChanged(true));
                                } else {
                                  context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholForSaleChanged(false));
                                }
                              });
                            },
                            isFoodForSale: () {
                              setState(() {
                                if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodForSale ?? false) {
                                  context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodForSaleChanged(true));
                                } else {
                                  context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodForSaleChanged(false));
                                }
                              });
                            },
                            getVendorAttendees: getVendorAttendees(),
                            didSelectCreateVendor: () {
                              _handleCreateNewAttendeeVendor(context);
                            }
                          )
                        ),
                        if (MediaQuery.of(context).size.width >= 1300) SizedBox(width: MediaQuery.of(context).size.width * 0.1)
                      ],
                    ),

                  // if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity != ProfileActivityTypeOption.experiences)
                  // mainContainerForSectionOneRowOne(context),
                  mainContainerForSectionFooterReq(
                      context: context,
                      model: widget.model,
                      state: context.read<UpdateActivityFormBloc>().state,
                      isGearProvided: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isGearProvided ?? false) {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isGearProvidedChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isGearProvidedChanged(true));
                          }
                        });
                      },
                      isEquipmentProvided: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false) {
                            context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isEquipmentProvidedChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isEquipmentProvidedChanged(true));
                          }
                        });
                      },
                      isAnalyticsProvided: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isAnalyticsProvided ?? false) {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAnalyticsProvidedChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAnalyticsProvidedChanged(true));
                          }
                        });
                      },
                      isOfficiatorProvided: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isOfficiatorProvided ?? false) {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isOfficiatorProvidedChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isOfficiatorProvidedChanged(true));
                          }
                        });
                      },
                      isAlcoholProvided: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholProvided ?? false) {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholProvidedChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholProvidedChanged(true));
                          }
                        });
                      },
                      isFoodProvided: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided ?? false) {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodProvidedChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodProvidedChanged(true));
                          }
                        });
                      },
                      isSecurityProvided: () {
                        setState(() {
                          if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isSecurityProvided ?? false) {
                            context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isSecurityProvidedChanged(false));
                          } else {
                            context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isSecurityProvidedChanged(true));
                          }
                        });
                      }
                  ),
                ],
              )
            ),
          )
        ],
      ),
    );
  }

  Widget getVendorAttendees() {
    return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.vendor.toString(), context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityFormId.getOrCrash())),
      child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
            attLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
            loadAllAttendanceFailure: (_) => Container(),
            loadAllAttendanceSuccess: (item) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vendors', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                  const SizedBox(height: 10),
                  Container(
                    width: 675,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vendors are Invite Only?', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor,)),
                            Text('otherwise anyone can request to be a vendor with you', style: TextStyle(color: widget.model.disabledTextColor))
                          ],
                        )
                        ),
                        FlutterSwitch(
                          width: 60,
                          inactiveColor: widget.model.accentColor,
                          activeColor: widget.model.paletteColor,
                          value: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantInviteOnly ?? false,
                          onToggle: (value) {
                            setState(() {
                              if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantInviteOnly ?? false) {
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMerchantInviteOnlyChanged(false));
                              } else {
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMerchantInviteOnlyChanged(true));
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 165,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: item.item.map(
                              (attendee) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: getVendorAttendeeType(
                                context,
                                widget.model,
                                attendee: attendee,
                                didSelectAttendee: (attendee) {

                                }
                            ),
                          )
                      ).toList(),
                    ),
                  ),
                ],
              );
            },
            orElse: () => Container(),
          );
        },
      ),
    );
  }

  // Widget mainContainerForSectionOneRowOne(BuildContext context) {
  //   return Container(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         /// *** age requirements *** ///
  //         SizedBox(height: 25),
  //         Text('Age Limit', style: TextStyle(
  //           color: widget.model.disabledTextColor,
  //           fontSize: widget.model.secondaryQuestionTitleFontSize,
  //           )
  //         ),
  //         const SizedBox(height: 20),
  //         Container(
  //           width: 675,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Expanded(child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(AppLocalizations.of(context)!.activityRequirementAgeSeventeenUnder, style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor,)),
  //                   Text('otherwise any partner can request to collaborate with you', style: TextStyle(color: widget.model.disabledTextColor))
  //                   ],
  //                 )
  //               ),
  //               FlutterSwitch(
  //                 width: 60,
  //                 inactiveColor: widget.model.accentColor,
  //                 activeColor: widget.model.paletteColor,
  //                 value: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isSeventeenAndUnder,
  //                 onToggle: (value) {
  //                   setState(() {
  //                     if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isSeventeenAndUnder) {
  //                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSeventeenAndUnderChanged(false));
  //                     } else {
  //                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isSeventeenAndUnderChanged(true));
  //                     }
  //                   });
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //
  //         Visibility(
  //           visible: !context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isSeventeenAndUnder,
  //           child: Container(
  //             width: 675,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const SizedBox(height: 20),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Expanded(
  //                       child: Text(AppLocalizations.of(context)!.activityAllowedBelowAge,
  //                           style: TextStyle(
  //                               color: widget.model.paletteColor,
  //                               fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1,
  //                       ),
  //                     ),
  //                     Row(
  //                       children: [
  //                         QuantityButtons(
  //                             model: widget.model,
  //                             initNumber: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.minimumAgeRequirement,
  //                             counterCallback: (int v) {
  //                               setState(() {
  //                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.minimumAgeChanged(v));
  //                               });
  //                             }
  //                         ),
  //                         Container(
  //                             decoration: BoxDecoration(
  //                                 color: widget.model.paletteColor,
  //                                 borderRadius: BorderRadius.all(Radius.circular(30))
  //                             ),
  //                             height: 35,
  //                             width: 60,
  //                             child: Center(
  //                               child: Text(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.minimumAgeRequirement.toString(), style: TextStyle(color: widget.model.disabledTextColor)
  //                             ),
  //                           )
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //
  //         const SizedBox(height: 15),
  //         // Padding(
  //         //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
  //         //   child: Divider(
  //         //     thickness: 0.35,
  //         //     color: widget.model.paletteColor,
  //         //   ),
  //         // ),
  //
  //
  //         /// games and class based req.
  //         Visibility(
  //           // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity == ProfileActivityTypeOption.classesLessons,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const SizedBox(height: 15),
  //                 Row(
  //                   children: [
  //                     Icon(Icons.sports, color: widget.model.paletteColor),
  //                     const SizedBox(width: 5),
  //                     Icon(Icons.videogame_asset_rounded, color: widget.model.paletteColor),
  //                     const SizedBox(width: 15),
  //                     Expanded(child: Text('Specific Demographic Info', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, overflow: TextOverflow.ellipsis), maxLines: 1)),
  //                   ],
  //                 ),
  //                 Text(AppLocalizations.of(context)!.activityRequirementPreferencesGender, style: TextStyle(color: widget.model.disabledTextColor)),
  //                 const SizedBox(height: 10),
  //                 Container(
  //                   width: 675,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Expanded(child: Text(AppLocalizations.of(context)!.activityRequirementPreferencesGenderMen, style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor,))
  //                       ),
  //                       FlutterSwitch(
  //                         width: 60,
  //                         inactiveColor: widget.model.accentColor,
  //                         activeColor: widget.model.paletteColor,
  //                         value: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isMensOnly ?? false,
  //                         onToggle: (value) {
  //                           setState(() {
  //                             if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isMensOnly ?? false) {
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(false));
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(false));
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(false));
  //                             } else {
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(true));
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(false));
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(false));
  //                             }
  //                           });
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 5),
  //                 Container(
  //                   width: 675,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Expanded(child: Text(AppLocalizations.of(context)!.activityRequirementPreferencesGenderWomen, style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor,))
  //                       ),
  //                       FlutterSwitch(
  //                         width: 60,
  //                         inactiveColor: widget.model.accentColor,
  //                         activeColor: widget.model.paletteColor,
  //                         value: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isWomenOnly ?? false,
  //                         onToggle: (value) {
  //                           setState(() {
  //                             if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isWomenOnly ?? false) {
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(false));
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(false));
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(false));
  //                             } else {
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(false));
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(true));
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(false));
  //                             }
  //                           });
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 5),
  //                 Container(
  //                   width: 675,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Expanded(child: Text(AppLocalizations.of(context)!.activityRequirementPreferencesGenderCoed, style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor,))
  //                       ),
  //                       FlutterSwitch(
  //                         width: 60,
  //                         inactiveColor: widget.model.accentColor,
  //                         activeColor: widget.model.paletteColor,
  //                         value: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isCoEdOnly ?? false,
  //                         onToggle: (value) {
  //                           setState(() {
  //                             if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isCoEdOnly ?? false) {
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(false));
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(false));
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(false));
  //
  //                             } else {
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMenOnlyChanged(false));
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isWomenOnlyChanged(false));
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isCoEdOnlyChanged(true));
  //                             }
  //                           });
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             )
  //           ),
  //
  //           Visibility(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const SizedBox(height: 25),
  //                 Row(
  //                   children: [
  //                     Icon(Icons.sports, color: widget.model.paletteColor),
  //                     const SizedBox(width: 5),
  //                     Icon(Icons.videogame_asset_rounded, color: widget.model.paletteColor),
  //                     const SizedBox(width: 15),
  //                     Text('Any Required Skills?', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //                   ],
  //                 ),
  //                 Text(AppLocalizations.of(context)!.activityRequirementPreferencesSkillsExpected, style: TextStyle(color: widget.model.disabledTextColor)),
  //                 const SizedBox(height: 10),
  //
  //                 Container(
  //                   decoration: BoxDecoration(
  //                       color: widget.model.webBackgroundColor,
  //                       borderRadius: BorderRadius.all(Radius.circular(20))
  //                   ),
  //                   child: Padding(
  //                       padding: const EdgeInsets.all(15.0),
  //                       child: Text(AppLocalizations.of(context)!.facilitiesSelectMulti, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize))
  //                   ),
  //                 ),
  //
  //                 const SizedBox(height: 10),
  //                 Container(
  //                     decoration: BoxDecoration(
  //                         color: widget.model.accentColor.withOpacity(0.3),
  //                         borderRadius: BorderRadius.all(Radius.circular(20)),
  //                         border: Border(
  //                             top: BorderSide(width: 0.5, color: widget.model.disabledTextColor),
  //                             left: BorderSide(width: 0.5, color: widget.model.disabledTextColor),
  //                             right: BorderSide(width: 0.5, color: widget.model.disabledTextColor),
  //                             bottom: BorderSide(width: 0.5, color: widget.model.disabledTextColor)
  //                         )
  //                     ),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: SkillLevel.values.map(
  //                             (e) => Padding(
  //                           padding: const EdgeInsets.all(4.0),
  //                           child: Container(
  //                               width: 500,
  //                               height: 40,
  //                               child: TextButton(
  //                                 style: ButtonStyle(
  //                                   backgroundColor: MaterialStateProperty.resolveWith<Color>(
  //                                         (Set<MaterialState> states) {
  //                                       if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
  //                                         return widget.model.paletteColor.withOpacity(0.1);
  //                                       }
  //                                       if (states.contains(MaterialState.hovered)) {
  //                                         return (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.skillLevelExpectation?.contains(e) ?? false) ? widget.model.paletteColor : widget.model.paletteColor.withOpacity(0.1);
  //                                       }
  //                                       return (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.skillLevelExpectation?.contains(e) ?? false) ? widget.model.paletteColor : Colors.transparent; // Use the component's default.
  //                                     },
  //                                   ),
  //                                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                                       RoundedRectangleBorder(
  //                                         borderRadius: const BorderRadius.all(Radius.circular(15)),
  //                                       )
  //                                   ),
  //                                 ),
  //                                 onPressed: () {
  //                                   setState(() {
  //
  //                                     final List<SkillLevel> listOfSkills = [];
  //                                     listOfSkills.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.skillLevelExpectation ?? []);
  //
  //                                     if (listOfSkills.contains(e)) {
  //                                       listOfSkills.removeWhere((element) => element == e);
  //                                     } else {
  //                                       listOfSkills.add(e);
  //                                     }
  //                                     context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.skillLevelExpectationChanged(listOfSkills));
  //                                   });
  //                                 },
  //                             child: Text(getSkillTypeName(context, e), style: TextStyle(color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.skillLevelExpectation?.contains(e) ?? false) ? widget.model.accentColor : widget.model.paletteColor, fontWeight: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.skillLevelExpectation?.contains(e) ?? false) ? FontWeight.bold : FontWeight.normal)),
  //                           )
  //                         ),
  //                       ),
  //                     ).toList(),
  //                   )
  //                 ),
  //               ],
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  // Widget mainContainerForSectionOneRowTwo(BuildContext context) {
  //
  //   bool activityAgeSetting = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.minimumAgeRequirement >= 18 && !context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isSeventeenAndUnder;
  //
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const SizedBox(height: 25),
  //       /// what is sold for all non - events.
  //       /// TODO: do not show if facility does not allow specific items to be sold.
  //
  //       /// what is sold - specifically for events.
  //       Visibility(
  //         // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity != ProfileActivityOption.toRent || context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity == ProfileActivityOption.tournament,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             /// show event or non-rent selling options
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //
  //               children: [
  //                 // if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity != ProfileActivityOption.toRent)
  //                 Row(
  //                   children: [
  //                     Icon(Icons.map, color: widget.model.paletteColor),
  //                     const SizedBox(width: 5),
  //                     Icon(Icons.sports, color: widget.model.paletteColor),
  //                     const SizedBox(width: 5),
  //                     Icon(Icons.videogame_asset_rounded, color: widget.model.paletteColor),
  //                     const SizedBox(width: 5),
  //                   ],
  //                 ),
  //                 if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity == ProfileActivityOption.tournament) Icon(Icons.sports_handball_rounded, color: widget.model.paletteColor),
  //                 const SizedBox(width: 15),
  //                 Expanded(child: Text('What are You Selling?', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize))),
  //               ],
  //             ),
  //             const SizedBox(height: 20),
  //
  //             IgnorePointer(
  //               ignoring: !activityAgeSetting,
  //               child: Container(
  //                 width: 675,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Expanded(child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(AppLocalizations.of(context)!.activityRequirementEventAlcoholTitle, style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor,)),
  //                         Visibility(
  //                           visible: !activityAgeSetting,
  //                             child: Text('Because this event is 18 and below - alcohol cannot be provided*', style: TextStyle(color: widget.model.disabledTextColor))
  //                           )
  //                         ],
  //                       )
  //                     ),
  //                     FlutterSwitch(
  //                       width: 60,
  //                       inactiveColor: widget.model.accentColor,
  //                       activeColor: widget.model.paletteColor,
  //                       value: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholForSale ?? false,
  //                       onToggle: (value) {
  //                         setState(() {
  //                           if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholForSale ?? false) {
  //                             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholForSaleChanged(true));
  //                           } else {
  //                             context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholForSaleChanged(false));
  //                           }
  //                         });
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 15),
  //
  //       Container(
  //         width: 675,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Expanded(child: Text(AppLocalizations.of(context)!.activityRequirementEventFoodTitle, style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor,))
  //             ),
  //             FlutterSwitch(
  //               width: 60,
  //               inactiveColor: widget.model.accentColor,
  //               activeColor: widget.model.paletteColor,
  //               value: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodForSale ?? false,
  //               onToggle: (value) {
  //                 setState(() {
  //                   print(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodForSale);
  //                   if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodForSale ?? false) {
  //                     context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodForSaleChanged(true));
  //                   } else {
  //                     context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodForSaleChanged(false));
  //                   }
  //                 });
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //
  //       const SizedBox(height: 25),
  //       BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.vendor.toString(), context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityFormId.getOrCrash())),
  //         child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
  //           builder: (context, state) {
  //             return state.maybeMap(
  //               attLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
  //               loadAllAttendanceFailure: (_) => Container(),
  //               loadAllAttendanceSuccess: (item) {
  //                 return Column(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text('Vendors', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //                       const SizedBox(height: 10),
  //                       Container(
  //                         width: 675,
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Expanded(child: Column(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Text('Vendors are Invite Only?', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.paletteColor,)),
  //                                 Text('otherwise anyone can request to be a vendor with you', style: TextStyle(color: widget.model.disabledTextColor))
  //                               ],
  //                             )
  //                             ),
  //                             FlutterSwitch(
  //                               width: 60,
  //                               inactiveColor: widget.model.accentColor,
  //                               activeColor: widget.model.paletteColor,
  //                               value: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantInviteOnly ?? false,
  //                               onToggle: (value) {
  //                                 setState(() {
  //                                   if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantInviteOnly ?? false) {
  //                                     context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMerchantInviteOnlyChanged(false));
  //                                   } else {
  //                                     context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isMerchantInviteOnlyChanged(true));
  //                                   }
  //                                 });
  //                               },
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       const SizedBox(height: 15),
  //                       Container(
  //                         height: 165,
  //                         child: ListView(
  //                           scrollDirection: Axis.horizontal,
  //                           children: item.item.map(
  //                                   (attendee) => Padding(
  //                                 padding: const EdgeInsets.symmetric(horizontal: 6.0),
  //                                 child: getVendorAttendeeType(
  //                                     context,
  //                                     widget.model,
  //                                     attendee: attendee,
  //                                     didSelectAttendee: (attendee) {
  //
  //                               }
  //                             ),
  //                           )
  //                         ).toList(),
  //                     ),
  //                       ),
  //                   ],
  //                 );
  //               },
  //               orElse: () => Container(),
  //             );
  //           },
  //         ),
  //       ),
  //
  //       const SizedBox(height: 15),
  //       /// invite merchants or vendors
  //       InkWell(
  //         onTap: () {
  //           showGeneralDialog(
  //             context: context,
  //             barrierDismissible: true,
  //             barrierLabel: AppLocalizations.of(context)!.facilityCreateFormNavLocation1,
  //             barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
  //             transitionDuration: Duration(milliseconds: 650),
  //             pageBuilder: (BuildContext contexts, anim1, anim2) {
  //               return Scaffold(
  //                   backgroundColor: Colors.transparent,
  //                   body: Align(
  //                     alignment: Alignment.bottomCenter,
  //                     child: Container(
  //                         decoration: BoxDecoration(
  //                             color: widget.model.accentColor,
  //                             borderRadius: BorderRadius.only(topRight: Radius.circular(17.5), topLeft: Radius.circular(17.5))
  //                         ),
  //                         width: 600,
  //                         height: 750,
  //                         child: CreateNewVendorMerchant(
  //                           model: widget.model,
  //                           reservation: context.read<UpdateActivityFormBloc>().state.reservationItem,
  //                         )
  //                     ),
  //                   )
  //               );
  //             },
  //             transitionBuilder: (context, anim1, anim2, child) {
  //               return SlideTransition(
  //                 position: Tween(begin: Offset(0, 1), end: Offset(0, 0.01)).animate(anim1),
  //                 child: child,
  //               );
  //             },
  //           );
  //         },
  //         child: Container(
  //           width: 675,
  //           height: 60,
  //           decoration: BoxDecoration(
  //             color: widget.model.webBackgroundColor,
  //             borderRadius: const BorderRadius.all(Radius.circular(15)),
  //           ),
  //           child: Align(
  //             child: Text('Invite New Vendor or Merchant', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //           ),
  //         ),
  //       ),
  //
  //     ],
  //   );
  // }

  // Widget mainContainerForSectionFooter(BuildContext context) {
  //
  //   bool activityAgeSetting = context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.minimumAgeRequirement >= 18 && !context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isSeventeenAndUnder;
  //
  // /// TODO: THESE OPTIONS NEED TO TAKE FACILITY RESTRICTIONS INTO ACCOUNT (IF 18+ ACTIVITIES ARE ALLOWED OR NOT)
  //   return Container(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         /// what will be provided for non event activities (i.e classes, games, experiences)
  //         Visibility(
  //           // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity != ProfileActivityOption.events,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const SizedBox(height: 15),
  //               Row(
  //                 children: [
  //                   Icon(Icons.map, color: widget.model.paletteColor),
  //                   const SizedBox(width: 15),
  //                   Text('Providing Anything?', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //                 ],
  //               ),
  //               Text(AppLocalizations.of(context)!.activityRequirementsCoveredSubTitle, style: TextStyle(color: widget.model.disabledTextColor)),
  //               const SizedBox(height: 10),
  //
  //               Container(
  //                 height: 220,
  //                 child: ListView(
  //                   scrollDirection: Axis.horizontal,
  //                   children: [
  //                     Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Text(AppLocalizations.of(context)!.activityRequirementsCoveredJerseyGear, style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isGearProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor)),
  //                         const SizedBox(height: 10),
  //                         Container(
  //                             height: 120,
  //                             child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Jersey_Gear.png', color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isGearProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
  //                         const SizedBox(height: 18),
  //                         FlutterSwitch(
  //                           width: 60,
  //                           inactiveColor: widget.model.accentColor,
  //                           activeColor: widget.model.paletteColor,
  //                           value: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isGearProvided ?? false),
  //                           onToggle: (value) {
  //
  //                             if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isGearProvided ?? false) {
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isGearProvidedChanged(false));
  //                             } else {
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isGearProvidedChanged(true));
  //                             }
  //                           },
  //                         )
  //                       ],
  //                     ),
  //                     const SizedBox(width: 23),
  //                     Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Text(AppLocalizations.of(context)!.activityRequirementsCoveredEquipment, style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor)),
  //                         const SizedBox(height: 10),
  //                         Container(
  //                             height: 120,
  //                             child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Equipment.png', color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
  //                         const SizedBox(height: 18),
  //                         FlutterSwitch(
  //                           width: 60,
  //                           inactiveColor: widget.model.accentColor,
  //                           activeColor: widget.model.paletteColor,
  //                           value: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false),
  //                           onToggle: (value) {
  //
  //                             if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false) {
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isEquipmentProvidedChanged(false));
  //                             } else {
  //                               context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isEquipmentProvidedChanged(true));
  //                             }
  //
  //                           },
  //                         )
  //                       ],
  //                     ),
  //                     const SizedBox(width: 16),
  //                     Visibility(
  //                       // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activityType == ProfileActivityTypeOption.gameMatches,
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Text(AppLocalizations.of(context)!.activityRequirementsCoveredAnalyticsStandings, style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isAnalyticsProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor), textAlign: TextAlign.center),
  //                           const SizedBox(height: 10),
  //                           Container(
  //                               height: 120,
  //                               child: Icon(Icons.bar_chart_rounded, size: 110, color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isAnalyticsProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor.withOpacity(0.45))),
  //                           const SizedBox(height: 18),
  //                           FlutterSwitch(
  //                             width: 60,
  //                             inactiveColor: widget.model.accentColor,
  //                             activeColor: widget.model.paletteColor,
  //                             value: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isAnalyticsProvided ?? false),
  //                             onToggle: (value) {
  //
  //                               if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isAnalyticsProvided ?? false) {
  //                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAnalyticsProvidedChanged(false));
  //                               } else {
  //                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAnalyticsProvidedChanged(true));
  //                               }
  //
  //                             },
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                     const SizedBox(width: 16),
  //                     Visibility(
  //                       // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activityType == ProfileActivityTypeOption.gameMatches,
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Text('Officiator/Referees', style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isOfficiatorProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor), textAlign: TextAlign.center,),
  //                           const SizedBox(height: 35),
  //                           Container(
  //                               height: 80,
  //                               width: 120,
  //                               child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Referee_Officiator.png', color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isOfficiatorProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
  //                           const SizedBox(height: 15),
  //                           const SizedBox(height: 18),
  //                           FlutterSwitch(
  //                             width: 60,
  //                             inactiveColor: widget.model.accentColor,
  //                             activeColor: widget.model.paletteColor,
  //                             value: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isOfficiatorProvided ?? false),
  //                             onToggle: (value) {
  //
  //                               if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isOfficiatorProvided ?? false) {
  //                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isOfficiatorProvidedChanged(false));
  //                               } else {
  //                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isOfficiatorProvidedChanged(true));
  //                               }
  //                             },
  //                           )
  //                         ],
  //                       ),
  //                     )
  //
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //
  //         /// what will be provided specifically for events
  //         /// TODO: WILL DEPEND ON FACILITY RULES
  //         Visibility(
  //           // visible: context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityType.activity == ProfileActivityOption.events,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 /// show provided specifically for events
  //                 const SizedBox(height: 25),
  //                 Row(
  //                   children: [
  //                     Icon(Icons.connect_without_contact_rounded, color: widget.model.paletteColor),
  //                     const SizedBox(width: 15),
  //                     Text('Provided for your Event?', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
  //                   ],
  //                 ),
  //                 Visibility(
  //                     visible: !activityAgeSetting,
  //                     child: Text('Because this event is 18 and below - alcohol cannot be provided*', style: TextStyle(color: widget.model.paletteColor))),
  //                 Text(AppLocalizations.of(context)!.activityRequirementsCoveredSubTitle, style: TextStyle(color: widget.model.disabledTextColor)),
  //                 const SizedBox(height: 10),
  //
  //                 Container(
  //                   height: 220,
  //                   child: ListView(
  //                     scrollDirection: Axis.horizontal,
  //                     children: [
  //
  //                       Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Text(AppLocalizations.of(context)!.activityRequirementsCoveredEquipment, style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor)),
  //                           SizedBox(height: 10),
  //                           Container(
  //                               height: 120,
  //                               width: 120,
  //                               child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Equipment.png', color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
  //                           SizedBox(height: 18),
  //                           FlutterSwitch(
  //                             width: 60,
  //                             inactiveColor: widget.model.accentColor,
  //                             activeColor: widget.model.paletteColor,
  //                             value: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false),
  //                             onToggle: (value) {
  //
  //                               if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.isEquipmentProvided ?? false) {
  //                                 context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isEquipmentProvidedChanged(false));
  //                               } else {
  //                                 context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isEquipmentProvidedChanged(true));
  //                               }
  //
  //                             },
  //                           )
  //                         ],
  //                       ),
  //                       const SizedBox(width: 15),
  //                       /// NOT AN OPTION IF EVENT IS UNDER 18...
  //                       IgnorePointer(
  //                         ignoring: !activityAgeSetting,
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             Text(AppLocalizations.of(context)!.activityRequirementEventAlcohol, style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor)),
  //                             SizedBox(height: 10),
  //                             Container(
  //                                 height: 120,
  //                                 width: 120,
  //                                 child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Alcohol.png', color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
  //                             SizedBox(height: 18),
  //                             FlutterSwitch(
  //                               width: 60,
  //                               inactiveColor: widget.model.accentColor,
  //                               activeColor: widget.model.paletteColor,
  //                               value: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholProvided ?? false),
  //                               onToggle: (value) {
  //
  //                                 if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholProvided ?? false) {
  //                                   context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholProvidedChanged(false));
  //                                 } else {
  //                                   context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isAlcoholProvidedChanged(true));
  //                                 }
  //                               },
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                       const SizedBox(width: 15),
  //
  //                       Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Text(AppLocalizations.of(context)!.activityRequirementEventFoodOrDrink, style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor), textAlign: TextAlign.center),
  //                           SizedBox(height: 25),
  //                           Container(
  //                               height: 90,
  //                               width: 120,
  //                               child: Image.asset('assets/images/activity_creator/provider_options/provided_activity_options_Food_Drinks.png', color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor.withOpacity(0.45), fit: BoxFit.fitHeight, scale: 1, filterQuality: FilterQuality.high,)),
  //                           SizedBox(height: 40),
  //                           FlutterSwitch(
  //                             width: 60,
  //                             inactiveColor: widget.model.accentColor,
  //                             activeColor: widget.model.paletteColor,
  //                             value: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided ?? false),
  //                             onToggle: (value) {
  //
  //                               if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodProvided ?? false) {
  //                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodProvidedChanged(false));
  //                               } else {
  //                                 context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodProvidedChanged(true));
  //                               }
  //
  //                             },
  //                           )
  //                         ],
  //                       ),
  //                       const SizedBox(width: 15),
  //                       Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         crossAxisAlignment: CrossAxisAlignment.center,
  //                         children: [
  //                           Text('Security', style: TextStyle(fontWeight: FontWeight.bold, color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isSecurityProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor), textAlign: TextAlign.center,),
  //                           SizedBox(height: 15),
  //                           Container(
  //                               height: 120,
  //                               width: 120,
  //                               child: Center(child: Icon(Icons.lock, size: 55, color: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isSecurityProvided ?? false) ? widget.model.paletteColor : widget.model.disabledTextColor.withOpacity(0.45)))),
  //                           SizedBox(height: 18),
  //                           FlutterSwitch(
  //                             width: 60,
  //                             inactiveColor: widget.model.accentColor,
  //                             activeColor: widget.model.paletteColor,
  //                             value: (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isSecurityProvided ?? false),
  //                             onToggle: (value) {
  //                               if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isSecurityProvided ?? false) {
  //                                 context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isSecurityProvidedChanged(false));
  //                               } else {
  //                                 context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isSecurityProvidedChanged(true));
  //                             }
  //                           },
  //                         )
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             ],
  //           )
  //         ),
  //       ],
  //     ),
  //   );
  // }

}