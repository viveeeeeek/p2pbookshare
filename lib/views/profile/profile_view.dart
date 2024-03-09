import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/global/widgets/p2pbookshare_listview.dart';
import 'package:p2pbookshare/views/profile/widgets/custom_tab_bar.dart';
import 'package:provider/provider.dart';

import 'package:p2pbookshare/providers/firebase/book_request_service.dart';
import 'package:p2pbookshare/providers/userdata_provider.dart';
import 'package:p2pbookshare/views/notifications/notification_view.dart';
import 'package:p2pbookshare/views/profile/tabs/outgoing_book_requests/outgoing_book_request_tab.dart';
import 'package:p2pbookshare/views/profile/tabs/user_books/user_books_tab.dart';
import 'package:p2pbookshare/views/profile/widgets/profile_header.dart';
import 'package:p2pbookshare/views/settings/setting_view.dart';

import 'widgets/widgets.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final bookRequestService = Provider.of<BookRequestHandlingService>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            P2pbookshareStreamBuilder(
                dataStream: bookRequestService.hasBookRequestsForCurrentUser(
                    'book_requests', userDataProvider.userModel!.userUid!),
                successBuilder: (data) {
                  final bool hasBookRequests = data as bool;
                  return IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotificationView()),
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
            // IconButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const NotificationView()),
            //       );
            // },
            // icon: bookRequestService.isBookRequestAvailable
            //     ? Icon(MdiIcons.bellBadgeOutline)
            //     : Icon(MdiIcons.bellOutline)),
            IconButton(
              icon: Icon(MdiIcons.cogOutline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingView()),
                );
              },
            ),
          ],
        ),
        body: DefaultTabController(
            length: 2,
            // initialIndex: 1,
            child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    ProfileHeader(
                      userModel: userDataProvider.userModel!,
                    ),
                  ]))
                ];
              },
              body: const Column(
                children: [
                  /// Custom Tabbar widget
                  CustomTabBar(),

                  Expanded(
                    /// Tabbar views
                    child: TabBarView(
                      children: [
                        UserBooksTab(),
                        OutgoingNotificationTab(),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
