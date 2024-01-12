import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter_bloc/flutter_bloc.dart';

// class ActivitySelectPricingCancellation extends StatefulWidget {
//
//   final DashboardModel model;
//   final ActivityCreatorForm activityCreatorForm;
//
//   const ActivitySelectPricingCancellation({Key? key, required this.model, required this.activityCreatorForm}) : super(key: key);
//
//   @override
//   State<ActivitySelectPricingCancellation> createState() => _ActivitySelectPricingCancellationState();
// }
//
// class _ActivitySelectPricingCancellationState extends State<ActivitySelectPricingCancellation> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(widget.activityCreatorForm))),
//       child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
//         listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.authFailureOrSuccessOptionLocation != c.authFailureOrSuccessOptionLocation,
//         listener: (context, state) {
//
//         },
//       buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activityManagerForm != c.activityManagerForm,
//       builder: (context, state) {
//         return Scaffold(
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: widget.model.paletteColor,
//             title: Text('Refunds', style: TextStyle(color: widget.model.accentColor)),
//             actions: [
//
//             ],
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(AppLocalizations.of(context)!.facilityCancellations, style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
//                 SizedBox(height: 15),
//                 Text(AppLocalizations.of(context)!.facilityCancellationDescription, style: TextStyle(color: widget.model.paletteColor)),
//                 SizedBox(height: 25),
//                 selectedCancelOption(
//                   context,
//                   widget.model,
//                   context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityCancellation.ruleOption,
//                   updateCancelOption: (e) {
//                     setState(() {
//                       context.read<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.cancellationChanged(e));
//                     });
//                   }
//                 )
//                 ],
//               ),
//             ),
//         );
//         }
//       )
//     );
//   }
// }