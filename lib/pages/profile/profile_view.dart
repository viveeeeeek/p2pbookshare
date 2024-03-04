// Thanks to Paisa on github.

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/extensions/color_extension.dart';
import 'package:p2pbookshare/pages/notifications/notif_list_view.dart';
import 'package:p2pbookshare/pages/profile/views/outgoing_book_request/outgoing_book_request_tab.dart';
import 'package:p2pbookshare/pages/profile/views/user_books/user_books_tab.dart';
import 'package:p2pbookshare/pages/profile/widgets/profile_header.dart';
import 'package:p2pbookshare/pages/settings/settings_view.dart';
import 'package:p2pbookshare/services/providers/firebase/book_request_service.dart';
import 'package:p2pbookshare/services/providers/userdata_provider.dart';
import 'package:provider/provider.dart';
import 'widgets/widgets.dart';

//FIXME: Remove notification tab from tabbar and create seperate screen for it. show notification icon in appbar

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  // late TabController _tabController = TabController(
  //     length: 2, vsync: this, initialIndex: 0); // Initialize the TabController

  BookRequestService _bookRequestService = BookRequestService();
  @override
  void initState() {
    super.initState();
    _bookRequestService.subscribeBookRequests();
  }

  @override
  void dispose() {
    super.dispose();
    _bookRequestService.cancelSubscription(); // Cleanup the stream subscription
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final bookRequestService = Provider.of<BookRequestService>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotifListView()),
                  );
                },
                icon: bookRequestService.hasDocuments
                    ? Icon(MdiIcons.bellAlert)
                    : Icon(MdiIcons.bellOutline)),
            IconButton(
              icon: Icon(MdiIcons.cogOutline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsView()),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: ProfileHeader(
                        userModel: userDataProvider.userModel!,
                      ),
                    ),
                  ]))
                ];
              },
              body: Column(
                children: [
                  // Tabbar
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(32),
                        color: context.surfaceVariant,
                        child: TabBar(
                          // controller: _tabController,
                          dividerColor: Colors.transparent,
                          splashBorderRadius: BorderRadius.circular(32),
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: context.primary,
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: context.onPrimary,
                          unselectedLabelColor: context.onSurfaceVariant,
                          labelStyle: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          unselectedLabelStyle: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          tabs: [
                            Tab(
                              child: Icon(MdiIcons.grid),
                            ),
                            Tab(
                              child: Icon(MdiIcons.arrowTopRightBoldOutline),
                            ),
                            // Tab(
                            //   child: Icon(MdiIcons.bellOutline),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Tabbar views
                  const Expanded(
                    child: TabBarView(
                      // controller: _tabController,
                      children: [
                        UserBooksTab(),
                        OutgoingNotificationTab(),
                        // RequestsNotificationTab(
                        //   incomingBookReqStream:
                        //       bookRequestService.fetchIncomingBookRequests(),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
