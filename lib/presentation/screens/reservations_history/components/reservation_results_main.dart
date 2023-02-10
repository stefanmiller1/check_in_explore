import 'dart:math';

import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/profile_reservation_widget.dart';
import 'package:check_in_web_mobile_explore/presentation/core/components/reservation_post_widget.dart';
import 'package:flutter/material.dart';

class ReservationResultMain extends StatefulWidget {

  final ReservationItem reservation;
  final ListingManagerForm listing;
  final DashboardModel model;

  const ReservationResultMain({super.key, required this.reservation, required this.listing, required this.model});

  @override
  State<ReservationResultMain> createState() => _ReservationResultMainState();
}

class _ReservationResultMainState extends State<ReservationResultMain> {

  final _controller = ScrollController();
  double _offset = 0;
  late double _percentageOpen = 0;

 @override
  void initState() {
    _controller.addListener(moveOffset);
    super.initState();
  }

  moveOffset() {
    setState(() {
      _offset = min(max(0, _controller.offset / 6 - 16), 32);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(moveOffset);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            stretch: true,
            pinned: true,
            elevation: 0,
            backgroundColor: widget.model.accentColor,
            flexibleSpace: flexibleReservationProfileHeader(
              context,
              widget.model,
              widget.reservation,
              widget.listing
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 5,
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  return reservationPostWidget(
                    context,
                    widget.model
                  );
                },
              childCount: 20
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 35,
            ),
          ),
        ],
      ),
    );
  }
}