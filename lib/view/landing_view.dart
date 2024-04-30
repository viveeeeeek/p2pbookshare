// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:p2pbookshare/provider/userdata_provider.dart';
import 'package:p2pbookshare/view/home/home_view.dart';
import 'package:p2pbookshare/view/profile/profile_view.dart';
import 'package:p2pbookshare/view/search/search_view.dart';
import 'package:p2pbookshare/view/upload_book/upload_book_view.dart';

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

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (_selectedScreenIndex != 0) {
          setState(() {
            _selectedScreenIndex = 0;
            didPop = false;
          });
          controller.jumpToPage(_selectedScreenIndex);
        } else {
          // if already on home screen
          if (!didPop) {
            didPop = true;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Press back again to exit"),
                duration: Duration(seconds: 2),
              ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              didPop = false;
            });
          } else {
            Navigator.of(context).pop(didPop);
          }
        }
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
            height: 75,
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
                            userDataProvider.userModel!.profilePictureUrl !=
                                null
                        ? CachedNetworkImageProvider(
                            userDataProvider.userModel!.profilePictureUrl!)
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
