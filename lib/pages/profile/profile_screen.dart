// Thanks to Paisa on github.

import 'package:flutter/material.dart';
import 'package:p2pbookshare/extensions/color_extension.dart';
import 'package:p2pbookshare/pages/profile/views/notifications_tab_tab.dart';
import 'package:p2pbookshare/pages/profile/views/incoming_book_req_tab.dart';
import 'package:p2pbookshare/pages/profile/views/your_books_tab.dart';
import 'package:p2pbookshare/pages/settings/settings_view.dart';
import 'package:p2pbookshare/pages/profile/widgets/profile_card.dart';
// ignore: unused_import
import 'package:p2pbookshare/services/providers/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/services/providers/firebase/book_request_service.dart';
import 'package:p2pbookshare/services/providers/userdata_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController = TabController(
      length: 3, vsync: this, initialIndex: 0); // Initialize the TabController

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
        body: DefaultTabController(
            length: 3,
            // initialIndex: 1,
            child: NestedScrollView(
              headerSliverBuilder: (context, _) {
                return [
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: UserProfileCard(
                        userModel: userDataProvider.userModel!,
                      ),
                    ),
                  ]))
                ];
              },
              body: Column(
                children: [
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
                          controller: _tabController,
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
                          tabs: const [
                            Tab(
                              child: Text('Your Books'),
                            ),
                            Tab(
                              child: Icon(Icons.pending_actions_rounded),
                            ),
                            Tab(
                              child: Icon(Icons.notifications_active_outlined),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        const YourBooksTabView(),
                        const NotificationsTabView(),
                        IncomingBookReqView(
                          incomingBookReqStream:
                              bookRequestService.fetchIncomingBookRequests(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
