import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:p2pbookshare/pages/addbook/addbook_screen.dart';
import 'package:p2pbookshare/pages/home/home_screen.dart';
import 'package:p2pbookshare/pages/profile/profile_screen.dart';
import 'package:p2pbookshare/pages/search/search_screen.dart';
import 'package:p2pbookshare/services/providers/userdata_provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final PageController controller = PageController();
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
            HomeScreen(),
            SearchView(),
            AddBookScreen(),
            ProfileScreen(),
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
              const NavigationDestination(
                icon: Icon(Icons.search),
                selectedIcon: Icon(Symbols.search),
                label: "Search",
              ),
              const NavigationDestination(
                icon: Icon(Symbols.add),
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
