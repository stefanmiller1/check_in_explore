import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import '../core/web_dashboard/widgets/tab_floating_dropdown_helper.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


class MainWebHelperCore {

  static DashboardMarker currentDashboardMarker = DashboardMarker.search;

}

bool showTopNavBar(DashboardMarker marker) => marker == DashboardMarker.resSettings || marker == DashboardMarker.settings || marker == DashboardMarker.reservations || marker == DashboardMarker.profile || marker == DashboardMarker.chat || marker == DashboardMarker.resVendorForms;

String? getImageFromSelectedReservationActivity(ActivityManagerForm? activityManagerForm, ReservationItem? reservationItem, ListingManagerForm? listingForm) {
  late String currentImageForRes;

  if (activityManagerForm != null) {
    if (activityManagerForm.profileService.activityBackground.activityProfileImages?.isNotEmpty == true)  {
      return activityManagerForm.profileService.activityBackground.activityProfileImages?.first.uriPath;
    }
  }

  if (listingForm != null && reservationItem != null) {
    if (retrieveReservationSpacesFromListing(reservationItem, listingForm).where((element) => element.photoUri != null).isNotEmpty) {
      return retrieveReservationSpacesFromListing(reservationItem, listingForm).firstWhere((element) => element.photoUri != null).photoUri;
    }
  }

  return null;
}


List<String>? getImageFromCurrentReservations(BuildContext context, List<ReservationItem> reservations, List<ActivityManagerForm> activities) {

  final List<String> imageList = [];


  for (ReservationItem reservationItem in reservations) {
      /// add activity
        if (activities.where((element) => element.activityFormId == reservationItem.reservationId).isNotEmpty) {
          final ActivityManagerForm activity = activities.where((element) => element.activityFormId == reservationItem.reservationId).first;
          if (activity.profileService.activityBackground.activityProfileImages?.isNotEmpty == true) {

            imageList.add(activity.profileService.activityBackground.activityProfileImages?[0].uriPath ?? '');
          } else {
            imageList.add('');
        }
      } else {
          imageList.add('');
      }
    }

  return imageList;

}


Widget _chatMainWidget(BuildContext context, DashboardModel model, List<types.Room>? chats, FloatingDropdownTabMarker tabMarker, {required Function(types.Room) didSelectRoom}) {
  switch (tabMarker) {
    case FloatingDropdownTabMarker.preview:
      final rooms = chats ?? <types.Room>[];
      return Container(
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: model.accentColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header text remains if desired
            Text('Messages',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: model.paletteColor
              ),
            ),
            
            const SizedBox(width: 8),
            // Overlapping avatars stack
            SizedBox(
              height: 37.5,
              width: 85,
              // You may adjust width or let it expand
              child: Stack(
                children: List.generate(
                  rooms.length,
                  (idx) {
                    final room = rooms[idx];
                    return Positioned(
                      left: idx * 25.0,
                      child: InkWell(
                        onTap: () {
                         didSelectRoom(room);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: model.accentColor, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: room.imageUrl != null
                                ? NetworkImage(room.imageUrl!)
                                : const AssetImage('assets/profile-avatar.png')
                                    as ImageProvider,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(CupertinoIcons.plus_circle, color: model.disabledTextColor, size: 30),
              tooltip: 'Create New Chat',
              onPressed: () {
                // TODO: Implement create chat functionality
                showCreateNewChatPopOver(
                  context,
                  model,
                );
              },
            )
          ],
        ),
      );
    case FloatingDropdownTabMarker.getStarted:  
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
        'Start a new conversation',
        style: TextStyle(
          fontSize: model.secondaryQuestionTitleFontSize,
          fontWeight: FontWeight.bold,
          color: model.disabledTextColor,
        ),
          ),
          Text(
        'Tap the chat icon to begin messaging.',
        style: TextStyle(color: model.disabledTextColor),
          ),
        ],
      );
    default:
      return const SizedBox.shrink();
  }
} 



Widget _reservationsMainWidget(DashboardModel model, List<ReservationItem>? reservations, FloatingDropdownTabMarker tabMarker, {required Function(ReservationItem) didSelectReservation, required Function() didSelectCreateNewDraft}) {
  switch (tabMarker) {
    case FloatingDropdownTabMarker.preview:
      return Container(
              height: 60,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
              color: model.accentColor,
              borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 if (reservations != null && reservations.isNotEmpty) ...[Text(
                'Upcoming Reservations',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: model.paletteColor,
                ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                height: 37.5,
                width: 85,
                child: Stack(
                  children: List.generate(
                  reservations.length,
                  (idx) {
                    final reservation = reservations[idx];
                    String? imageUrl;
                    final mediaList = reservation.reservationMetadata?.activityMainMedia;
                    if (mediaList != null && mediaList.isNotEmpty) {
                    imageUrl = mediaList.first.uriPath;
                    }
                    return Positioned(
                    left: idx * 25.0,
                    child: InkWell(
                      onTap: () => didSelectReservation(reservation),
                      child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: model.accentColor, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: imageUrl != null
                          ? NetworkImage(imageUrl)
                          : const AssetImage('assets/profile-avatar.png') as ImageProvider,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(CupertinoIcons.plus_circle, color: model.disabledTextColor, size: 30),
                tooltip: 'Create New Draft',
                onPressed: () {
                    didSelectCreateNewDraft();
                },
              ),
            ],
          ]
        )
      );
    case FloatingDropdownTabMarker.getStarted:
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You have no upcoming reservations',
            style: TextStyle(
              fontSize: model.secondaryQuestionTitleFontSize,
              fontWeight: FontWeight.bold,
              color: model.disabledTextColor,
            ),
          ),
          Text(
            'Browse events and book your next reservation.',
            style: TextStyle(color: model.disabledTextColor),
          ),
        ],
      );
    default:
      return const SizedBox.shrink();
  }
}


