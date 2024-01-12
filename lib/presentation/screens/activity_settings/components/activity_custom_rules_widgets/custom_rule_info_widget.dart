import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';

/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:check_in_presentation/check_in_presentation.dart';


class CustomRuleSettingWidget extends StatefulWidget {

  final DashboardModel model;

  const CustomRuleSettingWidget({Key? key, required this.model}) : super(key: key);

  @override
  State<CustomRuleSettingWidget> createState() => _CustomRuleSettingWidgetState();
}

class _CustomRuleSettingWidgetState extends State<CustomRuleSettingWidget> {

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
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        width: 675,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mainContainerForCustom(
                  context: context,
                  model: widget.model,
                  state: context.read<UpdateActivityFormBloc>().state,
                  createCustomEditForm: (value) {
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
                                child: CustomRuleEditForm(
                                  model: widget.model,
                                  currentCustomRuleOption: value,
                                  didSaveCustomRule: (rule) {
                                    setState(() {
                                      final List<CustomRuleOption> newCustomRule = [];
                                      newCustomRule.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.customFieldRuleSetting);
                                      newCustomRule.add(rule);

                                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.customFieldRuleSettingsChanged(newCustomRule));
                                    });
                                  },
                                ),
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
                  },
                  customFieldRuleSettingsChanged: (customForms) {
                    setState(() {
                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.customFieldRuleSettingsChanged(customForms));
                    });
                  },
                  editCustomRuleEdit: () {
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
                                child: CustomRuleEditForm(
                                  model: widget.model,
                                  currentCustomRuleOption: CustomRuleOption(ruleId: UniqueId(), customRuleTitleLabel: ''),
                                  didSaveCustomRule: (rule) {
                                    setState(() {
                                      final List<CustomRuleOption> newCustomRule = [];
                                      newCustomRule.addAll(context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.customFieldRuleSetting);
                                      newCustomRule.add(rule);

                                      context.read<UpdateActivityFormBloc>().add(UpdateActivityFormEvent.customFieldRuleSettingsChanged(newCustomRule));
                                    });
                                  },
                                ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}