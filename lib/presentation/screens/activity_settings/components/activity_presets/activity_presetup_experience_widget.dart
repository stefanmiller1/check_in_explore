import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:dartz/dartz.dart' as dart;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:check_in_presentation/check_in_presentation.dart';


// class ActivitySetupExperienceContactDetails extends StatelessWidget {
//
//   final DashboardModel model;
//   final ActivityManagerForm activityManagerForm;
//
//   const ActivitySetupExperienceContactDetails({Key? key, required this.model, required this.activityManagerForm}) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Builder(
//       builder: (context) {
//         return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(activityManagerForm))),
//           child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
//             listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.authFailureOrSuccessOptionLocation != c.authFailureOrSuccessOptionLocation,
//             listener: (context, state) {
//
//             },
//             buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activityManagerForm != c.activityManagerForm,
//             builder: (context, state) {
//             return Scaffold(
//               appBar: AppBar(
//                 elevation: 0,
//                 backgroundColor: model.paletteColor,
//                 title: Text('Preset Experience', style: TextStyle(color: model.accentColor)),
//                 actions: [
//
//                 ],
//               ),
//               body: Padding(
//                 padding: const EdgeInsets.all(18.0),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//
//                       Container(
//                         alignment: Alignment.centerLeft,
//                         height: 55,
//                         decoration: BoxDecoration(
//                             color: model.accentColor,
//                             borderRadius: BorderRadius.all(Radius.circular(17.5))
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 15.0),
//                           child: Text(AppLocalizations.of(context)!.facilityLocationSaved, style: TextStyle(color: model.paletteColor, fontSize: model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }
//           )
//         );
//       }
//     );
//   }
// }

// class ActivitySetupExperienceOrgDetails extends StatelessWidget {
//
//   final DashboardModel model;
//   final ActivityManagerForm activityManagerForm;
//
//   const ActivitySetupExperienceOrgDetails({Key? key, required this.model, required this.activityManagerForm}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//       return BlocProvider(create: (context) => getIt<UpdateActivityFormBloc>()..add(UpdateActivityFormEvent.initializeActivityForm(dart.optionOf(activityManagerForm))),
//           child: BlocConsumer<UpdateActivityFormBloc, UpdateActivityFormState>(
//           listenWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting,
//           listener: (context, state) {
//
//           },
//           buildWhen: (p, c) => p.authFailureOrSuccessOptionSaving != c.authFailureOrSuccessOptionSaving || p.authFailureOrSuccessOptionSubmitting != c.authFailureOrSuccessOptionSubmitting || p.activitySettingsForm != c.activitySettingsForm,
//           builder: (context, state) {
//         return Scaffold(
//             appBar: AppBar(
//             elevation: 0,
//             backgroundColor: model.paletteColor,
//             title: Text('Preset Experience', style: TextStyle(color: model.accentColor)),
//               actions: [
//
//             ],
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//
//                 ],
//               ),
//             ),
//           );
//         }
//       )
//     );
//   }
// }