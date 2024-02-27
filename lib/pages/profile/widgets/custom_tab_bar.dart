import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final Function(int) onTabSelected; // Callback for handling tab selection

  const CustomTabBar({Key? key, required this.onTabSelected}) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this); // Adjust length as needed
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void switchToTab(int tabIndex) {
    _tabController.animateTo(tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight, // Adjust height as needed
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface, // Use surface color
        borderRadius:
            const BorderRadius.all(Radius.circular(12)), // Rounded corners
      ),
      child: TabBar(
        controller: _tabController, // Assign the TabController
        isScrollable: true, // Allow scrolling if too many tabs
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0, // Adjust indicator thickness
            ),
          ),
        ),
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Colors.grey[700], // Adjust unselected color
        tabs: [
          Tab(
            child: Text(
              'Your Books',
              style:
                  Theme.of(context).textTheme.titleLarge, // Adjust text style
            ),
          ),
          const Tab(text: 'Pending Requests'),
          const Tab(text: 'Incoming Requests'),
        ],
        onTap: widget.onTabSelected,
      ),
    );
  }
}
