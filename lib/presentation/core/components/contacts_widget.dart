// import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';

class ContactsListWidget extends StatefulWidget {

  final List<Contact> contactList;
  final DashboardModel model;

  const ContactsListWidget({
    super.key,
    required this.model,
    required this.contactList,
  });

  @override
  State<ContactsListWidget> createState() => _ContactsListWidgetState();
}

class _ContactsListWidgetState extends State<ContactsListWidget> {

  List<String> strList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }



  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
    appBar: AppBar(
      elevation: 0,
      backgroundColor: widget.model.paletteColor,
      title: Text('Contacts', style: TextStyle(color: widget.model.accentColor),
      ),
      centerTitle: true,
    ),
    body: querySearchController(widget.contactList.map((e) => e.displayName).toList())
    );
  }

  Widget querySearchController(List<String> contactList) {

    List<String> contacts = [];
    for (String contact in contactList.where((element) => element.contains(searchController.text))) {
      contacts.add(contact);
    }
    contacts.sort((a,b) => a.compareTo(b));
    return Container();
    // return AlphabetListScrollView(
    //   strList: contacts,
    //   showPreview: true,
    //   indexedHeight: (i) {
    //     return 70;
    //   },
    //   headerWidgetList: <AlphabetScrollListHeader>[
    //     AlphabetScrollListHeader(
    //         widgetList: [
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Padding(
    //               padding: const EdgeInsets.only(top: 8.0),
    //               child: TextFormField(
    //                 controller: searchController,
    //                 style: TextStyle(color: widget.model.paletteColor),
    //                 decoration: InputDecoration(
    //                   prefixIcon: Icon(Icons.zoom_out, color: widget.model.disabledTextColor),
    //                   hintText: 'Search a Name or Email',
    //                   errorStyle: TextStyle(
    //                       fontWeight: FontWeight.bold,
    //                       fontSize: 14,
    //                       color: widget.model.disabledTextColor
    //                   ),
    //                   filled: true,
    //                   contentPadding: const EdgeInsets.only(bottom: 15, top: 15),
    //                   fillColor: widget.model.accentColor,
    //                   focusedErrorBorder: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(25.0),
    //                     borderSide: BorderSide(
    //                         color: widget.model.paletteColor,
    //                         width: 0
    //                     ),
    //                   ),
    //                   focusedBorder:  OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(25.0),
    //                     borderSide: const BorderSide(
    //                         color: Colors.transparent,
    //                         width: 0
    //                     ),
    //                   ),
    //                   errorBorder: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(25.0),
    //                     borderSide: const BorderSide(
    //                       width: 0,
    //                     ),
    //                   ),
    //                   enabledBorder: OutlineInputBorder(
    //                     borderRadius: BorderRadius.circular(25.0),
    //                     borderSide: BorderSide(
    //                       color: widget.model.webBackgroundColor,
    //                       width: 0,
    //                     ),
    //                   ),
    //                 ),
    //                 autocorrect: true,
    //                 keyboardType: TextInputType.multiline,
    //                 maxLines: 5,
    //                 minLines: 1,
    //                 onChanged: (query) {
    //                   setState(() {
    //                   });
    //                 },
    //               ),
    //             ),
    //
    //           ),
    //         ],
    //         icon: Icon(Icons.search, color: widget.model.disabledTextColor),
    //         indexedHeaderHeight: (index) => 70
    //     ),
    //   ],
    //   itemBuilder: (context, index) {
    //     Contact? contact;
    //     if (widget.contactList.where((element) => element.displayName == contacts[index]).isNotEmpty) {
    //       contact = widget.contactList.firstWhere((element) => element.displayName == contacts[index]);
    //     }
    //     if (contact != null) {
    //       return ListTile(
    //         title: Text(contact.displayName, style: TextStyle(color: widget.model.paletteColor)),
    //         leading: CircleAvatar(
    //           backgroundImage: (contact.photo != null || contact.photoOrThumbnail != null) ? Image.memory(contact.photo ?? contact.photoOrThumbnail!).image : Image.asset('assets/profile-avatar.png').image,
    //         ),
    //         trailing: Padding(
    //           padding: const EdgeInsets.only(right: 38.0),
    //           child: InkWell(
    //             onTap: () {
    //
    //             },
    //             child: Container(
    //               decoration: BoxDecoration(
    //                   color: widget.model.accentColor,
    //                   borderRadius: BorderRadius.circular(25)
    //               ),
    //               child: Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Text('Send Invite +', style: TextStyle(color: widget.model.paletteColor),),
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     }
    //     return Container();
    //   },
    // );
  }

}