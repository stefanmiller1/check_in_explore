
// class ReservationNewAttendeeOnBoarding extends StatefulWidget {
//
//   final DashboardModel model;
//   final ReservationItem reservationItem;
//   final ActivityManagerForm? activityManagerForm;
//
//   const ReservationNewAttendeeOnBoarding({super.key, required this.model, required this.reservationItem, this.activityManagerForm});
//
//   @override
//   State<ReservationNewAttendeeOnBoarding> createState() => _ReservationNewAttendeeOnBoardingState();
// }
//
// class _ReservationNewAttendeeOnBoardingState extends State<ReservationNewAttendeeOnBoarding> {
//
//   ScrollController? _scrollController;
//
//   @override
//   void initState() {
//     _scrollController = ScrollController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _scrollController?.dispose();
//     super.dispose();
//   }
//
//   /// what are the activity rules for how you want to join...
//   Widget
//
//   /// on joining res show option to add to discussion. with some image and text thanking attendee for joining...change 'join' to 'leave'?
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       controller: _scrollController,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//
//         ],
//       ),
//     );
//   }
//
//
//
// }