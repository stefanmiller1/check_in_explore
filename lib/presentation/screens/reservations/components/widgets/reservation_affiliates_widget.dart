// class ReservationAffiliatesWidget extends StatefulWidget {
//
//   final UserProfileModel currentUser;
//   final List<UserProfileModel> users;
//   final DashboardModel model;
//   final bool isOwner;
//   final String reservationId;
//   final Function(UserProfileModel) didSelectProfile;
//
//   const ReservationAffiliatesWidget({super.key, required this.model, required this.users, required this.currentUser, required this.didSelectProfile, required this.isOwner, required this.reservationId});
//
//   @override
//   State<ReservationAffiliatesWidget> createState() => _ReservationAffiliatesWidgetState();
// }
//
// class _ReservationAffiliatesWidgetState extends State<ReservationAffiliatesWidget> {
//
//   List<ContactDetails> selectedUsers = [];
//   late TextEditingController _textController;
//   String querySearch = '';
//   bool isEditing = false;
//
//   @override
//   void initState() {
//     selectedUsers = [];
//     _textController = TextEditingController();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _textController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       resizeToAvoidBottomInset: true,
//       body: MultiBlocProvider(
//         providers: [
//           BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationItem(widget.reservationId))),
//           BlocProvider(create: (_) => getIt<BookedReservationFormBloc>()..add(BookedReservationFormEvent.initializedPostForm(bloc.optionOf(Post(authorId: widget.currentUser.userId, id: UniqueId().getOrCrash(), status: PostStatus.sending, reservationId: widget.reservationId, type: PostType.text))))),
//         ],
//
//         child: getReservationItem()
//       ),
//     );
//   }
//
//   Widget getReservationItem() {
//     return BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
//       builder: (context, state) {
//         return state.maybeMap(
//           resLoadInProgress: (_) => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
//           loadReservationItemSuccess: (e) {
//             return getMainContainerWidget(e.item);
//           },
//           orElse: () => JumpingDots(color: widget.model.paletteColor, numberOfDots: 3),
//         );
//       },
//     );
//   }
//
//
//   Widget getMainContainerWidget(ReservationItem reservation) {
//
//     final affiliatedUsersProfiles = widget.users.where((element) => (reservation.reservationAffiliates?.map((e) => e.contactId).contains(element.userId)) ?? false);
//
//
//     return BlocConsumer<BookedReservationFormBloc, BookedReservationFormState>(
//         listenWhen: (p,c) => p.isSubmitting != c.isSubmitting || p.isCreatingLink != c.isCreatingLink,
//         listener: (context, state) {
//           state.authFailureOrSuccess.fold(
//                   () => {},
//                   (either) => either.fold(
//                       (failure) {
//                     final snackBar = SnackBar(
//                         backgroundColor: widget.model.webBackgroundColor,
//                         content: failure.maybeMap(
//
//                           reservationServerError: (e) => Text(e.failed ?? AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
//                           orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
//                         )
//                     );
//                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//                   },
//                       (_) {
//                     setState(() {
//                       Navigator.of(context).pop();
//                     });
//                   }
//               )
//           );
//         },
//         buildWhen: (p,c) => p.isSubmitting != c.isSubmitting,
//         builder: (context, state) {
//           return Container(
//               height: MediaQuery.of(context).size.height * 0.85,
//               width: MediaQuery.of(context).size.width,
//               decoration: BoxDecoration(
//                 color: widget.model.mobileBackgroundColor,
//                 borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
//               ),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 8),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextFormField(
//                         controller: _textController,
//                         style: TextStyle(color: widget.model.paletteColor),
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.zoom_out, color: widget.model.disabledTextColor),
//                           hintText: 'Search a Name or Email',
//                           errorStyle: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                               color: widget.model.disabledTextColor
//                           ),
//
//                           filled: true,
//                           contentPadding: const EdgeInsets.only(bottom: 15, top: 15),
//                           fillColor: widget.model.accentColor,
//                           focusedErrorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(25.0),
//                             borderSide: BorderSide(
//                                 color: widget.model.paletteColor,
//                                 width: 0
//                             ),
//                           ),
//
//                           focusedBorder:  OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(25.0),
//                             borderSide: const BorderSide(
//                                 color: Colors.transparent,
//                                 width: 0
//                             ),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(25.0),
//                             borderSide: const BorderSide(
//                               width: 0,
//                             ),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(25.0),
//                             borderSide: BorderSide(
//                               color: widget.model.webBackgroundColor,
//                               width: 0,
//                             ),
//                           ),
//                         ),
//                         autocorrect: true,
//                         keyboardType: TextInputType.multiline,
//                         maxLines: 5,
//                         minLines: 1,
//                         onChanged: (query) {
//                           setState(() {
//                             querySearch = query.toLowerCase();
//                           });
//                         }
//                     ),
//                   ),
//                   /// ---------------- ///
//                   Container(
//                     height: 10,
//                     width: MediaQuery.of(context).size.width,
//                     color: widget.model.accentColor,
//                   ),
//
//                   querySearchItems(context, reservation, affiliatedUsersProfiles.toList(), reservation.reservationAffiliates ?? [])
//
//               ],
//             ),
//           );
//         }
//       );
//   }
//
//   Widget querySearchItems(BuildContext context, ReservationItem reservation, List<UserProfileModel> users, List<ContactDetails> affiliates) {
//
//     List<ContactDetails> queryList = [];
//     for (UserProfileModel user in users.where((element) => element.legalSurname.value.fold((l) => '', (r) => r).toLowerCase().contains(querySearch) || element.legalName.value.fold((l) => '', (r) => r).toLowerCase().contains(querySearch))) {
//       if (user.legalName.isValid() && user.legalSurname.isValid() && user.userId != widget.currentUser.userId) {
//
//         late ContactDetails contactItem;
//
//         if (affiliates.map((e) => e.contactId).contains(user.userId)) {
//           contactItem = affiliates.firstWhere((element) => element.contactId == user.userId);
//         }
//         queryList.add(
//             ContactDetails(
//                 contactId: user.userId,
//                 name: FirstLastName('${user.legalName.getOrCrash()} ${user.legalSurname.getOrCrash()}'),
//                 emailAddress: user.emailAddress,
//                 contactStatus: contactItem.contactStatus ?? ContactStatus.invited
//           )
//         );
//       }
//     }
//
//
//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//         FocusScopeNode currentFocus = FocusScope.of(context);
//         if (!currentFocus.hasPrimaryFocus) {
//           currentFocus.unfocus();
//         }
//       },
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Guest List', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
//                   if (widget.isOwner) InkWell(
//                     onTap: () {
//                       setState(() {
//                         isEditing = !isEditing;
//                       });
//                     },
//                     child: Container(
//                         child: Text('Edit', style: TextStyle(color: (isEditing) ? widget.model.disabledTextColor : widget.model.paletteColor, decoration: TextDecoration.underline))),
//                   )
//                 ],
//               ),
//             ),
//             Expanded(
//               child: (queryList.isNotEmpty) ? ListView.builder(
//                   itemCount: queryList.length,
//                   shrinkWrap: true,
//                   padding: const EdgeInsets.all(0.0),
//                   itemBuilder: (context, index) {
//
//                     final user = queryList[index];
//
//                     return ListTile(
//                       onTap: () {
//
//                         if (users.map((e) => e.userId).contains(user.contactId)) {
//                           final userProfile = users.firstWhere((
//                               element) => element.userId == user.contactId);
//
//                             widget.didSelectProfile(userProfile);
//                         }
//                         FocusScopeNode currentFocus = FocusScope.of(context);
//                         if (!currentFocus.hasPrimaryFocus) {
//                           currentFocus.unfocus();
//                         }
//                       },
//                       leading: CircleAvatar(backgroundImage: (users.firstWhere((profileUser) => profileUser.userId == user.contactId).profileImage != null) ? users.firstWhere((profileUser) => profileUser.userId == user.contactId).profileImage!.image : Image.asset('assets/profile-avatar.png').image),
//                       title: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(child: Text(user.name.getOrCrash(), style: TextStyle(color: widget.model.paletteColor))),
//                           Container(
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(25),
//                                 color: widget.model.accentColor
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(getContactStatus(user.contactStatus), style: TextStyle(color: widget.model.disabledTextColor)),
//                             ),
//                           ),
//                         ],
//                       ),
//                       trailing: (isEditing) ? InkWell(
//                         onTap: () {
//                           setState(() {
//                               if (!(selectedUsers.map((e) => e.contactId).contains(user.contactId))) {
//                                 selectedUsers.add(user);
//                               } else {
//                                 selectedUsers.removeWhere((element) => element.contactId == user.contactId);
//                               }
//                           });
//                         },
//                         child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 300),
//                             curve: Curves.easeInOut,
//                             height: 30,
//                             width: (isEditing) ? 30 : 0,
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                                 border: Border.all(width: 2, color: widget.model.paletteColor),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(15),
//                                       color: (selectedUsers.map((e) => e.contactId).contains(user.contactId)) ? widget.model.paletteColor : Colors.transparent
//                                   ),
//                                 ),
//                               ),
//                             )
//                           ),
//                         ) : null
//                       // subtitle: Text('${user.emailAddress.getOrCrash()}', style: TextStyle(color: widget.model.disabledTextColor)),
//                     );
//                   },
//                 ) : Container(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 90,
//                         width: 90,
//                         child: CircleAvatar(backgroundImage: Image.asset('assets/profile-avatar.png').image),
//                       ),
//                       const SizedBox(height: 10),
//                       Text('Has Not Joined Yet!', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
//                       const SizedBox(height: 5),
//                       Text('Sorry, $querySearch can\'nt be found.')
//                     ],
//                   ),
//                 ),
//               )
//             ),
//             if (selectedUsers.isNotEmpty) Padding(
//               padding: const EdgeInsets.all(18.0),
//               child: InkWell(
//                 onTap: () {
//                   setState(() {
//
//                     List<ContactDetails> updatedAffiliates = [];
//                     updatedAffiliates.addAll(affiliates);
//
//                     for (ContactDetails contact in selectedUsers) {
//                       updatedAffiliates.removeWhere((element) => element.contactId == contact.contactId);
//                     }
//
//                     context.read<BookedReservationFormBloc>().add(BookedReservationFormEvent.didRemoveAffiliate(reservation, updatedAffiliates));
//
//                   });
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 8.0),
//                   child: Container(
//                     height: 60,
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(35),
//                       color: widget.model.accentColor
//                     ),
//                     child: const Center(child: Text('Remove Guests', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
