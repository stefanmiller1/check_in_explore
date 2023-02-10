import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';

Widget reservationPostWidget(BuildContext context, DashboardModel model) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
    ),
  );
}