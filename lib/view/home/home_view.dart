import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:p2pbookshare/core/constants/app_constants.dart';
import 'package:p2pbookshare/provider/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/provider/userdata_provider.dart';

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
    // const double toolbarHeight = kToolbarHeight + 8;
    return LayoutBuilder(builder: (context, constraints) {
      return SafeArea(
        child: Scaffold(

            /// SearchAppBar navigates to searchview
            // appBar: const PreferredSize(
            //   preferredSize: Size.fromHeight(toolbarHeight),
            //   child: SearchAppBar(
            //     isExpanded: false,
            //   ),
            // ),
            body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
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
                                userDataProvider.userModel!.userName ?? 'User',
                            style: const TextStyle(
                              fontSize: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  NewBookRequestCard(
                    userUid: userDataProvider.userModel!.userUid!,
                  ),
                  for (String genre in AppConstants.bookGenres)
                    buildCategorizedBookList(context, genre),
                ],
              ),
            ),
          ],
        )),
      );
    });
  }
}
