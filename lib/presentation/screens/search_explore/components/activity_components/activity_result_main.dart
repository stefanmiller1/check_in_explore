import 'dart:math';
import 'dart:ui';

import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_card.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/discovery_search_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/helper.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/search_explore_widgets/search_explore_helper_core.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:check_in_facade/check_in_facade.dart';
import 'package:flutter/rendering.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class ActivityResultMain extends StatefulWidget {

  final ListingManagerForm? listing;
  final List<ReservationItem> reservations;
  final DashboardModel model;
  final Function(ListingManagerForm listing, ReservationItem res) didSelectEmbeddedRes;

  const ActivityResultMain({super.key, required this.reservations, required this.model, required this.listing, required this.didSelectEmbeddedRes});

  @override
  State<ActivityResultMain> createState() => _ActivityResultMainState();
}

class _ActivityResultMainState extends State<ActivityResultMain> with TickerProviderStateMixin {

  late bool isLoading = false;

  Random random = Random();
  late AnimationController _initAnimateController;
  late AnimationController _animationController;
  late AnimationController _progressAnimationController;

  late Animation<double> _nextPage;
  int _currentPage = 0;
  late final PageController _activityPageController = PageController(initialPage: 0);
  late final Future<List<ReservationPreviewer>> getReservationList;

  Future<List<ReservationPreviewer>> getActivitiesInOrderOfWeight(List<ReservationItem> reservations) async {
    late List<ReservationPreviewer> resToPreview = [];

    for (ReservationItem reservationItem in reservations) {
      late int weight = 0;
      
      ReservationPreviewer resPreview = ReservationPreviewer(
        reservation: reservationItem,
        previewWeight: 0
      );

      try {
        final activityManagerForm = await ActivitySettingsFacade.instance
            .getActivitySettings(
            reservationId: reservationItem.reservationId.getOrCrash()
        );
        resPreview = resPreview.copyWith(
          activityManagerForm: activityManagerForm
        );
        /// has hero images (10 points)
        if (activityManagerForm.profileService.activityBackground.activityProfileImages?.isNotEmpty ?? false) {
          weight += 10;
        }
      } catch (e) {}

      try {
        final activityAttendeesCount = await ActivitySettingsFacade.instance
            .getNumberOfActivityAttendees(
            reservationId: reservationItem.reservationId.getOrCrash()
        );
        resPreview = resPreview.copyWith(
          attendeesCount: activityAttendeesCount
        );
        /// has attendees (1 point per attendee - or 5 points flat?)
        if (activityAttendeesCount != 0) {
          weight += (1 * activityAttendeesCount);
        }
      } catch (e) {}

      try {

        final activityDiscussionChats = await ActivitySettingsFacade.instance
            .getNumberOfChatsInDiscussion(
            reservationId: reservationItem.reservationId.getOrCrash()
        );
        /// has discussions (2 points)
        if (activityDiscussionChats != 0) {
          weight += (1* activityDiscussionChats);
        }
      } catch (e) {}


      resPreview = resPreview.copyWith(
          previewWeight: weight
      );
      
      resToPreview.add(resPreview);
    }

    /// order from highest weight to smallest
    return resToPreview.sorted((a, b) => b.previewWeight.compareTo(a.previewWeight));
  }


  void updateStateSafely() {
      Future.delayed(const Duration(milliseconds: 750), () {
          isLoading = false;
      });
  }

