import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/view/profile/widgets/custom_tab_bar.dart';
import 'package:provider/provider.dart';

import 'package:p2pbookshare/provider/userdata_provider.dart';
import 'package:p2pbookshare/view/profile/tabs/outgoing_req/outgoing_req_tab.dart';
import 'package:p2pbookshare/view/profile/tabs/user_books/user_books_tab.dart';
import 'package:p2pbookshare/view/profile/widgets/profile_header.dart';
import 'package:p2pbookshare/view/settings/setting_view.dart';

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

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
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
            initialIndex: 0,
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
              body: Column(
                children: [
                  /// Custom Tabbar widget
                  const CustomTabBar(),

                  Expanded(
                    /// Tabbar views
                    child: TabBarView(
                      children: [
                        const UserBooksTab(),
                        OutgoingNotificationTab(
                          currentUseruid: userDataProvider.userModel!.userUid!,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
