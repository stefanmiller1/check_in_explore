import 'dart:ui';

import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:check_in_presentation/core/cancellation_core/cancellation_helper.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/widgets.dart';
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_domain/domain/misc/filter_services/vendor_contact_filter_model.dart';

class ActivityVendorRejectionPopOver extends StatefulWidget {

  final DashboardModel model;
  final String currency;
  final List<VendorContactDetail> rejectionList;
  final Function() didSelectReject;

  const ActivityVendorRejectionPopOver({super.key, required this.model, required this.didSelectReject, required this.rejectionList, required this.currency});

  @override
  State<ActivityVendorRejectionPopOver> createState() => _ActivityVendorRejectionPopOverState();
}

class _ActivityVendorRejectionPopOverState extends State<ActivityVendorRejectionPopOver> {

  late CancelMarker navItem = CancelMarker.cancelReason;
  late CancellationRequestType? cancellationType = null;
  late TextEditingController? backgroundDescriptionController;

  late PageController? pageController = null;
  late bool isLoading = false;



  @override
  void initState() {
    backgroundDescriptionController = TextEditingController();
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    backgroundDescriptionController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: widget.model.paletteColor,
        title: Text(
          'Rejections', style: TextStyle(color: widget.model.accentColor),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.cancel, color: widget.model.accentColor, size: 40,),
          tooltip: 'Cancel',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: getMainContainer(context),
    );
  }


  Widget getMainContainer(BuildContext context) {

    List<Widget> rejectionContainerModel(BuildContext context) => [
      Container(
        child: getCancelReason(
          widget.model,
          'Send Booth Rejections',
          cancellationType,
          didSelectType: (type) {
            setState(() {
              cancellationType = type;
            });
          },
        ),
      ),
      Container(
        child: getCancelMessageReason(
            context,
            widget.model,
            backgroundDescriptionController!,
            'Everyone',
            didUpdateText: (text) {
            setState(() {

            });
          }
        ),
      ),
      Container(
        child: getCancelReviewRefund(
          widget.model,
          attendeeVendorFee(widget.rejectionList.map((e) => e.boothItem).toList()).toDouble(),
          widget.currency,
          'Cancelling from ${widget.rejectionList.map((e) => e.attendee.attendeeOwnerId).toSet().length} Applicants',
          'Refunding ${widget.rejectionList.length} Booths'
        ),
      )
    ];

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
            color: widget.model.webBackgroundColor,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height
        ),

        CreateNewMain(
            isPreviewer: false,
            isLoading: isLoading,
            model: widget.model,
            pageController: pageController,
            onPageChanged: (index) {

            },
            child: rejectionContainerModel(context),
        ),


        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Container(
            height: 90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (pageController?.positions.isNotEmpty == true && pageController?.page != 0) {
                                  pageController?.animateToPage((pageController?.page ?? 0).toInt() - 1, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
                                }
                                switch (navItem) {
                                  case CancelMarker.cancelReason:
                                    Navigator.of(context).pop();
                                    break;
                                  case CancelMarker.cancelMessage:
                                    navItem = CancelMarker.cancelReason;
                                    break;
                                  case CancelMarker.submit:
                                    navItem = CancelMarker.cancelMessage;
                                    break;
                                  case CancelMarker.finished:
                                    navItem = CancelMarker.submit;
                                    break;
                                }
                              });
                            },
                            icon: Icon(Icons.arrow_back_ios, color: widget.model.paletteColor)
                        ),
                        const SizedBox(width: 4.5),

                        Visibility(
                          visible: attendeeVendorFee(widget.rejectionList.map((e) => e.boothItem).toList()).toDouble() != 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Missed Earnings', style: TextStyle(color: widget.model.disabledTextColor, fontSize: widget.model.secondaryQuestionTitleFontSize,), maxLines: 1,),
                              Text(completeTotalPriceWithCurrency(
                                      (attendeeVendorFee(widget.rejectionList.map((e) => e.boothItem).toList())).toDouble() +
                                      (attendeeVendorFee(widget.rejectionList.map((e) => e.boothItem).toList())).toDouble()*CICOReservationPercentageFee +
                                      (attendeeVendorFee(widget.rejectionList.map((e) => e.boothItem).toList())).toDouble()*CICOTaxesFee, widget.currency), style: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                    )
                ),

                Visibility(
                  visible: isCompleteCurrentTab(navItem, cancellationType, backgroundDescriptionController?.text),
                  child:  InkWell(
                    onTap: () {
                      setState(() {
                        if (pageController?.positions.isNotEmpty == true && pageController?.page != 3) {
                          pageController?.animateToPage((pageController?.page ?? 0).toInt() + 1, duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
                        }
                        switch (navItem) {
                          case CancelMarker.cancelReason:
                            navItem = CancelMarker.cancelMessage;
                            break;
                          case CancelMarker.cancelMessage:
                            navItem = CancelMarker.submit;
                            break;
                          case CancelMarker.submit:
                            Navigator.of(context).pop();
                            widget.didSelectReject();
                            break;
                          case CancelMarker.finished:
                            break;
                        }
                      });
                    },
                    child: Container(
                      constraints: BoxConstraints(
                          maxWidth: 200
                      ),
                      height: 45,
                      width: 185,
                      decoration: BoxDecoration(
                        color: widget.model.paletteColor,
                        borderRadius: const BorderRadius.all(Radius.circular(40)),
                      ),
                      child: Center(child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(getForwardButtonTitle(navItem), style: TextStyle(color: widget.model.accentColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
                      )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),


      ],
    );
  }
}