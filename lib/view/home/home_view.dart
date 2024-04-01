import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/provider/others/notification_service.dart';
import 'package:provider/provider.dart';

import 'package:p2pbookshare/core/constants/app_constants.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_listview.dart';
import 'package:p2pbookshare/provider/chat/chat_service.dart';
import 'package:p2pbookshare/provider/firebase/book_borrow_request_service.dart';
import 'package:p2pbookshare/provider/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/provider/userdata_provider.dart';
import 'package:p2pbookshare/view/chat/chats_list_view.dart';
import 'package:p2pbookshare/view/notifications/notification_view.dart';

import 'widgets/widgets.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  NotificationService _notificationService = NotificationService();
  _requestNotificationPermission() async {
    await _notificationService.requestNotificationPermission();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestNotificationPermission();
  }

  Widget buildCategorizedBookList(BuildContext context, String genre) {
    return Consumer<BookFetchService>(
      builder: (context, bookFetchServices, _) {
        return CategorizedBookList(
          context: context,
          stream: bookFetchServices.getCategoryWiseBooks(genre),
          currentUserID:
              Provider.of<UserDataProvider>(context).userModel!.userUid!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final bookRequestService = Provider.of<BookRequestService>(context);
    final chatService = Provider.of<ChatService>(context);
    return LayoutBuilder(builder: (context, constraints) {
      return NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, isInnerBoxScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                // pinned: true,
                title: Row(
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          context.onBackground, BlendMode.srcIn),
                      child: SvgPicture.asset(
                        'assets/images/p2pbookshare.svg',
                        height: 25,
                        width: 25,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('p2pbookshare'),
                  ],
                ),
                forceElevated: isInnerBoxScrolled,
                actions: [
                  P2pbookshareStreamBuilder(
                      dataStream:
                          bookRequestService.hasBookRequestsForCurrentUser(
                              'book_requests',
                              userDataProvider.userModel!.userUid!),
                      successBuilder: (data) {
                        final bool hasBookRequests = data as bool;
                        return IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const NotificationView()),
                              );
                            },
                            icon: hasBookRequests
                                ? Icon(MdiIcons.bellBadgeOutline)
                                : Icon(MdiIcons.bellOutline));
                      },
                      waitingBuilder: () {
                        return const SizedBox();
                      },
                      errorBuilder: (error) {
                        return Text('$error');
                      }),
                  P2pbookshareStreamBuilder(
                      dataStream: chatService.hasChatroomForUser(
                          'chatrooms', userDataProvider.userModel!.userUid!),
                      successBuilder: (sucess) {
                        final _hasChatroomAvailable = sucess as bool;
                        return IconButton(
                          icon: _hasChatroomAvailable
                              ? Icon(MdiIcons.messageBadgeOutline)
                              : Icon(MdiIcons.messageOutline),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ChatsListView()),
                            );
                          },
                        );
                      },
                      waitingBuilder: () {
                        return const SizedBox();
                      },
                      errorBuilder: (error) {
                        return Text('$error');
                      })
                ],
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 25, 25),
                  child: Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        const TextSpan(
                          text: 'Welcome,\n',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              userDataProvider.userModel!.displayName ?? 'User',
                          style: const TextStyle(
                            fontSize: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // NewBookRequestCard(
                //   userUid: userDataProvider.userModel!.userUid!,
                // ),
                for (String genre in AppConstants.bookGenres)
                  buildCategorizedBookList(context, genre),
              ],
            ),
          ));
    });
  }
}
