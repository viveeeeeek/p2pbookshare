import 'package:flutter/material.dart';
import 'package:p2pbookshare/global/constants/app_constants.dart';
import 'package:provider/provider.dart';

import 'package:p2pbookshare/pages/home/widgets/category_book_list.dart';
import 'package:p2pbookshare/services/providers/firebase/book_fetch_service.dart';
import 'package:p2pbookshare/services/providers/userdata_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget buildCategorizedBookList(BuildContext context, String genre) {
    return Consumer<BookFetchService>(
      builder: (context, bookFetchServices, _) {
        return CategorizedBookList(
          context: context,
          stream: bookFetchServices.getCategoryWiseBooks(genre),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userDataProvider = Provider.of<UserDataProvider>(context);

    // List bookRatingCount = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

    return LayoutBuilder(
      builder: (context, constraints) => SafeArea(
        child: Scaffold(
            // appBar: AppBar(
            //   title: const Text('p2pbookshare'),
            // ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     Navigator.push(context, MaterialPageRoute(builder: ((context) {
            //       return Screen();
            //     })));
            //   },
            //   child: const Icon(Icons.location_pin),
            // ),
            body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                //TODO  Implement Spotify like spot light like effect for background
                // Container(
                //   width: constraints.maxWidth,
                //   height: constraints.maxHeight,
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: [
                //         Colors.black87.withOpacity(0.7),
                //         Colors.black87.withOpacity(0.4),
                //         Colors.transparent,
                //         Colors.transparent,
                //       ],
                //       begin: Alignment.topRight,
                //       end: Alignment.bottomLeft,
                //     ),
                //   ),
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        children: [
                          Text.rich(
                            TextSpan(
                              children: <InlineSpan>[
                                const TextSpan(
                                  text: 'Welcome,\n',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: userDataProvider.userModel!.userName ??
                                      'User',
                                  style: const TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    //TODO Implement NF-Like-Top-10-Books
                    // SizedBox(
                    //   height: 200,
                    //   child: ListView(
                    //     scrollDirection: Axis.horizontal,
                    //     children: bookRatingCount.map((rating) {
                    //       return NFtop10Stack(bookRatingCount: rating);
                    //     }).toList(),
                    //   ),
                    // ),
                    // Generate CategorizedBookList widgets dynamically
                    // ! Categorized book listview
                    for (String genre in AppConstants.bookGenres)
                      buildCategorizedBookList(context, genre),
                  ],
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
