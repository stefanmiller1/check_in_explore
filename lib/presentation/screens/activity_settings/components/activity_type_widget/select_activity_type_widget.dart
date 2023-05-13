import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' as dart;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/src/provider.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectActivityTypeWidget extends StatelessWidget {

  final DashboardModel model;
  final ActivityCreatorForm activityCreatorForm;

  const SelectActivityTypeWidget({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(activityCreatorForm))),
        child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
        listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.authFailureOrSuccessOptionLocation != c.authFailureOrSuccessOptionLocation,
          listener: (context, state) {

          },
          buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activityCreatorForm != c.activityCreatorForm,
          builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: model.paletteColor,
            title: Text('The Activity', style: TextStyle(color: model.accentColor)),
            actions: [

            ],
          ),
          body:Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: model.accentColor,
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(AppLocalizations.of(context)!.facilitiesSelect, style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    for (var activityType in groupBy(getActivityOptions(context), (activity) => activity.activityType).entries.toList())

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text(getActivityTypeOptions(context).where((element) => activityType.key == element.activityType).first.title ?? 'Loading', style: TextStyle(color: model.paletteColor, fontWeight: FontWeight.bold, fontSize: model.secondaryQuestionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 5),
                          Text(getActivityTypeOptions(context).where((element) => activityType.key == element.activityType).first.description ?? '...', style: TextStyle(color: model.disabledTextColor)),
                          const SizedBox(height: 10),
                          ...activityType.value.map(
                                  (e) => ListTile(
                                  title: Container(
                                      decoration: BoxDecoration(
                                          color: model.accentColor,
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(4.5),
                                          child: TextButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                    (Set<MaterialState> states) {
                                                  if (states.contains(MaterialState.selected) && states.contains(MaterialState.pressed) && states.contains(MaterialState.focused)) {
                                                    return model.paletteColor.withOpacity(0.1);
                                                  }
                                                  if (states.contains(MaterialState.hovered)) {
                                                    return context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityType.activity == e.activity ? model.paletteColor.withOpacity(0.8) : model.paletteColor.withOpacity(0.1);
                                                  }
                                                  return context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityType.activity == e.activity ? model.paletteColor : Colors.transparent; // Use the component's default.
                                                },
                                              ),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.activityOptionChanged(e));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 50,
                                                      child: SvgPicture.asset(getActivityOptions(context).firstWhere((element) => element.activityId == e.activityId).iconPath ?? '', height: 60, fit: BoxFit.cover, color: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityType.activity == e.activity ? model.accentColor : model.paletteColor)),
                                                  SizedBox(width: 15),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(getTitleForActivityOption(context, e.activity) ?? 'Activity', style: TextStyle(color: context.read<UpdateActivityFormBloc>().state.activityCreatorForm.activityType.activity == e.activity ? model.accentColor : model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),

                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                      )
                                  )
                              )
                          ).toList()
                        ],
                      ),

                  ],
                ),
              )
          )
          );
        }
      )
    );
  }
}