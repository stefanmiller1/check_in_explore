import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';

/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/src/provider.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityRulesToReview extends StatefulWidget {

  final DashboardModel model;
  final ActivityManagerForm activityManagerForm;
  final ReservationItem reservation;

  const ActivityRulesToReview({Key? key, required this.model, required this.activityManagerForm, required this.reservation}) : super(key: key);

  @override
  State<ActivityRulesToReview> createState() => _ActivityRulesToReviewState();
}

class _ActivityRulesToReviewState extends State<ActivityRulesToReview> {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityManagerForm), dart.optionOf(widget.reservation))),
    child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
    listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting,
    listener: (context, state) {

    },
    buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activitySettingsForm != c.activitySettingsForm,
    builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: widget.model.paletteColor,
            title: Text('Rules', style: TextStyle(color: widget.model.accentColor)),
            actions: [

            ],
          ),
          body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.facilityRuleDescription1, style: TextStyle(
                        color: widget.model.paletteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.model.questionTitleFontSize)),
                    Text(AppLocalizations.of(context)!.activityRulePreSubTitle, style: TextStyle(
                        color: widget.model.paletteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    SizedBox(height: 25),

                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 25),
                          Text(
                              AppLocalizations.of(context)!.facilityRuleFirst,
                              style: TextStyle(
                                  color: widget.model.paletteColor)),
                          SizedBox(height: 15),
                          Text(AppLocalizations.of(context)!.facilityRuleSecond, style: TextStyle(
                              color: widget.model.paletteColor)),
                          SizedBox(height: 15),
                          Text(
                              AppLocalizations.of(context)!.facilityRuleThird,
                              style: TextStyle(
                                  color: widget.model.paletteColor)),
                          SizedBox(height: 25),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(AppLocalizations.of(context)!.activityRuleCustomDetailsTitle, style: TextStyle(
                        color: widget.model.paletteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: widget.model.secondaryQuestionTitleFontSize)),
                    Text(AppLocalizations.of(context)!.activityRuleCustomDetailsSubTitle, style: TextStyle(
                        color: widget.model.paletteColor)),
                    SizedBox(height: 25),
                    _selectedRulesToInclude(context, widget.model, context.read<UpdateActivityFormBloc>().state.activitySettingsForm.rulesService.ruleOption)
                ]
              )
            ),
        );
        }
      )
    );
  }

  Widget _selectedRulesToInclude(BuildContext context, DashboardModel model, ListK<DetailOption> detailOptionList) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 8),
      child: Column(
        children: predefinedDetailOptions(context).map(
                (e) => Container(
              height: 50,
              child: Row(
                children: [
                  Expanded(child: Text(e.detail ?? '', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize))),
                  TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(30)),
                              )
                          )
                      ),
                      onPressed: () {
                        setState(() {
                          if (detailOptionList.getOrCrash().contains(
                              detailOptionList.getOrCrash().where((element) => element.uid == e.uid).isNotEmpty
                                  ? detailOptionList.getOrCrash().where((element) => element.uid == e.uid).first : [])) {

                            detailOptionList.getOrCrash().remove(detailOptionList.getOrCrash().where((element) => element.uid == e.uid).isNotEmpty
                                ? detailOptionList.getOrCrash().where((element) => element.uid == e.uid).first : []);

                          }

                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.ruleOptionChanged(detailOptionList));
                        });
                      },
                      child: Icon((detailOptionList.getOrCrash().contains(
                          detailOptionList.getOrCrash().where((element) => element.uid == e.uid).isNotEmpty
                              ? detailOptionList.getOrCrash().where((element) => element.uid == e.uid).first : [])) ? Icons.cancel_outlined : Icons.cancel, size: 50, color: widget.model.paletteColor,)),
                  SizedBox(width: 8),
                  Container(
                    child: TextButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                                )
                            )
                        ),
                        onPressed: () {
                          setState(() {
                            if (!detailOptionList.getOrCrash().contains(
                                detailOptionList.getOrCrash().where((element) => element.uid == e.uid).isNotEmpty
                                    ? detailOptionList.getOrCrash().where((element) => element.uid == e.uid).first : [])) {

                              detailOptionList.getOrCrash().add(DetailOption(uid: e.uid));

                            }
                            context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.ruleOptionChanged(detailOptionList));
                          });
                        },
                        child: Icon((detailOptionList.getOrCrash().contains(
                            detailOptionList.getOrCrash().where((element) => element.uid == e.uid).isNotEmpty
                                ? detailOptionList.getOrCrash().where((element) => element.uid == e.uid).first : [])) ?  Icons.check_circle : Icons.check_circle_outlined, size: 50, color: widget.model.paletteColor)),
                  )
                ],
              ),
            )
        ).toList(),
      ),
    );
  }
}