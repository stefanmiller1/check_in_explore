import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_application/un_auth/watcher_services/attendee_watcher_service/attendee_manager_watcher_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget loadExploreItems() {
  return Container();
}

Widget noExploreItemsFound() {
  return Container();
}

Widget getSearchComponentListItem(BuildContext context, DashboardModel model, UniqueId currentUserId, SearchExploreType searchItem, ListingManagerForm? listingItem, ReservationItem? reservationItem, SpaceOptionSizeDetail? currentSpaceOptionDetail, {required Function(ListingManagerForm) didSelectListing, required Function(ListingManagerForm? listing, ReservationItem res) didSelectReservation, required Function(SpaceOptionSizeDetail) currentSpaceOptionSizeDetail}) {
  switch (searchItem) {
    case SearchExploreType.facility:
      return (listingItem != null) ? facilitySearchItem(
          context,
          model,
          listingItem,
          currentSpaceOptionDetail,
          didSelectItem: (listing) {
            didSelectListing(listing);
          },
          didSelectEmbeddedRes: (listing, res) {
            didSelectReservation(listing, res);
          },
          currentSpaceOptionSizeDetail: (space) {
            currentSpaceOptionSizeDetail(space);
          }
      ) : Container();
    case SearchExploreType.activity:
      return (reservationItem != null) ? reservationSearchItem(
          model,
          currentUserId,
          listingItem,
          reservationItem,
          didSelectReservation: () {
            didSelectReservation(listingItem, reservationItem);
          }
        ) : Container();
    case SearchExploreType.post:
      return postSearchItem();
    case SearchExploreType.profile:
      return profileSearchItem();
    case SearchExploreType.community:
      return communitySearchItem();
    case SearchExploreType.ad:
      // TODO: Handle this case.
      break;
  }
  return Container();
}


Widget facilitySearchItem(BuildContext context, DashboardModel model, ListingManagerForm listingManagerForm, SpaceOptionSizeDetail? currentSpaceOptionDetail, {required Function(ListingManagerForm listing) didSelectItem, required Function(ListingManagerForm listing, ReservationItem res) didSelectEmbeddedRes, required Function(SpaceOptionSizeDetail) currentSpaceOptionSizeDetail}) {

  return Container(
    child: baseSearchItemContainer(
        isSelected: null,
        model: model,
        height: 600,
        width: 600,
        backgroundWidget: ListingResultMain(
            showReservations: true,
            listing: listingManagerForm,
            isLoading: false,
            model: model,
            didSelectListingItem: (listing) {
              didSelectItem(listing);
            },
            didSelectEmbeddedRes: (listing, res) {
              didSelectEmbeddedRes(listing, res);
            }, didChangeSpaceOptionItem: (SpaceOptionSizeDetail space) {
              currentSpaceOptionSizeDetail(space);
            },
        ),
        bottomWidget: retrievedListingsFooter(
            context,
            model,
            listingManagerForm,
            currentSpaceOptionDetail,
            false,
            didTap: () {
              didSelectItem(listingManagerForm);
        }
      )
    )
  );
}

Widget reservationSearchItem(DashboardModel model, UniqueId currentUserId, ListingManagerForm? listingManagerForm, ReservationItem reservationItem, {required Function() didSelectReservation}) {
  /// retrieve activity item for reservation...if activity exists.
  return BlocProvider(create: (context) =>  getIt<ActivityManagerWatcherBloc>()..add(ActivityManagerWatcherEvent.watchActivityManagerFormStarted(reservationItem.reservationId.getOrCrash())),
      child: BlocBuilder<ActivityManagerWatcherBloc, ActivityManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadActivityManagerFormSuccess: (item) {
                return baseSearchItemContainer(
                        isSelected: null,
                        model: model,
                        height: 400,
                        width: 400,
                        backgroundWidget: getReservationMediaFrame(context, model, 400, 400, listingManagerForm, item.item, reservationItem, didSelectItem: didSelectReservation),
                        bottomWidget: getSearchFooterWidget(
                            context,
                            model,
                            currentUserId,
                            model.paletteColor,
                            model.disabledTextColor,
                            model.accentColor,
                            ReservationPreviewer(
                                reservation: reservationItem,
                                listing: listingManagerForm,
                                activityManagerForm: item.item,
                                previewWeight: 0
                            ),
                            false,
                            didSelectItem: didSelectReservation,
                            didSelectInterested: () {  }
                  )
                );
              },
              orElse: () {
                return  baseSearchItemContainer(
                    isSelected: null,
                    model: model,
                    height: 400,
                    width: 400,
                    backgroundWidget: getReservationMediaFrame(context, model, 400, 400, listingManagerForm, ActivityManagerForm.empty(), reservationItem, didSelectItem: didSelectReservation),
                    bottomWidget: getSearchFooterWidget(
                        context,
                        model,
                        currentUserId,
                        model.paletteColor,
                        model.disabledTextColor,
                        model.accentColor,
                        ReservationPreviewer(
                            reservation: reservationItem,
                            listing: listingManagerForm,
                            activityManagerForm: ActivityManagerForm.empty(),
                            previewWeight: 0
                        ),
                        false,
                        didSelectItem: didSelectReservation,
                        didSelectInterested: () {  }
                    )
            );
          }
        );
      },
    ),
  );
}

Widget activitySearchItem() {
  return Container();
}

Widget activityPassSearchItem() {
  return Container();
}

Widget activityTicketSearchItem() {
  return Container();
}

Widget postSearchItem() {
  return Container();
}

Widget profileSearchItem() {
  return Container();
}

/// should there be featured communities/upcoming communities - or suggested communities based on history or activity?
Widget communitySearchItem() {
  return Container();
}

