import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_search_component.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/listing_search_result.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';



class SearchExploreScreen extends StatefulWidget {

  final DashboardModel model;
  final Function(double pos) slidePosition;

  const SearchExploreScreen({super.key, required this.slidePosition, required this.model});

  @override
  State<SearchExploreScreen> createState() => _SearchExploreScreenState();
}

class _SearchExploreScreenState extends State<SearchExploreScreen> {

  final double _initFabHeight = 75.0;
  bool _isOpened = false;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  final double _panelHeightClosed = 75.0;
  late PanelController _panelController;
  @override
  void initState() {
    super.initState();
    _panelController = PanelController();
    _fabHeight = _initFabHeight;

  }

  @override
  void dispose() {
    // SearchHelper.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = panelHeight(context);

    return Responsive(
        mobile: Stack(
          children: [
            SlidingUpPanel(
              color: widget.model.mobileBackgroundColor,
              controller: _panelController,
              maxHeight: _panelHeightOpen,
              minHeight: _panelHeightClosed,
              parallaxEnabled: true,
              parallaxOffset: 0.5,
              backdropTapClosesPanel: false,
              isDraggable: SearchHelper.isPanelDraggable,
              body: MapSearchContainer(
                  model: widget.model,
                  selectedListing: (listingId) {
                    setState(() {
                    });
                },
              ),
              panelBuilder: (sc) {
                return ListingSearchResult(
                    model: widget.model,
                    isOpen: _isOpened,
                    didUpdate: () {
                        setState(() {
                        });
                  },
                );
              },
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24),
                topLeft: Radius.circular(24)
              ),
              onPanelSlide: (pos) {

                setState(() {
                  widget.slidePosition(pos);
                  _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
                });
              },
              onPanelOpened: () {
                setState(() {
                  final int index = context.read<ListingsSearchRequirementsBloc>().state.markers.toList().map((e) => e.markerId).toList().indexWhere((element) => element.value == context.read<ListingsSearchRequirementsBloc>().state.selectedListingId?.getOrCrash());
                  SearchHelper.controller = PageController(
                      initialPage: index,
                      keepPage: false
                  );
                  _isOpened = true;
                });
              },

              onPanelClosed: () {
                setState(() {

                  _isOpened = false;
                  SearchHelper.isPanelDraggable = true;
                });
              },
            ),
          ],
        ),
        tablet: Container(),
        desktop: Container()
    );
  }
}