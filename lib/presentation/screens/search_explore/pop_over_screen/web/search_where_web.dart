import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/map_helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_locations_results.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_when_where_helper.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';

class SearchWhereWeb extends StatefulWidget {

  final DashboardModel model;
  final Function() didSelectItem;

  const SearchWhereWeb({super.key, required this.model, required this.didSelectItem});

  @override
  State<SearchWhereWeb> createState() => _SearchWhereWebState();
}

class _SearchWhereWebState extends State<SearchWhereWeb> {


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          searchListItem(
              context,
              widget.model,
              isSelected: true,
              tagTitle: 'search_tag',
              didSelectItem: widget.didSelectItem,
              isFinishedSelection: (context.read<ListingsSearchRequirementsBloc>().state.locationItemId != null) || (context.read<ListingsSearchRequirementsBloc>().state.isSomeWhereNear != null) || (context.read<ListingsSearchRequirementsBloc>().state.locationCityFromMap != null),
              iconItem: Icons.search_rounded,
              selectedTitle: 'Where Abouts?',
              defaultTitle: 'Where Would You Like to Be?',
              subTitle: (context.read<ListingsSearchRequirementsBloc>().state.locationItemId != null) ? getMapOptions.firstWhere((element) => element.locationItemId == context.read<ListingsSearchRequirementsBloc>().state.locationItemId).locationTitle : (context.read<ListingsSearchRequirementsBloc>().state.isSomeWhereNear ?? false) ? 'Somewhere Near Me' : (context.read<ListingsSearchRequirementsBloc>().state.locationCityFromMap != null) ? context.read<ListingsSearchRequirementsBloc>().state.locationCityFromMap! : 'Pick an Area'
          ),
          const SizedBox(height: 15),

          Container(
            decoration: BoxDecoration(
              color: widget.model.accentColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  searchSettingsButton(
                    widget.model,
                    didSelectButton: () {
                      setState(() {
                        showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: 'Search Location',
                            // barrierColor: widget.model.disabledTextColor.withOpacity(0.34),
                            transitionDuration: Duration(milliseconds: 350),
                            pageBuilder: (BuildContext contexts, anim1, anim2) {
                              return Scaffold(
                                backgroundColor: Colors.transparent,
                                body: PointerInterceptor(
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Container(
                                        height: 650,
                                        width: 550,
                                        decoration: BoxDecoration(
                                            color: widget.model.accentColor,
                                            borderRadius: BorderRadius.all(Radius.circular(25))
                                        ),
                                        child: SearchLocationsResults(
                                          model: widget.model,
                                          locationHistory: context.read<ListingsSearchRequirementsBloc>().state.historyLocationSearch?.toList() ?? [],
                                          onSelectionChanged: ({String? addressStr, String? cityStr, double? lat, double? lng, String? placeId, String? provinceStateStr}) {
                                            setState(() {
                                              context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationIsSomewhereNearChanged(null));
                                              context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.locationItemIdRequiredChanged(null));
                                              context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationCotyFromMapChanged('$addressStr, $cityStr'));
                                              widget.didSelectItem();
                                            });
                                          },
                                          onTapClearHistory: () {
                                            setState(() {
                                              context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationSearchHistoryChanged([]));
                                            });
                                          },
                                          onTapLocationHistory: (historyItem) {
                                            setState(() {
                                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationIsSomewhereNearChanged(null));
                                            context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.locationItemIdRequiredChanged(null));
                                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationCotyFromMapChanged('${historyItem.address}, ${historyItem.city}'));
                                            });
                                          },
                                          locationCityFromMap: context.read<ListingsSearchRequirementsBloc>().state.locationCityFromMap ?? '',
                                          historyDidChange: (history) {
                                            setState(() {
                                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationSearchHistoryChanged(history));
                                            });
                                          },
                                          didFinishSelection: () {
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            transitionBuilder: (context, anim1, anim2, child) {
                              return Transform.scale(
                                  scale: anim1.value,
                                  child: Opacity(
                                      opacity: anim1.value,
                                      child: child
                                  )
                              );
                            },
                        );
                      });
                    },
                    iconItem: Icons.search_rounded,
                    buttonTitle: 'Search Locations',
                    isSelected: false,
                  ),
                  const SizedBox(height: 10),
                  listOfDefaultLocations(
                      widget.model,
                      context.read<ListingsSearchRequirementsBloc>().state.locationItemId,
                      didSelectItem: (selectedItem) {
                        setState(() {
                          context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.locationIsSomewhereNearChanged(null));
                          context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.locationCotyFromMapChanged(null));

                          if (selectedItem.locationItemId == context.read<ListingsSearchRequirementsBloc>().state.locationItemId) {
                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationItemIdRequiredChanged(null));
                          } else {
                            widget.didSelectItem;
                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationItemIdRequiredChanged(selectedItem.locationItemId));
                            MapHelper.mapController.animateCamera(
                                CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                        zoom: getMapOptions.firstWhere((element) => element.locationItemId == selectedItem.locationItemId).zoom,
                                        target: getMapOptions.firstWhere((element) => element.locationItemId == selectedItem.locationItemId).locationPosition
                              )
                            )
                          );
                        }
                      });
                    }
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: searchSettingsButton(
                            widget.model,
                            didSelectButton: () async {
                              setState(() {
                                if (!(context.read<ListingsSearchRequirementsBloc>().state.isSomeWhereNear ?? false)) {
                                  widget.didSelectItem;
                                }
                                context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.locationItemIdRequiredChanged(null));
                                context.read<ListingsSearchRequirementsBloc>().add(const ListingsSearchRequirementsEvent.locationCotyFromMapChanged(null));

                                context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.locationIsSomewhereNearChanged(!(context.read<ListingsSearchRequirementsBloc>().state.isSomeWhereNear ?? false)));
                              });


                              if (!(context.read<ListingsSearchRequirementsBloc>().state.isSomeWhereNear ?? false)) {
                                Position position = await MapHelper.determineCurrentPosition(context, widget.model);
                                MapHelper.mapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            zoom: 12,
                                            target: LatLng(position.latitude, position.longitude)
                                    )
                                  )
                                );
                              }
                            },
                            iconItem: Icons.location_on_outlined,
                            buttonTitle: 'Somewhere Near Me..',
                            isSelected: context.read<ListingsSearchRequirementsBloc>().state.isSomeWhereNear ?? false
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: searchSettingsButton(
                            widget.model,
                            didSelectButton: () {
                              setState(() {
                                widget.didSelectItem();
                              });
                            },
                            iconItem: Icons.navigate_next,
                            buttonTitle: 'Next',
                            isSelected: false
                        ),
                      ),
                    ],
                  )

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}