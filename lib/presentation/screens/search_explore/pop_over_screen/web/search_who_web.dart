import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/components/helper.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/search_explore/pop_over_screen/search_when_where_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchWhoWeb extends StatefulWidget {

  final DashboardModel model;
  final Function() didSelectItem;

  const SearchWhoWeb({super.key, required this.model, required this.didSelectItem});

  @override
  State<SearchWhoWeb> createState() => _SearchWhoWebState();
}

class _SearchWhoWebState extends State<SearchWhoWeb> with TickerProviderStateMixin {

  late int tabIndexWho = 0;
  late TabController _tabControllerWho;

  @override
  void initState() {
    _tabControllerWho = TabController(length: 2, vsync: this);
    super.initState();
  }

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
              tagTitle: 'search_who',
              didSelectItem: widget.didSelectItem,
              isFinishedSelection: (context.read<ListingsSearchRequirementsBloc>().state.participantId != null),
              iconItem: Icons.group_outlined,
              selectedTitle: 'How Many Do You Expect?',
              defaultTitle: 'Who\'s Joining You?',
              subTitle: (context.read<ListingsSearchRequirementsBloc>().state.participantId != null) ? getParticipantRangeOptions.firstWhere((element) => element.partId == context.read<ListingsSearchRequirementsBloc>().state.participantId).partTitle : (context.read<ListingsSearchRequirementsBloc>().state.participantRange != null) ? '${context.read<ListingsSearchRequirementsBloc>().state.participantRange?.start.toInt()} - ${context.read<ListingsSearchRequirementsBloc>().state.participantRange?.end.toInt()} Friends' : 'Add Friends?'
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
                  SizedBox(
                    height: 50,
                    child: topTabBarController(
                        widget.model,
                        _tabControllerWho,
                        tabWhoList,
                        didTapTab: (index) {
                          setState(() {
                            tabIndexWho = index;
                        });
                      }
                    ),
                  ),

                  SizedBox(
                    height: 415,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabBarView(
                        controller: _tabControllerWho,
                        children: [
                            /// search button
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Column(
                                children: [
                                  getParticipantListView(
                                      widget.model,
                                      context.read<ListingsSearchRequirementsBloc>().state.participantId,
                                      didSelectRange: (selectedRange) {
                                        setState(() {
                                          if (selectedRange.partId == context.read<ListingsSearchRequirementsBloc>().state.participantId) {
                                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.participantsIdChanged(null));
                                            // context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.participantsRequiredChanged(null));
                                          } else {
                                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.participantsIdChanged(selectedRange.partId));
                                            context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.participantsRequiredChanged(selectedRange.rangeValues));
                                        }
                                      });
                                    }
                                  ),
                                  const SizedBox(height: 15),
                                  searchSettingsButton(
                                    widget.model,
                                    didSelectButton: () {
                                      setState(() {
                                        widget.didSelectItem();
                                      });
                                    },
                                    iconItem: Icons.check_rounded,
                                    buttonTitle: 'Done',
                                    isSelected: false,
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 25.0),
                              child: getParticipantsBasedOnRange(
                                  widget.model,
                                  context.read<ListingsSearchRequirementsBloc>().state.participantRange ?? const RangeValues(1, 20),
                                  onChangeStart: (values) {
                                    setState(() {
                                      context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.participantsIdChanged(null));
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.participantsRequiredChanged(value));
                                    });
                                  }, clearItems: () {
                                    setState(() {
                                      context.read<ListingsSearchRequirementsBloc>().add(ListingsSearchRequirementsEvent.participantsRequiredChanged(null));
                                    });
                              }),
                            )

                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}