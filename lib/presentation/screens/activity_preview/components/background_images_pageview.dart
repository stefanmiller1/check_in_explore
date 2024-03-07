import 'dart:typed_data';
import 'dart:ui';

import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityBackgroundImagePreview extends StatefulWidget {

  final ActivityManagerForm activityForm;
  final DashboardModel model;
  final ReservationItem reservation;

  const ActivityBackgroundImagePreview({super.key, required this.activityForm, required this.model, required this.reservation});

  @override
  State<ActivityBackgroundImagePreview> createState() => _ActivityBackgroundImagePreviewState();
}

class _ActivityBackgroundImagePreviewState extends State<ActivityBackgroundImagePreview> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;

  int _currentPage = 0;
  late final PageController _activityPageController = PageController(initialPage: 0);

  @override
  void initState() {

    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 5));


    //Add listener to AnimationController for know when end the count and change to the next page
    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.completed) {
        setState(() {
        _animationController.reset(); //
        // Reset the controller
        final int page = widget.activityForm.profileService.activityBackground.activityProfileImages?.length ?? 0; //Number of pages in your PageView
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
        });
      }
    });
    super.initState();
  }

  DateTime? upcomingDateOrFinished() {
    return widget.reservation.reservationSlotItem.map((e) => e.selectedDate).where((element) => element.isAfter(DateTime.now())).isNotEmpty ? widget.reservation.reservationSlotItem.map((e) => e.selectedDate).where((element) => element.isAfter(DateTime.now())).first : null;
  }

  bool currentDateIsReservationDate(DateTime? nextDate) {
    if (nextDate?.year == DateTime.now().year && nextDate?.month == DateTime.now().month && nextDate?.day == DateTime.now().day) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 285,
            child: PageView.builder(
                controller: _activityPageController,
                itemCount: widget.activityForm.profileService.activityBackground.activityProfileImages?.length ?? 1,
                onPageChanged: (page) {
                  _currentPage = page;
                },
                itemBuilder: (context, index) {

                  final Uint8List? activityImageMemory = widget.activityForm.profileService.activityBackground.activityProfileImages?[index].imageToUpload;
                  final String? activityImage = widget.activityForm.profileService.activityBackground.activityProfileImages?[index].uriPath;
                  if (activityImage != null || activityImageMemory != null) {
                    return ImageWithProgressIndicator(
                        showProgress: widget.activityForm.profileService.activityBackground.activityProfileImages?.length != 1,
                        image: (activityImageMemory != null) ? Image.memory(activityImageMemory, fit: BoxFit.cover) : Image.network(activityImage!, fit: BoxFit.cover),
                        model: widget.model);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: getActivityTypeTabOption(
                        context,
                        widget.model,
                        200,
                        false,
                        getActivityOptions().firstWhere((element) => element.activityId == widget.reservation.reservationSlotItem.first.selectedActivityType)
                  ),
                );
              }
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: currentDateIsReservationDate(upcomingDateOrFinished()) ? widget.model.paletteColor : widget.model.webBackgroundColor.withOpacity(0.83),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      /// date that event is happening on (and subsequent dates if)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(CupertinoIcons.calendar_today, size: 38, color: currentDateIsReservationDate(upcomingDateOrFinished()) ? widget.model.accentColor : widget.model.disabledTextColor.withOpacity(0.5)),
                      ),
                      /// get date based on current date and upcoming reservation
                      Column(
                        children: [
                          (upcomingDateOrFinished() != null) ? Text(DateFormat.MMM().format(upcomingDateOrFinished()!), style: TextStyle(color: currentDateIsReservationDate(upcomingDateOrFinished()) ? widget.model.accentColor : widget.model.disabledTextColor.withOpacity(0.5), fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)) : Container(
                              decoration: BoxDecoration(
                                  color:  widget.model.disabledTextColor.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('Finished', style: TextStyle(color: widget.model.webBackgroundColor, fontWeight: FontWeight.bold, fontSize: widget.model.secondaryQuestionTitleFontSize)),
                              )),
                          if (upcomingDateOrFinished() != null) Text(DateFormat.d().format(upcomingDateOrFinished()!), style: TextStyle(color: currentDateIsReservationDate(upcomingDateOrFinished()) ? widget.model.accentColor : widget.model.disabledTextColor.withOpacity(0.5), fontWeight: FontWeight.bold, fontSize: widget.model.questionTitleFontSize))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}


class ImageWithProgressIndicator extends StatefulWidget {

  final Image image;
  final bool showProgress;
  final DashboardModel model;

  const ImageWithProgressIndicator({super.key, required this.image, required this.model, required this.showProgress});

  @override
  State<ImageWithProgressIndicator> createState() => _ImageWithProgressIndicatorState();
}


class _ImageWithProgressIndicatorState extends State<ImageWithProgressIndicator> with SingleTickerProviderStateMixin {

  late AnimationController _progressAnimationController;

  @override
  void initState() {
    _progressAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 5), value: 0);
    super.initState();
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _progressAnimationController.forward();

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
            height: 285,
            width: MediaQuery.of(context).size.width,
            child: widget.image),
        if (widget.showProgress) SizedBox(
          height: 3,
          width: MediaQuery.of(context).size.width,
          child: TweenAnimationBuilder<double>(
            duration: _progressAnimationController.duration ?? Duration(seconds: 3),
            curve: Curves.easeInOut,
            tween: Tween<double>(
              begin: _progressAnimationController.value,
              end: 1,
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
}