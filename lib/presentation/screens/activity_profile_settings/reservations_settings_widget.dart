import 'dart:collection';

import 'package:check_in_application/auth/update_services/listing_update_create_services/settings_update_create_services/activity_settings/activity_settings_form_bloc.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
/// import supported languages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:check_in_presentation/check_in_presentation.dart';

class ReservationSettingsWidget extends StatefulWidget {
  
  final DashboardModel model;
  final ReservationSlotItem? selectedReservationSlot;

  const ReservationSettingsWidget({Key? key, required this.model, this.selectedReservationSlot}) : super(key: key);

  @override
  State<ReservationSettingsWidget> createState() => _ReservationSettingsWidgetState();
}

class _ReservationSettingsWidgetState extends State<ReservationSettingsWidget> {

  ScrollController? _scrollController;
  final int durationType = 30;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }
  
  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    bool isLessThanMain = (MediaQuery.of(context).size.width <= 1450);
    
    return Container(
      height: 600,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [

          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),

          SingleChildScrollView(
            controller: _scrollController,
            child: (isLessThanMain) ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mainContainerSectionOneRes(
                    context: context,
                    model: widget.model,
                    selectedReservationSlot: widget.selectedReservationSlot,
                    durationType: durationType,
                    timeAgo: timeago.format(context.read<UpdateActivityFormBloc>().state.reservationItem.dateCreated)
                ),
                mainContainerSectionTwo(context),

                /// *** Reservation Pricing Details *** ///
                mainContainerFooterRes(
                    context: context,
                    model: widget.model,
                    state: context.read<UpdateActivityFormBloc>().state
                ),
              ],
            ) : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: mainContainerSectionOneRes(
                        context: context,
                        model: widget.model,
                        selectedReservationSlot: widget.selectedReservationSlot,
                        durationType: durationType,
                        timeAgo: timeago.format(context.read<UpdateActivityFormBloc>().state.reservationItem.dateCreated)
                      ),
                    ),
                    Expanded(child: mainContainerSectionTwo(context)),
                  ],
                ),
                mainContainerFooterRes(
                    context: context,
                    model: widget.model,
                    state: context.read<UpdateActivityFormBloc>().state
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  

  
  Widget mainContainerSectionTwo(BuildContext context) {
    return Column(
      children: [

      ],
    );
  }

}