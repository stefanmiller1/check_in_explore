import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:check_in_web_mobile_explore/presentation/core/responsive/responsive.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/direct_chat_rooms_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/screens/chat_inbox/direct_chat_screen.dart';
import 'package:check_in_web_mobile_explore/presentation/web_screens/main_container_widgets/chat_widget/chat_helper_core.dart';
import 'package:flutter/material.dart';

class ChatSubContainerWidget extends StatefulWidget {

  final DashboardModel model;
  final Function() didSelectRoom;

  const ChatSubContainerWidget({super.key, required this.model, required this.didSelectRoom});

  @override
  State<ChatSubContainerWidget> createState() => _ChatSubContainerWidgetState();
}

class _ChatSubContainerWidgetState extends State<ChatSubContainerWidget> with SingleTickerProviderStateMixin {

  late TabController? _tabController;
  late PageController? _pageController;


  @override
  void initState() {
    _tabController = TabController(initialIndex: ChatHelperCore.currentPageIndex, length: 2, vsync: this);
    _pageController = PageController(initialPage: ChatHelperCore.currentPageIndex);
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              controller: _tabController,
              onTap: (index) {
                  ChatHelperCore.currentPageIndex = index;
                  _pageController?.animateToPage(index, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
              },
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: widget.model.paletteColor
              ),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              labelColor: widget.model.accentColor,
              unselectedLabelColor: widget.model.disabledTextColor,
              tabs: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: const Tab(text: 'Chats')),
                ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Tab(text: 'Archive')
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Divider(color: widget.model.disabledTextColor),
        
        Expanded(
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: 2,
            scrollDirection: Axis.horizontal,
            allowImplicitScrolling: true,
            itemBuilder: (_, index) {
              if (index == 0) {
                return DirectChatRoomsScreen(
                    model: widget.model,
                    isArchive: false,
                    didSelectArchive: () {
                      setState(() {
                        ChatHelperCore.currentPageIndex = 1;
                        _tabController?.animateTo(1, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
                        _pageController?.animateToPage(1, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
                      });
                    },
                    didSelectChats: () {
                    },
                    didSelectRoom: (room, profile) {

                      if (Responsive.isMobile(context)) {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) {
                            return DirectChatScreen(
                              model: widget.model,
                              room: room,
                              currentUser: profile,
                              reservationItem: null,
                              isFromReservation: false,
                            );
                          }));
                      } else {
                        ChatHelperCore.isLoading = true;
                        ChatHelperCore.selectedRoom = room;
                        ChatHelperCore.currentUserProfile = profile;
                        widget.didSelectRoom();

                        Future.delayed(const Duration(seconds: 1), () {
                          ChatHelperCore.isLoading = false;
                          widget.didSelectRoom();
                        });
                      }
                    },
                );
              } else {
               return DirectChatRoomsScreen(
                   model: widget.model,
                    isArchive: true,
                     didSelectArchive: () {
                     },
                     didSelectChats: () {
                       setState(() {
                           ChatHelperCore.currentPageIndex = 0;
                           _tabController?.animateTo(0, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
                           _pageController?.animateToPage(0, duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
                       });
                     },
                     didSelectRoom: (room, profile) {
                     if (Responsive.isMobile(context)) {
                       Navigator.push(context, MaterialPageRoute(
                           builder: (_) {
                             return DirectChatScreen(
                               model: widget.model,
                               room: room,
                               currentUser: profile,
                               reservationItem: null,
                               isFromReservation: false,
                             );
                           }));
                     } else {
                       ChatHelperCore.isLoading = true;
                       ChatHelperCore.selectedRoom = room;
                       ChatHelperCore.currentUserProfile = profile;
                       widget.didSelectRoom();

                       Future.delayed(const Duration(seconds: 1), () {
                         ChatHelperCore.isLoading = false;
                         widget.didSelectRoom();
                       });
                     }

                 },
               );
              }
            },
          ),
        ),
      ],
    );
  }
}