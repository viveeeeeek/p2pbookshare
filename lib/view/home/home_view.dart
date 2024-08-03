// Flutter imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/core/constants/app_route_constants.dart';
import 'package:p2pbookshare/core/widgets/notifications_permission_card.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/user_model.dart';
import 'package:p2pbookshare/services/firebase/user_service.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/core/constants/app_constants.dart';
import 'package:p2pbookshare/core/extensions/color_extension.dart';
import 'package:p2pbookshare/core/widgets/p2pbookshare_listview.dart';
import 'package:p2pbookshare/services/chat/chat_service.dart';
import 'package:p2pbookshare/services/firebase/book_borrow_request_service.dart';
import 'package:p2pbookshare/services/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/services/userdata_provider.dart';
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
  late UserDataProvider userDataProvider;
  final _userService = FirebaseUserService();
  final _currentUser = FirebaseAuth.instance.currentUser;
  // late final currentUserID;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    userDataProvider = Provider.of<UserDataProvider>(context);
    // currentUserID = userDataProvider.userModel!.userUid!;
    super.didChangeDependencies();
  }

  Widget buildCategorizedBookList(BuildContext context, String genre) {
    return Consumer<BookFetchService>(
      builder: (context, bookFetchServices, _) {
        return CategorizedBookList(
            context: context,
            stream: bookFetchServices.getCategoryWiseBooks(genre),
            currentUserID: _currentUser!.uid);
      },
    );
  }

  /// function to fetch user details using current user uid
  Future<Map<String, dynamic>?> fetchUserDetails() async {
    final _userData = await _userService.getUserDetailsById(_currentUser!.uid);

    return _userData;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bookRequestService = Provider.of<BookRequestService>(context);
    final chatService = Provider.of<ChatService>(context);
    return LayoutBuilder(builder: (context, constraints) {
      return NestedScrollView(
          headerSliverBuilder: (context, isInnerBoxScrolled) {
            return [
              SliverAppBar(
                pinned: true,
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
                            onPressed: () => context.pushNamed(
                                  AppRouterConstants.notificationView,
                                ),
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
                          onPressed: () => context.pushNamed(
                            AppRouterConstants.chatsListView,
                          ),
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
                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 10),
                    child: FutureBuilder(
                      future: fetchUserDetails(),
                      builder: (context, snapshot) {
                        String _currentUserDisplayName = '';
                        Widget _displayNameWidget;

                        if (snapshot.hasData) {
                          final userModel = UserModel.fromMap(
                              snapshot.data as Map<String, dynamic>);
                          _currentUserDisplayName = userModel.displayName!;
                          _displayNameWidget = Text(
                            _currentUserDisplayName,
                            style: const TextStyle(
                              fontSize: 26,
                            ),
                          );
                        } else {
                          _displayNameWidget =
                              const P2PBookShareShimmerContainer(
                                  height: 50, width: 175, borderRadius: 15);
                        }

                        return Text.rich(
                          TextSpan(
                            children: <InlineSpan>[
                              const TextSpan(
                                text: 'Welcome,\n',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const WidgetSpan(child: SizedBox(height: 20)),
                              WidgetSpan(child: _displayNameWidget),
                            ],
                          ),
                        );
                      },
                    )),

                // Shows the notification permission alert card if the user has not granted the permission
                const NotifPermissionAlertCard(),
                // NewBookRequestCard(
                //   userUid: userDataProvider.userModel!.userUid!,
                // ),
                // Container(
                //     height: 100,
                //     width: 100,
                //     color: Theme.of(context).bottomNavigationBarTheme),
                for (String genre in AppConstants.bookGenres)
                  buildCategorizedBookList(context, genre),
              ],
            ),
          ));
    });
  }
}