  @override
  void initState() {
    getReservationList = getActivitiesInOrderOfWeight(widget.reservations);
    // updateStateSafely();

    int randomNumber = 5 + random.nextInt(10 - 5);
    _initAnimateController = AnimationController(vsync: this, duration: const Duration(seconds: 1, milliseconds: 300));
    //Start at the controller and set the time to switch pages
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: randomNumber));
    _progressAnimationController = AnimationController(vsync: this, duration: Duration(seconds: randomNumber), value: 1.0);
    _nextPage = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    //Add listener to AnimationController for know when end the count and change to the next page
    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.reset(); //
        // Reset the controller
        final int page = widget.reservations.length; //Number of pages in your PageView
        if (_currentPage < page - 1) {
          _currentPage++;


          _activityPageController.animateToPage(_currentPage,
              duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);

        } else  {
          _currentPage = 0;
          if (_activityPageController.positions.isNotEmpty) {
            _activityPageController.animateToPage(0,
                duration: const Duration(milliseconds: 300), curve: Curves.easeInSine);
          }
        }
      }
    });

    if (mounted) {
      _initAnimateController.forward();
    }
    super.initState();
  }

  @override
  void dispose() {
    _initAnimateController.dispose();
    _animationController.dispose();
    _progressAnimationController.dispose();
    isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();

    return SlideTransition(
        position: Tween<Offset>(
        begin: Offset(0.1, 0.0), // Start from below
        end: Offset.zero).animate(_initAnimateController),
      child: FadeTransition(
        opacity: _initAnimateController,
        child: FutureBuilder<List<ReservationPreviewer>>(
          future: getReservationList,
          builder: (context, snap) {
            final reservationList = snap.data ?? [];

            return SizedBox(
              // height: panelHeight(context) - listingHeaderHeight - 125,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        _animationController.stop();
                        _progressAnimationController.stop();
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        _animationController.forward();
                        _progressAnimationController.forward();
                      });
                    },
                    child: GestureDetector(
                      onLongPressStart: (_) {
                        setState(() {
                          _animationController.stop();
                          _progressAnimationController.stop();
                        });
                      },
                      onLongPressEnd: (_) {
                        setState(() {
                          _animationController.forward();
                          _progressAnimationController.forward();
                        });
                      },
                      onLongPressCancel: () {
                        setState(() {
                          _animationController.forward();
                          _progressAnimationController.forward();
                        });
                      },
                      child: PageView.builder(
                          controller: _activityPageController,
                          itemCount: reservationList.length,
                          onPageChanged: (page) {
                            setState(() {
                              _currentPage = page;
                              if (kIsWeb) _animationController.stop();
                            });
                          },
                          itemBuilder: (context, index) {

                            final ReservationPreviewer preview = reservationList[index];

                            /// happening now!
                            /// most anticipated
                            /// media
                            /// when reservation starts
                            /// reservation owner
                            /// current attendees?
                            /// become a vendor/partner/instructor?
                            /// if over threshold show main image as discussion media
                            /// if over threshold show discussion text

                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                // Container(
                                //   width: MediaQuery.of(context).size.width,
                                //   height: MediaQuery.of(context).size.height,
                                // ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                        preview.activityManagerForm?.profileService.activityBackground.activityProfileImages?.first.uriPath ?? '',
                                        errorBuilder: (context, err, stack) {
                                          return getActivityTypeTabOption(
                                              context,
                                              widget.model,
                                              40,
                                              false,
                                              getActivityOptions().firstWhere((element) => element.activityId == preview.reservation?.reservationSlotItem.first.selectedActivityType)
                                          );
                                        },
                                      fit: BoxFit.cover
                                    ),
                                  ),
                                ),

                                /// footer details container
                                bottomFooterDetails(
                                    context,
                                    widget.model,
                                    preview,
                                    didSelectItem: () {
                                    if (widget.listing != null) {
                                      widget.didSelectEmbeddedRes(widget.listing!, preview.reservation!);
                                    }
                                  }
                                ),
                                /// header detail container
                                /// starting soon...
                                /// if popular
                                /// happening now (or should be header?)?
                                if (showHeader(preview)) Positioned(
                                  left: 8,
                                  top: 15,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: widget.model.accentColor,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [BoxShadow(
                                          color: Colors.black.withOpacity(0.58),
                                          spreadRadius: 1,
                                          blurRadius: 15,
                                          offset: Offset(0, 2)
                                        )
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Text(getHeaderState(preview), style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                                          const SizedBox(width: 2.5),
                                          Icon(getIconForHeaderState(preview), color: widget.model.paletteColor),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  height: 3,
                                  width: MediaQuery.of(context).size.width,
                                  child: TweenAnimationBuilder<double>(
                                    duration: _progressAnimationController.duration ?? Duration(seconds: 3),
                                    curve: Curves.easeInOut,
                                    tween: Tween<double>(
                                      begin: 0,
                                      end: _progressAnimationController.value,
                                    ),
                                    builder: (context, value, _) =>
                                        LinearProgressIndicator(
                                            minHeight: 3,
                                            backgroundColor: widget.model.paletteColor,
                                            value: value,
                                            valueColor: AlwaysStoppedAnimation<Color>(widget.model.accentColor),
                                  ),
                                ),
                              )
                            ],
                            );
                        }
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List<int>.generate(reservationList.length, (int index) => index + 1).asMap().map(
                                (index, e) => MapEntry(index,
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                  child: Container(
                                    height: 6,
                                    // width: ((MediaQuery.of(context).size.width ~/ reservations.length) * 0.75).toDouble(),
                                    decoration: BoxDecoration(
                                        color: (index == _currentPage) ? widget.model.paletteColor : widget.model.paletteColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                  ),
                                ),
                              ),
                            )
                        ).values.toList(),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}