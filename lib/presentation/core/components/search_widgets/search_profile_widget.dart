import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jumping_dot/jumping_dot.dart';

class SearchProfileCommunity extends StatefulWidget {

  final DashboardModel model;
  final String? currentUserId;
  final Function(ContactDetails) didSelectUser;

  const SearchProfileCommunity({
    super.key,
    required this.model,
    required this.currentUserId,
    required this.didSelectUser,
  });

  @override
  State<SearchProfileCommunity> createState() => _SearchProfileCommunityState();
}

class _SearchProfileCommunityState extends State<SearchProfileCommunity> {

  List<Contact>? _contacts;
  List<ContactDetails> selectedUsers = [];
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
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: widget.model.paletteColor,
              title: Text('Search', style: TextStyle(color: widget.model.accentColor),
              ),
              centerTitle: true,
              actions: [
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
                                              Text('Search Circles', style: TextStyle(color: widget.model.paletteColor)),
                                              Text('Find your Circles and their reservation', style: TextStyle(color: widget.model.disabledTextColor))
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



                    /// search results for all users
                    BlocProvider(create: (context) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserAllProfilesStarted()),
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


  Widget querySearchItemsContainer(BuildContext context, List<UserProfileModel> users) {

    List<ContactDetails> queryList = [];
    for (UserProfileModel user in users.where((element) => element.legalSurname.value.fold((l) => '', (r) => r).toLowerCase().contains(querySearch) || element.legalName.value.fold((l) => '', (r) => r).toLowerCase().contains(querySearch))) {
      if (user.legalName.isValid() && user.userId.getOrCrash() != widget.currentUserId) {
        queryList.add(
            ContactDetails(
                contactId: user.userId,
                name: FirstLastName('${user.legalName.getOrCrash()} ${user.legalSurname.value.fold((l) => '', (r) => r)}'),
                emailAddress: user.emailAddress,
                contactStatus: null
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
              child: Text('Search', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
            ),
            Expanded(
                child: (queryList.isNotEmpty) ? ListView.builder(
                  itemCount: queryList.length,
                  itemBuilder: (context, index) {
                    final user = queryList[index];

                    return ListTile(
                      onTap: () {
                        setState(() {
                          widget.didSelectUser(user);
                        });
                      },
                      leading: CircleAvatar(backgroundImage: (users.firstWhere((profileUser) => profileUser.userId == user.contactId).profileImage != null) ? users.firstWhere((profileUser) => profileUser.userId == user.contactId).profileImage!.image : Image.asset('assets/profile-avatar.png').image),
                      title: Text(user.name.getOrCrash(), style: TextStyle(color: widget.model.paletteColor)
                      )
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