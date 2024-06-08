import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_facade/check_in_facade.dart' as facade;
import 'package:check_in_web_mobile_explore/presentation/core/components/search_widgets/search_profile_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/discovery_components/discovery_hero_main_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/discovery_components/discovery_listigs_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/search_explore_widgets/search_explore_helper_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoverySearchComponent extends StatefulWidget {

  final DashboardModel model;
  final Function(ListingManagerForm) didSelectListing;

  const DiscoverySearchComponent({super.key, required this.model, required this.didSelectListing});

  @override
  State<DiscoverySearchComponent> createState() => _DiscoverySearchComponentState();
}

class _DiscoverySearchComponentState extends State<DiscoverySearchComponent> {


  late List<ReservationPreviewer> discoveryFeed = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.model.webBackgroundColor,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),

          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 85),
                getWeeklyDiscoveryMainContainer(),
                // const SizedBox(height: 12),
                // getDiscoveryFeedNearYou(),
                // const SizedBox(height: 12),
                // getDiscoveryFeedCommunities(),
                const SizedBox(height: 12),
                getNextFewHoursMainContainer(),
                const SizedBox(height: 12),
                getListingsBasedOnTypeMainContainer(),
                const SizedBox(height: 12),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: InkWell(
                onTap: () {
                  didSelectSearchedUser(
                      context: context,
                      model: widget.model,
                      currentUserId: facade.FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                      didSelectContact: (contact) {
                        Navigator.of(context).pop();

                    }
                  );
                },
                child: Container(
                  height: 55,
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    color: widget.model.accentColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: widget.model.disabledTextColor.withOpacity(0.25), width: 1),
                      boxShadow: [
                        BoxShadow(
                            color: widget.model.paletteColor.withOpacity(0.08),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 2)
                      )
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 8),
                        Icon(Icons.search_rounded, color: widget.model.disabledTextColor),
                        const SizedBox(width: 8),
                        Text('Search Communities or People', style: TextStyle(fontSize: widget.model.secondaryQuestionTitleFontSize, color: widget.model.disabledTextColor)
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// retrieve all reservations based on listings & confirmed, completed & current bookings that will happen between now and 7 days and that have happened in the last 7 days. sort by preview alg.
  /// is there a way to get the best 10?
  Widget getWeeklyDiscoveryMainContainer() {
    /// limit query to reservations happening over the next 7 days.
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(const ReservationManagerWatcherEvent.watchDiscoveryReservationsList([ReservationSlotState.confirmed] ,168, null)),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadDiscoveryReservationItemSuccess: (e) {
                return (e.item.isNotEmpty) ? getDiscoveryFeedHeader(e.item) : Container();
              },
              orElse: () => Container()
          );
        },
      ),
    );
  }

  Widget getNextFewHoursMainContainer() {
    return BlocProvider(create: (_) => getIt<ReservationManagerWatcherBloc>()..add(const ReservationManagerWatcherEvent.watchDiscoveryReservationsList([ReservationSlotState.current], null, null)),
      child: BlocBuilder<ReservationManagerWatcherBloc, ReservationManagerWatcherState>(
        builder: (context, state) {
          return state.maybeMap(
              loadDiscoveryReservationItemSuccess: (e) {
                return (e.item.isNotEmpty) ? getDiscoveryUpComingTodayOrHalfDay(e.item) : Container();
              },
              orElse: () => Container()
          );
        },
      ),
    );
  }


  Widget getListingsBasedOnTypeMainContainer() {
    return BlocProvider(create: (_) => getIt<PublicListingWatcherBloc>()..add(PublicListingWatcherEvent.watchAllPublicListingsSearchStarted([ManagerListingStatusType.finishSetup], null, null, null)),
          child: BlocBuilder<PublicListingWatcherBloc, PublicListingWatcherState>(
            builder: (context, state) {
              return state.maybeMap(
                  loadAllSearchedPublicListingItemsSuccess: (e) => getListingsThisWeekForDiscovery(e.items),
                  orElse: () => Container()
            );
          },
        )
      );
  }

  /// filter by user activity
  /// option to show all
  /// organize by
  /// video horizontal paging controller (on mobile)
  /// call all listings? (sort/order by latest first? or last booking made time?)

  Widget getDiscoveryFeedHeader(List<ReservationItem> resPreview) {

    if (resPreview.isEmpty) {
      return Container();
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                constraints: BoxConstraints(maxWidth: 850),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text('Unforgettable Experiences Starting This Week', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                    const SizedBox(height: 12),
                  ],
                ),
              ),


              Center(
                child: SizedBox(
                  height: 565,
                  width: MediaQuery.of(context).size.width,
                  child: DiscoveryHeroMainWidget(
                      reservations: resPreview,
                      model: widget.model,
                  ),
                ),
              )

        ],
      ),
    );
  }

  /// communities you may know?
  Widget getDiscoveryFeedNearYou() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Text('Happening Soon Near you', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget getDiscoveryFeedCommunities() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Text('Communities You Might Know?', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
        const SizedBox(height: 8),
      ],
    );
  }

  /// see all options
  /// show number of all
  Widget getDiscoveryUpComingTodayOrHalfDay(List<ReservationItem> reservations) {
    if (reservations.isEmpty) {
      return Container();
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text('Happening Now!', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
                const SizedBox(height: 8),
              ],
            ),
          ),

          Center(
            child: Container(
              height: 565,
              width: MediaQuery.of(context).size.width,
              child: DiscoveryHeroMainWidget(
                reservations: reservations,
                model: widget.model,
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget getListingsThisWeekForDiscovery(List<ListingManagerForm> listings) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text('Great for Organizers', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize)),
          const SizedBox(height: 8),

          /// number of slots this week?
          Center(
            child: Container(
              height: 360,
              width: MediaQuery.of(context).size.width,
              child: DiscoveryListingWidget(
                listings: listings,
                model: widget.model,
                activityFilterType: ProfileActivityOption.toRent,
                didSelectListing: (ListingManagerForm listing) {
                  widget.didSelectListing(listing);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

}