// import 'package:check_in_presentation/check_in_presentation.dart';
// import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/direct_chat_rooms_screen.dart';
// import 'package:flutter/material.dart';


// class DirectChatArchiveRoomsScreen extends StatefulWidget {

//   final DashboardModel model;

//   const DirectChatArchiveRoomsScreen({super.key, required this.model});

//   @override
//   State<DirectChatArchiveRoomsScreen> createState() => _DirectChatArchiveRoomsScreenState();
// }

// class _DirectChatArchiveRoomsScreenState extends State<DirectChatArchiveRoomsScreen> {


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: widget.model.paletteColor,
//           title: Text('Your Archive', style: TextStyle(color: widget.model.accentColor),
//           ),
//         ),
//         body: DirectChatRoomsScreen(
//           model: widget.model,
//           isArchive: true,
//           didSelectArchive: () {

//           },
//           didSelectChats: () {
//             Navigator.of(context).pop();
//         },
//           didSelectRoom: (room, profile) {
//             Navigator.push(context, MaterialPageRoute(
//                 builder: (_) {
//                   return DirectChatScreen(
//                     model: widget.model,
//                     room: room,
//                     currentUser: profile,
//                     reservationItem: null,
//                     isFromReservation: false,
//                   );
//                 }));
//         },
//       )
//     );
//   }
// }