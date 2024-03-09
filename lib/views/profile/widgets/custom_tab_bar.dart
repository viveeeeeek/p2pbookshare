import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/global/utils/extensions/color_extension.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
            ],
          ),
        ),
      ),
    );
  }
}
