import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'package:p2pbookshare/extensions/color_extension.dart';
import 'package:p2pbookshare/pages/search/search_viewmodel.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({super.key});

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  bool _isExpanded = false;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() => _isExpanded = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Added unfocus method
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            top: _isExpanded ? false : true,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
              height: _isExpanded ? constraints.maxHeight : 56.0,
              margin: _isExpanded
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(top: 8, bottom: 8),
              padding: _isExpanded
                  ? EdgeInsets.zero
                  : const EdgeInsets.symmetric(horizontal: 12.0),
              child: ClipRRect(
                borderRadius:
                    _isExpanded ? BorderRadius.zero : BorderRadius.circular(32),
                clipBehavior: Clip.antiAlias,
                child: Consumer<SearchViewModel>(
                  builder: (context, searchViewModel, child) {
                    return AppBar(
                      backgroundColor:
                          context.secondaryContainer.withOpacity(0.5),
                      scrolledUnderElevation: 0,
                      titleSpacing: 10,
                      title: TextField(
                        controller: searchViewModel.searchQueryTextController,
                        textAlign: TextAlign.start,
                        onTap: () => setState(() => _isExpanded = true),
                        onTapOutside: (_) {
                          setState(() {
                            _isExpanded = false;
                          });
                        },
                        focusNode: _focusNode, // Assign focusNode
                        decoration: InputDecoration(
                          fillColor: context.tertiary,
                          hintText: 'Search books and authors',
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
