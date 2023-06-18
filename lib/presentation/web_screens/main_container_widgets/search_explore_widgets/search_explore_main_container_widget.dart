import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';

class SearchExploreMainContainerWidget extends StatefulWidget {

  final DashboardModel model;

  const SearchExploreMainContainerWidget({super.key, required this.model});

  @override
  State<SearchExploreMainContainerWidget> createState() => _SearchExploreMainContainerWidgetState();
}

class _SearchExploreMainContainerWidgetState extends State<SearchExploreMainContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0, left: 30.0, bottom: 30.0, top: 40.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Container(
          // color: Colors.deepOrange,
        ),
      ),
    );
  }
}