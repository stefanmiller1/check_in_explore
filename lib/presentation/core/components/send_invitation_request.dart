import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_application/misc/update_services/invitiation_services/invitation_service_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/contacts_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart' as bloc;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SendInvitationRequest extends StatefulWidget {

  final DashboardModel model;
  final UserProfileModel currentUser;
  final ReservationItem currentGuests;

  const SendInvitationRequest({
    super.key,
    required this.model,
    required this.currentUser,
    required this.currentGuests
  });

  @override
  State<SendInvitationRequest> createState() => _SendInvitationRequestState();
}

class _SendInvitationRequestState extends State<SendInvitationRequest> {

  List<Contact>? _contacts;
  List<ContactDetails> selectedUsers = [];
  List<UserProfileModel> searchResults = [];
  late TextEditingController _textController;
  String querySearch = '';
  bool _permissionDenied = false;


  @override
  void initState() {
    selectedUsers = [];
    _textController = TextEditingController();
    _fetchContacts();
    super.initState();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(create: (_) => getIt<InvitationFormBloc>()..add(InvitationFormEvent.initializedInviteForm(bloc.optionOf(selectedUsers))),
      child: BlocConsumer<InvitationFormBloc, InvitationFormState>(
        listenWhen: (p,c) => p.isSubmitting != c.isSubmitting,
        listener: (context, state)  {
            state.authFailureOrSuccess.fold(
                    () => null,
                    (either) => either.fold(
                      (failure) {
                        final snackBar = SnackBar(
                          backgroundColor: widget.model.webBackgroundColor,
                          content: failure.maybeMap(
                              serverError: (_) => Text(AppLocalizations.of(context)!.serverError, style: TextStyle(color: widget.model.disabledTextColor)),
                              orElse: () => Text('A Problem Happened', style: TextStyle(color: widget.model.disabledTextColor)),
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                  (_) {
                Navigator.of(context).pop();
              }
            )
          );
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: widget.model.paletteColor,
              title: Text('Send Invite', style: TextStyle(color: widget.model.accentColor),
              ),
              centerTitle: true,
              actions: [
               if (!state.isSubmitting) Center(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (selectedUsers.isNotEmpty && !state.isSubmitting) {
                          selectedUsers.addAll(widget.currentGuests.reservationAffiliates ?? []);

                          state.inviteList.toList(growable: true).addAll(selectedUsers);
                          context.read<InvitationFormBloc>().add(InvitationFormEvent.updateInviteList(state.inviteList.toList()));
                          context.read<InvitationFormBloc>().add(InvitationFormEvent.finishedSubmittingInvite(widget.currentGuests.reservationId.getOrCrash()));
                          selectedUsers.clear();
                        }
                      });
                    },
                    child: Text('Invite', style: TextStyle(color: (selectedUsers.isEmpty) ? widget.model.accentColor.withOpacity(0.4) : widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize),),
                  ),
                ),
                const SizedBox(width: 15),
              ],
            ),
            body: Column(
              children: [
                const SizedBox(height: 8),
                /// search controller
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _textController,
                    style: TextStyle(color: widget.model.paletteColor),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.zoom_out, color: widget.model.disabledTextColor),
                      hintText: 'Search a Name or Email',
                      errorStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: widget.model.disabledTextColor
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.only(bottom: 15, top: 15),
                      fillColor: widget.model.accentColor,
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                            color: widget.model.paletteColor,
                            width: 0
                        ),
                      ),
                      focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(
                          width: 0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: widget.model.webBackgroundColor,
                          width: 0,
                        ),
                      ),
                    ),
                    autocorrect: true,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 1,
                    onChanged: (query) {
                      setState(() {
                        querySearch = query.toLowerCase();
                      });
                    }
                  ),
                ),

                /// invite from contacts
                if (querySearch == '' && !(state.isSubmitting)) Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: InkWell(
                          onTap: () async {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                              return ContactsListWidget(
                                model: widget.model,
                                contactList: _contacts ?? [],
                              );
                            })
                            );
                          },
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.perm_contact_cal_outlined, color: widget.model.paletteColor),
                                          const SizedBox(width: 18.0),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Invite From Contacts', style: TextStyle(color: widget.model.paletteColor)),
                                              Text('send invites directly to your contacts', style: TextStyle(color: widget.model.disabledTextColor))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor)
                                  ]
                              )
                          )
                      ),
                    ),

                    /// ------------------ ///
                    Container(
                      height: 10,
                      width: MediaQuery.of(context).size.width,
                      color: widget.model.accentColor,
                    ),


                    /// search results for all owned communities or start community - go to community members list/count
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: InkWell(
                          onTap: () {

                          },
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.people_alt_outlined, color: widget.model.paletteColor),
                                          const SizedBox(width: 18.0),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Create New Community', style: TextStyle(color: widget.model.paletteColor)),
                                              Text('Get your community to join this reservation', style: TextStyle(color: widget.model.disabledTextColor))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor)
                                  ]
                              )
                          )
                      ),
                    ),

                    /// ------------------ ///
                    Container(
                      height: 10,
                      width: MediaQuery.of(context).size.width,
                      color: widget.model.accentColor,
                    ),
                  ],
                ),

                if (state.isSubmitting) SizedBox(
                    height: 220,
                    child: JumpingDots(numberOfDots: 3, color: widget.model.paletteColor)
                ),


                /// search results for all users
                if (!state.isSubmitting) BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(UserProfileWatcherEvent.watchUserAllProfilesStarted()),
                  child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
                    builder: (context, authState) {
                      return authState.maybeMap(
                        loadInProgress: (_) => JumpingDots(numberOfDots: 3, color: widget.model.paletteColor),
                        loadAllUserProfilesSuccess: (items) {
                          return querySearchItemsContainer(context, items.profile);
                        },
                        orElse: () => querySearchItemsContainer(context, [])
                      );
                    }
                  ),
                ),

                /// quickly share icon list
                Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  color: widget.model.accentColor,
                  child: SingleChildScrollView(
                    child: Row(
                      children: [

                      ],
                    ),
                  ),
                ),

              ],
            ),

          );
        }
      )
    );
  }

  Widget querySearchItemsContainer(BuildContext context, List<UserProfileModel> users) {

      List<ContactDetails> queryList = [];
      for (UserProfileModel user in users.where((element) => element.legalSurname.value.fold((l) => '', (r) => r).toLowerCase().contains(querySearch) || element.legalName.value.fold((l) => '', (r) => r).toLowerCase().contains(querySearch))) {
        if (user.legalName.isValid() && user.legalSurname.isValid() && user.userId != widget.currentUser.userId) {
          queryList.add(
            ContactDetails(
                contactId: user.userId,
                name: FirstLastName('${user.legalName.getOrCrash()} ${user.legalSurname.getOrCrash()}'),
                emailAddress: user.emailAddress,
                contactStatus: ContactStatus.invited
            )
          );
        }
      }

      return Expanded(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Invite', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (selectedUsers.length == users.length) {
                            selectedUsers.clear();
                            selectedUsers.addAll(widget.currentGuests.reservationAffiliates ?? []);
                          } else {
                            selectedUsers.clear();
                            selectedUsers.addAll(users.map((user) =>  ContactDetails(
                                contactId: user.userId,
                                name: user.legalName,
                                emailAddress: user.emailAddress,
                                contactStatus: ContactStatus.invited
                            )).toList());
                          }
                        });
                      },
                      child: Text('Select All', style: TextStyle(color: widget.model.paletteColor, decoration: TextDecoration.underline)),
                    )
                  ],
                ),
              ),
              Expanded(
                child: (queryList.isNotEmpty) ? ListView.builder(
                    itemCount: queryList.length,
                    itemBuilder: (context, index) {
                      final user = queryList[index];

                      return ListTile(
                        onTap: () {
                          setState(() {

                            if (!(widget.currentGuests.reservationAffiliates?.map((e) => e.contactId).contains(user.contactId) ?? false)) {
                              if (!(selectedUsers.map((e) => e.contactId).contains(user.contactId))) {
                                selectedUsers.add(user);
                              } else {
                                selectedUsers.removeWhere((element) => element.contactId == user.contactId);
                              }
                            }
                          });
                        },
                        leading: CircleAvatar(backgroundImage: (users.firstWhere((profileUser) => profileUser.userId == user.contactId).profileImage != null) ? users.firstWhere((profileUser) => profileUser.userId == user.contactId).profileImage!.image : Image.asset('assets/profile-avatar.png').image),
                        title: Text(user.name.getOrCrash(), style: TextStyle(color: widget.model.paletteColor)),
                        trailing: (widget.currentGuests.reservationAffiliates?.map((e) => e.contactId).contains(user.contactId) ?? false) ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: widget.model.accentColor
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(getContactStatus(widget.currentGuests.reservationAffiliates?.firstWhere((element) => element.contactId == user.contactId).contactStatus), style: TextStyle(color: widget.model.disabledTextColor)),
                          ),
                        ) : Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: 2, color: widget.model.paletteColor)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: (selectedUsers.map((e) => e.contactId).contains(user.contactId)) ? widget.model.paletteColor : Colors.transparent
                              ),
                            ),
                          ),
                        ),
                        // subtitle: Text('${user.emailAddress.getOrCrash()}', style: TextStyle(color: widget.model.disabledTextColor)),
                    );
                  },
                ) : Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                      children: [
                        Container(
                          height: 90,
                          width: 90,
                          child: CircleAvatar(backgroundImage: Image.asset('assets/profile-avatar.png').image),
                        ),
                        const SizedBox(height: 10),
                        Text('Has Not Joined Yet!', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                        const SizedBox(height: 5),
                        Text('Sorry, $querySearch can\'nt be found.')
                    ],
                  ),
                ),
              )
            ),
          ],
      ),
        ),
    );
  }
}

String getContactStatus(ContactStatus? status) {
  switch (status) {
    case ContactStatus.invited:
      return 'Invited';
    case ContactStatus.joined:
      return 'Joined';
    case ContactStatus.pending:
      return 'Pending';
    default:
      return 'Invited';
  }
}