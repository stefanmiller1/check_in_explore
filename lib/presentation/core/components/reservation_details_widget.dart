import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_domain/domain/misc/attendee_services/attendee_item/attendee_item.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/direct_chat_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/facility_preview_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReservationDetailsWidget extends StatefulWidget {

  final DashboardModel model;
  final ListingManagerForm listing;
  final ReservationItem reservationItem;
  final bool isReservationOwner;
  final List<AttendeeItem> allAttendees;
  final UserProfileModel currentUser;
  final bool isFromChat;

  const ReservationDetailsWidget({
    super.key,
    required this.model,
    required this.listing,
    required this.reservationItem,
    required this.isReservationOwner,
    required this.allAttendees,
    required this.currentUser,
    required this.isFromChat
  });

  @override
  State<ReservationDetailsWidget> createState() => _ReservationDetailsWidgetState();
}

class _ReservationDetailsWidgetState extends State<ReservationDetailsWidget> {

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Iterable<ContactDetails> affiliatedJoined = widget.reservationItem.reservationAffiliates?.where((element) => element.contactStatus == ContactStatus.joined) ?? [];
    // final affiliatedUsersProfiles = widget.profiles.where((element) => (affiliatedJoined.map((e) => e.contactId).contains(element.userId)));


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: widget.model.paletteColor,
        title: Text('Your Reservation', style: TextStyle(color: widget.model.accentColor)),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  /// ------------------------ ///
                  /// image booking space/name/where/review
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                          children: getSpacesFromSelectedReservationSlot(context, widget.listing, widget.reservationItem).map(
                                  (e) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: getSelectedSpaces(context, e, widget.model),
                              )
                          ).toList()
                      ),
                    ),
                  ),
                  /// ------------------------ ///
                  /// manage/edit your activity
                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),

                  Text('Manage Activity', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),

                  Column(
                    children: getActivityFromSelectedReservation(widget.reservationItem.reservationSlotItem).map(
                            (e) => InkWell(
                                onTap: () {

                                },
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              getActivityTypeTabOption(
                                                  context,
                                                  widget.model,
                                                  100,
                                                  false,
                                                  getActivityOptions().firstWhere((element) => element.activityId == e)
                                              ),
                                            ],
                                          ),
                              Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor)
                            ]
                          )
                        )
                      ),
                    ).toList(),
                  ),

                  /// ------------------------ ///
                  /// your booking
                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),

                  Text('Your Booking Slots', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),

                  viewListOfSelectedSlots(
                      context,
                      widget.model,
                      [],
                      widget.reservationItem.reservationSlotItem,
                      widget.reservationItem.cancelledSlotItem ?? [],
                      false,
                      AppLocalizations.of(context)!.profileFacilitySlotTime,
                      AppLocalizations.of(context)!.profileFacilitySlotBookingLocation,
                      AppLocalizations.of(context)!.profileFacilitySlotBookingDate,
                      widget.listing,
                      didSelectReservation: (e) {
                      },
                      didSelectCancelResSlot: (e, f) {
                        setState(() {});
                      },
                      didSelectRemoveResSlot: (e, f) {

                      }
                  ),

                  /// ------------------------ ///
                  /// contact listing owner

                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),
                  Text('Reservation Details', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text('Where You\'ll be and Who you can expect be there', style: TextStyle(color: widget.model.disabledTextColor)),

                  /// reservation listing
                  InkWell(
                      onTap: () {
                        if (kIsWeb) {

                        } else {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                          return FacilityPreviewScreen(
                            isAutoImplyLeading: true,
                            model: widget.model,
                            listing: widget.listing,
                            listingId: widget.listing.listingServiceId,
                            selectedReservationsSlots: null,

                                didSelectBack: () {},
                                didSelectReservation: (listing, res) {

                                },
                              );
                            }
                          )
                        );
                        }
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
                                      Icon(Icons.home_outlined, color: widget.model.paletteColor),
                                      const SizedBox(width: 18.0),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Show Listing', style: TextStyle(color: widget.model.paletteColor)),
                                          Text(widget.listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), style: TextStyle(color: widget.model.disabledTextColor))
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
                  if (widget.isReservationOwner) Divider(color: widget.model.disabledTextColor),
                  /// message host
                  if (widget.isReservationOwner) InkWell(
                    onTap: () {

                      Navigator.push(context, MaterialPageRoute(
                          builder: (_) {
                            return DirectChatScreen(
                              model: widget.model,
                              room: null,
                              currentUser: widget.currentUser,
                              reservationItem: widget.reservationItem,
                              isFromReservation: true,
                            );
                        }));
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
                                Icon(Icons.messenger_outline, color: widget.model.paletteColor),
                                const SizedBox(width: 18.0),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Message Host', style: TextStyle(color: widget.model.paletteColor)),
                                    // Text((widget.profiles.where((element) => element.userId == widget.listing.listingProfileService.backgroundInfoServices.listingOwner).isNotEmpty) ? widget.profiles.firstWhere((element) => element.userId == widget.listing.listingProfileService.backgroundInfoServices.listingOwner).legalName.getOrCrash() : '', style: TextStyle(color: widget.model.disabledTextColor))
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Row(
                            children: [
                              // if (widget.profiles.firstWhere((element) => element.userId == widget.listing.listingProfileService.backgroundInfoServices.listingOwner).profileImage != null)
                              // CircleAvatar(radius: 23.5, foregroundImage: (widget.profiles.where((element) => element.userId == widget.listing.listingProfileService.backgroundInfoServices.listingOwner).isNotEmpty) ? widget.profiles.firstWhere((element) => element.userId == widget.listing.listingProfileService.backgroundInfoServices.listingOwner).profileImage?.image ?? Image.asset('assets/profile-avatar.png').image : Image.asset('assets/profile-avatar.png').image),
                              const SizedBox(width: 12),
                              Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor)
                            ],
                          )
                        ]
                      )
                    )
                  ),
                  if (widget.isReservationOwner) Divider(color: widget.model.disabledTextColor),
                  /// who's joined/coming?
                  if (widget.isReservationOwner) InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                        return SendInvitationRequest(
                          model: widget.model,
                          currentUserId: widget.currentUser.userId.getOrCrash(),
                          attendeeType: AttendeeType.free,
                          reservationItem: widget.reservationItem,
                          inviteType: InvitationType.reservation,
                          didSelectInvite: (contacts) {},
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
                                Icon(Icons.group_outlined, color: widget.model.paletteColor),
                                const SizedBox(width: 18.0),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Send Invites', style: TextStyle(color: widget.model.paletteColor)),
                                    Text('${affiliatedJoined.length} Joined', style: TextStyle(color: widget.model.disabledTextColor))
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // if (widget.profiles.isNotEmpty) Container(
                          //   height: 50,
                          //   width: 180,
                          //   child: InkWell(
                          //     onTap: () {
                          //
                          //     },
                          //     child: AvatarStack(
                          //         settings: RestrictedPositions(
                          //           maxCoverage: 0.3,
                          //           minCoverage: 0.1,
                          //           laying: StackLaying.first
                          //         ),
                          //         infoWidgetBuilder: (surplus) {
                          //           return Container(
                          //             height: 50,
                          //             width: 50,
                          //             decoration: BoxDecoration(
                          //               color: widget.model.paletteColor,
                          //               borderRadius: BorderRadius.circular(50)
                          //             ),
                          //             child: Center(
                          //               child: Text('+$surplus', style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                          //             ),
                          //           );
                          //         },
                          //         avatars: [
                          //           if (affiliatedUsersProfiles.isNotEmpty) for (var n = 0; n < affiliatedUsersProfiles.length; n++) (affiliatedUsersProfiles.toList()[n].profileImage != null) ? affiliatedUsersProfiles.toList()[n].profileImage!.image : Image.asset('assets/profile-avatar.png').image
                          //         ]
                          //     ),
                          //   ),
                          // ),
                          if (widget.allAttendees.isEmpty) Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor)
                        ],
                      ),
                    ),
                  ),

                  /// ------------------------ ///
                  /// cancellation policy
                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),
                  Text('Cancellations', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),

                  if (widget.listing.listingReservationService.cancellationSetting.isNotAllowedCancellation ?? false)
                    getPricingCancellationForNoCancellations(context, widget.model),
                  if (!(widget.listing.listingReservationService.cancellationSetting.isNotAllowedCancellation ?? false))
                    getPricingCancellationWithChangesCancellation(context, widget.model, widget.listing.listingReservationService.cancellationSetting.isAllowedChangeNotEarlyEnd ?? false,
                        widget.listing.listingReservationService.cancellationSetting.isAllowedEarlyEndAndChanges ?? false),
                  if ((widget.listing.listingReservationService.cancellationSetting.isAllowedFeeBasedChanges ?? false) &&
                      (widget.listing.listingReservationService.cancellationSetting.feeBasedCancellationOptions?.isNotEmpty ?? false))
                    getPricingWithFeeCancellation(context, widget.model, widget.reservationItem.reservationSlotItem.map((e) => e.selectedDate).toList(),
                        widget.listing.listingReservationService.cancellationSetting.feeBasedCancellationOptions ?? []),
                  if ((widget.listing.listingReservationService.cancellationSetting.isAllowedTimeBasedChanges ?? false) &&
                      (widget.listing.listingReservationService.cancellationSetting.timeBasedCancellationOptions?.isNotEmpty ?? false))
                    getPricingWithTimeCancellation(context, widget.model, widget.reservationItem.reservationSlotItem.map((e) => e.selectedDate).toList(), widget.listing.listingReservationService.cancellationSetting.timeBasedCancellationOptions ?? []),
                  const SizedBox(height: 8),

                  /// ------------------------ ///
                  /// payment / fee details


                  if (widget.isReservationOwner) Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: widget.model.paletteColor),
                      const SizedBox(height: 5),
                      Text('Pricing Info', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Text('Total:', style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize,)),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(completeTotalPriceWithCurrency((getListingTotalPriceDouble(widget.reservationItem.reservationSlotItem, widget.reservationItem.cancelledSlotItem ?? []) +
                                getListingTotalPriceDouble(widget.reservationItem.reservationSlotItem, widget.reservationItem.cancelledSlotItem ?? [])*CICOReservationPercentageFee +
                                getListingTotalPriceDouble(widget.reservationItem.reservationSlotItem, widget.reservationItem.cancelledSlotItem ?? [])*CICOTaxesFee), widget.listing.listingProfileService.backgroundInfoServices.currency), style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                          ),

                        ],
                      ),

                      /// get receipt ///
                      InkWell(
                          onTap: () {

                            if (widget.reservationItem.receipt_link != null) {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) {
                                    return WebViewWidgetComponent(
                                      urlString: widget.reservationItem.receipt_link!,
                                      model: widget.model,
                                    );
                                  })
                              );
                            }
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
                                          Icon(Icons.receipt_long_rounded, color: widget.model.paletteColor),
                                          const SizedBox(width: 18.0),
                                          Text('Review Receipt', style: TextStyle(color: widget.model.paletteColor)),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.keyboard_arrow_right_rounded, color: widget.model.paletteColor)
                                  ]
                              )
                          )
                      ),
                    ],
                  ),


                  /// ------------------------ ///
                  /// rules and where
                  /// show listing


                  /// ------------------------ ///
                  /// get support
                  const SizedBox(height: 5),
                  Divider(color: widget.model.paletteColor),
                  const SizedBox(height: 5),
                  Text('Help & Support', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Text('Contact us at anytime for help or support on this reservation', style: TextStyle(color: widget.model.disabledTextColor)),
                  profileSettingItemWidget(
                      widget.model,
                      Icons.verified_user,
                      'Contact CICO Support',
                      false,
                      didSelectItem: () {

                    }
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}