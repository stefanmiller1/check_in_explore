import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_search_component.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/search_components/search_helper.dart';
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

  final double _initFabHeight = 0;
  bool _isOpened = false;
  double _fabHeight = 0;
  double _panelHeightOpen = 0;
  double _panelHeightClosed(context) => 100;
  late PanelController _panelController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _panelController = PanelController();
    // _scrollController = ScrollController();
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
    SearchExploreWebHelperCore.isPanelDraggable = context.read<ListingsSearchRequirementsBloc>().state.markers.isNotEmpty;

    return Responsive(
        mobile: searchExploreControllerMobile(),
        tablet: Container(),
        desktop: Container()
    );
  }

  Widget searchExploreControllerMobile() {
    return Stack(
      children: [
        SlidingUpPanel(
          color: widget.model.mobileBackgroundColor,
          controller: _panelController,
          maxHeight: _panelHeightOpen,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          minHeight: _panelHeightClosed(context),
          parallaxEnabled: true,
          parallaxOffset: 0.23,
          backdropTapClosesPanel: true,
          backdropEnabled: true,
          backdropOpacity: 0.15,
          panelSnapping: true,
          renderPanelSheet: false,
          isDraggable: SearchExploreWebHelperCore.isPanelDraggable,
          body: MapSearchContainer(
            model: widget.model,
            selectedListing: (listingId) {
              setState(() {
              });
            },
            didSelectListingPreview: (ListingManagerForm ) {

            },
          ),
          panelBuilder: (pc) {
            return ListingSearchResult(
              model: widget.model,
              isOpen: _isOpened,
              controller: pc,
              panelController: _panelController,
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
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed(context)) + _initFabHeight;
            });
          },
          onPanelOpened: (pc) {
            _isOpened = true;
          },
          onPanelClosed: (pc) {
            setState(() {
              _isOpened = false;
              SearchExploreWebHelperCore.isPanelDraggable = true;
            });
          },
        ),
      ],
    );
  }
}