Widget _profileMainWidget(DashboardModel model, UserProfileModel? currentUserProfile, List<EventMerchantVendorProfile>? vProfile, FloatingDropdownTabMarker tabMarker) {
  switch (tabMarker) {
    case FloatingDropdownTabMarker.preview:
      return const SizedBox.shrink();
    case FloatingDropdownTabMarker.getStarted:
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Create an additional profile', style: TextStyle(fontSize: model.secondaryQuestionTitleFontSize,
              fontWeight: FontWeight.bold,
              color: model.disabledTextColor,
            ),
          ),
          Text('Tap the profile icon to get started.', style: TextStyle(color: model.disabledTextColor),
          ),
        ],
      );
    default:
      return const SizedBox.shrink();
  }
}


// ─────────────────────────────────────────────────────────────────────────────

bool _hasDataForMarker(
  DashboardMarker marker,
  List<ReservationItem>? reservations,
  UserProfileModel? currentUserProfile,
  List<EventMerchantVendorProfile>? vProfile,
  List<types.Room>? chats,
) {
  switch (marker) {
    case DashboardMarker.search:
      return true;
    case DashboardMarker.reservations:
      return reservations != null && reservations.isNotEmpty;
    case DashboardMarker.chat:
      return chats != null && chats.isNotEmpty;
    case DashboardMarker.profile:
      return vProfile != null && vProfile.isNotEmpty;
    default:
      return false;
  }
}

bool _isMarkerSelected(DashboardMarker marker) {
  // e.g., compare current selected marker in state
  return true;
}

 /// Returns a FloatingDropdownModel configured for the given dashboard marker.
  FloatingDropdownModel buildTabDropdownModel(
    BuildContext context,
    DashboardModel model, 
    DashboardMarker marker, 
    List<ReservationItem>? reservations, 
    UserProfileModel? currentUserProfile, 
    List<EventMerchantVendorProfile>? vProfile, 
    List<types.Room>? chats,
    {
    Function(types.Room)? didSelectRoom,
    Function(ReservationItem)? didSelectReservation,
    Function()? didSelectCreateNewDraft,
    }
    ) {
    FloatingDropdownTabMarker tabState;
    // Determine state: getStarted if no data, hint if data but not selected, preview if selected
    if (!_hasDataForMarker(
          marker,
          reservations,
          currentUserProfile,
          vProfile,
          chats,
        )) {
      tabState = FloatingDropdownTabMarker.getStarted;
    } else if (!_isMarkerSelected(marker)) {
      tabState = FloatingDropdownTabMarker.hint;
    } else {
      tabState = FloatingDropdownTabMarker.preview;
    }

  switch (marker) {
    case DashboardMarker.search:
      return FloatingDropdownModel(
        icon: CupertinoIcons.circle,
        hintText: [
          'Discover upcoming activities tailored to your interests',
          'Bookmark activities to plan your schedule efficiently',
          'Search for activities and events happening near you',
          'Change your location to find activities in different cities',
        ],
        mainWidget: null,
        tabMarker: tabState,
      );

    case DashboardMarker.reservations:
      return FloatingDropdownModel(
        icon: CupertinoIcons.calendar,
        hintText: [
          'Update and manage your calendar with Markets you\'ll be attending',
          'Plan your schedule so everyone knows where to find you next!',
          'Share your profile & schedule with friends and organizers',
          'Cancel or modify reservations as needed'
        ],
        mainWidget: _reservationsMainWidget(model, reservations, tabState, didSelectReservation: didSelectReservation ?? (reservation) {}, didSelectCreateNewDraft: didSelectCreateNewDraft ?? () {}),
        tabMarker: tabState,
      );

    case DashboardMarker.chat:
      return FloatingDropdownModel(
        icon: CupertinoIcons.chat_bubble,
        hintText: [
          'Message your favourite vendor about upcoming Markets',
          'Message organizers and ask questions about activities directly through chat',
          'Connect with other users to share experiences'
        ],
        mainWidget: _chatMainWidget(context, model, chats, tabState, didSelectRoom: didSelectRoom ?? (room) {}),
        tabMarker: tabState,
      );

    case DashboardMarker.profile:
     
      return FloatingDropdownModel(
        icon: CupertinoIcons.info,
        hintText: [
          'Create or switch to an additional profile to get started',
        ],
        mainWidget: _profileMainWidget(model, currentUserProfile, vProfile, tabState),
        tabMarker: tabState,
      );

    default:
      return FloatingDropdownModel(
        icon: CupertinoIcons.info,
        hintText: null,
        mainWidget: null,
        tabMarker: tabState,
      );
  }
}