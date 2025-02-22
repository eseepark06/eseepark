import 'package:flutter/material.dart';

class SearchResult extends StatefulWidget {
  final String searchText;
  final int maxResults;
  final double? maxRadius;

  const SearchResult({
    super.key,
    required this.searchText,
    required this.maxResults,
    this.maxRadius,
  });

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: widget.maxResults,
        itemBuilder: (context, index) {
          return Container();
        },
      ),
    );
  }
}
