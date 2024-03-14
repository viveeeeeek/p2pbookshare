import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/view/home/home_view.dart';
import 'package:p2pbookshare/view/profile/profile_view.dart';
import 'package:p2pbookshare/view/search/search_view.dart';
import 'package:p2pbookshare/view/upload_book/upload_book_view.dart';
import 'package:p2pbookshare/provider/userdata_provider.dart';
import 'package:provider/provider.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  int _selectedScreenIndex = 0;

  /// move this screenIndex inside viewModel to dynamically change the index

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final PageController controller =
        PageController(initialPage: _selectedScreenIndex);
    void onTap(int index) {
      if (_selectedScreenIndex != index) {
        controller.jumpToPage(index);
        setState(() {
          _selectedScreenIndex = index;
        });
      }
    }

    return WillPopScope(
      onWillPop: () async {
        if (_selectedScreenIndex != 0) {
          setState(() {
            _selectedScreenIndex = 0;
          });
          controller.jumpToPage(_selectedScreenIndex);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: PageView(
          // index: _selectedScreenIndex,
          controller: controller,
          onPageChanged: onTap,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeView(),
            SearchView(),
            BookUploadView(),
            ProfileView(),
          ],
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          child: NavigationBar(
            // height: 70,
            onDestinationSelected: onTap,
            selectedIndex: _selectedScreenIndex,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: "Home",
              ),
              NavigationDestination(
                icon: Icon(MdiIcons.magnify),
                selectedIcon: Icon(MdiIcons.magnify),
                label: "Search",
              ),
              NavigationDestination(
                // icon: Icon(MdiIcons.fromString('book-open-variant')),
                icon: Icon(MdiIcons.plus),
                label: "Add",
              ),
              NavigationDestination(
                icon: CircleAvatar(
                    radius: 15,
                    backgroundImage: userDataProvider.userModel != null &&
                            userDataProvider.userModel!.userPhotoUrl != null
                        ? CachedNetworkImageProvider(
                            userDataProvider.userModel!.userPhotoUrl!)
                        : null),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
