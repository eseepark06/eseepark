import 'dart:convert';

import 'package:eseepark/main.dart';
import 'package:eseepark/models/search_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralProvider with ChangeNotifier {
  static final GeneralProvider _instance = GeneralProvider._internal();

  factory GeneralProvider() => _instance;

  GeneralProvider._internal();

  Future<void> initialize() async {
    await _loadGetStarted();
    await loadSearch();
  }

  bool _isGetStartedShown = false;
  bool _isInitialized = false;

  bool get isGetStartedShown => _isGetStartedShown;
  bool get isInitialized => _isInitialized;


  // SEARCH PROVIDDER
  List<SearchModel> _searched = [];

  List<SearchModel> get searched => _searched;

  Future<void> loadSearch() async {
    if (supabase.auth.currentUser != null) {
      final prefs = await SharedPreferences.getInstance();

      List<SearchModel> searched = [];

      if (prefs.containsKey('${supabase.auth.currentUser?.id}-searched-words')) {
        String? savedSearches = prefs.getString('${supabase.auth.currentUser?.id}-searched-words');

        if (savedSearches != null && savedSearches.isNotEmpty) {
          List<dynamic> decodedList = List.from(jsonDecode(savedSearches));

          searched = decodedList.map((item) {
            return SearchModel.fromMap(item as Map<String, dynamic>);
          }).toList();
        }
      }

      _searched = searched;
    }

    notifyListeners();
  }

  Future<void> saveSearch(SearchModel search) async {
    final prefs = await SharedPreferences.getInstance();

    if(_searched.any((s) => s.searchText == search.searchText)) {
      return;
    }

    _searched.add(search);

    List<Map<String, dynamic>> searchMaps = _searched.map((e) => e.toMap()).toList();
    String searchJson = jsonEncode(searchMaps);
    await prefs.setString('${supabase.auth.currentUser?.id}-searched-words', searchJson);

    notifyListeners();
  }

  Future<void> deleteSearch(SearchModel search) async {
    final prefs = await SharedPreferences.getInstance();

    _searched.removeWhere((s) => s.searchText == search.searchText);

    List<Map<String, dynamic>> searchMaps = _searched.map((e) => e.toMap()).toList();
    String searchJson = jsonEncode(searchMaps);
    await prefs.setString('${supabase.auth.currentUser?.id}-searched-words', searchJson);

    notifyListeners();
  }


  Future<void> _loadGetStarted() async {
    final prefs = await SharedPreferences.getInstance();


    _isGetStartedShown = prefs.getBool('isGetStartedShown') ?? false;
    _isInitialized = true;


    notifyListeners();
  }

  Future<bool> setGetStartedValue(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      bool status = await prefs.setBool('isGetStartedShown', value);

      if(status) {
        _isGetStartedShown = true;
        notifyListeners();

        return true;
      } else {
        return false;
      }
    } catch(e) {
      return false;
    }
  }
}