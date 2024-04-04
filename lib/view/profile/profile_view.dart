// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/core/widgets/p2pbookshare_shimmer_container.dart';
import 'package:p2pbookshare/model/user_model.dart';
import 'package:p2pbookshare/provider/firebase/user_service.dart';
import 'package:p2pbookshare/provider/userdata_provider.dart';
import 'package:p2pbookshare/view/profile/tabs/outgoing_req/outgoing_req_tab.dart';
import 'package:p2pbookshare/view/profile/tabs/user_books/user_books_tab.dart';
import 'package:p2pbookshare/view/profile/widgets/custom_tab_bar.dart';
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

    final _userService = FirebaseUserService();
    final _currentUser = FirebaseAuth.instance.currentUser;

    /// function to fetch user details using current user uid
    Future<Map<String, dynamic>?> fetchUserDetails() async {
      final _userData =
          await _userService.getUserDetailsById(_currentUser!.uid);
      return _userData;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
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
                    FutureBuilder(
                        future: fetchUserDetails(),
                        builder: ((context, snapshot) => snapshot.hasData
                            ? ProfileHeader(
                                userModel: UserModel.fromMap(
                                    snapshot.data as Map<String, dynamic>))
                            : const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: P2PBookShareShimmerContainer(
                                    height: 150,
                                    width: double.infinity,
                                    borderRadius: 25),
                              ))),
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
