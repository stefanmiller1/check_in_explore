import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/listing_activity_preview_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/core/core_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/facility_preview/facility_preview_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/listing_components/listing_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget getListingPagingController(BuildContext context, DashboardModel model, double bottomOffset, List<ListingManagerForm> listings, UniqueId? selectedListing, {required Function(int) didChangePage, required Function(ListingManagerForm) didSelectListing}) {

  /// based on selected listing-id & search filter type - search for corresponding reservations
  switch (SearchExploreCoreHelper.currentSearchListingType) {
    case SearchListingType.facilities:
      return getListingPageQuickPreview(
          context,
          model,
          bottomOffset,
          listings,
          selectedListing,
          null,
          didChangePage: (page) => didChangePage(page),
          didSelectListing: (listing) => didSelectListing(listing)
      );
    case SearchListingType.activities:
      return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(ReservationManagerWatcherEvent.watchReservationsList([selectedListing != null ? selectedListing.getOrCrash() : ''], null, null, [ReservationSlotState.completed, ReservationSlotState.confirmed, ReservationSlotState.current])),
        child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
          builder: (context, state) {
            return state.maybeMap(
                resLoadInProgress: (_) => Positioned(
                  bottom: bottomOffset,
                    child: Container(
                      height: 115,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                            decoration: BoxDecoration(
                              color: model.mobileBackgroundColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(child: JumpingDots(color: model.paletteColor, numberOfDots: 3))),
                    ),
                  )
                ),
              loadReservationListSuccess: (items) => getListingPageQuickPreview(
                  context,
                  model,
                  bottomOffset,
                  listings,
                  selectedListing,
                  items.item,
                  didChangePage: (page) => didChangePage(page),
                  didSelectListing: (listing) => didSelectListing(listing)
              ),
              orElse: () => Container()
          );
        },
      )
    );
  }
}


Widget getListingPageQuickPreview(BuildContext context, DashboardModel model, double bottomOffset, List<ListingManagerForm>? listings, UniqueId? selectedListingId, List<ReservationItem>? reservation, {required Function(int) didChangePage, required Function(ListingManagerForm) didSelectListing}) {

  return Positioned(
    bottom: bottomOffset,
    child: Container(
    height: 115,
    width: MediaQuery.of(context).size.width,
      child: (reservation?.isNotEmpty ?? false) ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: getActivityQuickPreview(
          context,
          model,
          (listings?.where((element) => element.listingServiceId == selectedListingId).isNotEmpty ?? false) ? listings?.firstWhere((element) => element.listingServiceId == selectedListingId) : null,
          reservation ?? []
        ),
      ) : PageView(
        controller: MapHelper.pageController,
        onPageChanged: (page) {
          didChangePage(page);
        },
        children: listings?.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: getFacilityQuickPreview(
                context,
                model,
                e,
                didSelectListing: (listing) => didSelectListing(listing)
              )
            );
          }
        ).toList() ?? [],
      ),
    ),
  );
}

Widget getActivityQuickPreview(BuildContext context, DashboardModel model, ListingManagerForm? listing, List<ReservationItem> reservations) {
  if (listing == null) {
    return Container();
  }

  String? listingImage;

  for (SpaceOption space in listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r)) {
    if (space.quantity.where((element) => element.photoUri != null).isNotEmpty) {
      listingImage = space.quantity.firstWhere((element) => element.photoUri != null).photoUri;
    }
  }

  return Container(
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      color: model.mobileBackgroundColor,
      borderRadius: BorderRadius.circular(25),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 115,
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          left: 35,
          bottom: 1.5,
          child: Container(
            height: 115,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                itemCount: reservations.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final ReservationItem reservation = reservations[index];

                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 45.0),
                      child: getListingActivityPreviewWidget(context, model, listing, reservation)
                    );
                  }
                  if (index == (reservations.length - 1)) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 50.0),
                      child: getListingActivityPreviewWidget(context, model, listing, reservation)
                    );
                  }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: getListingActivityPreviewWidget(context, model, listing, reservation)
                );
              },
            ),
          ),
        ),
        Positioned(
          left: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) {
                    return FacilityPreviewScreen(
                      listing: listing,
                      listingId: listing.listingServiceId,
                      model: model,
                      isAutoImplyLeading: false,
                      selectedReservationsSlots: context.read<ListingsSearchRequirementsBloc>().state.selectedReservationsSlots?.toList() ?? [],
                      didSelectBack: () {},
                      didSelectReservation: (listing, res) {

                      },
                    );
                  }
              ));
            },
            child: Container(
              width: 60,
              child: Column(
                children: [
                   CircleAvatar(
                    radius: 30,
                    backgroundColor: model.paletteColor,
                    backgroundImage: (listingImage != null) ? Image.network(listingImage, fit: BoxFit.cover).image : Image.asset('assets/map_icons/noun-house-5004704.png', color: model.accentColor).image,
                  ),
                  const SizedBox(height: 3),
                  Container(
                    color: model.mobileBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(listing.listingProfileService.backgroundInfoServices.listingName.getOrCrash(), overflow: TextOverflow.ellipsis, maxLines: 1,),
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


Widget getFacilityQuickPreview(BuildContext context, DashboardModel model, ListingManagerForm listing, {required Function(ListingManagerForm) didSelectListing}) {
  String? listingImage;

    for (SpaceOption space in listing.listingProfileService.spaceSetting.spaceTypes.value.fold((l) => [], (r) => r)) {
      if (space.quantity.where((element) => element.photoUri != null).isNotEmpty) {
        listingImage = space.quantity.firstWhere((element) => element.photoUri != null).photoUri;
      }
    }

    return InkWell(
      onTap: () {
        didSelectListing(listing);
      },
      child: Container(
        decoration: BoxDecoration(
          color: model.mobileBackgroundColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: PointerInterceptor(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  width: 115,
                  height: 115,
                  color: model.accentColor,
                  child: (listingImage != null) ? Image.network(listingImage, fit: BoxFit.cover) : Icon(Icons.house_outlined, color: model.disabledTextColor),
                ),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: retrieveListingPreviewFacility(
                      context,
                      model,
                      listing,
                  ),
                )
              ),
            ],
          ),
        )
      ),
    );
}