import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:p2pbookshare/extensions/color_extension.dart';
import 'package:p2pbookshare/pages/search/search_viewmodel.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            clipBehavior: Clip.antiAlias,
            child: Consumer<SearchViewModel>(
              builder: (context, searchViewModel, child) {
                return AppBar(
                  backgroundColor: context.secondaryContainer.withOpacity(0.5),
                  scrolledUnderElevation: 0,
                  titleSpacing: 15,
                  title: TextField(
                    controller: searchViewModel.searchQueryTextController,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      fillColor: context.tertiary,
                      hintText: 'Search',
                      border: InputBorder.none,
                      prefixIcon: Icon(MdiIcons.magnify),
                    ),
                    onChanged: (val) {
                      //Sets up new changed booktitle inside provider
                      searchViewModel.setBookTitle(val);
                    },
                  ),
                  actions: [
                    searchViewModel.searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchViewModel.clearSearchController();
                              searchViewModel.setBookTitle('');
                            },
                            icon: const Icon(Icons.clear))
                        : const SizedBox(),
                    const SizedBox(width: 8),
                  ],
                );
              },
            )),
      ),
    );
  }
}
