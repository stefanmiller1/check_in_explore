import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';

class RequirementSettingsWidget extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel activityOwner;
  final UserProfileModel currentUser;
  final ReservationItem reservationItem;
  final ActivityManagerForm activityManagerForm;
  // final ActivityManagerForm

  const RequirementSettingsWidget({Key? key,
    required this.model,
    required this.activityOwner,
    required this.currentUser,
    required this.reservationItem,
    required this.activityManagerForm}) : super(key: key);

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
    didSelectInvitationRequest(
        context: context,
        model: widget.model,
        currentUser: widget.currentUser.userId.getOrCrash(),
        attendeeType: AttendeeType.vendor,
        reservationItem: widget.reservationItem,
        inviteType: InvitationType.reservation,
        activityManagerForm: widget.activityManagerForm
    );
  }

  @override
  Widget build(BuildContext context) {

    bool isLessThanMain = (MediaQuery.of(context).size.width <= 1150) || ReservationHelperCore.didPresentSidePanel;

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
              child: Row(
                children: [
                  if (isLessThanMain) Flexible(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
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
                              activityManagerForm: widget.activityManagerForm,
                              isAlcoholForSale: () {
                                setState(() {
                                  if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholForSale == true) {
                                    context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isAlcoholForSaleChanged(false));
                                  } else {
                                    context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isAlcoholForSaleChanged(true));
                                  }
                                });
                              },
                              isVendorMerchInviteOnly: () {
                                setState(() {
                                  if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantInviteOnly == true) {
                                    context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isMerchantInviteOnlyChanged(false));
                                  } else {
                                    context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isMerchantInviteOnlyChanged(true));
                                  }
                                });
                              },
                              isFoodForSale: () {
                                setState(() {
                                  if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodForSale == true) {
                                    context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodForSaleChanged(false));
                                  } else {
                                    context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.isFoodForSaleChanged(true));
                                  }
                                });
                              },
                              getVendorAttendees: getVendorAttendeesList(widget.activityManagerForm),
                              didSelectCreateVendor: () {
                                _handleCreateNewAttendeeVendor(context);
                              },
                              didChangeMerchVenLimit: (limit) {
                                context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.merchantLimitChanged(int.parse(limit)));
                              },
                              didChangeMerchVenFee: (fee) {
                                context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.merchantFeeChanged(int.parse(fee)));
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
                      ),
                    ),
                  ) else Expanded(
                    child: Column(
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
                                activityManagerForm: widget.activityManagerForm,
                                isAlcoholForSale: () {
                                  setState(() {
                                    if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isAlcoholForSale ?? false) {
                                      context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.isAlcoholForSaleChanged(false));
                                    } else {
                                      context.read<UpdateActivityFormBloc>().add(const UpdateActivityFormEvent.isAlcoholForSaleChanged(true));
                                    }
                                  });
                                },
                                isVendorMerchInviteOnly: () {
                                  setState(() {
                                    if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantInviteOnly == true) {
                                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isMerchantInviteOnlyChanged(false));
                                    } else {
                                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isMerchantInviteOnlyChanged(true));
                                    }
                                  });
                                },
                                isFoodForSale: () {
                                  setState(() {
                                    if (context.read<UpdateActivityFormBloc>().state.activitySettingsForm.profileService.activityRequirements.eventActivityRulesRequirement?.isFoodForSale ?? false) {
                                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isFoodForSaleChanged(false));
                                    } else {
                                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.isFoodForSaleChanged(true));
                                    }
                                  });
                                },
                                getVendorAttendees: getVendorAttendeesList(widget.activityManagerForm),
                                didSelectCreateVendor: () {
                                  _handleCreateNewAttendeeVendor(context);
                                },
                                didChangeMerchVenLimit: (limit) {
                                  context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.merchantLimitChanged(int.parse(limit)));
                                },
                                didChangeMerchVenFee: (fee) {
                                  context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.merchantFeeChanged(int.parse(fee)));
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
                    ),
                  ),

                  Visibility(
                      visible: ReservationHelperCore.didPresentSidePanel && isLessThanMain == false,
                      child: AnimatedContainer(
                        width: (ReservationHelperCore.didPresentSidePanel && isLessThanMain == false) ? ReservationHelperCore.previewerWidth + 20 : 0,
                        duration: const Duration(milliseconds: 650),
                        curve: Curves.easeInOut,
                        child: Visibility(
                          visible: ReservationHelperCore.didPresentSidePanel,
                          child: Row(
                            children: [
                              const SizedBox(width: 60),
                              Expanded(
                                child: SizedBox(
                                  width: ReservationHelperCore.previewerWidth,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  )

                ],
              )
            ),
          )
        ],
      ),
    );
  }

  Widget getVendorAttendeesList(ActivityManagerForm activityForm) {
    return BlocProvider(create: (context) =>  getIt<AttendeeManagerWatcherBloc>()..add(AttendeeManagerWatcherEvent.watchAllAttendanceByType(AttendeeType.vendor.toString(), context.read<UpdateActivityFormBloc>().state.activitySettingsForm.activityFormId.getOrCrash())),
      child: BlocBuilder<AttendeeManagerWatcherBloc, AttendeeManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
            attLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
            loadAllAttendanceFailure: (_) => Container(),
            loadAllAttendanceSuccess: (item) {
              return getVendorAttendees(
                  context,
                  widget.model,
                  activityForm,
                  item.item,
                  didSelectAttendee: () {

                }
              );
            },
            orElse: () => Container(),
          );
        },
      ),
    );
  }

}