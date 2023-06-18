import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';

Widget emptyLoadingListView(BuildContext context, bool isBrowser) {
  return Container(
    height: (isBrowser) ? MediaQuery.of(context).size.height : MediaQuery.of(context).size.height - 170,
    width: MediaQuery.of(context).size.width,
    child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: loadingRoomItem(context),
          );
        }),
  );
}