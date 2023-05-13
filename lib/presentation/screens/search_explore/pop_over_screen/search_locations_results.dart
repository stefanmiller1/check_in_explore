import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_when_where_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:check_in_facade/check_in_facade.dart';
import 'package:provider/provider.dart';

class SearchLocationsResults extends StatefulWidget {

  final DashboardModel model;

  const SearchLocationsResults({super.key, required this.model});

  @override
  State<SearchLocationsResults> createState() => _SearchLocationsResultsState();
}

class _SearchLocationsResultsState extends State<SearchLocationsResults> {

  late bool _isOpen = false;
  late bool isLoading = false;
  late List<LocationSearchLatLngModel> history = [];

  @override
  void initState() {
    _isOpen = true;
    history.addAll(context.read<ListingsSearchRequirementsBloc>().state.historyLocationSearch?.toList() ?? []);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: (isLoading) ? JumpingDots(numberOfDots: 3, color: widget.model.paletteColor) : null,
        actions: [
          IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.cancel, size: 40, color: widget.model.paletteColor), padding: EdgeInsets.zero),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Hero(
            tag: 'search_location',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 60,
                child: searchSettingsButton(
                  widget.model,
                  didSelectButton: () {
                    setState(() {
                    });
                  },
                  iconItem: Icons.search_rounded,
                  buttonTitle: 'Search Locations',
                  isSelected: false,
                ),
              ),
            ),
          ),

          Positioned(
            top: 70,
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AddressSearchControllerWidget(
                      localization: AppLocalizations.of(context)!.localeName,
                      model: widget.model,
                      update: () {

                      },
                      onQueryChanged: (String e) {

                      },
                      selectionChanged: ({String? addressStr, String? cityStr, String? provinceStateStr, String? placeId, double? lat, double? lng}) async {
                        final LocationSearchLatLngModel location = LocationSearchLatLngModel(
                            addressStr ?? '',
                            cityStr ?? '',
                            provinceStateStr ?? '',
                            lat,
                            lng
                        );
                        history.add(location);

                        isLoading = true;
                        setState(() {
                          context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationIsSomewhereNearChanged(null));
                          context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.locationItemIdRequiredChanged(null));
                          context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationCotyFromMapChanged('$addressStr, $cityStr'));
                          context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationSearchHistoryChanged(history));

                          if (lat != null && lng != null) {
                            MapHelper.mapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                        zoom: 11,
                                        target: LatLng(lat - 0.07, lng)
                                    )
                                )
                            );
                          }
                        });

                        MapHelper.listingStream = FirebaseMapFacade.instance.mapListings(latitude: lat ?? 43.6532, longitude: lng ?? -79.3832, selectedRadius: MapHelper.currentZoom);
                        MapHelper.currentZoom = 12;

                        final listing = await MapHelper.listingStream.first;
                        MapHelper.initMarkers(context, widget.model, listing);


                        Future.delayed(const Duration(seconds: 3, milliseconds: 300), () async {
                          isLoading = false;
                          Navigator.of(context).pop();
                        });
                      },

                      currentCountry: '',
                      currentAddress: context.read<ListingsSearchRequirementsBloc>().state.locationCityFromMap ?? '',
                      onFocusChanged: (bool focus) {
                        setState(() {
                          _isOpen = !focus;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_isOpen) Positioned(
            top: 150,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    /// history list
                    Visibility(
                      visible: context.read<ListingsSearchRequirementsBloc>().state.historyLocationSearch?.isNotEmpty ?? false,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('History', style: TextStyle(color: widget.model.paletteColor, fontWeight: FontWeight.bold)),
                            InkWell(
                              onTap: () {},
                              child: Text('Clear', style: TextStyle(color: widget.model.paletteColor, decoration: TextDecoration.underline),),
                            ),
                            // const SizedBox(width: 1) .
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                        visible: context.read<ListingsSearchRequirementsBloc>().state.historyLocationSearch?.isNotEmpty ?? false,
                        child: SingleChildScrollView(
                          child: Column(
                            children: context.read<ListingsSearchRequirementsBloc>().state.historyLocationSearch?.map(
                                    (e) => ListTile(
                                  onTap: () {
                                  },
                                  title: Text('${e.address}'),
                                  subtitle: Text('${e.city}, ${e.provinceState}'),
                                  trailing: Icon(Icons.history_sharp, color: widget.model.disabledTextColor),
                                )
                      ).toList() ?? [],
                    ),
                        )
                  )
                ],
              ),
            )
          ),

        ],
      ),
    );
  }
}