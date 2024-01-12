import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';

Widget loadingCard(BuildContext context) {
  return Container(
    child: Row(
      children: [
        Container(
          height: 40,
          width: 40,
        )
      ],
    ),
  );
}

Widget getImageItemSelectionTabWidget(BuildContext context, DashboardModel model, int length, int currentPageIndex) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
    child: Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List<int>.generate(length, (int index) => index + 1).asMap().map(
                (index, e) => MapEntry(index,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Container(
                    height: 6,
                    // width: ((MediaQuery.of(context).size.width ~/ reservations.length) * 0.75).toDouble(),
                    decoration: BoxDecoration(
                        color: (index == currentPageIndex) ? model.paletteColor : model.paletteColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15)
                    ),
                  ),
                ),
              ),
            )
        ).values.toList(),
      ),
    ),
  );
}