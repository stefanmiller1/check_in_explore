import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';

/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/src/provider.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivityRuleToCreate extends StatefulWidget {

  final DashboardModel model;
  final ActivityCreatorForm activityCreatorForm;

  const ActivityRuleToCreate({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);

  @override
  State<ActivityRuleToCreate> createState() => _ActivityRuleToCreateState();
}


class _ActivityRuleToCreateState extends State<ActivityRuleToCreate> {

  
  @override
  Widget build(BuildContext context) {
   return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityCreatorForm))),
    child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
    listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.authFailureOrSuccessOptionLocation != c.authFailureOrSuccessOptionLocation,
    listener: (context, state) {

    },
    buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activityCreatorForm != c.activityCreatorForm,
    builder: (context, state) {
         return Scaffold(
             appBar: AppBar(
             elevation: 0,
             backgroundColor: widget.model.paletteColor,
             title: Text('Special Rules', style: TextStyle(color: widget.model.accentColor)),
        actions: [

            ],
          ),
         body: Padding(
         padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
                Text(AppLocalizations.of(context)!.activityRuleGameExpectationTitle, style: TextStyle(
                    color: widget.model.paletteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: widget.model.questionTitleFontSize)),
                SizedBox(height: 10),
                Text('e.g..${AppLocalizations.of(context)!.activityRuleGameExpectationExample}...', style: TextStyle(color: widget.model.paletteColor)),
                SizedBox(height: 25),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 55,
                  // width: (widget.model.mainContentWidth)! - 200,
                  decoration: BoxDecoration(
                      color: widget.model.accentColor,
                      borderRadius: BorderRadius.all(Radius.circular(17.5))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(AppLocalizations.of(context)!.activityCreateAndAdd, style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: 10),
                _selectedCustomRulesToInclude(context, widget.model, context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.customRuleOption),

                Visibility(
                  visible: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityType.activity == ProfileActivityOption.camp ||
                      context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityType.activityType == ProfileActivityTypeOption.classesLessons,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25),
                      Text(AppLocalizations.of(context)!.activityRuleGameExpectationSkillsTitle, style: TextStyle(
                          color: widget.model.paletteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.model.secondaryQuestionTitleFontSize)),
                      SizedBox(height: 10),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 55,
                        // width: (widget.model.mainContentWidth)! - 200,
                        decoration: BoxDecoration(
                            color: widget.model.accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(17.5))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(AppLocalizations.of(context)!.facilitiesSelectMulti, style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                          decoration: BoxDecoration(
                              color: widget.model.accentColor.withOpacity(0.3),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              border: Border(
                                  top: BorderSide(width: 0.5, color: widget.model.disabledTextColor),
                                  left: BorderSide(width: 0.5, color: widget.model.disabledTextColor),
                                  right: BorderSide(width: 0.5, color: widget.model.disabledTextColor),
                                  bottom: BorderSide(width: 0.5, color: widget.model.disabledTextColor)
                              )
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: SkillLevel.values.map(
                                  (e) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                    width: 500,
                                    height: 40,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                              (Set<MaterialState> states) {
                                            if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                              return widget.model.paletteColor.withOpacity(0.1);
                                            }
                                            if (states.contains(MaterialState.hovered)) {
                                              return (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.skillLevelReached?.contains(e) ?? false) ? widget.model.paletteColor : widget.model.paletteColor.withOpacity(0.1);
                                            }
                                            return (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.skillLevelReached?.contains(e) ?? false) ? widget.model.paletteColor : Colors.transparent; // Use the component's default.
                                          },
                                        ),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: const BorderRadius.all(Radius.circular(15)),
                                            )
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {

                                          if (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.skillLevelReached?.contains(e) ?? false) {
                                            context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.skillLevelReached?.remove(e);
                                          } else {
                                            context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.skillLevelReached?.add(e);
                                          }
                                          context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.skillLevelToReachChanged(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.skillLevelReached ?? []));
                                        });
                                      },
                                  child: Text(getSkillTypeName(context, e), style: TextStyle(color: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.skillLevelReached?.contains(e) ?? false) ? widget.model.accentColor : widget.model.paletteColor, fontWeight: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.skillLevelReached?.contains(e) ?? false) ? FontWeight.bold : FontWeight.normal)),
                                )
                              ),
                            ),
                          ).toList(),
                        )
                      ),


                    ],
                  ),
                ),
              ]
            ),
          ),
      ),
       );
     }
    )
   );
  }

  Widget _selectedCustomRulesToInclude(BuildContext context, DashboardModel model, ListK<DetailCustomOption>? customDetailOptionList) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

            ...customDetailOptionList?.getOrCrash().asMap().map((i,e) {
              final _selectedTextEditingController = TextEditingController();
              if (_selectedTextEditingController.text != e.customDetail) {
                _selectedTextEditingController.text = e.customDetail ?? '';
              }

              return MapEntry(i,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: getDescriptionTextField(
                              context,
                              widget.model,
                              _selectedTextEditingController,
                              '',
                              1,
                              60,
                              updateText: (value) {

                                context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.customRuleOption?.getOrCrash()[i] = context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.customRuleOption!.getOrCrash()[i].copyWith(customDetail: value);
                                context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.customRuleOptionChanged(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.customRuleOption ?? ListK([])));

                              }
                          ),
                        ),
                        SizedBox(width: 15),
                        Visibility(
                          visible: i != 0,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: TextButton(onPressed: () {
                              setState(() {

                                context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.customRuleOption?.getOrCrash().removeAt(i);
                                    context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.customRuleOptionChanged(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.customRuleOption ?? ListK([])));
                                  
                                
                              });
                            }, child: Icon(Icons.cancel_outlined, size: 40, color: (i != 0) ? widget.model.paletteColor : widget.model.disabledTextColor)),
                          ),
                        ),
                        SizedBox(width: 15),
                        ],
                      ),
                    ],
                  ),
                );
              }
            ).values.toList() ?? [],
          SizedBox(height: 10),
          Visibility(
            visible: (context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.customRuleOption?.getOrCrash().length ?? 1) < 5,
            child: Center(
              child: IconButton(onPressed: () {
                setState(() {

                  if ((context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.customRuleOption?.getOrCrash().length ?? 1) < 5) {

                    customDetailOptionList?.getOrCrash().add(DetailCustomOption(uid: UniqueId(), customDetail: ''));
                    context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.customRuleOptionChanged(context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityRules.customRuleOption ?? ListK([])));
                  }

                });
              }, icon: Icon(Icons.add_circle_outline, size: 25, color: widget.model.paletteColor,)),
            ),
          )
        ]
    );
  }
}