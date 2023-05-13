import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/activity_settings/components/activity_availability_widget/select_activity_duration_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityAvailabilitySelectDurationTypePreview extends StatelessWidget {

  final DashboardModel model;

  const ActivityAvailabilitySelectDurationTypePreview({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (_) {
              return ActivityDurationSelection(
                model: model,
                activityCreatorForm: context.read<UpdateActivityFormBloc>().state.activityCreatorForm,
              );
            })
        );
      },
      title: const Text('The Calendar'),
      subtitle: Column(
        children: [

        ],
      ),
    );
  }
}

class ActivityAvailabilitySelectOperatingHours extends StatelessWidget {

  final DashboardModel model;

  const ActivityAvailabilitySelectOperatingHours({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {

      },
      title: Text(''),
    );
  }
}

class ActivityAvailabilitySelectSessionType extends StatelessWidget {

  final DashboardModel model;

  const ActivityAvailabilitySelectSessionType({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {

      },
      title: Text(''),
    );
  }
}


class ActivityAvailabilityReviewPreview extends StatelessWidget {

  final DashboardModel model;
  final ReservationItem reservation;

  const ActivityAvailabilityReviewPreview({super.key, required this.model, required this.reservation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {

      },
      title: const Text('Review Dates'),
      subtitle: Column(
        children: [
          Text('dates: '),

        ],
      ),
    );
  }
}