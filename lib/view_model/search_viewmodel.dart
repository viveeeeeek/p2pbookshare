import 'package:flutter/material.dart';

class SearchViewModel with ChangeNotifier {
  /// TextEditingController for SearchBar
  TextEditingController searchQueryTextController = TextEditingController();

  /// Getter and setter for [searchQuery]
  /// Initial search query
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  setBookTitle(newTitle) {
    _searchQuery = newTitle;
    notifyListeners();
  }

  /// Clear current [searchQuery] using [searchQueryTextController]
  clearSearchController() {
    searchQueryTextController.clear();
    notifyListeners();
  }

  /// Getter & setter for [selectedGenreFilter]
  /// Setting initial search filter to 'All'
  String _selectedGenreFilter = 'All';
  String get selectedGenreFilter => _selectedGenreFilter;
  void setSelectedGenre(String genre) {
    _selectedGenreFilter = genre;
    notifyListeners();
  }

  /// Clear selected search filter
  void clearSelectedGenre() {
    _selectedGenreFilter = '';
    notifyListeners();
  }
}
