import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/discovery_search_helper.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:check_in_facade/check_in_facade.dart';

class DiscoveryHeroMainWidget extends StatefulWidget {

  final DashboardModel model;
  final List<ReservationItem> reservations;

  const DiscoveryHeroMainWidget({super.key, required this.reservations, required this.model});

  @override
  State<DiscoveryHeroMainWidget> createState() => _DiscoveryHeroMainWidgetState();
}

class _DiscoveryHeroMainWidgetState extends State<DiscoveryHeroMainWidget> {

  int _currentPage = 0;
  late bool showButton = false;
  late final Future<List<ReservationPreviewer>> getReservationList;


  Future<List<ReservationPreviewer>> getWeightedDiscoveryFeed(List<ReservationItem> reservations) async {
    late List<ReservationPreviewer> resToPreview = [];

    for (ReservationItem reservationItem in reservations) {
      late int weight = 0;

      ReservationPreviewer resPreview = ReservationPreviewer(
          reservation: reservationItem,
          previewWeight: weight
      );

      try {
        final activityManagerForm = await ActivitySettingsFacade.instance
            .getActivitySettings(
            reservationId: reservationItem.reservationId.getOrCrash()
        );


        resPreview = resPreview.copyWith(
            activityManagerForm: activityManagerForm
        );

        /// is looking for vend. or merch
        if (activityManagerForm.profileService.activityRequirements.eventActivityRulesRequirement?.isMerchantInviteOnly == true) {
          weight += 2;
        }
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

      resPreview = resPreview.copyWith(
          previewWeight: weight
      );
      resToPreview.add(resPreview);
    }

    return resToPreview.sorted((a, b) => b.previewWeight.compareTo(a.previewWeight));
  }

  @override
  void initState() {
    // _reservationPageController = PageController(initialPage: 0, viewportFraction: (Responsive.isDesktop(context)) ? 0.2 : 0.65);
    getReservationList = getWeightedDiscoveryFeed(widget.reservations);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PageController _reservationPageController = PageController(viewportFraction: 380 / MediaQuery.of(context).size.width);


    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (e) {
        setState(() {
          showButton = true;
        });
      },
      onHover: (e) {
        setState(() {
          showButton = true;
        });
      },
      onExit: (e) {
        setState(() {
          showButton = false;
        });
      },
      child: FutureBuilder<List<ReservationPreviewer>>(
          future: getReservationList,
          builder: (context, snap) {
            final reservationList = snap.data ?? [];

            return Stack(
              alignment: Alignment.topCenter,
              children: [

                PageView.builder(
                    padEnds: false,
                    controller: _reservationPageController,
                    itemCount: reservationList.length,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      final ReservationPreviewer preview = reservationList[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: 380,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.11),
                                      spreadRadius: 1,
                                      blurRadius: 15,
                                      offset: Offset(0, 2)
                                  )
                                ]
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                    (preview.activityManagerForm?.profileService.activityBackground.activityProfileImages?.isNotEmpty ?? false) ? preview.activityManagerForm?.profileService.activityBackground.activityProfileImages?.first.uriPath ?? '' : '',
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
                            Container(
                              width: 380,
                              child: bottomFooterDetails(
                                  context,
                                  widget.model,
                                  preview,
                                  didSelectItem: () {

                                  }
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                ),

                AnimatedOpacity(
                  duration: Duration(milliseconds: 350),
                  opacity: (showButton) ? 1 : 0,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color:  widget.model.paletteColor,
                                border: Border.all(color: widget.model.paletteColor, width: 0.5),
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _reservationPageController.animateToPage(_currentPage - 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                                });
                              },
                              icon: Icon(Icons.arrow_back_ios_new_rounded, color: widget.model.disabledTextColor),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: widget.model.paletteColor,
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _reservationPageController.animateToPage(_currentPage + 1, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
                                });
                              },
                              icon: Icon(Icons.arrow_forward_ios_rounded, color: widget.model.disabledTextColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        }
      ),
    );
  }

  Widget isLoadingDiscoveryHeroWidget() {
    return Container();
  }


}
