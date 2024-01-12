import 'package:avatar_stack/avatar_stack.dart';
import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

// class ActivityPresetContactDetails extends StatelessWidget {
//
//   final DashboardModel model;
//
//   const ActivityPresetContactDetails({super.key, required this.model});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(
//             builder: (_) {
//               return ActivitySetupExperienceContactDetails(
//                 model: model,
//                 activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
//             );
//           })
//         );
//       },
//       title: Text('Contact Details'),
//       leading: Icon(Icons.library_books_rounded, color: model.paletteColor),
//       trailing: Icon(Icons.keyboard_arrow_right_rounded, color: model.paletteColor),
//     );
//   }
// }
//
// class ActivityPresetCommunityLinkToPreview extends StatelessWidget {
//
//   final DashboardModel model;
//
//   const ActivityPresetCommunityLinkToPreview({super.key, required this.model});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(
//             builder: (_) {
//               return ActivitySetupExperienceOrgDetails(
//                 model: model,
//                 activityManagerForm: context.read<UpdateActivityFormBloc>().state.activitySettingsForm,
//             );
//           })
//         );
//       },
//       title: Text('Partnering With'),
//       leading: Icon(Icons.handshake_rounded, color: model.paletteColor),
//       trailing: Icon(Icons.keyboard_arrow_right_rounded, color: model.paletteColor),
//     );
//   }
//
// }
//
//
// class ActivityPresetClassPreview extends StatelessWidget {
//
//   final DashboardModel model;
//
//   const ActivityPresetClassPreview({super.key, required this.model});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(
//             builder: (_) {
//               return ActivitySetupClassesWidget(
//                 model: model,
//                 activityManagerForm: context.read<UpdateActivityFormBloc>().state.activityManagerForm,
//               );
//             })
//         );
//       },
//       title: Text('Classes Details'),
//       subtitle: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isWorkingAlone == null)
//             Text('Add who your working with'),
//           /// TODO: make this a list of communities that are of type organizations
//           if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isWorkingAlone != null && context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isWorkingAlone == true)
//             ...context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.affiliateOptions.map((e) => Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(25),
//                   color: model.accentColor
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Icon(Icons.account_circle, color: model.paletteColor),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(e.affiliateName),
//                           const SizedBox(height: 3),
//                           Text(e.affiliateContact)
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ).toList() ?? [],
//
//         ],
//       ),
//       leading: Icon(Icons.library_books_rounded, color: model.paletteColor),
//       trailing: Icon(Icons.keyboard_arrow_right_rounded, color: model.paletteColor),
//     );
//   }
//
// }
//
// class ActivityPresetClassPlayersPreview extends StatelessWidget {
//
//   final DashboardModel model;
//
//   const ActivityPresetClassPlayersPreview({super.key, required this.model});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(
//             builder: (_) {
//               return ActivitySetupClassesAddAttendees(
//                 model: model,
//                 activityCreatorForm: context.read<UpdateActivityFormBloc>().state.activityManagerForm,
//               );
//             })
//         );
//       },
//       title: Text('Class Attendees'),
//       subtitle: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 5),
//                 if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isOpenToMorePlayers == null || context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isOpenToMorePlayers == false)
//                 const Text('Additional Open Slots: Invite Only'),
//                 if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.isOpenToMorePlayers == true)
//                 Text('Additional Open Slots: ${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.attendeeLimit}'),
//                 const SizedBox(height: 3),
//                 if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster == null || context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?.isNotEmpty == true)
//                 const Text('Setup Attendees'),
//                 if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?.isNotEmpty ?? false)
//                   const Text('Attendees:')
//               ],
//             ),
//           ),
//
//           /// if added players to player roster
//           if (context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?.isNotEmpty ?? false) Container(
//             width: 150,
//             child: AvatarStack(
//                 avatars: context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.classesActivityAvailability?.playerRoster?.map(
//                         (e) => Image.asset('assets/profile-avatar.png').image
//                 ).toList() ?? []
//             ),
//           )
//         ],
//       ),
//       leading: Icon(Icons.people_rounded, color: model.paletteColor),
//       trailing: Icon(Icons.keyboard_arrow_right_rounded, color: model.paletteColor),
//     );
//   }
//
// }
//
// class ActivityPresetGamePreview extends StatelessWidget {
//
//   final DashboardModel model;
//
//   const ActivityPresetGamePreview({super.key, required this.model});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(
//             builder: (_) {
//               return ActivitySetupGames(
//                 model: model,
//                 activityManagerForm: context.read<UpdateActivityFormBloc>().state.activityManagerForm,
//               );
//             })
//         );
//       },
//       title: Text('Game Details'),
//       leading: Icon(Icons.library_books_rounded, color: model.paletteColor),
//       subtitle: Text('Number of Teams: ${context.read<UpdateActivityFormBloc>().state.activityManagerForm.activityAvailability.gameActivityAvailability?.tournamentNumberOfTeams ?? 0}',),
//       trailing: Icon(Icons.keyboard_arrow_right_rounded, color: model.paletteColor),
//     );
//   }
//
// }